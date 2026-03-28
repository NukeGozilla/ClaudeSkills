$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "ClaudeSkills Sync"
Write-Host "================="

# Stage and commit any local changes
$status = git status --porcelain
if ($status) {
    Write-Host "Local changes detected - committing..."
    git add -A
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    git commit -m "sync: $env:COMPUTERNAME - $timestamp"
} else {
    Write-Host "No local changes."
}

# Pull remote changes
Write-Host "Pulling remote changes..."
git pull --rebase
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "CONFLICT detected. Resolve manually, then run:"
    Write-Host "  cd $PSScriptRoot; git rebase --continue"
    exit 1
}

# Push if there are local commits ahead of remote
$ahead = git rev-list --count origin/main..HEAD 2>$null
if ($ahead -gt 0) {
    Write-Host "Pushing to remote..."
    git push origin main
}

Write-Host ""
Write-Host "Synced."
