---
name: figma-comments-to-tasks
description: >
  Turn Figma file comments into reviewable task drafts (and optionally push them
  to Asana or Linear). Use this skill ANY time the user wants to: pull comments
  from a Figma file, triage Figma feedback, convert designer/reviewer comments
  into dev tickets, or audit unresolved comments on a design. Trigger phrases:
  "figma comments", "pull comments from figma", "turn figma feedback into tasks",
  "review comments on [figma url]", "what's unresolved on this figma file",
  "create tickets from figma comments", "audit figma feedback". Always trigger
  when the user shares a Figma URL alongside any of: comments, feedback, review,
  tickets, tasks, todos, punch list. Workflow is REVIEW-FIRST — drafts are
  written to disk and shown to the user before any task is created in
  Asana/Linear. Do NOT auto-create tasks without explicit user approval.
---

# Figma Comments → Tasks

Turn Figma file comments into structured, reviewable task drafts. Optionally push approved drafts to Asana or Linear.

This is a **review-first** workflow. Never create tasks in Asana/Linear without explicit user approval of each draft.

## Prerequisites

The user must have a Figma personal access token in `~/.zshrc`:

```bash
export FIGMA_TOKEN="figd_xxx..."
```

The Bash tool runs `bash`, which doesn't auto-load `.zshrc`. **Always source it explicitly** at the start of any Bash call that uses `$FIGMA_TOKEN`:

```bash
source ~/.zshrc 2>/dev/null; <command using $FIGMA_TOKEN>
```

If `$FIGMA_TOKEN` is empty after sourcing, stop and tell the user to set it up at figma.com → Settings → Security → Personal access tokens (scopes: File content read, Comments read).

## Project Routing

Map Figma files to PM tools using the user's project landscape:

| Figma file mentions | Route to |
|---|---|
| Beamco / Fans Mobile / Artist | Asana — `mcp__asana-beamco__*` |
| Ztor | Asana — `mcp__asana-ztor__*` |
| Sports | Linear — `mcp__linear__*` |

If the project isn't obvious from the file name, **ask the user** before pushing tasks anywhere. Never guess.

## The Workflow

### Step 1 — Extract file key

From a Figma URL like `figma.com/design/OammYyGMZ6DVI2NQ7eNpk0/Beamco-Fans-Mobile-v3?...`:
- File key is the segment after `/design/` → `OammYyGMZ6DVI2NQ7eNpk0`

### Step 2 — Pull comments

```bash
source ~/.zshrc 2>/dev/null
curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/<FILE_KEY>/comments" > /tmp/figma-comments-raw.json
```

### Step 3 — Filter

By default, work with **unresolved top-level comments only** (skip replies and resolved threads). Confirm with the user if they want a different filter (e.g. "only mentioning me", "from last 7 days", "only from Sam").

```bash
jq '[.comments[] | select(.parent_id == "" and .resolved_at == null)]' /tmp/figma-comments-raw.json > /tmp/figma-comments-filtered.json
```

Show the user a summary count first (total / unresolved / by author) and ask: "Process all N unresolved, or filter further?" Don't generate drafts for hundreds of comments without confirmation.

### Step 4 — For each comment, build a draft

For each comment in the filtered set:

1. **Get design context** for the anchored node using the Figma MCP:
   - Tool: `mcp__claude_ai_Figma__get_design_context`
   - Args: `fileKey`, `nodeId` (from `comment.client_meta.node_id`)
   - This returns the design's structure, text content, and a screenshot

2. **Export a PNG** to disk via Figma REST API (cleaner than the MCP screenshot for ticket attachment):
   ```bash
   source ~/.zshrc 2>/dev/null
   URL=$(curl -s -H "X-Figma-Token: $FIGMA_TOKEN" \
     "https://api.figma.com/v1/images/<FILE_KEY>?ids=<NODE_ID>&format=png&scale=2" \
     | jq -r '.images["<NODE_ID>"]')
   mkdir -p /tmp/figma-drafts/<FILE_KEY>
   curl -s -o /tmp/figma-drafts/<FILE_KEY>/<COMMENT_ID>.png "$URL"
   ```

