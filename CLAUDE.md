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

## Claude Desktop ≠ filesystem-synced

This repo only syncs **Claude Code** (CLI). Claude Desktop user skills are stored in cloud-synced bundles that the app downloads from claude.ai — there is **no local folder it reads from**.

To use a skill from `skills/` in Claude Desktop:
1. Open the SKILL.md (e.g. `skills/figma-comments-to-tasks/SKILL.md`)
2. Paste its contents into claude.ai → Settings → Capabilities → Skills (or Claude Desktop → Settings → Capabilities → Skills)
3. Save — it syncs to all your Desktop installs automatically (no per-machine work)

When you update a skill in this repo, you must **re-paste the new SKILL.md** into the UI to push the update to Desktop. Claude Code picks up edits live via the symlink; Desktop does not.
