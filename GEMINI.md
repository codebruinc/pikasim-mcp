# PikaSim

The `pikasim` MCP server sells mobile connectivity: data eSIMs for 190+ countries, eSIMs with a real phone number (calls, SMS and data), and numbers for receiving SMS verification codes. No account, no email, no KYC.

- Ask what the user needs (country, how many days or how much data, whether they need a phone number) and search with `search_esim_packages`, `search_phone_plans` or `check_country_coverage`.
- `purchase_esim` and `purchase_phone_plan` return a checkout link for the exact plan. Give that link to the user: they pay on pikasim.com by card or crypto and install the eSIM from the page it opens. Never invent a link.
- To have purchases paid from a prepaid balance (and to use the SMS tools), the user connects a PikaSim Wallet: reconnect with `https://pikasim.com/mcp/wallet` (OAuth sign-in with the wallet code). An agent can also call `create_wallet` to get a wallet and API key in one step.
- Setup steps for every app, the full tool list and the FAQ: https://pikasim.com/mcp
