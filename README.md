# PikaSim MCP Server

> Buy eSIMs from an AI agent — no account, no email, no KYC. Anonymous data plans, **real carrier phone numbers**, and **SMS verification numbers** across 190+ countries, settled in crypto from a prepaid agent wallet.

PikaSim is a **remote, hosted MCP server** (Streamable HTTP). You don't run any code — just point your AI agent at the URL and it can search plans, check coverage, get pricing, and (with a funded agent wallet) purchase eSIMs and SMS numbers autonomously.

- **Browse (no auth):** `https://pikasim.com/mcp`
- **Purchase (OAuth):** `https://pikasim.com/mcp/wallet`
- **Transport:** Streamable HTTP (JSON-RPC over HTTP POST)
- **Docs:** https://pikasim.com/mcp-docs
- **Agent wallet:** https://pikasim.com/agent-wallet
- **Browsing needs no key.** Purchasing connects a prepaid agent wallet via one-click OAuth (or an `ak_live_` key on CLI clients).

---

## Quick start

Add PikaSim to your AI agent's MCP config:

```json
{
  "mcpServers": {
    "pikasim": {
      "type": "streamable-http",
      "url": "https://pikasim.com/mcp"
    }
  }
}
```

That's it — your agent can now search data and phone-number eSIM plans, check country coverage, and get pricing for 190+ countries. **No API key needed for browsing.**

