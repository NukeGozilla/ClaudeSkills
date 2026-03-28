# ClaudeSkills

Git-synced Claude Code settings, skills, and instructions across machines.

## Quick Setup

### macOS / Linux

```bash
git clone git@github.com:NukeGozilla/ClaudeSkills.git ~/ClaudeSkills
cd ~/ClaudeSkills
chmod +x install.sh sync.sh
./install.sh
```

### Windows (PowerShell)

```powershell
git clone git@github.com:NukeGozilla/ClaudeSkills.git $env:USERPROFILE\ClaudeSkills
cd $env:USERPROFILE\ClaudeSkills
.\install.ps1
```

The Windows installer will detect existing configs and prompt you to choose when conflicts arise (keep repo version, keep local, or skip).

## What Gets Synced

| File | Description |
|------|-------------|
| `claude/CLAUDE.md` | Global instructions for all projects |
| `claude/settings.json` | Permissions, effort level, allowed commands |
| `claude/commands/` | Slash commands / skills |

## What Does NOT Sync

- `~/.claude/.credentials.json` — re-authenticate per machine
- `~/.claude/plugins/` — runtime-managed marketplace data
- `~/.claude/projects/` — session history (path-specific)
- `claude_desktop_config.json` — contains API tokens; use the `.example` template

## Quick Sync

Run `claude-sync` from anywhere to commit local changes, pull remote changes, and push.

### macOS / Linux

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
alias claude-sync="~/ClaudeSkills/sync.sh"
```

### Windows

Add to your PowerShell profile (`$PROFILE`):

```powershell
function claude-sync { & "$env:USERPROFILE\ClaudeSkills\sync.ps1" }
```

### Workflow

```
# Worked on Mac, want PC updated:
Mac:  claude-sync    # commits + pushes
PC:   claude-sync    # pulls changes

# Worked on PC, want Mac updated:
PC:   claude-sync    # commits + pushes
Mac:  claude-sync    # pulls changes

# Both changed things:
# Whichever runs second gets a rebase conflict prompt to resolve
```

## Uninstall

```bash
./uninstall.sh          # macOS / Linux
```

Removes symlinks and lists available backups for manual restore.

## Claude Desktop Config

The desktop config contains MCP server API tokens and is **not synced**.
Use `claude-desktop/claude_desktop_config.json.example` as a template.

| OS | Config Path |
|----|-------------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |
