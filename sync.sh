#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "ClaudeSkills Sync"
echo "================="

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
