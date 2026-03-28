# Claude Code Permissions Setup

## What this does

Reduces permission prompts so Claude only asks for approval on sensitive/unusual actions.

- File reads and edits: auto-approved
- Common CLI commands (git, npm, ls, cat, find, ssh): auto-approved
- Destructive commands (rm -rf, force push): always blocked
- Everything else: still prompts

## Setup

Edit (or create) `~/.claude/settings.json`:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Bash(npm run *)",
      "Bash(npm test *)",
      "Bash(npm install *)",
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(git commit *)",
      "Bash(git checkout *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(find *)",
      "Bash(env)",
      "Bash(* --version)",
      "Bash(* --help *)",
      "Bash(ssh macmini *)",
      "Bash(ssh ethanwalker@100.112.198.32 *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)"
    ],
    "additionalDirectories": [
      "/tmp"
    ]
  },
  "effortLevel": "medium"
}
```

## Switching modes during a session

Press **Shift+Tab** to cycle between modes:

- Ask before edits (default)
- Edit automatically (acceptEdits) -- recommended
- Plan mode

## Notes

- The allow list uses wildcard patterns (`*`), so `Bash(ssh macmini *)` covers any command sent to that host
- You can add more patterns over time -- when Claude prompts you, clicking "Allow always" adds the pattern automatically
- The deny list takes priority over the allow list
