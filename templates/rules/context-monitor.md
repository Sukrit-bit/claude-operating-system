# Context Budget Monitor

This rule applies every turn. It is an escalation trigger, not a suggestion.

## What to Track

Maintain a running mental count of:
- **T** = tool calls made this session (Bash, Read, Edit, Write, Glob, Grep, etc.)
- **M** = conversation turns (one user message + one assistant response = 1 turn)

Subagent activity does NOT count — subagents run in their own context windows.

## Thresholds

| Condition | Action |
|---|---|
| T >= 30 OR M >= 25 | **Heads-up.** One line to the user: "Context checkpoint: ~[T] tool calls, ~[M] turns. Good time to consider wrapping up or delegating remaining work to subagents." Keep working. |
| T >= 50 OR M >= 40 | **Auto-close.** Announce: "Context budget critical — finishing current task and running /session-end." Finish the immediate in-progress task (do not abandon mid-operation), then invoke /session-end. This is automatic — do not wait for user approval. |
| Compaction detected | **Immediate close.** If the system compacts the conversation (you notice earlier messages have been summarized), stop all work immediately and invoke /session-end Emergency Mode. Do not finish the current task. |

## Rules

- At **heads-up**: if the user says "keep going," continue but reassess after 5 more tool calls.
- At **auto-close**: if the user says "keep going," extend by exactly ONE more task, then invoke /session-end. No further extensions.
- At **compaction**: non-negotiable. Emergency Mode begins immediately.
- Delegating work to subagents is a valid mitigation at any threshold — subagent tool calls don't count toward T.
