# Tasks: Local Multi-Agent Readiness

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 580 authored additions + deletions; excludes this task artifact |
| Estimate breakdown | TOMLs 36 + orchestrator 120 + existing docs 84 + four new docs 220 + PowerShell checker 120 = 580 |
| 400-line budget risk | High |
| Chained PRs recommended | Yes by size; requested delivery remains single-pr |
| Suggested split | One single PR; `size:exception` accepted for this change only |
| Delivery strategy | exception-ok |
| Chain strategy | size-exception |

Decision needed before apply: No
Chained PRs recommended: Yes
Chain strategy: size-exception
400-line budget risk: High

The user accepted `size:exception` for this change only at the existing 580 authored changed-line forecast. The requested delivery target remains one single PR, and the chain strategy remains `size-exception`. This acceptance does not authorize commit, push, PR creation, MCP, production, global or user configuration, Engram data, or review mode changes. Do not omit security, QA, or documentation scope to reduce this estimate.

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Local roles, orchestrator, checker | Single PR; exception accepted for this change only | `pwsh -NoProfile -File scripts/check-local-readiness.ps1` | N/A: do not launch Codex or contact WordPress/MCP | Revert `.codex/agents/`, orchestrator, and checker changes |
| 2 | Onboarding, security, QA, Git, Engram, MCP docs | Same single PR; exception accepted for this change only | Checker plus `git diff --check` | N/A: documentation-only status, no live integration | Revert README and scoped `docs/`/`mcp/` changes |

## Phase 1: RED Acceptance Checks

Execution order: 1.1 first; 1.2-1.6 follow serially because they extend the same checker.

- [ ] 1.1 RED: Create `scripts/check-local-readiness.ps1` as a framework-free checker with expected failures for missing approved artifacts and required guidance; use existing tools only.
- [ ] 1.2 RED: Assert Git guidance verifies repository identity/root before any Git action (Secure Git review and staging guidance).
- [ ] 1.3 RED: Assert status and staged-diff inspection, explicit-path staging, and secret-safe reporting; never print matched secret values (Secure Git review and staging guidance).
- [ ] 1.4 RED: Assert push guidance requires explicit authorization and destination review; this change performs no push (Secure Git review and staging guidance).
- [ ] 1.5 RED: Assert PR guidance requires explicit authorization and intended-branch diff review; this change creates no PR (Secure Git review and staging guidance).
- [ ] 1.6 RED: Add checks for the approved path allowlist, all three TOML registrations, TOML parsing when available, and PowerShell parser validity (Bounded local change scope; Project-local specialist discovery).

## Phase 2: Local Readiness

After Phase 1, tasks 2.1-2.6 are independent and may run in parallel; Phase 3 waits for all six.

- [ ] 2.1 Create `.codex/agents/wordpress-developer.toml`, `.codex/agents/wordpress-security.toml`, and `.codex/agents/wordpress-qa.toml`, referencing their matching role docs (`agents/wordpress-developer.md` (read-only), `agents/wordpress-security.md` (read-only), `agents/wordpress-qa.md` (read-only)); omit model claims (Project-local specialist discovery).
- [ ] 2.2 Update `agents/orchestrator.md` for discovery, bounded delegation, SDD, integration, security/QA evidence, Git, Engram, scope limits, and accurate reporting (Right-sized delegation; Evidence-based QA).
- [ ] 2.3 Update `README.md` and `docs/architecture.md` with `LOCAL/PREPARED` and `MCP/PENDING`; make no runtime, model, or connection claims (Accurate onboarding status labels).
- [ ] 2.4 Create `docs/qa.md` and `docs/security.md` for inventory-driven framework-free tests, both PHP syntax targets, blocked prerequisites, attack surfaces, evidence, and unreviewed areas (Evidence-based QA; WordPress security review).
- [ ] 2.5 Create `docs/git-workflow.md` and `docs/engram.md` for safe staging/delivery and Webotto-scoped single-source memory; preserve the known warning and sync error without accessing Engram (Secure Git review; Project-scoped single-source Engram use).
- [ ] 2.6 Update `mcp/README.md` with pending/unverified status and future authorization, input-validation, and output-escaping gates; do not invoke or configure MCP (Future MCP security boundary).

## Phase 3: Verification

Run 3.1-3.4 sequentially so each check observes the completed and unchanged candidate.

- [ ] 3.1 Run `pwsh -NoProfile -File scripts/check-local-readiness.ps1`; verify TOML, PowerShell, path boundaries, Git status, and secret-pattern checks, reporting unavailable parsers as blocked without installs.
- [ ] 3.2 Run `git diff --check` and `git status --short`; review the full diff and confirm only approved project-local agent/documentation/checker paths changed, with no secret values in output.
- [ ] 3.3 Run `php -l` on both design targets when PHP exists; otherwise report both checks blocked. Run only applicable existing local tests; do not contact production or assert Codex/MCP runtime discovery.
- [ ] 3.4 Confirm all four Git RED checks pass, onboarding labels and Engram limitations remain accurate, and no plugin PHP, user config, dependencies, production, MCP, or Engram state changed.