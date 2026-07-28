# PikaSim over plain HTTPS (no MCP client needed)

Everything works with curl/fetch. Two API surfaces:

- **Public catalog** — `https://pikasim.com/api/packages/...`, no auth,
  ~100 req/min/IP.
- **Wallet API** — `https://pikasim.com/api/v1/agent-wallet/...`, auth with
  either header: `X-API-Key: ak_live_...` or `Authorization: Bearer ak_live_...`.

Authoritative reference (all endpoints, request/response shapes):
<https://pikasim.com/api-docs-for-ai> · machine-readable:
<https://pikasim.com/openapi.yaml>. This file covers the spine.

**Money units:** wallet-API amounts (`balance`, deposit `amount`) are USD
**cents**. Catalog `price` is **micro-dollars** (divide by 10,000) — prefer the
pre-computed `priceUSD` field. Don't mix them up.

## Cold start without MCP (one JSON-RPC call)

The keyless MCP endpoint is plain HTTP POST, so `create_wallet` works from curl:

```bash
curl -s -X POST https://pikasim.com/mcp \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call",
       "params":{"name":"create_wallet","arguments":{"acceptTos":true}}}'
```

The response text contains the wallet code and `ak_live_` API key — **each
shown exactly once, no recovery without them. Save both immediately.** A small
spend-only welcome credit is usually included.

## Catalog (public, no auth)

```bash
# natural-language helper: country + duration + usage in one query
curl 'https://pikasim.com/api/packages/ask?q=2+week+trip+to+japan'
# by country / by package code / phone plans
curl 'https://pikasim.com/api/packages/country/JP'
curl 'https://pikasim.com/api/packages/code/PACKAGE_CODE'
curl 'https://pikasim.com/api/packages/phone-plans'
```

## Wallet operations (authed)

```bash
# balance — cents + formatted string
curl -H "X-API-Key: $KEY" https://pikasim.com/api/v1/agent-wallet/balance

# fund: create a crypto deposit invoice (amount in CENTS, min 100 = $1).
# Returns invoice payment options (BTC on-chain / Lightning / XMR / USDT)
# + a checkout URL a human could pay in a browser instead.
curl -H "X-API-Key: $KEY" -H 'Content-Type: application/json' \
  -d '{"amount": 500}' \
  https://pikasim.com/api/v1/agent-wallet/deposit/btcpay
# poll: GET /deposit/btcpay/{invoiceId}/status until settled

# buy a data eSIM or phone plan (packageCode from the catalog)
curl -H "X-API-Key: $KEY" -H 'Content-Type: application/json' \
  -d '{"packageCode": "PACKAGE_CODE"}' \
  https://pikasim.com/api/v1/agent-wallet/orders
# response includes the eSIM install/invoice URL — deliver that link

# fleet: GET /esims · /esims/{iccid} · /esims/{iccid}/usage
#        /esims/{iccid}/topup-options · POST /esims/{iccid}/topup
# unused refund: POST /esims/{iccid}/cancel

# SMS verification (one-time code). serviceId/countryId come from the
# catalog via MCP search_sms_services / get_sms_service_countries, or the
# docs page. idempotencyKey (any unique string) makes retries safe.
# POST /sms/orders {serviceId, countryId, idempotencyKey}
#   -> poll GET /sms/orders/{orderId} until the code arrives (20-min auto-refund)
# rentals: POST /sms/rentals · GET /sms/rentals/{receiptId}/messages
#          POST /sms/rentals/{receiptId}/extend · /cancel
```

All wallet responses are `{"success": true, "data": {...}}` or
`{"success": false, "error": "..."}`. HTTP 402 = insufficient balance → fund
via the deposit endpoint, then retry.
