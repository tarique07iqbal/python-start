<#
.SYNOPSIS
  Lint PowerShell scripts in the repo using PSScriptAnalyzer.

.DESCRIPTION
  Installs PSScriptAnalyzer if missing, runs it against scripts/*.ps1, and exits
  with non-zero status if any Warning-or-Error findings are reported (matching CI).
#>

param(
  [string]$Path = "scripts\*.ps1"
)

function Ensure-PSSA {
  if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Host "PSScriptAnalyzer not found. Installing to CurrentUser scope..." -ForegroundColor Yellow
    Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser -SkipPublisherCheck
  }
}

Ensure-PSSA

Write-Host "Running PSScriptAnalyzer on $Path"
$issues = Invoke-ScriptAnalyzer -Path $Path -Severity Warning,Error -Recurse
if ($issues) {
  Write-Host "PSScriptAnalyzer found issues:" -ForegroundColor Red
  $issues | ForEach-Object { Write-Host "$($_.Severity): $($_.RuleName) - $($_.Message)" }
  Write-Host "Failing with exit code 1." -ForegroundColor Red
  exit 1
} else {
  Write-Host "No issues found by PSScriptAnalyzer." -ForegroundColor Green
  exit 0
}
