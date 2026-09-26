# Design: Local Multi-Agent Readiness

## Technical Approach

Prepare this repository for project-local Codex specialist discovery without changing plugin behavior or external integrations. Add three project-local TOML entries referencing the existing role Markdown, which remains the source of role detail. Keep `agents/orchestrator.md` authoritative for coordination and evidence-based reporting. Documentation may use external Codex source/documentation research to support the TOML format, but that is not proof of local discovery or execution. Do not launch Codex: its configured global WordPress MCP could be invoked. Report local runtime discovery as unverified; label repository preparation `LOCAL/PREPARED` and MCP integration `MCP/PENDING`.

## Architecture Decisions

| Decision | Choice | Alternatives and rationale |
|---|---|---|
| Codex specialist definitions | `.codex/agents/{wordpress-developer,wordpress-security,wordpress-qa}.toml`, with `name`, `description`, and flattened `developer_instructions` that direct Codex to the corresponding `agents/*.md`. | Duplicating role content would create two sources to maintain. User-level definitions would violate project-local discovery. No model field is added because availability is not established. |
| Guidance layout | Keep orchestration in `agents/orchestrator.md`; use README and architecture for status/entry points, and focused QA, security, Git, Engram, and MCP docs for operational boundaries. | One long README would blur responsibilities; new parallel role documents are unnecessary because the existing Markdown is authoritative. |
| QA evidence | Discover existing test directories, manifests, scripts, and documented commands before selecting checks; run every applicable available automated test, plus applicable local syntax, smoke, API, and regression checks. Report unavailable or blocked checks explicitly, never silently skip them. | Assuming no suite exists or treating an unrun check as N/A hides coverage gaps. No framework or dependency is installed. |
| WordPress security review | Enumerate authentication and authorization, capability checks, nonces, validation/sanitization, output escaping, REST permissions, secrets, external requests/MCP, plus SQL injection, XSS, CSRF, uploads, and AJAX when applicable. Findings report severity, file/line evidence, impact, and remediation; distinguish reviewed from unreviewed surfaces. | Generic “security reviewed” claims are not auditable and must not exceed observed evidence. |
| Engram and Git boundaries | Document Engram as the sole persistent-memory source scoped explicitly to project `Webotto`; preserve the known project-name warning and foreign sync-target error. Document status/diff-first Git hygiene and require user direction before delivery actions. | Repairing mappings/sync or performing commit, push, or PR actions would mutate out-of-scope state. |
| No-change boundaries | Review mode remains user-owned and is neither read nor changed by this work. All production resources remain untouched: no access, inspection, request, or mutation. No WordPress or MCP invocation, user-level settings access, secret access, Engram state change, dependency install, commit, push, or PR. | These operations are outside the authorized local documentation/configuration scope. |

## Data Flow

```text
Codex project discovery (planned, not locally proven)
  -> small local TOML entry
  -> authoritative specialist Markdown
  -> orchestrator assigns bounded work
  -> developer / security / QA evidence
  -> orchestrator integrates and reports observed results

External Codex source/docs evidence may support the file format; it does not establish runtime discovery.
Documentation status: LOCAL/PREPARED; MCP/PENDING absent direct, authorized evidence.
```

## File Changes

| File | Action | Description |
|---|---|---|
| `.codex/agents/wordpress-developer.toml` | Create | Project-local developer definition referencing `agents/wordpress-developer.md`. |
| `.codex/agents/wordpress-security.toml` | Create | Project-local security definition referencing `agents/wordpress-security.md`. |
| `.codex/agents/wordpress-qa.toml` | Create | Project-local QA definition referencing `agents/wordpress-qa.md`. |
| `agents/orchestrator.md` | Modify | Clarify discovery, proportional delegation, SDD coordination, review, evidence, Engram, Git, boundaries, and completion reporting. |
| `README.md`, `docs/architecture.md` | Modify | Entry-point and architecture status: local preparation versus pending MCP; do not assert runtime/model availability. |
| `docs/qa.md`, `docs/security.md`, `docs/git-workflow.md`, `docs/engram.md` | Create | Reproducible local QA, WordPress review boundary, safe Git procedure, and project-scoped Engram status/limitations. |
| `mcp/README.md` | Modify | Identify adapter/endpoint as documented local preparation, not proof of a connected MCP client; define future security gates. |
| Plugin PHP, user configuration, dependencies, Engram data, OpenSpec spec/proposal, review mode, production resources | No change | Explicitly outside the implementation boundary; production is not accessed or inspected. |

## Interfaces / Contracts

TOML entries contain `name`, `description`, and `developer_instructions`, based on external Codex format research only; references target the role Markdown without duplicating it. QA includes syntax targets `wp-content/plugins/webotto-hello/webotto-hello.php` and `wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php`. No local Codex runtime discovery is claimed or attempted. No user-level settings, secrets, MCP credentials/endpoints, or Engram state are accessed or written.

## Testing Strategy

| Layer | What to verify | Approach |
|---|---|---|
| Test discovery and automated coverage | Inventory test directories, project manifests, CI/workflow files, scripts, and documented test commands; run each applicable discovered suite and report exact command/outcome. | A genuinely absent suite is reported as “not found” with inventory basis. A present but unavailable suite/tool/dependency is `BLOCKED` with reason; failures are reported. Never silently omit an applicable check or install a framework. |
| Syntax, smoke, API, regression | Check PHP syntax for both named targets when PHP is available. Select smoke/API/regression checks from changed behavior and existing local test facilities; state why each check applies or is N/A. | Run only against local/non-production fixtures or services. If an applicable local target, prerequisite, or safe execution path is unavailable, report `BLOCKED`, not pass or silent skip. Never contact production. |
| Project config and documentation | TOML parses with an available parser, references resolve, and claims/boundaries match observed evidence. | Use existing tools only; no install. Static external Codex source/docs research supports format claims only. Do not launch Codex or claim local agent discovery, since its global WordPress MCP may run. |
| Change scope | Only approved local agent/configuration and documentation artifacts are proposed. | Inspect status/diff and paths; no commit, push, PR, review-mode operation, production access, WordPress/MCP invocation, or Engram mutation. |

## Threat Matrix

| Boundary | Applicability | Safe/failure behavior and planned acceptance check |
|---|---|---|
| Documentation-like paths | N/A — no executable-file classifier or runner changes. | Keep Markdown/TOML as documentation/configuration; introduce no execution path. |
| Git repository selection | Applicable — the guidance covers Git actions. | Confirm checkout/root before mutation; if ambiguous, stop. Verify guidance requires this before staging. |
| Commit state | Applicable — guidance covers staged and unstaged work. | Inspect status and both diffs; stage explicit intended paths only. Verify unrelated, untracked, or secret-bearing files are excluded and secret values are not reported. |
| Push state | Applicable — delivery guidance covers push boundaries. | No push in this change; verify future push requires explicit authorization and destination inspection. |
| PR commands | Applicable — delivery guidance covers PR boundaries. | No PR here; verify guidance requires explicit authorization and intended-branch diff review. |

These are documentation acceptance checks, not an automation harness; preserve applicable cases in tasks. No repository-selection, commit, push, or PR subprocess is implemented.

## Migration / Rollout

No migration required. Project-local discovery remains unverified until separately and safely validated; this change does not open a Codex runtime because that could invoke the existing global WordPress MCP. Do not claim agent invocation, model availability, or live MCP connectivity without direct evidence. Keep the planned work within the approved single-PR strategy; confirm size during implementation without dropping required scope.

## Open Questions

- None. The Codex project-agent format and role-document references are fixed by the request; the known Engram health issues remain intentionally unresolved.
