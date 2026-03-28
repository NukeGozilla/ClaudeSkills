---
name: setup-asana-mcp
description: >
  Use this skill to set up or repair Asana MCP connections for both Ztor and
  Beamco accounts. Triggers: "set up asana", "fix asana mcp", "asana not
  working", "can't access asana task", "add asana to claude", or when an Asana
  MCP call fails with access denied. Also use when setting up Claude on a new
  machine and needing Asana access.
---

# Asana MCP Setup for Ztor & Beamco

## Context

Jeff has two Asana workspaces that require separate PAT-based MCP connections:

| Account | Workspace Name | Workspace GID | PAT Prefix | Primary Use |
|---------|---------------|---------------|------------|-------------|
| **Ztor** | (Ztor workspace) | `1201357017636456` | `2/1203343297718153/...` | Ztor project management, marketing team bug tickets |
| **Beamco** | Beamco | `1205221415135461` | `2/1208372028705349/...` | Beamco tech & product, bug tracking, dev boards |

**Important:** The built-in `claude.ai Asana` connector (OAuth) only covers ONE account at a time. The PAT-based MCP servers below ensure both workspaces are always accessible regardless of which account the connector is pointed at.

---

## MCP Server Details

Both servers use the same package: `@roychri/mcp-server-asana`
- npm: https://www.npmjs.com/package/@roychri/mcp-server-asana
- GitHub: https://github.com/roychri/mcp-server-asana
- Auth env var: `ASANA_ACCESS_TOKEN`

### Server Names
- `asana-ztor` — Ztor workspace
- `asana-beamco` — Beamco workspace

---

## Setup Instructions

### Step 1: Get PAT tokens

Ask the user for their Asana PAT tokens if not provided. PATs are generated at:
https://app.asana.com/0/my-apps

Each workspace needs its own PAT from the corresponding Asana account.

### Step 2: Configure Claude Code

Run these commands (replace tokens with actual values):

```bash
# Ztor
claude mcp add -s user -e ASANA_ACCESS_TOKEN="<ZTOR_PAT>" -- asana-ztor npx -y @roychri/mcp-server-asana

# Beamco
claude mcp add -s user -e ASANA_ACCESS_TOKEN="<BEAMCO_PAT>" -- asana-beamco npx -y @roychri/mcp-server-asana
```

Using `-s user` scope makes these available across ALL Claude Code projects on the machine.

Verify with:
```bash
claude mcp list
```

### Step 3: Configure Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` under an `mcpServers` key:

```json
{
  "mcpServers": {
    "asana-ztor": {
      "command": "npx",
      "args": ["-y", "@roychri/mcp-server-asana"],
      "env": {
        "ASANA_ACCESS_TOKEN": "<ZTOR_PAT>"
      }
    },
    "asana-beamco": {
      "command": "npx",
      "args": ["-y", "@roychri/mcp-server-asana"],
      "env": {
        "ASANA_ACCESS_TOKEN": "<BEAMCO_PAT>"
      }
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
1. Check if the task URL contains workspace GID `1201357017636456` (Ztor) or `1205221415135461` (Beamco)
2. Use the corresponding `asana-ztor` or `asana-beamco` MCP tools
3. If both fail, the PAT may have expired — regenerate at https://app.asana.com/0/my-apps

### MCP server not appearing after setup
- Claude Code: check `~/.claude.json` under `mcpServers`
- Claude Desktop: check `~/Library/Application Support/Claude/claude_desktop_config.json`
- Ensure `npx` is available in PATH (requires Node.js installed)

### Identifying which workspace a URL belongs to
Asana URLs follow this pattern:
```
https://app.asana.com/1/<WORKSPACE_GID>/project/<PROJECT_GID>/task/<TASK_GID>
```
- Workspace `1201357017636456` = Ztor → use `asana-ztor` tools
- Workspace `1205221415135461` = Beamco → use `asana-beamco` tools

---

## Tool Naming Convention

Once set up, the MCP tools will be prefixed:
- `mcp__asana-ztor__*` — for Ztor workspace operations
- `mcp__asana-beamco__*` — for Beamco workspace operations
- `mcp__claude_ai_Asana__*` — built-in connector (covers whichever account is OAuth'd)

When a user shares an Asana URL, parse the workspace GID from the URL to determine which set of tools to use.
