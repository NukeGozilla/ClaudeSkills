# ClaudeSkills — Claude Code Instructions

Cross-machine configuration manager for Claude Code. Syncs settings, global instructions, and custom slash commands across macOS, Linux, and Windows via git.

---

## What This Project Does

Keeps Claude Code config consistent across machines by maintaining a git repo that symlinks into Claude's config directory (`~/.claude/`). Includes conflict resolution and bidirectional sync.

---

## Key Commands

```bash
# First-time setup on a new machine
./install.sh          # macOS/Linux
./install.ps1         # Windows

# Sync changes (pull remote, push local changes)
./sync.sh             # macOS/Linux
./sync.ps1            # Windows

# Remove symlinks and restore original config
./uninstall.sh
```

---

## Project Structure

```
ClaudeSkills/
├── claude/
│   ├── CLAUDE.md          ← global Claude Code instructions (symlinked to ~/.claude/CLAUDE.md)
│   ├── settings.json      ← permissions, effort level
│   └── commands/          ← custom slash command definitions
├── install.sh / install.ps1
├── sync.sh / sync.ps1
└── uninstall.sh
```

---

## Key Rules

- Edit config files inside `ClaudeSkills/claude/` — the symlinks will reflect changes in `~/.claude/` automatically
- Run `sync.sh` after making changes to push them to the remote repo
- Do not edit files directly in `~/.claude/` if they are symlinked — changes will be lost on sync
