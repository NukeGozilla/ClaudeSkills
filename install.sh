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

# Claude Desktop skills → Desktop's skills-plugin dir (no-ops if Desktop not installed)
case "$(uname -s)" in
    Darwin) DESKTOP_BASE="$HOME/Library/Application Support/Claude" ;;
    Linux)  DESKTOP_BASE="$HOME/.config/Claude" ;;
    *)      DESKTOP_BASE="" ;;
esac
DESKTOP_SKILLS_DIR="$DESKTOP_BASE/local-agent-mode-sessions/skills-plugin"

if [ -n "$DESKTOP_BASE" ] && [ -d "$DESKTOP_BASE" ] && [ -d "$REPO_DIR/skills" ]; then
    mkdir -p "$DESKTOP_SKILLS_DIR"
    echo ""
    echo "Linking skills into Claude Desktop..."
    desktop_linked=0
    for skill_dir in "$REPO_DIR/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")
        symlink_item "$skill_dir" "$DESKTOP_SKILLS_DIR/$skill_name" "desktop/skills/$skill_name/"
        desktop_linked=$((desktop_linked + 1))
    done
    if [ "$desktop_linked" -gt 0 ]; then
        echo "[note]   Restart Claude Desktop for new/changed skills to appear."
    fi
elif [ -n "$DESKTOP_BASE" ]; then
    echo "[info]   Claude Desktop not installed (no $DESKTOP_BASE) — skipping Desktop skill links"
fi

echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "Done. Backups saved to: $BACKUP_DIR"
else
    echo "Done. No backups needed (all items were fresh or already linked)."
fi
