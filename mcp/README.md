# MCP Integration Status

`MCP/PREPARED, NOT CONNECTED`. Project-local Codex stdio configuration and a PowerShell launcher are prepared for `https://papaotto.com/wp-json/mcp/mcp-adapter-default-server`. No remote connection or test was made. No production writes or deployment occurred, and no global Codex configuration was changed.

The model map is `gpt-6-astra` with low reasoning effort for the orchestrator, `gpt-6-sol` with medium effort for development, `gpt-6-astra` with low effort for security, and `gpt-6-luna` with high effort for QA. Account and client entitlement remains unverified.

The launcher reads the ignored local `.env`; Codex does not load dotenv files automatically. The checked-in `.env.example` has placeholders, while the local `.env` is intentionally blank. A user must fill it locally with credentials for a dedicated account with the required admin capability and an application password. Never commit the secret or share it in chat. `-ValidateOnly` checks only local configuration and never launches the package; blank credentials correctly produce a blocked result.

Codex project trust is required for `.codex/config.toml` to apply. If this project is not trusted, its configuration is ignored and a mismatched global `wordpress` server may remain effective. Do not launch Codex until the trusted project-local layer is confirmed. No global configuration values are copied or disclosed here.

The adapter at `wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php` handles initialization and `tools/list`, but returns an empty tool list and has no `tools/call` implementation. The current MCP integration therefore exposes zero WordPress actions; this setup prepares transport configuration only and does not establish a connection or usable WordPress tool.

The launcher pins `@automattic/mcp-wordpress-remote@0.4.0`, which requires Node.js 22 or newer. Normal launch uses `npx`, which may download the package; do not run it as part of local readiness validation.
