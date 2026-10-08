#!/usr/bin/env bash
# scripts/list-skills.sh — print skills grouped by category.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

if [[ ! -d "$SKILLS_DIR" ]]; then
    echo "(no skills/ directory)" >&2
    exit 0
fi

count=0
category=""
for skill_md in "$SKILLS_DIR"/*/*/SKILL.md; do
    [[ -f "$skill_md" ]] || continue
    skill_dir="$(dirname "$skill_md")"
    this_category="$(basename "$(dirname "$skill_dir")")"
    if [[ "$this_category" != "$category" ]]; then
        category="$this_category"
        printf '\n  %s\n' "$category"
    fi
    name="$(awk -F': *' '/^name:/{print $2; exit}' "$skill_md")"
    description="$(awk -F': *' '/^description:/{print $2; exit}' "$skill_md" | cut -c1-80)"
    printf '    %-28s %s\n' "${name:-$(basename "$skill_dir")}" "$description"
    count=$((count + 1))
done

printf '\n  total: %d skill(s)\n' "$count"
