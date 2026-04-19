$ErrorActionPreference = "Stop"

$RepoDir = $PSScriptRoot
$ClaudeDir = "$env:USERPROFILE\.claude"
$DesktopBase = "$env:APPDATA\Claude"
$DesktopSkillsDir = "$DesktopBase\local-agent-mode-sessions\skills-plugin"

function Remove-RepoLink {
    param([string]$Path, [string]$Label)

    if (-not (Test-Path $Path -ErrorAction SilentlyContinue)) {
        Write-Host "[skip]    $Label - does not exist"
        return
    }

    $item = Get-Item $Path -Force
    $isLink = $item.Attributes -match "ReparsePoint"

    if (-not $isLink) {
        Write-Host "[skip]    $Label - not a symlink/junction, leaving untouched"
        return
    }

    $target = $item.Target
    if ($target -and $target.StartsWith($RepoDir)) {
        Remove-Item $Path -Force -Recurse
        Write-Host "[removed] $Label - was linked to $target"
    } else {
        Write-Host "[skip]    $Label - link points outside this repo: $target"
    }
}

function Remove-SkillLinks {
    param([string]$TargetDir, [string]$LabelPrefix)

    if (-not (Test-Path $TargetDir)) { return }

    foreach ($child in Get-ChildItem $TargetDir -Force -ErrorAction SilentlyContinue) {
        $isLink = $child.Attributes -match "ReparsePoint"
        if (-not $isLink) { continue }
        Remove-RepoLink -Path $child.FullName -Label "$LabelPrefix/$($child.Name)"
    }
}

Write-Host "ClaudeSkills Sync - Removing symlinks (Windows)"
Write-Host "================================================"
Write-Host ""

Remove-RepoLink -Path "$ClaudeDir\CLAUDE.md"     -Label "CLAUDE.md"
Remove-RepoLink -Path "$ClaudeDir\settings.json" -Label "settings.json"
Remove-RepoLink -Path "$ClaudeDir\commands"      -Label "commands/"

Remove-SkillLinks -TargetDir "$ClaudeDir\skills" -LabelPrefix "skills"

if (Test-Path $DesktopSkillsDir) {
    Remove-SkillLinks -TargetDir $DesktopSkillsDir -LabelPrefix "desktop/skills"
}

Write-Host ""

# List available backups
$BackupRoot = "$ClaudeDir\backups"
if (Test-Path $BackupRoot) {
    $backups = Get-ChildItem $BackupRoot -Directory -Filter "sync-*" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending
    if ($backups) {
        Write-Host "Available backups to restore from:"
        $backups | ForEach-Object { Write-Host "  $($_.FullName)" }
        Write-Host ""
        Write-Host "To restore, copy files from the backup directory back to $ClaudeDir\"
    } else {
        Write-Host "No backups found."
    }
} else {
    Write-Host "No backups found."
}
