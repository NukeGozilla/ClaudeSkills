#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/sync-$(date +%Y%m%d-%H%M%S)"

symlink_item() {
    local src="$1" dst="$2" label="$3"

    if [ -L "$dst" ]; then
        current=$(readlink "$dst")
        if [ "$current" = "$src" ]; then
            echo "[skip]   $label — already linked"
            return
        fi
        echo "[backup] $label — replacing existing symlink"
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/"
    elif [ -e "$dst" ]; then
        echo "[backup] $label — backing up existing to $BACKUP_DIR/"
        mkdir -p "$BACKUP_DIR"
        if [ -d "$dst" ]; then
            cp -a "$dst" "$BACKUP_DIR/"
            rm -rf "$dst"
        else
            mv "$dst" "$BACKUP_DIR/"
        fi
    fi

    ln -s "$src" "$dst"
    echo "[link]   $label — $dst -> $src"
}

echo "ClaudeSkills Sync — Installing symlinks"
echo "========================================"
echo ""

mkdir -p "$CLAUDE_DIR"

symlink_item "$REPO_DIR/claude/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"     "CLAUDE.md"
symlink_item "$REPO_DIR/claude/settings.json"  "$CLAUDE_DIR/settings.json" "settings.json"
symlink_item "$REPO_DIR/claude/commands"        "$CLAUDE_DIR/commands"      "commands/"

echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "Done. Backups saved to: $BACKUP_DIR"
else
    echo "Done. No backups needed (all items were fresh or already linked)."
fi
