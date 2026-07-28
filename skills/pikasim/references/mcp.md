# PikaSim over MCP (preferred path)

Remote Streamable-HTTP MCP server, two endpoints:

| Endpoint | Auth | Use for |
|---|---|---|
| `https://pikasim.com/mcp` | none (keyless) | browse/search all products, `create_wallet` |
| `https://pikasim.com/mcp/wallet` | OAuth 2.1 (DCR + PKCE) | interactive clients — triggers a consent page where the user pastes their wallet code |

A wallet's `ak_live_` API key also works directly on the keyless endpoint —
send header `Authorization: Bearer ak_live_...` (or connect the URL
`https://pikasim.com/mcp/ak_live_YOUR_KEY`). With a key attached, purchase
tools work; without one, browsing and `create_wallet` still work.

## Connect

- **Claude Desktop / Claude.ai:** Settings → Connectors → Add custom
  connector. Browse: `https://pikasim.com/mcp`. Purchase:
  `https://pikasim.com/mcp/wallet` → Connect → paste wallet code on the
  consent page.
- **Claude Code:**
  `claude mcp add --transport http pikasim https://pikasim.com/mcp`
  (append `--header "Authorization: Bearer ak_live_..."` to purchase).
- **Cursor / other OAuth-capable clients:** add `https://pikasim.com/mcp/wallet`
  as a remote server; the client runs the OAuth flow.
- **ChatGPT:** add a custom connector with `https://pikasim.com/mcp`.

## Tool map (~30 tools; names are self-describing)

- **Discovery (keyless):** `search_esim_packages`, `check_country_coverage`,
  `get_pricing`, `get_package_details`, `search_phone_plans`,
  `get_phone_plan_pricing`, `search_sms_services`, `get_sms_service_countries`,
  `list_sms_rentals` (live stock), `search`, `fetch`.
- **Onboarding (keyless):** `create_wallet` — mints wallet code + `ak_live_`
  key + welcome credit in one call. Both credentials shown ONCE; save them.
- **Wallet (authed):** `check_balance`, `create_deposit` (from $1 — returns a
  Lightning/BTC/XMR/USDT invoice the agent can pay itself, plus a payment-page
  URL to hand a human), `list_transactions`, `list_orders`.
- **Purchase (authed):** `purchase_esim`, `purchase_phone_plan`,
  `order_sms_verification` → poll `check_sms_verification`,
  `rent_sms_number` → `get_sms_rental_messages` / `extend_sms_rental`.
- **Fleet (authed):** `list_esims`, `get_esim_status`, `get_topup_options`,
  `topup_esim`, `cancel_esim` (unused → refund to wallet),
  `cancel_sms_verification`, `cancel_sms_rental`.

## Flow: nothing → live purchase (no human)

1. Connect keyless `https://pikasim.com/mcp`.
2. `create_wallet` → SAVE wallet code + `ak_live_` key.
3. Reconnect with `Authorization: Bearer ak_live_...`.
4. `check_balance` — the welcome credit may already cover a sub-$1 first
   purchase (e.g. an SMS code). If not: `create_deposit`, pay the invoice (or
   hand the payment URL to the user), poll `check_balance` until credited.
5. Discover (`search_*`) → confirm price with the user → `purchase_*`.
6. Deliver the returned install/invoice URL (never raw activation codes).

Common trap: connecting only `/mcp/wallet` in a headless environment — it
401-challenges for OAuth and a headless agent can't complete the browser
consent. Headless agents should use `/mcp` with a Bearer key instead.
