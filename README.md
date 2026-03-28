# ClaudeSkills

Git-synced Claude Code settings, skills, and instructions across machines.

## Quick Setup (New Machine)

```bash
git clone git@github.com:NukeGozilla/ClaudeSkills.git ~/ClaudeSkills
cd ~/ClaudeSkills
chmod +x install.sh
./install.sh
```

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

## Daily Workflow

Edit files directly in this repo — changes reflect instantly via symlinks.

```bash
# After editing
git add . && git commit -m "update: ..." && git push

# On another machine
cd ~/ClaudeSkills && git pull
```

## Uninstall

```bash
./uninstall.sh
```

Removes symlinks and lists available backups for manual restore.

## Claude Desktop Config

The desktop config contains MCP server API tokens and is **not synced**.
Use `claude-desktop/claude_desktop_config.json.example` as a template.

| OS | Config Path |
|----|-------------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |
