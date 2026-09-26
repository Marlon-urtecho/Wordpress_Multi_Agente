$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$failed = $false
$phpBlocked = $false

function Report-Check {
    param([string]$State, [string]$Message)
    Write-Output "${State}: $Message"
    if ($State -eq 'FAIL') { $script:failed = $true }
}

$requiredPaths = @(
    'AGENTS.md', 'README.md', 'agents/orchestrator.md',
    'agents/wordpress-developer.md', 'agents/wordpress-security.md',
    'agents/wordpress-qa.md', 'docs/architecture.md', 'docs/qa.md',
    'docs/security.md', 'docs/git-workflow.md', 'docs/engram.md', 'mcp/README.md',
    '.codex/config.toml', '.env', '.env.example',
    '.codex/agents/wordpress-developer.toml',
    '.codex/agents/wordpress-security.toml', '.codex/agents/wordpress-qa.toml',
    'scripts/start-wordpress-mcp.ps1'
)
$allowedPaths = @($requiredPaths | Where-Object { $_ -notin @('AGENTS.md', '.env') }) + 'scripts/check-local-readiness.ps1'
$baselineOpenSpec = @(
    'openspec/changes/local-multi-agent-readiness/design.md',
    'openspec/changes/local-multi-agent-readiness/proposal.md',
    'openspec/changes/local-multi-agent-readiness/tasks.md',
    'openspec/changes/local-multi-agent-readiness/specs/local-multi-agent-readiness/spec.md'
)

foreach ($relativePath in $requiredPaths) {
    if (Test-Path -LiteralPath (Join-Path $repoRoot $relativePath) -PathType Leaf) {
        Report-Check 'PASS' "required path: $relativePath"
    }
    else {
        Report-Check 'FAIL' "required path: $relativePath"
    }
}

$tokens = $null
$parseErrors = $null
[System.Management.Automation.Language.Parser]::ParseFile($PSCommandPath, [ref]$tokens, [ref]$parseErrors) | Out-Null
if ($parseErrors.Count -eq 0) {
    Report-Check 'PASS' 'PowerShell parser: scripts/check-local-readiness.ps1'
}
else {
    Report-Check 'FAIL' 'PowerShell parser: scripts/check-local-readiness.ps1'
}

$launcherPath = Join-Path $repoRoot 'scripts/start-wordpress-mcp.ps1'
if (Test-Path -LiteralPath $launcherPath -PathType Leaf) {
    $launcherTokens = $null
    $launcherErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($launcherPath, [ref]$launcherTokens, [ref]$launcherErrors) | Out-Null
    if ($launcherErrors.Count -eq 0) { Report-Check 'PASS' 'PowerShell parser: scripts/start-wordpress-mcp.ps1' }
    else { Report-Check 'FAIL' 'PowerShell parser: scripts/start-wordpress-mcp.ps1' }
}

