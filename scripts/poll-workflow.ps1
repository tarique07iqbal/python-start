<#
.SYNOPSIS
  Poll the latest run of a specific GitHub Actions workflow until completion.

.DESCRIPTION
  - Finds the workflow by path (e.g. .github/workflows/python-tests.yml) or by name ("Python tests").
  - Polls the latest run for that workflow and prints a compact summary when it completes.
  - Returns exit code 0 on success, 1 on failure, 2 on timeout.

.PARAMETER RepoOwner
  GitHub repo owner (example: tarique07iqbal).

.PARAMETER RepoName
  GitHub repo name (example: python-start).

.PARAMETER WorkflowFile
  Workflow path under .github/workflows (default: .github/workflows/python-tests.yml).

.PARAMETER WorkflowName
  Alternative: workflow name (default: "Python tests"). Script tries path first then name.

.PARAMETER IntervalSeconds
  Poll interval in seconds (default: 5).

.PARAMETER MaxAttempts
  Optional max poll attempts. If omitted, polls indefinitely until completion.

.NOTES
  - Provide a GitHub PAT in env var GITHUB_PAT (recommended) or enter it interactively when prompted.
  - PAT scope: 'repo' for private repos, 'public_repo' is enough for public repos.
#>

param(
  [Parameter(Mandatory=$true)][string]$RepoOwner,
  [Parameter(Mandatory=$true)][string]$RepoName,
  [string]$WorkflowFile = ".github/workflows/python-tests.yml",
  [string]$WorkflowName = "Python tests",
  [int]$IntervalSeconds = 5,
  [int]$MaxAttempts
)

function Ensure-Token {
  if (-not $env:GITHUB_PAT -or $env:GITHUB_PAT -eq "") {
    Write-Host "GITHUB_PAT not set. You will be prompted to enter a PAT for this session." -ForegroundColor Yellow
    $secure = Read-Host -AsSecureString "Enter GitHub PAT (will be stored in this session only)"
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    $plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    $env:GITHUB_PAT = $plain
  }
}

function Get-ApiHeaders {
  return @{ Authorization = "token $($env:GITHUB_PAT)"; 'User-Agent' = 'powershell'; Accept = 'application/vnd.github+json' }
}

function Get-WorkflowId {
  param($owner, $repo, $workflowFile, $workflowName)
  $uri = "https://api.github.com/repos/$owner/$repo/actions/workflows"
  try {
    $res = Invoke-RestMethod -Headers (Get-ApiHeaders) -Uri $uri -Method Get
  } catch {
    Write-Error "Failed to list workflows: $($_.Exception.Message)"
    return $null
  }

  # Try to match by path first
  foreach ($w in $res.workflows) {
    if ($w.path -eq $workflowFile) {
      return $w.id
    }
  }
  # Fallback: match by name
  foreach ($w in $res.workflows) {
    if ($w.name -eq $workflowName) {
      return $w.id
    }
  }
  return $null
}

function Get-LatestRun {
  param($owner, $repo, $workflowId)
  $uri = "https://api.github.com/repos/$owner/$repo/actions/workflows/$workflowId/runs?per_page=1"
  try {
    $res = Invoke-RestMethod -Headers (Get-ApiHeaders) -Uri $uri -Method Get
  } catch {
    Write-Error "Failed to fetch workflow runs: $($_.Exception.Message)"
    return $null
  }
  if ($res.workflow_runs -and $res.workflow_runs.Count -ge 1) {
    return $res.workflow_runs[0]
  }
  return $null
}

function Print-RunSummary {
  param($run)
  if (-not $run) { return }
  $obj = [PSCustomObject]@{
    name       = $run.name
    id         = $run.id
    head_branch= $run.head_branch
    status     = $run.status
    conclusion = $run.conclusion
    url        = $run.html_url
    created_at = $run.created_at
    updated_at = $run.updated_at
  }
  $obj | Format-List
}

# --- main
Ensure-Token

Write-Host "Locating workflow..." -ForegroundColor Cyan
$wfId = Get-WorkflowId -owner $RepoOwner -repo $RepoName -workflowFile $WorkflowFile -workflowName $WorkflowName
if (-not $wfId) {
  Write-Error "Workflow not found by path '$WorkflowFile' or name '$WorkflowName' in $RepoOwner/$RepoName"
  exit 1
}

Write-Host "Found workflow id: $wfId" -ForegroundColor Green

$attempt = 0
while ($true) {
  if ($MaxAttempts -and $attempt -ge $MaxAttempts) {
    Write-Host "Reached max attempts ($MaxAttempts). Exiting." -ForegroundColor Yellow
    exit 2
  }
  $attempt++
  $run = Get-LatestRun -owner $RepoOwner -repo $RepoName -workflowId $wfId
  if (-not $run) {
    Write-Host "No runs found yet. Waiting $IntervalSeconds seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds $IntervalSeconds
    continue
  }

  $status = $run.status
  $conclusion = $run.conclusion
  Write-Host ("[{0}] run id {1} branch:{2} status:{3} conclusion:{4}" -f (Get-Date), $run.id, $run.head_branch, $status, ($conclusion -ne $null ? $conclusion : "<in-progress>"))

  if ($status -eq "completed" -or $conclusion) {
    Write-Host "`nRun finished. Summary:" -ForegroundColor Cyan
    Print-RunSummary -run $run

    switch ($conclusion) {
      "success" { exit 0 }
      "neutral" { exit 0 }
      "skipped" { exit 0 }
      default {
        if (-not $conclusion) { Write-Host "Run completed but conclusion missing; treating as non-success." -ForegroundColor Yellow; exit 1 }
        Write-Host "Run concluded with '$conclusion'." -ForegroundColor Red
        exit 1
      }
    }
  }

  Start-Sleep -Seconds $IntervalSeconds
}
