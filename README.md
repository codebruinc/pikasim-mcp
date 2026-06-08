# PikaSim MCP Server

Browse, compare, and purchase eSIMs for 190+ countries via AI agents using the [Model Context Protocol](https://modelcontextprotocol.io).

**Endpoint:** `https://pikasim.com/mcp`
**Transport:** Streamable HTTP (stateless)
**Documentation:** [pikasim.com/mcp-docs](https://pikasim.com/mcp-docs)

## Quick Start

Add to your AI agent's MCP config:

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

No API key needed for browsing. Add an optional `Authorization` header to unlock purchasing tools:

```json
{
  "mcpServers": {
    "pikasim": {
      "type": "streamable-http",
      "url": "https://pikasim.com/mcp",
      "headers": {
        "Authorization": "Bearer pk_live_your_api_key_here"
      }
    }
  }
}
```

Get a free API key at [pikasim.com/reseller](https://pikasim.com/reseller).

## Tools

### Public (no auth required)

| Tool | Description |
|------|-------------|
| `search_esim_packages` | Search by country code, region, or keyword. Returns top 10 matching packages with prices. |
| `get_package_details` | Full details for a package: coverage, data, duration, price, networks, and purchase URL. |
| `check_country_coverage` | All available plans for a country with price ranges and data options. |
| `get_pricing` | Price and accepted payment methods for a specific package. |

### Authenticated (free reseller API key)

| Tool | Description |
|------|-------------|
| `purchase_esim` | Buy an eSIM. Returns ICCID, QR code, and activation details. |
| `check_balance` | Wallet balance and available credit. |
| `get_esim_status` | Live status, data usage, and expiration of a purchased eSIM. |
| `topup_esim` | Add more data to an existing eSIM. |
| `get_topup_options` | Available top-up packages for an eSIM with prices. |
| `list_orders` | Recent order history with status and cost. |
| `create_deposit` | Fund wallet with crypto (BTC, XMR, USDT, 50+ altcoins). |
| `cancel_esim` | Cancel an unused eSIM for a wallet refund. |

## Supported Clients

Works with any MCP client that supports Streamable HTTP transport:

- **Claude Desktop** - Add to `claude_desktop_config.json`
- **Claude Code** - Add to `.mcp.json`
- **Cursor** - Settings > MCP Servers > Add Server
- **Windsurf** - MCP settings
- **Custom agents** - Any client implementing the [Streamable HTTP transport](https://modelcontextprotocol.io/specification/2025-03-26/basic/transports#streamable-http)

## Authentication

Public tools work without any API key. Authenticated tools require a PikaSim reseller API key (`pk_live_...`), which is free to obtain:

1. Sign up at [pikasim.com/reseller](https://pikasim.com/reseller)
2. Get approved (usually same day)
3. Generate your API key from the dashboard
4. Fund your wallet with crypto

When authenticated, public browsing tools also show 10% discounted reseller pricing.

## Examples

### Test with cURL

```bash
# Search Japan eSIM packages
curl -X POST https://pikasim.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "search_esim_packages",
      "arguments": { "country": "JP" }
    }
  }'
```

### Python

```python
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client

async def main():
    async with streamablehttp_client("https://pikasim.com/mcp") as (
        read_stream, write_stream, _
    ):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()
            result = await session.call_tool(
                "search_esim_packages",
                arguments={"country": "JP"}
            )
            print(result.content[0].text)

import asyncio
asyncio.run(main())
```

### Node.js

```javascript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StreamableHTTPClientTransport }
  from "@modelcontextprotocol/sdk/client/streamableHttp.js";

const transport = new StreamableHTTPClientTransport(
  new URL("https://pikasim.com/mcp")
);

const client = new Client(
  { name: "my-agent", version: "1.0" },
  { capabilities: {} }
);

await client.connect(transport);

const result = await client.callTool(
  "search_esim_packages",
  { country: "JP" }
);
console.log(result.content[0].text);

await client.close();
```

## Rate Limits

| Scope | Limit | Window |
|-------|-------|--------|
| MCP endpoint (per IP) | 60 requests | 1 minute |
| Reseller API (per key) | 60 requests | 1 minute |
| Orders (per key) | 100 orders | 1 day |

## Links

- [MCP Documentation](https://pikasim.com/mcp-docs)
- [REST API Documentation](https://pikasim.com/api-docs-for-ai)
- [OpenAPI Specification](https://pikasim.com/openapi.yaml)
- [Reseller Program](https://pikasim.com/reseller)
- [LLM.txt](https://pikasim.com/llm.txt)
- [Website](https://pikasim.com)

## License

Licensed under the [MIT License](LICENSE).

This repository contains documentation and integration details for the PikaSim MCP server. The server itself is a hosted service at `pikasim.com/mcp`.