3. **Write a markdown draft** to `/tmp/figma-drafts/<FILE_KEY>/<COMMENT_ID>.md` with this structure:

   ```markdown
   # <Generated title — short, action-oriented, derived from comment + design context>

   **Source:** Figma comment by <Author> — <Date>
   **Figma deep link:** https://figma.com/design/<FILE_KEY>?node-id=<NODE_ID>#<COMMENT_ID>
   **Screenshot:** <COMMENT_ID>.png

   ## Comment
   > <Original comment text, with @mentions preserved>

   ## Design Context
   <2-3 sentence summary of what the screen/component is and where the comment is anchored. Pull from get_design_context output.>

   ## Suggested Action
   <One sentence: what the dev team needs to decide or do. Be concrete.>

   ## Stakeholders
   <List @mentions from the comment, mapped to roles if known>
   ```

   **Title generation rules:**
   - Action verb first ("Add", "Decide", "Fix", "Clarify", "Confirm")
   - Reference the screen/component, not generic words like "comment" or "feedback"
   - <70 chars
   - Examples:
     - "Decide whether Crowdfunding gets its own tab on Artist Page"
     - "Add legal disclaimer block above Fanvestor module"
     - "Clarify non-Top-Fan view for Crowdfunding section"

### Step 5 — Review

After all drafts are written, present a numbered list to the user:

```
12 drafts written to /tmp/figma-drafts/<FILE_KEY>/

 1. Decide whether Crowdfunding gets its own tab — Sam Padbidri
 2. Add legal disclaimer above Fanvestor module — Sam Padbidri
 3. Replace blur on bottom nav with simple shadow — Flo Hua
 ...

What next?
  a) Push all to <Asana/Linear>
  b) Push selected (give me numbers, e.g. "1, 3, 7-9")
  c) Skip some and push the rest (give me numbers to skip)
  d) Show me draft #N
  e) Edit draft #N before pushing
  f) Done — leave drafts on disk
```

**Wait for the user's choice. Never proceed to Step 6 without explicit approval.**

### Step 6 — Push approved drafts

For each approved draft, use the appropriate MCP:

- **Asana (Beamco/Ztor):** `mcp__asana-beamco__asana_create_task` or `mcp__asana-ztor__asana_create_task`
  - Pass: `name` (title), `notes` (markdown body), `projects` (ask user which Asana project)
  - Asana doesn't accept image attachments via MCP — include the screenshot path in the notes and tell the user to drag it in manually, OR attach a Figma deep link that previews the node

- **Linear (Sports):** `mcp__linear__*` (check available tools — Linear MCP may need auth first)
  - Pass: `title`, `description` (markdown body), `team` (ask user)

After pushing, report back:
- "Created N tasks in <Asana project / Linear team>"
- List each task with its URL/ID
- Note any failures with reasons

## Edge Cases

- **No comments / API returns 403:** token likely expired or missing scopes. Tell user to regenerate.
- **Comment with no `client_meta.node_id`:** it's a file-level comment (not anchored). Skip the design context + screenshot steps; still write a draft with just the comment text.
- **Comment is just `@mentions` with no content:** skip — not a real action item.
- **Reply chains:** by default ignore replies. If the user wants the full thread, fetch all comments with that `parent_id` and inline them into the draft under a "Discussion" section.
- **Many comments (>30):** offer to do a first pass with just titles + 1-line summaries, then deep-dive only on the ones the user picks.
- **Token in chat:** never echo `$FIGMA_TOKEN`. If verifying it loaded, only show the prefix: `${FIGMA_TOKEN:0:8}...`.

## What NOT to do

- Don't auto-create Asana/Linear tasks without explicit per-batch approval.
- Don't skip the design context step — the screenshot + context is what makes these drafts useful vs. just dumping comment text.
- Don't generate drafts for resolved comments unless the user explicitly asks.
- Don't post replies back to the Figma thread (the API supports it, but it's out of scope for this skill).