$python = Get-Command python -ErrorAction SilentlyContinue
$tomllibAvailable = $false
if ($python) {
    & $python.Source -c 'import tomllib' *> $null
    $tomllibAvailable = ($LASTEXITCODE -eq 0)
}
if (-not $tomllibAvailable) {
    Report-Check 'BLOCKED' 'TOML parse: Python stdlib tomllib is unavailable'
}
else {
    $roleTomlCheck = 'import pathlib,sys,tomllib; p=pathlib.Path(sys.argv[1]); d=tomllib.loads(p.read_text(encoding="utf-8")); expected={"name","description","developer_instructions","model","model_reasoning_effort"}; models={"wordpress-developer":("gpt-6-sol","medium"),"wordpress-security":("gpt-6-astra","low"),"wordpress-qa":("gpt-6-luna","high")}; assert set(d)==expected; assert d["name"]==p.stem; assert "AGENTS.md" in d["developer_instructions"]; assert ("agents/"+p.stem+".md") in d["developer_instructions"]; assert (d["model"],d["model_reasoning_effort"])==models[p.stem]'
    foreach ($relativePath in @($requiredPaths | Where-Object { $_ -like '.codex/agents/*.toml' })) {
        $fullPath = Join-Path $repoRoot $relativePath
        if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
            & $python.Source -c $roleTomlCheck $fullPath *> $null
            if ($LASTEXITCODE -eq 0) { Report-Check 'PASS' "TOML schema, model mapping, and role reference: $relativePath" }
            else { Report-Check 'FAIL' "TOML schema, model mapping, or role reference: $relativePath" }
        }
    }

    $projectTomlPath = Join-Path $repoRoot '.codex/config.toml'
    if (Test-Path -LiteralPath $projectTomlPath -PathType Leaf) {
        $projectTomlCheck = 'import pathlib,sys,tomllib; d=tomllib.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")); s=d["mcp_servers"]["wordpress"]; assert d["model"]=="gpt-6-astra" and d["model_reasoning_effort"]=="low"; assert s["command"]=="pwsh" and s["args"]==["-NoProfile","-File","scripts/start-wordpress-mcp.ps1"] and s["cwd"]=="." and s["default_tools_approval_mode"]=="prompt" and "approval_mode" not in s; assert "papaotto.com" not in str(d).lower() and "wp_api_password" not in str(d).lower()'
        & $python.Source -c $projectTomlCheck $projectTomlPath *> $null
        if ($LASTEXITCODE -eq 0) { Report-Check 'PASS' 'TOML parse and project model/MCP configuration' }
        else { Report-Check 'FAIL' 'TOML parse or project model/MCP configuration' }
    }
}

& git -C $repoRoot check-ignore --quiet -- .env 2>$null
if ($LASTEXITCODE -eq 0) { Report-Check 'PASS' 'local .env is ignored by Git' }
else { Report-Check 'FAIL' 'local .env ignore rule' }
& git -C $repoRoot check-ignore --quiet -- .env.example 2>$null
if ($LASTEXITCODE -ne 0) { Report-Check 'PASS' '.env.example is not ignored by Git' }
else { Report-Check 'FAIL' '.env.example must remain includable by Git' }

$gitRoot = & git -C $repoRoot rev-parse --show-toplevel 2>$null
$branch = & git -C $repoRoot branch --show-current 2>$null
$remotes = @(& git -C $repoRoot remote 2>$null)
if (($LASTEXITCODE -eq 0) -and ([System.IO.Path]::GetFullPath($gitRoot) -eq $repoRoot)) {
    Report-Check 'PASS' 'Git repository root confirmed'
}
else { Report-Check 'FAIL' 'Git repository root could not be confirmed' }
if (-not [string]::IsNullOrWhiteSpace($branch)) { Report-Check 'PASS' "Git branch confirmed: $branch" }
else { Report-Check 'FAIL' 'Git branch could not be confirmed' }
if ($remotes.Count -gt 0) { Report-Check 'PASS' "Git remote names confirmed: $($remotes.Count); URLs withheld" }
else { Report-Check 'FAIL' 'No configured Git remote name found' }

$gitGuide = [System.IO.File]::ReadAllText((Join-Path $repoRoot 'docs/git-workflow.md'))
$gitRequirements = @(
    'git rev-parse --show-toplevel',
    'git status --short --branch',
    'git diff --check',
    'Stage explicit approved paths only',
    'Push requires separate explicit approval',
    'PR creation and deployment also require explicit approval and intended-branch diff review'
)
foreach ($requirement in $gitRequirements) {
    if ($gitGuide.Contains($requirement)) { Report-Check 'PASS' "Git guidance: $requirement" }
    else { Report-Check 'FAIL' 'Git guidance acceptance requirement missing: docs/git-workflow.md' }
}

