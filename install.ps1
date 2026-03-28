$ErrorActionPreference = "Stop"

$RepoDir = $PSScriptRoot
$ClaudeDir = "$env:USERPROFILE\.claude"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = "$ClaudeDir\backups\sync-$Timestamp"
$BackupCreated = $false

function Test-DeveloperMode {
    try {
        $key = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -ErrorAction SilentlyContinue
        return ($key.AllowDevelopmentWithoutDevLicense -eq 1)
    } catch {
        return $false
    }
}

function Show-DiffAndPrompt {
    param([string]$Label, [string]$RepoFile, [string]$LocalFile)

    Write-Host ""
    Write-Host "=== CONFLICT: $Label ==="
    Write-Host "Repo version:  $RepoFile"
    Write-Host "Local version: $LocalFile"
    Write-Host ""

    # Show differences
    if (Get-Command fc.exe -ErrorAction SilentlyContinue) {
        Write-Host "--- Differences ---"
        fc.exe /N $RepoFile $LocalFile
        Write-Host "-------------------"
    } else {
        Write-Host "[Repo content]:"
        Get-Content $RepoFile
        Write-Host ""
        Write-Host "[Local content]:"
        Get-Content $LocalFile
    }

    Write-Host ""
    Write-Host "Choose:"
    Write-Host "  [R] Keep REPO version (overwrite local)"
    Write-Host "  [L] Keep LOCAL version (copy into repo)"
    Write-Host "  [S] Skip (do nothing)"
    Write-Host ""

    do {
        $choice = Read-Host "Enter R, L, or S"
    } while ($choice -notin @("R", "r", "L", "l", "S", "s"))

    return $choice.ToUpper()
}

function Backup-Item {
    param([string]$Path)

    if (-not $script:BackupCreated) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        $script:BackupCreated = $true
    }

    $name = Split-Path $Path -Leaf
    if (Test-Path $Path -PathType Container) {
        Copy-Item -Path $Path -Destination "$BackupDir\$name" -Recurse -Force
    } else {
        Copy-Item -Path $Path -Destination "$BackupDir\$name" -Force
    }
}

function Install-FileLink {
    param([string]$Source, [string]$Destination, [string]$Label, [bool]$DevMode)

    # Already linked correctly
    if ((Get-Item $Destination -ErrorAction SilentlyContinue).Attributes -match "ReparsePoint") {
        $target = (Get-Item $Destination).Target
        if ($target -eq $Source) {
            Write-Host "[skip]   $Label - already linked"
            return
        }
    }

    # Destination exists — check for conflict
    if (Test-Path $Destination) {
        $repoHash = (Get-FileHash $Source -Algorithm MD5).Hash
        $localHash = (Get-FileHash $Destination -Algorithm MD5).Hash

        if ($repoHash -eq $localHash) {
            Write-Host "[match]  $Label - identical content, replacing with link"
            Backup-Item $Destination
            Remove-Item $Destination -Force
        } else {
            $choice = Show-DiffAndPrompt -Label $Label -RepoFile $Source -LocalFile $Destination
            switch ($choice) {
                "R" {
                    Write-Host "[repo]   $Label - keeping repo version"
                    Backup-Item $Destination
                    Remove-Item $Destination -Force
                }
                "L" {
                    Write-Host "[local]  $Label - copying local into repo"
                    Backup-Item $Destination
                    Copy-Item -Path $Destination -Destination $Source -Force
                    Remove-Item $Destination -Force
                }
                "S" {
                    Write-Host "[skip]   $Label - skipped by user"
                    return
                }
            }
        }
    }

    # Create symlink
    if ($DevMode) {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -Force | Out-Null
        Write-Host "[link]   $Label - $Destination -> $Source"
    } else {
        Copy-Item -Path $Source -Destination $Destination -Force
        Write-Host "[copy]   $Label - copied (no Developer Mode; changes won't auto-reflect)"
    }
}

function Install-DirLink {
    param([string]$Source, [string]$Destination, [string]$Label)

    # Already linked correctly
    if ((Get-Item $Destination -ErrorAction SilentlyContinue).Attributes -match "ReparsePoint") {
        $target = (Get-Item $Destination).Target
        if ($target -eq $Source) {
            Write-Host "[skip]   $Label - already linked"
            return
        }
    }

    # Destination exists — check for extra files not in repo
    if (Test-Path $Destination) {
        $localFiles = Get-ChildItem $Destination -File -ErrorAction SilentlyContinue
        $repoFiles = Get-ChildItem $Source -File -ErrorAction SilentlyContinue
        $repoNames = $repoFiles | ForEach-Object { $_.Name }

        $extraFiles = $localFiles | Where-Object { $_.Name -notin $repoNames }

        if ($extraFiles) {
            Write-Host ""
            Write-Host "=== $Label: Local has files not in repo ==="
            $extraFiles | ForEach-Object { Write-Host "  + $($_.Name)" }
            Write-Host ""
            Write-Host "Choose:"
            Write-Host "  [M] Merge (copy extra files into repo, then link)"
            Write-Host "  [R] Repo only (discard local extras)"
            Write-Host "  [S] Skip (do nothing)"
            Write-Host ""

            do {
                $choice = Read-Host "Enter M, R, or S"
            } while ($choice -notin @("M", "m", "R", "r", "S", "s"))

            if ($choice.ToUpper() -eq "M") {
                foreach ($f in $extraFiles) {
                    Copy-Item -Path $f.FullName -Destination "$Source\$($f.Name)" -Force
                    Write-Host "[merge]  Copied $($f.Name) into repo"
                }
            } elseif ($choice.ToUpper() -eq "S") {
                Write-Host "[skip]   $Label - skipped by user"
                return
            }
        }

        Backup-Item $Destination
        Remove-Item $Destination -Recurse -Force
    }

    # Create junction (no admin required)
    cmd /c mklink /J "$Destination" "$Source" | Out-Null
    Write-Host "[link]   $Label - $Destination -> $Source (junction)"
}

# ---- Main ----

Write-Host "ClaudeSkills Sync - Installing (Windows)"
Write-Host "========================================="
Write-Host ""

$devMode = Test-DeveloperMode
if ($devMode) {
    Write-Host "Developer Mode: enabled (will use symlinks)"
} else {
    Write-Host "Developer Mode: disabled (will use junctions for dirs, copies for files)"
    Write-Host "Tip: Enable Developer Mode in Settings > For Developers for full symlink support."
}
Write-Host ""

# Ensure .claude directory exists
if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
}

# Install items
Install-FileLink -Source "$RepoDir\claude\CLAUDE.md"     -Destination "$ClaudeDir\CLAUDE.md"     -Label "CLAUDE.md"     -DevMode $devMode
Install-FileLink -Source "$RepoDir\claude\settings.json"  -Destination "$ClaudeDir\settings.json" -Label "settings.json" -DevMode $devMode
Install-DirLink  -Source "$RepoDir\claude\commands"        -Destination "$ClaudeDir\commands"      -Label "commands/"

Write-Host ""
if ($BackupCreated) {
    Write-Host "Done. Backups saved to: $BackupDir"
} else {
    Write-Host "Done. No backups needed."
}
