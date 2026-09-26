# Webotto WordPress Multi-Agent

## Status

- `LOCAL/PREPARED`: project-local Codex configuration pins `gpt-6-astra` with low reasoning effort for the orchestrator, `gpt-6-sol` with medium effort for development, `gpt-6-astra` with low effort for security, and `gpt-6-luna` with high effort for QA. Account and client entitlement for these models remains unverified.
- `MCP/PREPARED, NOT CONNECTED`: the project-local stdio server configuration and launcher are prepared for the fixed papaotto.com endpoint. No remote connection or test was made, and no production writes or deployment occurred.
- The local WordPress adapter advertises an empty tool list and does not implement `tools/call`; MCP currently exposes zero WordPress actions.

The Markdown role documents remain authoritative. `agents/model-policy.yml` contains Gentle-AI profiles, not Codex model IDs.

## Local Configuration

Codex must trust this project before reading `.codex/config.toml`. If the project is not trusted, the project configuration is ignored and a mismatched global `wordpress` server may remain effective. Do not launch Codex until the trusted project-local configuration is confirmed. No global configuration was changed.

`.env` is ignored by Git and is read by the PowerShell launcher because Codex does not load dotenv files automatically. Fill it locally with credentials for a dedicated account with the required admin capability and an application password. Keep credentials out of the repository and chat. The checked-in `.env.example` contains placeholders only; the local `.env` is intentionally blank. `-ValidateOnly` validates without launching the MCP package and blocks while credentials are blank.

## Local QA

Run `pwsh -NoProfile -File scripts/check-local-readiness.ps1` after changing local agent or readiness guidance, before reporting readiness. It checks required paths, TOML with Python `tomllib`, model mapping, dotenv ignore boundaries, PowerShell syntax, Git whitespace, path scope, and secret-like assignments without reading `.env` during secret scanning or printing matched values. Missing PHP blocks PHP lint; absent local WordPress and test infrastructure block smoke/API/regression checks. It makes no network requests. See [QA](docs/qa.md), [Security](docs/security.md), [Git](docs/git-workflow.md), [Engram](docs/engram.md), and [Architecture](docs/architecture.md).
