#!/usr/bin/env bash
# scripts/validate-skill-frontmatter.sh
#
# Validates SKILL.md frontmatter invariants (see .claude/reference/skill-authoring.md).
# Pass one or more SKILL.md paths (pre-commit passes the changed files); with no
# args, validates every skills/*/*/SKILL.md.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

check_file() {
    local file="$1"
    [[ -f "$file" ]] || return 0
    local folder
    folder="$(basename "$(dirname "$file")")"

    local name
    name="$(awk -F': *' '/^name:/{print $2; exit}' "$file")"
    if [[ -z "$name" ]]; then
        echo "✗ $file: missing 'name:' field" >&2
        fail=1
    elif [[ "$name" != "$folder" ]]; then
        echo "✗ $file: name '$name' does not match folder '$folder'" >&2
        fail=1
    fi

    local description
    description="$(awk -F': *' '/^description:/{print $2; exit}' "$file")"
    if [[ -z "$description" ]]; then
        echo "✗ $file: missing 'description:' field" >&2
        fail=1
    elif [[ "$description" =~ ^[\"\'] ]]; then
        echo "✗ $file: description must not be quoted" >&2
        fail=1
    elif [[ ${#description} -ge 1024 ]]; then
        echo "✗ $file: description must be under 1024 characters" >&2
        fail=1
    fi

    if grep -q '^argument-hint:' "$file"; then
        echo "✗ $file: 'argument-hint:' is not allowed — skills are model-invoked, not slash-only" >&2
        fail=1
    fi

    # shellcheck disable=SC2016 # literal match intended, not expansion
    if grep -qF '$ARGUMENTS' "$file"; then
        echo "✗ $file: '\$ARGUMENTS' is not allowed — write descriptive prose instead" >&2
        fail=1
    fi
}

if [[ $# -gt 0 ]]; then
    for f in "$@"; do check_file "$f"; done
else
    for f in "$REPO_DIR"/skills/*/*/SKILL.md; do check_file "$f"; done
fi

exit $fail
