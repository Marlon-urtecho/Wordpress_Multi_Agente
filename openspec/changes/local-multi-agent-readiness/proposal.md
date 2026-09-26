# Proposal: Local Multi-Agent Readiness

## Intent

Make the repository's existing WordPress roles usable as project-local Codex workers and give the orchestrator a bounded, evidence-based workflow for planning, implementation, security review, QA, and reporting. This closes the gap between the existing role guidance and repeatable local execution without expanding runtime integrations.

## Scope

### In Scope
- Add project-local `.codex/agents/*.toml` worker definitions for the existing developer, security, and QA roles, using the user-confirmed Codex format.
- Update orchestrator guidance for discovery, planning, SDD, proportionate delegation, implementation, security, QA/tests, review, Git, Engram, and reporting; retain the rule against delegating tiny tasks.
- Define framework-free QA commands for syntax-checking `webotto-hello.php` and the MCP adapter PHP file. Report missing PHP runtime as blocked; install no framework.
- Update README and architecture, security, QA, Git, and Engram documentation. Distinguish LOCAL/PREPARED work from MCP/PENDING work.
- Preserve the confirmed audit boundary: an existing global Codex WordPress MCP registration is out of scope and is not verified connected. The Engram project-name warning and foreign cloud-sync-target error remain untouched.

### Out of Scope
- Any MCP call, connection, or configuration; production access or changes; and all plugin PHP edits.
- Reading or writing Codex user configuration, secrets, or Engram state; changing Engram cloud-sync or project mappings; enabling review mode.
- Claims of successful runtime, security, or test results without captured evidence.

## Capabilities

### New Capabilities
- `local-multi-agent-readiness`: Project-local worker definitions, bounded orchestration guidance, framework-free QA commands, and clear separation of prepared local work from pending MCP integration.

### Modified Capabilities
- None. No existing OpenSpec specs were present in the workspace search.

## Approach

Keep all changes in local agent/configuration and documentation files. Mirror the existing role documents in the verified Codex TOML format; make QA commands conditional on PHP availability and describe absent runtime as blocked, not passed. Record integration state conservatively and preserve every stated boundary.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.codex/agents/` | New | Three project-local worker definitions |
| `agents/orchestrator.md` | Modified | End-to-end orchestration and reporting guidance |
| `README.md`, `docs/` | Modified/New | Architecture, security, QA, Git, and Engram guidance |
| Plugin PHP files | Excluded | QA targets only; no edits |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Documentation implies unverified integration or test success | Medium | Separate LOCAL/PREPARED from MCP/PENDING; require observed evidence for results |
| PHP is unavailable for syntax checks | Medium | Report blocked explicitly; do not install a framework or claim a pass |

## Rollback Plan

Revert only this change's added worker definitions and documentation edits; leave plugin files, user configuration, Engram state, and production untouched.

## Dependencies

- PHP runtime is needed only to execute the documented syntax checks; its absence blocks those checks.

## Success Criteria

- [ ] Three project-local Codex worker TOML definitions correspond to the existing specialist role docs.
- [ ] Orchestrator and documentation describe the bounded local workflow and distinguish prepared local work from pending MCP work.
- [ ] QA instructions cover both plugin PHP files, install no framework, and report missing PHP as blocked.
- [ ] No prohibited files, settings, integrations, or production resources are accessed or changed; no unverified result is reported as successful.