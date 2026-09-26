# Webotto MCP Adapter

The Codex MCP configuration points to this WordPress REST route:

```text
https://papaotto.com/wp-json/mcp/mcp-adapter-default-server
```

The local implementation lives in:

```text
wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php
```

## Endpoint

- Namespace: `mcp`
- Route: `/mcp-adapter-default-server`
- Full WordPress REST path: `/wp-json/mcp/mcp-adapter-default-server`
- Methods: `GET`, `POST`
- Access: authenticated WordPress users with `manage_options`

## Supported checks

- `GET` returns adapter metadata for connection verification.
- `POST` supports minimal JSON-RPC MCP handshake methods:
  - `initialize`
  - `tools/list`

This adapter intentionally starts with no exposed tools. Add tools only after their permissions, input validation, and output escaping rules are defined.
