# Claude Dotfiles Sync — Project Plan

**Goal:** Use a Git repo as the single source of truth for Claude Code (and Claude Desktop) settings and skills, synced across multiple machines via symlinks.

---

## 1. Repo Structure

```
ClaudeSkill/
├── README.md                  # This file (overview + setup instructions)
├── install.sh                 # Symlink installer script
├── uninstall.sh               # Remove symlinks (restore originals)
├── claude/
│   ├── CLAUDE.md              # Global instructions (all projects)
│   ├── settings.json          # Theme, model, permission preferences
│   ├── skills/                # Slash commands / skill files
│   │   └── example-skill.md
│   ├── agents/                # Custom sub-agents
│   ├── rules/                 # Coding preferences / style rules
│   └── plugins/               # Plugin configurations
├── claude-desktop/
│   └── claude_desktop_config.json   # MCP server config for Claude Desktop
└── .gitignore                 # Exclude credentials, local-only files
```

---

## 2. Phases

### Phase 1 — Repo Bootstrap
- [ ] Create private GitHub repo `ClaudeSkill`
- [ ] Copy current `~/.claude/CLAUDE.md`, `settings.json`, `skills/`, `agents/`, `rules/` into `claude/`
- [ ] Copy Claude Desktop `claude_desktop_config.json` into `claude-desktop/`
- [ ] Add `.gitignore` (exclude `.credentials.json`, `settings.local.json`, `statsig/`, `projects/`)
- [ ] Initial commit and push

### Phase 2 — Install Script
- [ ] Write `install.sh` to:
  - Back up any existing `~/.claude/` files before symlinking
  - Symlink `claude/CLAUDE.md` → `~/.claude/CLAUDE.md`
  - Symlink `claude/settings.json` → `~/.claude/settings.json`
  - Symlink `claude/skills/` → `~/.claude/skills/`
  - Symlink `claude/agents/` → `~/.claude/agents/`
  - Symlink `claude/rules/` → `~/.claude/rules/`
  - Symlink `claude/plugins/` → `~/.claude/plugins/`
  - Symlink `claude-desktop/claude_desktop_config.json` → Claude Desktop config path
  - Print status for each symlink (synced / skipped / conflict)
- [ ] Write `uninstall.sh` to remove symlinks and optionally restore backups

### Phase 3 — Skill State Tracking
- [ ] Add skill metadata: each skill file gets a frontmatter block
  ```yaml
  ---
  name: my-skill
  sync: true        # true = synced across machines, false = local-only
  ---
  ```
- [ ] `install.sh` reads `sync: false` and skips those files during symlinking
- [ ] Document skill states: `synced`, `local-only`, `conflict`, `external-symlink`

### Phase 4 — New Machine Setup (One Command)
- [ ] Document full bootstrap flow in `README.md`:
  ```bash
  git clone git@github.com:<username>/ClaudeSkill.git ~/ClaudeSkill
  cd ~/ClaudeSkill
  chmod +x install.sh
  ./install.sh
  ```
- [ ] Handle macOS vs Linux path differences in the script
- [ ] Add Claude Desktop config path detection (macOS vs Linux)

### Phase 5 — Maintenance Workflow
- [ ] Document daily workflow:
  - Edit skills/settings directly in `~/ClaudeSkill/` (changes reflect instantly via symlink)
  - `git add . && git commit -m "update: ..." && git push` to publish
  - On another machine: `git pull` (symlinks auto-pick up changes)
- [ ] Add optional shell alias: `claude-sync` → `cd ~/ClaudeSkill && git pull`

---

## 3. .gitignore

```gitignore
# Never commit credentials
claude/.credentials.json
claude/statsig/
claude/projects/          # Session history (path-specific, not portable)
claude/settings.local.json

# OS noise
.DS_Store
Thumbs.db
```

---

## 4. Claude Desktop Config Path Reference

| OS      | Path |
|---------|------|
| macOS   | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Linux   | `~/.config/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |

---

## 5. Security Notes

- Keep repo **private** (it contains MCP server configs which may have sensitive endpoint URLs)
- Never commit `.credentials.json` — re-authenticate on each machine after cloning
- MCP auth tokens should stay in the local config only; store only the server URL in the repo copy

---

## 6. Future Improvements

- [ ] Add `ccms`-style `status` command to show sync state per file
- [ ] CI check: scan for accidentally committed secrets on push
- [ ] Support Windows paths in install script
- [ ] Add `memoir` or `claude-sync` as optional fallback for session history
