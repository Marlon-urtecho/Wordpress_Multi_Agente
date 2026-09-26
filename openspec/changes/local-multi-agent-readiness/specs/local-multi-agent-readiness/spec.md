# Local Multi-Agent Readiness Specification

## Purpose

Define project-local preparation for Codex-assisted WordPress work using the repository's existing developer, security, and QA roles, while keeping coordination, verification claims, persistent-memory handling, Git operations, and MCP boundaries explicit and evidence-based.

## Requirements

### Requirement: Project-local specialist discovery

The project MUST provide Codex-discoverable, project-local specialist definitions corresponding to the existing WordPress developer, security, and QA roles. The orchestrator MUST remain the coordinator that interprets the request, scopes work, assigns specialists, integrates results, and reports completion; it MUST NOT be replaced by a specialist worker. The project MUST NOT depend on user-level Codex configuration to discover these project-local specialists.

#### Scenario: Codex discovers the project specialists

- GIVEN a Codex session opened with this repository as its project
- WHEN the session discovers project-local agents
- THEN it can identify the developer, security, and QA specialists corresponding to the existing role guidance
- AND the orchestrator remains the coordinating role

#### Scenario: User-level configuration is unavailable

- GIVEN project-local agent definitions are present
- WHEN Codex uses the repository without relying on user-level agent configuration
- THEN the project-local specialists remain the project's declared worker roles
- AND no user-level configuration is required or modified by this change

### Requirement: Right-sized delegation and orchestration

The orchestrator MUST inspect the relevant project context, plan work proportionately, and delegate only when a specialist or independent work unit provides meaningful value. It MUST retain coordination and integration responsibility, avoid delegating trivial or mechanical tasks unnecessarily, and keep assigned work within the user's scope and repository boundaries.

#### Scenario: Work benefits from specialist review

- GIVEN a requested change has implementation work and a distinct WordPress security or QA concern
- WHEN the orchestrator plans the work
- THEN it assigns only the relevant specialist responsibilities
- AND the orchestrator retains responsibility for scope, integration, and the final report

#### Scenario: Trivial task needs no worker

- GIVEN a request is a small, self-contained task that does not benefit from specialist input
- WHEN the orchestrator selects a workflow
- THEN it may complete the task without delegating it
- AND it does not create unnecessary parallel work

### Requirement: Evidence-based QA and local validation

The QA role MUST report the changed files and the exact checks performed, their observed results, failures, and pending risks. Validation MUST cover applicable static inspection and PHP syntax checks for `webotto-hello.php` and the MCP adapter PHP file, run available automated tests without installing a test framework, and perform only applicable local smoke, API, and regression checks. Smoke and API checks MUST remain local and MUST NOT access production. A check that was not run MUST NOT be reported as passed. If PHP is unavailable, the affected syntax checks MUST be reported as blocked rather than passed.

#### Scenario: PHP and automated checks are available

- GIVEN a change affects code for which PHP syntax checks or automated tests are available
- WHEN QA validates the change
- THEN QA reports the syntax-check and available-test commands and their observed outcomes
- AND QA reports the changed files, applicable local smoke/API and regression results, failures, and remaining risks

#### Scenario: PHP is unavailable

- GIVEN the PHP runtime needed for the specified syntax checks is unavailable
- WHEN QA attempts to establish validation coverage
- THEN the syntax checks are reported as blocked because the prerequisite is missing
- AND no framework is installed and no successful syntax result is claimed

#### Scenario: A check is outside the local boundary or was not run

- GIVEN a proposed smoke or API check would contact production, or a check cannot be executed
- WHEN QA records validation results
- THEN the production check is not performed and the unrun check is identified as pending or blocked
- AND neither check is represented as successful

### Requirement: WordPress security review

The security role MUST review applicable WordPress attack surfaces, including authentication and authorization, capabilities, nonces, input validation and sanitization, output escaping, SQL injection, XSS, CSRF, file uploads, REST API permissions, secret exposure, unsafe remote requests, and insecure AJAX actions. Findings MUST identify severity and concrete evidence with remediation guidance when available. The reviewer MUST avoid rewriting unrelated functionality.

#### Scenario: Security-sensitive WordPress behavior changes

- GIVEN a change handles untrusted input, permissions, authentication, REST APIs, database access, files, uploads, or external integrations
- WHEN the security specialist reviews it
- THEN the review traces applicable input and authorization boundaries and checks the relevant sanitization, validation, and output controls
- AND findings include severity, evidence, and actionable remediation where applicable

#### Scenario: No applicable security finding is observed

- GIVEN the reviewer has examined the applicable security surfaces
- WHEN the reviewer reports the result
- THEN the report distinguishes the examined scope from unexamined areas
- AND it does not claim broader security certification

### Requirement: Future MCP security boundary and integration status

