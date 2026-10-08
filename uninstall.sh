#!/usr/bin/env bash
# uninstall.sh — remove every skill this repo installed from ~/.claude/skills/.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

PURGE=false
for arg in "$@"; do
    case "$arg" in
        --purge) PURGE=true ;;
        *)
            echo "unknown flag: $arg" >&2
            exit 1
            ;;
    esac
done

# shellcheck source=scripts/symlink-skills.sh
source "$REPO_DIR/scripts/symlink-skills.sh"

for skill_md in "$REPO_DIR"/skills/*/*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    name="$(basename "$(dirname "$skill_md")")"
    unregister_skill "$name"
done

if [[ "$PURGE" == "true" ]]; then
    echo "Removing $REPO_DIR"
    rm -rf "$REPO_DIR"
fi
