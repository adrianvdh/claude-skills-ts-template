#!/usr/bin/env bash
# hooks/check-skills.sh
#
# Copy this into a CONSUMING repo's .claude/hooks/ (not this repo's) and wire it
# up as a PreToolUse hook matching the "Skill" tool, to make this library a hard
# dependency there — skill use fails loudly if the library isn't installed,
# instead of silently behaving as if it were:
#
#   {
#     "hooks": {
#       "PreToolUse": [
#         { "matcher": "Skill", "hooks": [{ "type": "command", "command": ".claude/hooks/check-skills.sh" }] }
#       ]
#     }
#   }
#
# Set this to the directory name this library was installed under inside
# ~/.claude/skills/ (defaults to matching this repo's own name via setup.sh).
LIBRARY_NAME="ts-skills-library"

set -euo pipefail

if [[ ! -d "$HOME/.claude/skills/$LIBRARY_NAME" ]]; then
    printf '{"decision": "block", "reason": "Required skill library '\''%s'\'' is not installed under ~/.claude/skills/. Clone it and run ./setup.sh, then retry."}\n' "$LIBRARY_NAME"
    exit 0
fi

exit 0