Project guidance MUST define authorization, input-validation, and output-escaping boundaries before any future MCP tools are exposed. This change MUST NOT invoke, connect, configure, reconfigure, or implement MCP. Documentation MUST distinguish existing local preparation from a verified live connection and MUST NOT claim that the existing global Codex WordPress MCP registration is connected. References to a local adapter or endpoint MUST not be treated as evidence of a live MCP session.

#### Scenario: Future MCP tool is considered

- GIVEN a future change proposes exposing an MCP tool
- WHEN its security requirements are documented
- THEN the tool's authorization, input-validation, and output-escaping boundaries are defined before exposure
- AND this readiness change itself makes no MCP call or integration change

#### Scenario: Local adapter documentation is read

- GIVEN repository documentation describes a local MCP adapter or endpoint
- WHEN onboarding or status is reported
- THEN that description is identified as local preparation only
- AND the report does not infer that an external registration is connected or verified

### Requirement: Project-scoped single-source Engram use

Project guidance MUST identify Engram as the sole persistent-memory source for this workflow and keep memory lookup and use scoped to the Webotto project. It MUST preserve the known project-name warning and foreign cloud-sync-target error as current limitations, without claiming they are fixed or resolved. This change MUST NOT read or write Engram state, change project mappings or cloud-sync targets, or otherwise mutate Engram data.

#### Scenario: Memory is needed for project work

- GIVEN the workflow needs persistent project memory
- WHEN the orchestrator looks up or uses that memory
- THEN it uses Engram as the single persistent-memory source and scopes the operation to this project
- AND it does not substitute an unapproved second persistent-memory store

#### Scenario: Existing Engram health limitations are reported

- GIVEN the documented project-name warning or foreign cloud-sync-target error remains present
- WHEN project onboarding or status is described
- THEN the limitation is stated as unresolved and left unchanged
- AND no claim is made that Engram health or synchronization has been repaired

#### Scenario: This change is applied

- GIVEN the local readiness artifacts are being added or updated
- WHEN this change is performed
- THEN no Engram state, mapping, or cloud-sync target is read or mutated

### Requirement: Secure Git review and staging guidance

Project guidance MUST require inspection of repository status and changes before staging, staging only intended project files, and reviewing the staged changes before any commit. Secrets and credentials MUST NOT be exposed or included in staged changes. Git reporting MUST distinguish observed repository state and completed actions from proposed or pending actions. This change MUST NOT create a commit, push, or pull request.

#### Scenario: Intended local changes are staged

- GIVEN work has produced repository changes
- WHEN the orchestrator prepares a staging set
- THEN it checks repository status and reviews the changes
- AND it stages only files within the authorized scope and checks the staged changes before any commit

#### Scenario: A secret or unrelated change is present

- GIVEN inspection finds a secret, credential, or unrelated file among the changes
- WHEN the staging set is prepared
- THEN the sensitive or unrelated change is excluded and reported as a pending issue
- AND the secret is not reproduced in reports

#### Scenario: Readiness documentation is completed

- GIVEN this change's specifications or implementation are being completed
- WHEN Git actions are considered
- THEN no commit, push, or pull request is created as part of this change
- AND any unperformed Git action is reported as pending, not completed

### Requirement: Accurate onboarding status labels

Onboarding and architecture documentation MUST clearly label repository-level agent and workflow preparation as `LOCAL/PREPARED` and MCP integration as `MCP/PENDING` unless a connection is directly verified. Documentation MUST not claim runtime functionality, available models, connected services, or successful validation beyond captured evidence.

#### Scenario: Local readiness is described

- GIVEN a user reads onboarding or architecture documentation
- WHEN the project-local agent and workflow preparation is summarized
- THEN it is labeled `LOCAL/PREPARED`
- AND documented role definitions are not presented as proof that a runtime invoked them

#### Scenario: MCP status is described

- GIVEN no direct evidence verifies a live MCP connection
- WHEN onboarding or architecture documentation describes MCP
- THEN it is labeled `MCP/PENDING`
- AND no connection, invocation, or successful integration is claimed

#### Scenario: Validation evidence is incomplete

- GIVEN a test, runtime, model, or service result has not been directly observed
- WHEN documentation or a completion report states project status
- THEN that result remains unverified, pending, or blocked as appropriate
- AND it is not described as successful

### Requirement: Bounded local change scope

The local readiness change MUST be limited to project-local agent definitions and project documentation. It MUST NOT modify plugin PHP, user-level configuration, production resources, or dependencies, and MUST NOT install packages or frameworks. MCP and Engram boundaries MUST remain unchanged.

#### Scenario: Change scope is reviewed

- GIVEN the readiness change has produced candidate file changes
- WHEN the orchestrator reviews the final changed-file set
- THEN it contains only the in-scope local agent and documentation artifacts
- AND no plugin PHP, user-level configuration, production resource, dependency installation, MCP integration, or Engram mutation is included