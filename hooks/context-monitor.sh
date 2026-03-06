#!/bin/bash
# PostToolUse hook: Maintains accurate tool call counter via temp file.
# Injects system messages at context budget thresholds (30 and 50 tool calls).
# Counter is keyed by session_id so concurrent sessions don't interfere.
#
# Install: symlink to ~/.claude/hooks/context-monitor.sh
# Config:  add PostToolUse hook entry in ~/.claude/settings.json

set -euo pipefail

# Read the full stdin JSON from Claude Code
INPUT=$(cat)

# Extract session_id (pure sed, no external dependencies)
SESSION_ID=$(echo "$INPUT" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# No session_id → exit silently (graceful degradation)
if [ -z "$SESSION_ID" ]; then
  exit 0
fi

COUNTER_FILE="/tmp/claude-context-monitor-${SESSION_ID}"

# Read current count (default 0), increment, write back
COUNT=0
if [ -f "$COUNTER_FILE" ]; then
  COUNT=$(cat "$COUNTER_FILE")
fi
COUNT=$((COUNT + 1))
echo "$COUNT" > "$COUNTER_FILE"

# Inject system messages at thresholds
if [ "$COUNT" -eq 30 ]; then
  echo '{"systemMessage": "Context checkpoint: 30 tool calls reached. Good time to consider wrapping up or delegating remaining work to subagents."}'
elif [ "$COUNT" -eq 50 ]; then
  echo '{"systemMessage": "Context budget critical — 50 tool calls reached. Finish current task and run /session-end. This is automatic — do not wait for user approval."}'
fi
