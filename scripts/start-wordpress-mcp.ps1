param(
    [switch]$ValidateOnly
)

$ErrorActionPreference = 'Stop'
$expectedUrl = 'https://papaotto.com/wp-json/mcp/mcp-adapter-default-server'
$allowedKeys = @('WP_API_URL', 'WP_API_USERNAME', 'WP_API_PASSWORD', 'OAUTH_ENABLED')
$dotenvPath = Join-Path $PSScriptRoot '..\.env'

function Stop-Configuration {
    param([string]$Message)
    [Console]::Error.WriteLine("Configuration error: $Message")
    exit 1
}

if (-not (Test-Path -LiteralPath $dotenvPath -PathType Leaf)) {
    Stop-Configuration 'required variable source is missing: .env'
}

$settings = @{}
try {
    foreach ($line in [System.IO.File]::ReadAllLines((Resolve-Path -LiteralPath $dotenvPath))) {
        $trimmedLine = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmedLine) -or $trimmedLine.StartsWith('#')) { continue }

        if ($trimmedLine -notmatch '^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
            Stop-Configuration 'malformed .env entry'
        }

        $key = $Matches[1]
        $rawValue = $Matches[2].Trim()
        if ($allowedKeys -cnotcontains $key) {
            Stop-Configuration "unknown variable: $key"
        }
        if ($settings.ContainsKey($key)) {
            Stop-Configuration "duplicate variable: $key"
        }

        if ($rawValue.StartsWith('"') -or $rawValue.StartsWith("'")) {
            $quote = $rawValue.Substring(0, 1)
            $closingQuoteIndex = $rawValue.IndexOf($quote, 1)
            if ($closingQuoteIndex -lt 1) {
                Stop-Configuration "unpaired quotes for variable: $key"
            }
            $trailingText = $rawValue.Substring($closingQuoteIndex + 1)
            if (-not [string]::IsNullOrWhiteSpace($trailingText) -and $trailingText -notmatch '^\s+#.*$') {
                Stop-Configuration "unexpected text after quoted variable: $key"
            }
            $value = $rawValue.Substring(1, $closingQuoteIndex - 1)
        }
        else {
            if ($rawValue.Contains('"') -or $rawValue.Contains("'")) {
                Stop-Configuration "unpaired quotes for variable: $key"
            }
            $commentIndex = [System.Text.RegularExpressions.Regex]::Match($rawValue, '\s+#').Index
            if ($commentIndex -gt 0) { $rawValue = $rawValue.Substring(0, $commentIndex).TrimEnd() }
            $value = $rawValue
        }

        $settings[$key] = $value
    }
}
catch {
    if ($_.Exception.Message -like 'Configuration error:*') { throw }
    Stop-Configuration 'unable to read .env'
}

foreach ($key in $allowedKeys) {
    if (-not $settings.ContainsKey($key)) {
        Stop-Configuration "missing variable: $key"
    }
}

$parsedUrl = $null
if (-not [System.Uri]::TryCreate($settings['WP_API_URL'], [System.UriKind]::Absolute, [ref]$parsedUrl) -or
    $parsedUrl.Scheme -cne 'https' -or $parsedUrl.Host -cne 'papaotto.com' -or
    $parsedUrl.AbsolutePath -cne '/wp-json/mcp/mcp-adapter-default-server' -or
    -not $parsedUrl.IsDefaultPort -or -not [string]::IsNullOrEmpty($parsedUrl.Query) -or
    -not [string]::IsNullOrEmpty($parsedUrl.Fragment) -or -not [string]::IsNullOrEmpty($parsedUrl.UserInfo)) {
    Stop-Configuration 'WP_API_URL must use HTTPS, the approved host, and exact adapter path'
}

if ($settings['OAUTH_ENABLED'] -cne 'false') {
    Stop-Configuration 'OAUTH_ENABLED must be false'
}

foreach ($key in @('WP_API_USERNAME', 'WP_API_PASSWORD')) {
    $value = $settings[$key]
    $isPlaceholder = $value -match '^(?i)(?:your(?:[-_ ].*)?|change[-_ ]?me|replace[-_ ]?me|placeholder(?:[-_ ].*)?|<.*>)$'
    if ([string]::IsNullOrWhiteSpace($value) -or $isPlaceholder) {
        Stop-Configuration "required credential is empty or a placeholder: $key"
    }
}

if ($ValidateOnly) {
    [Console]::Error.WriteLine('Configuration valid; package launch skipped.')
    exit 0
}

$npx = Get-Command npx -ErrorAction SilentlyContinue
if (-not $npx) {
    Stop-Configuration 'required executable is unavailable: npx'
}

$environmentNames = @('WP_API_URL', 'WP_API_USERNAME', 'WP_API_PASSWORD', 'OAUTH_ENABLED')
$previousEnvironment = @{}
foreach ($name in $environmentNames) {
    $previousEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
    [Environment]::SetEnvironmentVariable($name, $settings[$name], 'Process')
}

try {
    & $npx.Source -y '@automattic/mcp-wordpress-remote@0.4.0'
    exit $LASTEXITCODE
}
finally {
    foreach ($name in $environmentNames) {
        [Environment]::SetEnvironmentVariable($name, $previousEnvironment[$name], 'Process')
    }
}