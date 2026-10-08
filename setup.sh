#!/usr/bin/env bash
# setup.sh — build any packages/* binaries, then install every skill in
# skills/*/*/SKILL.md into ~/.claude/skills/<name>/.
set -euo pipefail
umask 077

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

CHECK=false
FORCE=false
QUIET=false

for arg in "$@"; do
    case "$arg" in
        --check) CHECK=true ;;
        --force) FORCE=true ;;
        --quiet | -q) QUIET=true ;;
        *)
            echo "unknown flag: $arg" >&2
            exit 1
            ;;
    esac
done

if [[ "$CHECK" == "true" ]]; then
    exec "$REPO_DIR/scripts/list-skills.sh"
fi

# shellcheck source=scripts/symlink-skills.sh
source "$REPO_DIR/scripts/symlink-skills.sh"

build_binaries() {
    local dir
    for dir in "$REPO_DIR"/packages/*/; do
        [[ -f "$dir/package.json" ]] || continue
        grep -q '"build:binary"' "$dir/package.json" || continue
        if ! command -v bun >/dev/null 2>&1; then
            echo "✗ bun is required to build $(basename "$dir") but was not found on PATH" >&2
            return 1
        fi
        [[ "$QUIET" == "true" ]] || echo "building $(basename "$dir")"
        (cd "$dir" && bun run build:binary)
    done
}

if [[ -d "$REPO_DIR/packages" ]]; then
    if [[ ! -d "$REPO_DIR/node_modules" ]] && command -v bun >/dev/null 2>&1; then
        (cd "$REPO_DIR" && bun install)
    fi
    build_binaries
fi

mkdir -p "$SKILLS_DIR"

count=0
for skill_md in "$REPO_DIR"/skills/*/*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    skill_dir="$(dirname "$skill_md")"
    name="$(basename "$skill_dir")"
    if register_skill "$name" "$skill_dir" "$FORCE"; then
        count=$((count + 1))
    fi
done

if [[ "$count" -eq 0 ]]; then
    echo "✗ no skills were registered despite skills/*/*/SKILL.md existing — aborting" >&2
    exit 1
fi

[[ "$QUIET" == "true" ]] || echo "Installed $count skill(s) into $SKILLS_DIR"
