#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "ClaudeSkills Sync"
echo "================="

# Import new/updated skills from Claude Desktop
DESKTOP_SKILLS_DIR="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
COMMANDS_DIR="$(pwd)/claude/commands"

# Built-in skills to skip (shipped with Claude Desktop)
BUILTIN_SKILLS="pdf|xlsx|pptx|docx|schedule|skill-creator"

if [ -d "$DESKTOP_SKILLS_DIR" ]; then
    echo "Scanning Claude Desktop for new skills..."
    found=0
    while IFS= read -r skill_file; do
        skill_name=$(basename "$(dirname "$skill_file")")

        # Skip built-in skills
        if echo "$skill_name" | grep -qE "^($BUILTIN_SKILLS)$"; then
            continue
        fi

        target="$COMMANDS_DIR/$skill_name.md"

        if [ ! -f "$target" ]; then
            cp "$skill_file" "$target"
            echo "  [new] $skill_name"
            found=$((found + 1))
        elif ! diff -q "$skill_file" "$target" > /dev/null 2>&1; then
            cp "$skill_file" "$target"
            echo "  [updated] $skill_name"
            found=$((found + 1))
        fi
    done < <(find "$DESKTOP_SKILLS_DIR" -name "SKILL.md" 2>/dev/null | sort -r)

    if [ "$found" -eq 0 ]; then
        echo "  No new Desktop skills found."
    fi
fi

# Stage and commit any local changes
if [ -n "$(git status --porcelain)" ]; then
    echo "Local changes detected — committing..."
    git add -A
    git commit -m "sync: $(hostname) — $(date '+%Y-%m-%d %H:%M')"
else
    echo "No local changes."
fi

# Pull remote changes, prompt on conflict
echo "Pulling remote changes..."
git pull --rebase || {
    echo ""
    echo "CONFLICT detected. Resolve manually, then run:"
    echo "  cd $(pwd) && git rebase --continue"
    exit 1
}

# Push if there are local commits ahead of remote
if [ "$(git rev-list --count origin/main..HEAD 2>/dev/null)" -gt 0 ]; then
    echo "Pushing to remote..."
    git push origin main
fi

echo ""
echo "Synced."
