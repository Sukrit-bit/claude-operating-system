#!/bin/bash
# PreCompact hook: Fires before context compression.
# On automatic compaction (context window full), injects emergency close message.
# On manual /compact, stays silent — the user knows what they're doing.
#
# Install: symlink to ~/.claude/hooks/pre-compact.sh
# Config:  add PreCompact hook entry in ~/.claude/settings.json

set -euo pipefail

INPUT=$(cat)

# Extract trigger type: "auto" (context window full) or "manual" (/compact command)
TRIGGER=$(echo "$INPUT" | sed -n 's/.*"trigger"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# Only fire on automatic compaction — manual /compact is intentional
if [ "$TRIGGER" = "auto" ]; then
  echo '{"systemMessage": "EMERGENCY: Context compaction imminent. Stop all work immediately and run /session-end Emergency Mode. Do not finish the current task."}'
fi
