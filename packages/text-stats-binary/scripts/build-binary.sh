#!/usr/bin/env bash
# packages/text-stats-binary/scripts/build-binary.sh — compile the CLI to a
# standalone binary so skills can call it without a bun/node runtime present.
set -euo pipefail
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$dir"
mkdir -p dist
bun build --compile --outfile=dist/text-stats ./src/cli.ts
