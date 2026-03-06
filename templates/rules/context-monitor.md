# Context Budget Monitor

This rule applies every turn. It is an escalation trigger, not a suggestion.

## How It Works

Tool call counting is handled automatically by a PostToolUse hook (`~/.claude/hooks/context-monitor.sh`). The hook maintains an accurate counter in a temp file keyed by session_id and injects system messages when thresholds are reached.

A PreCompact hook (`~/.claude/hooks/pre-compact.sh`) fires before automatic context compression and injects an emergency close message.

Subagent tool calls do NOT trigger these hooks — subagents run in their own context windows.

## When You Receive a Hook Message

| Hook Message | Action |
|---|---|
| "Context checkpoint: 30 tool calls reached..." | **Heads-up.** Relay the message to the user. Keep working. |
| "Context budget critical — 50 tool calls reached..." | **Auto-close.** Finish the immediate in-progress task (do not abandon mid-operation), then invoke /session-end. This is automatic — do not wait for user approval. |
| "EMERGENCY: Context compaction imminent..." | **Immediate close.** Stop all work immediately and invoke /session-end Emergency Mode. Do not finish the current task. |

## Rules

- At **heads-up**: if the user says "keep going," continue but reassess after 5 more tool calls.
- At **auto-close**: if the user says "keep going," extend by exactly ONE more task, then invoke /session-end. No further extensions.
- At **compaction**: non-negotiable. Emergency Mode begins immediately.
- Delegating work to subagents is a valid mitigation at any threshold — subagent tool calls don't count.