$statusLines = @(& git -C $repoRoot status --porcelain=v1 --untracked-files=all 2>$null)
foreach ($statusLine in $statusLines) {
    if ($statusLine.Length -lt 4) { continue }
    $relativePath = $statusLine.Substring(3).Replace('\', '/')
    if ($baselineOpenSpec -contains $relativePath) {
        Report-Check 'BASELINE' "pre-existing OpenSpec artifact preserved: $relativePath"
    }
    elseif ($allowedPaths -contains $relativePath) {
        Report-Check 'PASS' "changed path is allowed: $relativePath"
    }
    else {
        Report-Check 'FAIL' "out-of-scope changed path: $relativePath"
    }
}

foreach ($gitArgs in @(@('diff', '--check'), @('diff', '--cached', '--check'))) {
    & git -C $repoRoot @gitArgs *> $null
    if ($LASTEXITCODE -eq 0) { Report-Check 'PASS' "Git whitespace check: git $($gitArgs -join ' ')" }
    else { Report-Check 'FAIL' "Git whitespace check: git $($gitArgs -join ' ')" }
}

$secretPattern = '(?im)\b(?:api[_-]?key|access[_-]?token|client[_-]?secret|password|passwd)\b\s*[:=]\s*["'']?[A-Za-z0-9/_+=.-]{12,}'
$secretFinding = $false
foreach ($relativePath in @($allowedPaths | Where-Object { $_ -ne '.env' })) {
    $fullPath = Join-Path $repoRoot $relativePath
    if ((Test-Path -LiteralPath $fullPath -PathType Leaf) -and
        [System.Text.RegularExpressions.Regex]::IsMatch([System.IO.File]::ReadAllText($fullPath), $secretPattern)) {
        $secretFinding = $true
        Report-Check 'FAIL' "credential-like assignment (HIGH): $relativePath"
    }
}
if (-not $secretFinding) { Report-Check 'PASS' 'credential-like assignment scan: approved paths only; no matches' }

$mcpDocPaths = @('README.md', 'docs/architecture.md', 'mcp/README.md')
foreach ($relativePath in $mcpDocPaths) {
    $document = [System.IO.File]::ReadAllText((Join-Path $repoRoot $relativePath)).ToLowerInvariant()
    $hasModels = $document.Contains('gpt-6-astra') -and $document.Contains('gpt-6-sol') -and $document.Contains('gpt-6-luna')
    $hasBoundaries = $document.Contains('not connected') -and $document.Contains('zero wordpress actions') -and $document.Contains('no remote connection or test was made')
    if ($hasModels -and $hasBoundaries) { Report-Check 'PASS' "model and MCP boundary documentation: $relativePath" }
    else { Report-Check 'FAIL' "model or MCP boundary documentation: $relativePath" }
}

$php = Get-Command php -ErrorAction SilentlyContinue
$phpTargets = @(
    'wp-content/plugins/webotto-hello/webotto-hello.php',
    'wp-content/plugins/webotto-mcp-adapter/webotto-mcp-adapter.php'
)
foreach ($target in $phpTargets) {
    if (-not $php) {
        $phpBlocked = $true
        Report-Check 'BLOCKED' "PHP lint: $target (php unavailable)"
    }
    else {
        & $php.Source -l (Join-Path $repoRoot $target) *> $null
        if ($LASTEXITCODE -eq 0) { Report-Check 'PASS' "PHP lint: $target" }
        else { Report-Check 'FAIL' "PHP lint: $target (diagnostic details withheld)" }
    }
}

$hasLocalWordPress = (Test-Path (Join-Path $repoRoot 'wp-load.php')) -or (Test-Path (Join-Path $repoRoot 'wp-config.php'))
$hasTestSuite = (Test-Path (Join-Path $repoRoot 'composer.json')) -or
    (Test-Path (Join-Path $repoRoot 'phpunit.xml')) -or (Test-Path (Join-Path $repoRoot 'tests'))
if (-not $hasTestSuite) { Report-Check 'NOT FOUND' 'local automated test suite or manifest' }
if (-not $hasLocalWordPress -or -not $hasTestSuite) {
    Report-Check 'NOT RUN' 'local smoke/API/regression (blocked: local WordPress/test harness absent; no URLs accessed)'
}

if ($failed) { exit 1 }
if ($phpBlocked) { exit 2 }
exit 0