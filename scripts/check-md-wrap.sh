#!/usr/bin/env bash
# scripts/check-md-wrap.sh — fail on hard-wrapped markdown prose (one line per
# paragraph/bullet is this repo's convention; see .claude/reference/skill-authoring.md §3).
set -euo pipefail

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <file.md> [more.md ...]" >&2
    exit 1
fi

violations=$(awk '
    FNR == 1 { fm = 0; fence = 0; prev_ok = 0; prev_line = 0 }
    FNR == 1 && $0 == "---" { fm = 1; next }
    fm { if ($0 == "---") fm = 0; prev_ok = 0; next }
    /^[[:space:]]*(```|~~~)/ { fence = !fence; prev_ok = 0; next }
    fence { next }
    /^[[:space:]]*\|/ || /^#/ || /^[[:space:]]*$/ { prev_ok = 0; next }
    {
        if (prev_ok && $0 ~ /^[[:space:]]*[a-z(]/) {
            printf "%s:%d: hard-wrapped prose, join with the next line\n", FILENAME, prev_line
        }
        prev_ok = (length($0) <= 100 && $0 ~ /[A-Za-z0-9,]$/)
        prev_line = FNR
    }
' "$@")

if [[ -n "$violations" ]]; then
    echo "$violations"
    echo
    echo "check-md-wrap: hard-wrapped prose found — one line per paragraph/bullet (see .claude/reference/skill-authoring.md §3)" >&2
    exit 1
fi
