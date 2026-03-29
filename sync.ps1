$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host "ClaudeSkills Sync"
Write-Host "================="

# Import new/updated skills from Claude Desktop
$DesktopSkillsDir = "$env:APPDATA\Claude\local-agent-mode-sessions\skills-plugin"
$CommandsDir = "$PSScriptRoot\claude\commands"

# Built-in skills to skip
$BuiltinSkills = @("pdf", "xlsx", "pptx", "docx", "schedule", "skill-creator")

if (Test-Path $DesktopSkillsDir) {
    Write-Host "Scanning Claude Desktop for new skills..."
    $found = 0
    $skillFiles = Get-ChildItem -Path $DesktopSkillsDir -Recurse -Filter "SKILL.md" -ErrorAction SilentlyContinue

    foreach ($skillFile in $skillFiles) {
        $skillName = $skillFile.Directory.Name

        # Skip built-in skills
        if ($skillName -in $BuiltinSkills) { continue }

        $target = Join-Path $CommandsDir "$skillName.md"

        if (-not (Test-Path $target)) {
            Copy-Item -Path $skillFile.FullName -Destination $target
            Write-Host "  [new] $skillName"
            $found++
        } elseif ((Get-FileHash $skillFile.FullName).Hash -ne (Get-FileHash $target).Hash) {
            Copy-Item -Path $skillFile.FullName -Destination $target -Force
            Write-Host "  [updated] $skillName"
            $found++
        }
    }

    if ($found -eq 0) {
        Write-Host "  No new Desktop skills found."
    }
}

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
