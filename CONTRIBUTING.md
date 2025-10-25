# Contributing

Small notes to help contributors run local checks and the CI helper script.

## Run PowerShell static checks locally

This repository includes a PowerShell helper `scripts/poll-workflow.ps1`. The CI workflow runs `PSScriptAnalyzer` against this file. To run the same checks locally:

1. Open PowerShell (Windows PowerShell or PowerShell Core).
2. Install PSScriptAnalyzer if you don't have it:

```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -SkipPublisherCheck
```

3. Run the analyzer:

```powershell
Invoke-ScriptAnalyzer -Path scripts\poll-workflow.ps1 -Severity Warning,Error
```

4. Fix any reported issues. CI currently fails on Warning-or-Error level issues.

## Provide a GitHub PAT for helper scripts (optional)

Some helper scripts may prompt for a GitHub Personal Access Token (PAT) to access API endpoints. To set a PAT in your session (recommended):

```powershell
$env:GITHUB_PAT = Read-Host -AsSecureString "Enter GitHub PAT" | ConvertFrom-SecureString
```

Add the PAT as a repository secret (name: `CODECOV_TOKEN`) if you need to upload coverage for private repos.

Thanks for contributing — small, focused PRs are easiest to review.
