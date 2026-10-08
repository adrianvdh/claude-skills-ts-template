#!/usr/bin/env bash
# scripts/run-in-packages.sh <script-name> — run `bun run <script-name>` in
# every packages/* member that declares that script, skipping the rest.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_name="${1:?usage: run-in-packages.sh <script-name>}"

for dir in "$REPO_DIR"/packages/*/; do
    [[ -f "$dir/package.json" ]] || continue
    grep -q "\"$script_name\"" "$dir/package.json" || continue
    echo "-- $script_name: $(basename "$dir")"
    (cd "$dir" && bun run "$script_name")
done
