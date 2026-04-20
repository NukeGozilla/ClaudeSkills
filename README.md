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
| `claude/commands/` | Slash commands |
| `skills/` | Claude **Code** skills (folder-based, symlinked into `~/.claude/skills/`) |

## What Does NOT Sync

- `~/.claude/.credentials.json` — re-authenticate per machine
- `~/.claude/plugins/` — runtime-managed marketplace data
- `~/.claude/projects/` — session history (path-specific)
- `claude_desktop_config.json` — contains API tokens; use the `.example` template
- **Claude Desktop user skills** — see below

## Claude Desktop Skills (manual upload)

Claude Desktop reads user skills from cloud-synced bundles, not from any local folder. The repo's `skills/` folder is the **source of truth** — but to use a skill in Desktop, you must paste its `SKILL.md` into the cloud once:

1. Open the skill's `SKILL.md` (e.g. `skills/figma-comments-to-tasks/SKILL.md`)
2. Go to claude.ai → **Settings** → **Capabilities** → **Skills** → **New skill**
3. Paste the file contents and save
4. The skill syncs to every Claude Desktop install on your account automatically

For Claude **Code**, the symlink approach is fully automatic — `./install.sh` wires up `skills/` and edits are live. Only Desktop needs the manual step.

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
