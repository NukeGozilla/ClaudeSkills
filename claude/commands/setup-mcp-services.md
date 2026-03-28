---
name: setup-mcp-services
description: >
  Set up or repair MCP connections for Asana, Notion, and Linear across Claude
  Code and Claude Desktop. Triggers: "set up mcp", "fix asana/notion/linear",
  "mcp not working", "can't access task/page", or when any MCP call fails with
  access denied. Also use when setting up Claude on a new machine.
---

# MCP Services Setup

## Quick Reference

| Server Name | Service | Account | Package | Auth Env Var |
|-------------|---------|---------|---------|-------------|
| `asana-ztor` | Asana | Ztor | `@roychri/mcp-server-asana` | `ASANA_ZTOR_PAT` |
| `asana-beamco` | Asana | Beamco | `@roychri/mcp-server-asana` | `ASANA_BEAMCO_PAT` |
| `notion-personal` | Notion | Personal | `@notionhq/notion-mcp-server` | `NOTION_PERSONAL_TOKEN` |
| `notion-sports` | Notion | Sports | `@notionhq/notion-mcp-server` | `NOTION_SPORTS_TOKEN` |
| `linear` | Linear | (single) | HTTP endpoint | OAuth (no token) |

**Token storage:** All tokens are stored in the user's keychain manager. Config files reference them via `${ENV_VAR}` syntax — never store plain text tokens in configs.

---

## Workspace / Account Mapping

### Asana
| Account | Workspace GID | Primary Use |
|---------|--------------|-------------|
| **Ztor** | `1201357017636456` | Ztor project management, marketing team bug tickets |
| **Beamco** | `1205221415135461` | Tech & product, bug tracking, dev boards |

### Notion
| Account | Primary Use |
|---------|-------------|
| **Personal** | Main workspace, general notes |
| **Sports** | All notes for sports project |

### Linear
| Account | Primary Use |
|---------|-------------|
| Single | PM tool for sports project |

---

## URL Routing Guide

When a user shares a URL, use these patterns to pick the right MCP tools:

**Asana:** `https://app.asana.com/1/<WORKSPACE_GID>/...`
- Workspace `1201357017636456` → use `asana-ztor` tools
- Workspace `1205221415135461` → use `asana-beamco` tools

**Notion:** Check the workspace name or ask the user which account.

**Linear:** Single account — always use `linear` tools.

### MCP Tool Prefixes (after setup)
- `mcp__asana-ztor__*` — Ztor workspace
- `mcp__asana-beamco__*` — Beamco workspace
- `mcp__notion-personal__*` — Personal Notion
- `mcp__notion-sports__*` — Sports Notion
- `mcp__linear__*` — Linear
- `mcp__claude_ai_Asana__*` — Built-in connector (covers whichever account is OAuth'd)
- `mcp__claude_ai_Notion__*` — Built-in connector (covers whichever account is OAuth'd)

---

## Setup Instructions

### Prerequisites
- Node.js installed (for `npx`)
- Tokens stored in keychain and exported as environment variables

### Step 1: Set environment variables

The user must have these env vars available in their shell (e.g. via keychain, `.zshrc`, or secret manager):

```
ASANA_ZTOR_PAT=<ztor asana pat>
ASANA_BEAMCO_PAT=<beamco asana pat>
NOTION_PERSONAL_TOKEN=<personal notion integration token>
NOTION_SPORTS_TOKEN=<sports notion integration token>
```

PATs are generated at:
- Asana: https://app.asana.com/0/my-apps
- Notion: https://www.notion.so/my-integrations

### Step 2: Configure Claude Code

```bash
# Asana
claude mcp add -s user -e ASANA_ACCESS_TOKEN='${ASANA_ZTOR_PAT}' -- asana-ztor npx -y @roychri/mcp-server-asana
claude mcp add -s user -e ASANA_ACCESS_TOKEN='${ASANA_BEAMCO_PAT}' -- asana-beamco npx -y @roychri/mcp-server-asana

# Notion
claude mcp add -s user -e NOTION_TOKEN='${NOTION_PERSONAL_TOKEN}' -- notion-personal npx -y @notionhq/notion-mcp-server
claude mcp add -s user -e NOTION_TOKEN='${NOTION_SPORTS_TOKEN}' -- notion-sports npx -y @notionhq/notion-mcp-server

# Linear (OAuth, no token needed)
claude mcp add -s user -t http linear https://mcp.linear.app/mcp
```

Verify: `claude mcp list`

### Step 3: Configure Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) under `mcpServers`:

```json
{
  "mcpServers": {
    "asana-ztor": {
      "command": "npx",
      "args": ["-y", "@roychri/mcp-server-asana"],
      "env": { "ASANA_ACCESS_TOKEN": "${ASANA_ZTOR_PAT}" }
    },
    "asana-beamco": {
      "command": "npx",
      "args": ["-y", "@roychri/mcp-server-asana"],
      "env": { "ASANA_ACCESS_TOKEN": "${ASANA_BEAMCO_PAT}" }
    },
    "notion-personal": {
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": { "NOTION_TOKEN": "${NOTION_PERSONAL_TOKEN}" }
    },
    "notion-sports": {
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": { "NOTION_TOKEN": "${NOTION_SPORTS_TOKEN}" }
    },
    "linear": {
      "type": "http",
      "url": "https://mcp.linear.app/mcp"
    }
  }
}
```

Merge with existing config if `preferences` or other keys already exist.

### Step 4: Restart

- Claude Code: restart the session or reload the IDE window
- Claude Desktop: quit and reopen the app

---

## Troubleshooting

### "You do not have access to this task/project"
1. Identify which workspace the URL belongs to (see URL Routing Guide above)
2. Use the corresponding MCP tools
3. If both fail, the token may have expired — regenerate and update keychain

### MCP server not appearing after setup
- Claude Code: run `claude mcp list` to verify
- Claude Desktop: check `claude_desktop_config.json`
- Ensure `npx` is available in PATH (requires Node.js)
- Ensure env vars are exported in the shell session

### Token expired
- Asana: regenerate at https://app.asana.com/0/my-apps
- Notion: regenerate at https://www.notion.so/my-integrations
- Update the value in your keychain manager

### Linear OAuth prompt
Linear uses OAuth — the first time you use it, you'll be prompted to authorize in the browser. No token management needed.

---

## New Machine Checklist

1. Clone ClaudeSkills repo and run `install.sh` (symlinks commands/)
2. Set up keychain with all 4 tokens (2 Asana + 2 Notion)
3. Export env vars in shell profile
4. Run the Claude Code commands from Step 2 above
5. Copy Desktop config from `claude-desktop/claude_desktop_config.json.example`
6. Restart Claude Code and Claude Desktop
7. Test each connection
