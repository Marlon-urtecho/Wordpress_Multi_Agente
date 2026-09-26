---
name: wordpress-security
description: "Trigger: WordPress security, REST permissions, nonce, capability, sanitization, escaping, security review. Review WordPress changes for authorization, input safety, output safety, and exposed secrets."
license: Apache-2.0
metadata:
  author: "Webotto"
  version: "1.0"
---

## Activation Contract

Use this skill for WordPress plugins, themes, REST endpoints, AJAX handlers, database access, file operations, uploads, remote requests, authentication, authorization, or MCP integrations.

## Hard Rules

- Inspect the complete request path before judging security.
- Verify authorization before sensitive operations; never rely on authentication alone.
- Validate and sanitize untrusted input at boundaries.
- Escape output for its final context: HTML, attribute, URL, JavaScript, SQL, or JSON.
- Prefer WordPress APIs and prepared queries over direct implementation.
- Never expose credentials, tokens, private paths, or unnecessary user data.
- Do not rewrite unrelated functionality.

## Decision Gates

| Surface | Required checks |
|---|---|
| REST or AJAX | Capability, nonce/authentication model, methods, input schema, error disclosure |
| Database | `$wpdb->prepare()`, authorization, pagination, data exposure |
| Files or uploads | Capability, MIME/extension validation, storage location, path traversal |
| External request or MCP | Allowlist, timeout, secret handling, response validation, least privilege |
| Rendered output | Context-appropriate escaping and XSS review |

## Execution Steps

1. Identify entry points and trust boundaries.
2. Trace user-controlled data to storage, remote calls, and output.
3. Verify authentication, authorization, CSRF protection, validation, sanitization, and escaping.
4. Classify findings as critical, high, medium, low, or informational.
5. Report concrete file paths, evidence, impact, and remediation.
6. State what was checked and any unverified runtime assumptions.

## Output Contract

Return:
- attack surface reviewed;
- findings ordered by severity;
- exact remediation for each finding;
- tests or checks executed;
- remaining risks and runtime assumptions;
- explicit security status: pass, pass with warnings, or fail.

## References

- `AGENTS.md` — project security and production rules.
- `agents/wordpress-security.md` — security reviewer responsibilities.
- `wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php` — current MCP REST surface.
