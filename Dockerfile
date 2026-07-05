# PikaSim is a REMOTE, hosted MCP server (Streamable HTTP) at https://pikasim.com/mcp.
# There is no local server code to build. This image exists so registries such as
# Glama can start a container, speak MCP over stdio, and introspect the tool set.
#
# It runs `mcp-remote`, which bridges a local stdio MCP client to the hosted
# Streamable HTTP endpoint. The plain /mcp URL is browse-only (no key required),
# so all public tools are discoverable without any secret. Purchasing tools are
# advertised too and only require an agent-wallet key at call time.
FROM node:22-alpine

# mcp-remote: proxies a local stdio MCP client to a remote HTTP(S) MCP server.
# Pinned and installed globally so startup is deterministic and needs no network
# fetch (npx would re-resolve at runtime).
RUN npm install -g mcp-remote@0.1.38

# Run as the built-in non-root user, with a writable HOME for mcp-remote's cache.
USER node
ENV HOME=/home/node

# Bridge stdio <-> the hosted PikaSim MCP endpoint.
ENTRYPOINT ["mcp-remote", "https://pikasim.com/mcp"]
