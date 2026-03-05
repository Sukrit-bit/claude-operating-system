---
name: learnings
description: Update learnings_for_Sukrit.md with new insights from this session
---

Update BOTH the project-level and global learnings files with insights from this session, then generate an interactive HTML dashboard.

**Three outputs are always produced:**
1. `learnings_for_Sukrit.md` in the current project root (detailed, project-specific)
2. `~/Documents/Projects/learning-from-building/learnings_for_Sukrit_global.md` (condensed, cross-project, tagged by project name — lives in the framework repo)
3. `learnings_dashboard.html` in the current project root (interactive visual dashboard)

---

## PART A: Project-Level File

### Step 1: Determine mode

Check if `learnings_for_Sukrit.md` exists in the project root.

- **If it does NOT exist → FIRST-RUN MODE** (create the file from scratch)
- **If it exists → APPEND MODE** (add this session's learnings to the bottom)

### Step 2a: FIRST-RUN MODE (file doesn't exist yet)

Create `learnings_for_Sukrit.md` in the project root with comprehensive coverage:

1. **Header and intro** — `# Learnings for Sukrit` with a brief explanation of what this file is
2. **The Big Picture** — What the project is and why it exists, explained in plain language
3. **How the codebase is structured** — The architecture, how the parts connect, what lives where, and why it's organized this way. Use analogies.
4. **Technologies used and why** — Every major technology/library/API, why it was chosen, and what alternatives were considered
5. **Key technical concepts** — The important patterns, algorithms, or design decisions, explained accessibly
6. **Bugs and debugging stories** — Real bugs from the sessions so far, how they were found, and what they teach
7. **Engineering principles demonstrated** — What this project teaches about good engineering
8. **Session-specific learnings** — Detailed learnings from THIS session (same format as append mode)

This first-run file should be engaging to read — conversational tone, analogies, anecdotes. Not a textbook. Think "a smart friend explaining their project over coffee." Reference actual file paths, include code examples where helpful.

### Step 2b: APPEND MODE (file already exists)

1. Read the existing file to understand what's already documented
2. Review the full conversation history and identify ALL key learnings from THIS session
3. Append a new dated section to the BOTTOM of the file using this format:

```markdown
---

## Session: [Date] — [Brief topic description]

### What We Did
[1-2 sentences summarizing the session's work]

### New Learnings

#### [Learning Title]
[Conversational explanation with context, why it matters, and what to do about it]

#### [Learning Title]
[...]
```

---

## PART B: Global File

After updating the project-level file, ALSO update `~/Documents/Projects/learning-from-building/learnings_for_Sukrit_global.md`.

### If the global file doesn't exist yet

Create it with this header:

```markdown
# Sukrit's Engineering Learning Log

> Cross-project learnings from building with Claude.
> Each entry is tagged with the project name for easy filtering.
> This file is the single source for building an interactive learnings UI later.

---
```

### Append a condensed entry

Add a new entry to the BOTTOM of the global file in this format:

```markdown
## [Date] — [Project Name] — [Brief topic]

**What happened:** [1-2 sentences]

**Key learnings:**
- **[Learning title]:** [1-2 sentence condensed version]
- **[Learning title]:** [1-2 sentence condensed version]
- ...

**Tags:** [comma-separated tags like: debugging, architecture, API-gotcha, LLM, database, performance, testing, deployment]

---
```

The global entries should be CONDENSED (not the full detailed version from the project file). Think of it as the "index card" version — enough context to be useful, short enough to scan across 50+ entries from different projects.

IMPORTANT: Always include the **Tags** line. These tags will power filtering and search in the interactive UI later.

---

## PART C: HTML Dashboard

After updating both markdown files, generate an interactive HTML dashboard.

**Read the visualize-learnings skill** at `~/.claude/skills/visualize-learnings/SKILL.md` for the full dashboard specification, then follow its instructions to generate `learnings_dashboard.html` in the project root.

If the visualize-learnings skill file is not accessible, generate a self-contained HTML dashboard with these requirements:
- Read `learnings_for_Sukrit.md` from the project root as the data source
- Parse all `## Session:` sections to extract dates, topics, learnings, and tags
- Generate a single-file HTML page with inline CSS and JS (no external dependencies)
- Include: stats header, tag frequency chart, filterable session timeline with expandable cards
- Dark theme, responsive, clean typography
- Write to `learnings_dashboard.html` in the project root
- Confirm to the user: "Dashboard generated at learnings_dashboard.html"

---

## Rules (all outputs)
- APPEND only for markdown files — never delete or modify previous sections
- Keep tone conversational and engaging, not like a textbook
- Use analogies where they help make concepts memorable
- Include specific code examples or commands where relevant
- Reference actual file paths in the project (project-level file only)
- Each learning should have enough context to make sense on its own, months later
- Don't be generic — every learning should be specific to what actually happened
- The global file entries must ALWAYS include the project name and tags
