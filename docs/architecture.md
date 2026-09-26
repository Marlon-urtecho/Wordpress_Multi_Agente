# Architecture and Status

## Local workflow

`User -> wordpress-orchestrator -> developer -> applicable security review -> QA/tests -> final diff review -> Git and Engram -> report`

The orchestrator owns scope, delegation, integration, and reporting. Existing role Markdown is authoritative; three project-local Codex agent files point to those roles. Project-local model pins are `gpt-6-astra`/low for the orchestrator, `gpt-6-sol`/medium for development, `gpt-6-astra`/low for security, and `gpt-6-luna`/high for QA. Account and client entitlement is unverified.

Codex must trust this project to load `.codex/config.toml`. When it is not trusted, project configuration is ignored and a mismatched global `wordpress` server may remain effective. Do not launch Codex until the trusted project-local layer is confirmed. No global configuration was altered.

## Integration boundary

`MCP/PREPARED, NOT CONNECTED`. Project configuration points a stdio launcher at the fixed papaotto.com endpoint. The launcher reads ignored local `.env`; it is not loaded by Codex automatically. No remote connection or test was made, and no production writes or deployment occurred. Credentials must be supplied locally for a dedicated account with the required admin capability and an application password; never commit or share them in chat.

The adapter source at `wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php` handles initialization and `tools/list`, returns an empty tool list, and does not implement `tools/call`. Therefore MCP currently provides zero WordPress actions. The logical profiles in `agents/model-policy.yml` are Gentle-AI profiles, not Codex model IDs.

Use the [QA procedure](qa.md) for local-only checks and the [MCP notes](../mcp/README.md) for setup boundaries. No production or external service was contacted as part of this architecture verification.
