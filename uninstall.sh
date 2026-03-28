#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

remove_symlink() {
    local dst="$1" label="$2"

    if [ -L "$dst" ]; then
        target=$(readlink "$dst")
        if [[ "$target" == "$REPO_DIR"* ]]; then
            rm "$dst"
            echo "[removed] $label — was linked to $target"
        else
            echo "[skip]    $label — symlink points outside this repo: $target"
        fi
    elif [ -e "$dst" ]; then
        echo "[skip]    $label — not a symlink, leaving untouched"
    else
        echo "[skip]    $label — does not exist"
    fi
}

echo "ClaudeSkills Sync — Removing symlinks"
echo "======================================="
echo ""

remove_symlink "$CLAUDE_DIR/CLAUDE.md"     "CLAUDE.md"
remove_symlink "$CLAUDE_DIR/settings.json" "settings.json"
remove_symlink "$CLAUDE_DIR/commands"      "commands/"

echo ""

# List available backups
BACKUPS=$(find "$CLAUDE_DIR/backups" -maxdepth 1 -name "sync-*" -type d 2>/dev/null | sort -r)
if [ -n "$BACKUPS" ]; then
    echo "Available backups to restore from:"
    echo "$BACKUPS"
    echo ""
    echo "To restore, copy files from the backup directory back to $CLAUDE_DIR/"
else
    echo "No backups found."
fi
