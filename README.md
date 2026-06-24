# PikaSim MCP Server

> Buy eSIMs from an AI agent — no account, no email, no KYC. Anonymous data plans and **real carrier phone numbers** across 190+ countries, settled in crypto from a prepaid agent wallet.

PikaSim is a **remote, hosted MCP server** (Streamable HTTP). You don't run any code — just point your AI agent at the URL and it can search plans, check coverage, get pricing, and (with a funded agent wallet) purchase eSIMs autonomously.

- **Endpoint:** `https://pikasim.com/mcp`
- **Transport:** Streamable HTTP (JSON-RPC over HTTP POST), protocol `2025-03-26`
- **Docs:** https://pikasim.com/mcp-docs
- **Agent wallet:** https://pikasim.com/agent-wallet
- **Browsing needs no key.** Purchasing needs a prepaid `ak_live_` agent-wallet key.

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

To **purchase** too, create a free [agent wallet](https://pikasim.com/agent-wallet) (a prepaid, crypto-funded balance at retail pricing) and attach its `ak_live_` key (see [Authentication](#authentication)).

---

## Two product lines

Don't assume "eSIM" means data-only. PikaSim sells both:

1. **Data eSIMs** — anonymous data plans across 190+ countries, from **$0.75**. Discover with `search_esim_packages` / `check_country_coverage`; buy with `purchase_esim`.
2. **Phone-number eSIMs** — a **real carrier phone number** (not VoIP) with voice calls, SMS, and data. US plans give a real **+1** number on AT&T and T-Mobile; global plans cover 157 countries. Discover with `search_phone_plans`; buy with `purchase_phone_plan`.

`search_esim_packages` and `check_country_coverage` return **both** lines in separate buckets. Package codes appear in `[brackets]` — pass them to the matching purchase tool.

---

## Setup guides

PikaSim is a remote MCP server at `https://pikasim.com/mcp`. The config key and steps differ per client.

### Claude Desktop

Remote servers are added as **Connectors**, not via `claude_desktop_config.json`. Go to **Settings → Connectors → Add custom connector** and paste `https://pikasim.com/mcp`. To purchase, paste `https://pikasim.com/mcp/ak_live_YOUR_KEY` instead.

### Claude Code (CLI)

```bash
# Browse only
claude mcp add --transport http pikasim https://pikasim.com/mcp

# With an agent wallet (purchasing)
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

### ChatGPT (custom connector)

Add a custom connector with URL `https://pikasim.com/mcp` (or `https://pikasim.com/mcp/ak_live_YOUR_KEY` to purchase).

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

---

## Authentication

Browsing is open. To purchase, fund a prepaid **agent wallet** and attach its `ak_live_` key one of two ways:

1. **Key-in-URL** (Claude Desktop, ChatGPT, any connector that only takes a URL):
   `https://pikasim.com/mcp/ak_live_YOUR_KEY`
2. **Bearer header** (CLI clients):
   `Authorization: Bearer ak_live_YOUR_KEY`

The plain `https://pikasim.com/mcp` URL (no key) is **browse-only** — the wallet and funds live behind the key. Create a wallet and get a key at **https://pikasim.com/agent-wallet** (save the wallet code; it's the only way back in).

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

## License

MIT — see [LICENSE](LICENSE). This repository contains documentation for the hosted PikaSim MCP server; the server itself runs at `https://pikasim.com/mcp`.
