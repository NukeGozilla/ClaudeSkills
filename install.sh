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

# Claude Code / Cowork skills (folder-based SKILL.md format) → ~/.claude/skills/
if [ -d "$REPO_DIR/skills" ]; then
    mkdir -p "$CLAUDE_DIR/skills"
    for skill_dir in "$REPO_DIR/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")
        symlink_item "$skill_dir" "$CLAUDE_DIR/skills/$skill_name" "skills/$skill_name/"
    done
else
    echo "[info]   No skills/ folder found — skipping Claude Code skills"
fi

# Note: Claude Desktop user skills are NOT synced via filesystem.
# Desktop reads skills from cloud-synced bundles, not from local folders.
# To use a skill from this repo in Claude Desktop, paste its SKILL.md
# into claude.ai → Settings → Capabilities → Skills (one-time per skill).
if [ -d "$REPO_DIR/skills" ]; then
    echo ""
    echo "[info]   Claude Desktop skills are upload-only — paste each SKILL.md"
    echo "         into claude.ai → Settings → Capabilities → Skills if you"
    echo "         want them available in Desktop. Source files:"
    for skill_dir in "$REPO_DIR/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")
        echo "           - $skill_dir""SKILL.md"
    done
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "Done. Backups saved to: $BACKUP_DIR"
else
    echo "Done. No backups needed (all items were fresh or already linked)."
fi