To **purchase** too, connect `https://pikasim.com/mcp/wallet` instead — it triggers a one-click OAuth flow where you authorize a free, prepaid [agent wallet](https://pikasim.com/agent-wallet) by pasting your wallet code (no key handling, no account, no email). See [Authentication](#authentication).

---

## Three product lines

Don't assume "eSIM" means data-only. PikaSim sells:

1. **Data eSIMs** — anonymous data plans across 190+ countries, from **$0.75**. Discover with `search_esim_packages` / `check_country_coverage`; buy with `purchase_esim`.
2. **Phone-number eSIMs** — a **real carrier phone number** (not VoIP) with voice calls, SMS, and data. US plans give a real **+1** number on AT&T and T-Mobile; global plans cover 157 countries. Discover with `search_phone_plans`; buy with `purchase_phone_plan`.
3. **SMS verification numbers** — receive-only numbers for getting verification codes, no eSIM involved. **Quick SMS**: a one-time code on a temporary number, auto-refund if nothing arrives in 20 minutes (`search_sms_services` → `get_sms_service_countries` → `order_sms_verification` → poll `check_sms_verification`). **Long-term rentals**: keep a number for days to months and receive multiple SMS, with live stock shown per duration (`list_sms_rentals` → `rent_sms_number` → `get_sms_rental_messages` / `extend_sms_rental`).

`search_esim_packages` and `check_country_coverage` return **both** eSIM lines in separate buckets. Package codes appear in `[brackets]` — pass them to the matching purchase tool.

---

## Setup guides

PikaSim is a remote MCP server at `https://pikasim.com/mcp`. The config key and steps differ per client.

### Claude Desktop

Remote servers are added as **Connectors**, not via `claude_desktop_config.json`. Go to **Settings → Connectors → Add custom connector**. To browse, paste `https://pikasim.com/mcp`. To **purchase**, paste `https://pikasim.com/mcp/wallet` and click **Connect** — Claude opens a PikaSim page where you authorize a wallet by pasting your wallet code (one-click OAuth, no key in the URL).

### Claude Code (CLI)

```bash
# Browse only
claude mcp add --transport http pikasim https://pikasim.com/mcp

# With purchasing via OAuth (recommended): add the wallet URL, then run /mcp
# inside Claude Code and pick "Authenticate" — a browser opens the PikaSim
# consent page where you paste your wallet code
claude mcp add --transport http pikasim https://pikasim.com/mcp/wallet

# With purchasing via key (scriptable alternative)
claude mcp add --transport http pikasim https://pikasim.com/mcp \
  --header "Authorization: Bearer ak_live_YOUR_KEY"
```

### Cursor / Windsurf / other JSON-config clients

```json
{
  "mcpServers": {
    "pikasim": {
      "type": "streamable-http",
      "url": "https://pikasim.com/mcp"
    }
  }
}
```

To purchase from clients that support MCP OAuth (Cursor does), use `https://pikasim.com/mcp/wallet` as the URL instead — the client opens the PikaSim consent page where you paste your wallet code.

### ChatGPT (custom connector)

Add a custom connector with URL `https://pikasim.com/mcp` to browse, or `https://pikasim.com/mcp/wallet` to purchase (the wallet URL triggers OAuth — authorize by pasting your wallet code).

---

## Tools

### Public tools (no API key)

| Tool | Description |
|------|-------------|
| `search_esim_packages` | Search eSIM plans by country, region, or keyword. Returns **both** data and phone-number buckets. |
| `search_phone_plans` | Search phone-number eSIMs (real carrier number + voice + SMS + data). |
| `get_package_details` | Full details for a plan: coverage, data, voice/SMS allowance, duration, price, networks, purchase URL. |
| `check_country_coverage` | What PikaSim plans cover a country — data and phone-number buckets with counts and price ranges. |
| `get_pricing` | USD price for a specific plan (data or phone-number) by `packageCode`. |
| `get_phone_plan_pricing` | USD price + voice/SMS/data allowance for a specific phone-number eSIM. |
| `search_sms_services` | Search SMS verification services (Discord, Google, Telegram, … or "Other" for anything unlisted). |
| `get_sms_service_countries` | Countries offering a quick SMS number for one service, with live price, success rate, and VoIP vs real-mobile flag. |
| `list_sms_rentals` | Long-term SMS rental numbers with duration tiers, live prices, and **live stock** per duration. |

### Authenticated tools (require an `ak_live_` agent-wallet key)

| Tool | Description |
|------|-------------|
| `check_balance` | Check your agent-wallet balance. |
| `purchase_esim` | Buy a data eSIM. Returns activation info (ICCID, QR, SM-DP+). |
| `purchase_phone_plan` | Buy a phone-number eSIM (real number + voice + SMS + data). |
| `get_esim_status` | Live status, data usage, and expiration of an eSIM. |
| `get_topup_options` | List valid top-up packages for an existing eSIM. |
| `topup_esim` | Add more data to an existing eSIM. |
| `list_orders` | List recent orders with status and cost. |
| `create_deposit` | Generate a crypto invoice to fund your wallet (BTC, Lightning, Monero, USDT, 50+ altcoins). |
| `cancel_esim` | Cancel an **unused** eSIM and refund to your wallet (only if never installed/activated). |
| `order_sms_verification` | Buy a quick SMS number for one verification code (single-use, 20 min, auto-refund if no SMS). |
| `check_sms_verification` | Poll a quick SMS order for the incoming code. |
| `cancel_sms_verification` | Cancel a waiting quick SMS order for an immediate refund. |
| `list_sms_orders` | List your quick SMS orders and rental numbers. |
| `rent_sms_number` | Rent a long-term receive-only SMS number (extendable; not for banking/financial verification). |
| `get_sms_rental_messages` | Read a rental number's inbox. |
| `extend_sms_rental` | Extend a rental before expiry — days are added on top of the current expiry. |

---

## Authentication

Browsing is open at `https://pikasim.com/mcp`. To purchase, connect `https://pikasim.com/mcp/wallet`, which supports two auth methods:

1. **OAuth (recommended, for app clients like Claude Desktop / ChatGPT):** connecting the wallet URL triggers OAuth 2.1 (Dynamic Client Registration + PKCE). You're sent to a PikaSim consent page where you paste your **wallet code** to authorize. The client receives a revocable access token — never your wallet code or `ak_live_` key. No account, no email, no KYC.
2. **Bearer key (for CLI clients):** send `Authorization: Bearer ak_live_YOUR_KEY`.

The plain `https://pikasim.com/mcp` URL is **browse-only**. Create a wallet and get your wallet code + key at **https://pikasim.com/agent-wallet** (save the wallet code; it's the only way back in).

### Wallet, in brief

- Prepaid, crypto-funded balance (min deposit **$10**). Retail pricing.
- Fund via `create_deposit` (Bitcoin, Lightning, Monero, USDT, and 50+ altcoins) or at the wallet page.
- No personal account, email, or KYC required.

> There's also a separate **reseller** program at https://pikasim.com/reseller — a B2B track with its own `pk_live_` key and a 10% discount. Reseller keys also work on this MCP server at wholesale pricing.

---

## Example

```jsonc
// 1. Find data plans for Japan
{ "tool": "search_esim_packages", "arguments": { "country": "JP", "type": "data" } }

// 2. Get a real US phone number plan
{ "tool": "search_phone_plans", "arguments": { "country": "US" } }

// 3. Check your wallet, then buy (needs ak_live_ key)
{ "tool": "check_balance", "arguments": {} }
{ "tool": "purchase_esim", "arguments": { "packageCode": "PACKAGE_CODE_FROM_SEARCH" } }
```

---

## Rate limits & errors

- Public browsing is rate-limited per IP. Authenticated tools are scoped to your wallet.
- Errors return a clear message (e.g. insufficient balance → fund via `create_deposit` or the wallet page).
- Full reference: **https://pikasim.com/mcp-docs**

---

## About PikaSim

[PikaSim](https://pikasim.com) is a privacy-first eSIM marketplace: no accounts, no email, no KYC, crypto settlement. The MCP server exposes the same catalog and ordering to AI agents.

- Website: https://pikasim.com
- MCP docs: https://pikasim.com/mcp-docs
- Agent wallet: https://pikasim.com/agent-wallet
- Agentic ordering guide: https://pikasim.com/agentic-esim-ordering

## For registries (Dockerfile)

You do **not** need Docker to use PikaSim — just point your client at the URL above. The included [`Dockerfile`](Dockerfile) exists only so registries (e.g. [Glama](https://glama.ai/mcp/servers/codebruinc/pikasim-mcp)) can start a container, speak MCP over stdio, and introspect the tool set. It runs [`mcp-remote`](https://www.npmjs.com/package/mcp-remote), which bridges a local stdio client to the hosted Streamable HTTP endpoint. All public tools are discoverable with no key.

## License

MIT — see [LICENSE](LICENSE). This repository contains documentation for the hosted PikaSim MCP server; the server itself runs at `https://pikasim.com/mcp`.
