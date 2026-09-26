# Webotto WordPress Multi-Agent

Initial multi-agent foundation for Gentle AI + Codex.

## Current phase
Agent definitions, project governance, and a minimal WordPress MCP adapter endpoint.

The MCP adapter endpoint is implemented as a WordPress plugin at:

```text
wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php
```

Expected REST endpoint:

```text
/wp-json/mcp/mcp-adapter-default-server
```

## Agents
- orchestrator
- developer
- security
- qa

Model assignment policy:

```text
wordpress-orchestrator -> reasoning
wordpress-developer    -> coding
wordpress-security     -> security
wordpress-qa           -> testing
```

The canonical mapping is stored in `agents/model-policy.yml`. Gentle AI is responsible for mapping these logical profiles to concrete model IDs.
