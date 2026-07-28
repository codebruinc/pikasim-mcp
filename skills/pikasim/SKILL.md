---
name: pikasim
description: "Buy mobile connectivity from PikaSim — anonymous eSIM data plans in 190+ countries (from $0.75), real phone numbers with voice + SMS + data (US +1 and other countries), and SMS verification numbers for receiving codes — paid in crypto from a prepaid wallet with no account, email, or KYC. An agent can fully self-onboard: one call mints a wallet + API key with a small welcome credit, so it can go from nothing to a live purchase with no human. Routes to the best channel the host supports (remote MCP server, plain REST over HTTPS, or a browser link for the user). Triggers when the user mentions eSIM, travel data, roaming, SIM card, a phone number for calls or SMS, receiving an SMS/OTP verification code, burner or temporary number, anonymous or no-KYC or crypto-paid connectivity — or when the agent itself needs mobile data or a phone number to complete a task."
compatibility: "Needs ONE of: an MCP-capable client (remote Streamable-HTTP server, OAuth or Bearer key), or outbound HTTPS (curl/fetch) for the REST path, or a browser to hand the user a link. Payments: BTC (on-chain + Lightning), XMR, USDT, or card via browser. No account, email, or KYC on any path."
metadata:
  author: codebruinc
  version: "1.0.0"
  homepage: "https://pikasim.com/agentic-esim"
  docs: "https://pikasim.com/mcp-docs"
  repository: "https://github.com/codebruinc/pikasim-mcp"
---

# PikaSim

PikaSim sells three product lines an agent can buy end-to-end with no human, no
account, and no KYC, settled from a prepaid crypto wallet:

1. **Data eSIMs** — anonymous data plans, 190+ countries, from $0.75.
2. **Phone-number eSIMs** — REAL carrier numbers (not VoIP) with voice + SMS +
   data. US plans give a +1 number on AT&T/T-Mobile; local and global plans
   cover 157 countries.
3. **SMS verification numbers** — receive-only numbers for one-time codes
   (auto-refund if no code arrives in 20 min) or long-term rentals.

Do NOT assume "eSIM" means data-only — if the user needs calls, SMS, or to
receive a verification code, product lines 2 and 3 exist. Details, gotchas, and
when-to-use guidance: [products.md](references/products.md).

## Pick a path

Walk in order; first match wins.

1. **MCP-capable host?** (Claude.ai, Claude Desktop/Code, Cursor, ChatGPT,
   Gemini CLI, anything that can add a remote Streamable-HTTP server.)
   Highest fidelity: typed tools, built-in discovery, OAuth or key auth.
   → [mcp.md](references/mcp.md)

2. **Outbound HTTPS only?** (shell + curl, fetch, any HTTP client.) Full
   catalog + purchase via REST; cold-start wallet creation works here too via
   one JSON-RPC call. → [api.md](references/api.md)

3. **Browser + human in the loop?** Hand the user a link:
   storefront <https://pikasim.com>, wallet dashboard
   <https://pikasim.com/agent-wallet> (create/fund a wallet, mint an
   `ak_live_` API key to bring back to paths 1–2).

4. **None of the above** — give the user <https://pikasim.com/agentic-esim>
   and stop.

## Cold start (no wallet yet, no human available)

One call mints a wallet + `ak_live_` API key + a small spend-only welcome
credit — often enough for a first SMS code without any funding:

- MCP: call the `create_wallet` tool on the keyless endpoint
  `https://pikasim.com/mcp`.
- REST/curl: same tool via one JSON-RPC POST — exact request in
  [api.md](references/api.md).

**SAVE the wallet code AND the API key immediately — each is shown exactly
once and there is no account recovery, password reset, or support lookup
without them.** Fund later from $1 (Lightning/BTC/XMR/USDT invoice the agent
can pay itself, or a payment page link to hand the user).

## Spending safeguards

Real money moves on every purchase. Non-negotiable rules:

- **Confirm before buying.** Show product, coverage, duration, and exact USD
  price; wait for explicit approval. Skip only when the user has clearly opted
  into autonomous purchasing for the session.
- **Check the price first** (`get_pricing` / packages API) — never buy from a
  remembered or assumed price.
- **Treat the wallet code and `ak_live_` key as cash.** Never paste them into
  chat logs, commits, or shared channels. Store in memory or a secrets store.
- **Deliver eSIMs by link, not raw codes.** Purchases return an install/invoice
  URL with QR + instructions — pass that URL along.
- **SMS caveat:** delivery of a code from one specific service is never
  guaranteed (some services block virtual ranges). Quick verifications
  auto-refund to the wallet if nothing arrives in 20 minutes; that refund is
  the remedy — don't fight for a code that isn't coming, try another number or
  country instead.
- **Refunds:** unused eSIMs can usually be cancelled back to the wallet
  (`cancel_esim`); activated/used ones cannot. Don't promise refunds beyond
  that.

## Source of truth

This skill routes; it does not enumerate. Live catalog, prices, and coverage
come from the API/MCP tools at call time — never from memory. Full API
reference: <https://pikasim.com/api-docs-for-ai> · OpenAPI:
<https://pikasim.com/openapi.yaml> · MCP docs: <https://pikasim.com/mcp-docs>.
