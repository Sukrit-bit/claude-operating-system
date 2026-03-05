---
name: visualize-learnings
description: Generate an interactive HTML dashboard from the project's learnings file
---

Generate a self-contained interactive HTML dashboard that visualizes the project's learnings file. This skill can be invoked standalone or is called by the `/learnings` skill as Part C.

---

## Step 1: Locate and Read the Learnings File

1. Look for `learnings_for_Sukrit.md` in the current project root
2. If not found, ask the user which file to visualize
3. Read the entire file

---

## Step 2: Parse the Data

Extract from the learnings file:

- **Sessions:** Each `## Session:` block (date, topic, "What We Did" summary, individual learnings)
- **Learnings:** Each `####` heading within a session (title + body text)
- **Tags:** If the file contains `Tags:` lines, extract them. If not (project-level files often don't have explicit tags), infer tags from content keywords
- **Big Picture / Structure sections:** If present (first-run format), extract for the overview panel

Also count:
- Total number of sessions
- Total number of individual learnings
- Total unique tags
- Tags by frequency (how many sessions/learnings each tag appears in)

---

## Step 3: Generate the HTML Dashboard

Write a single self-contained HTML file to `learnings_dashboard.html` in the project root.

### Required Sections

**1. Header Bar**
- Project name (extracted from the file header or the project directory name)
- Stats: total sessions, total learnings, total unique tags
- Last updated date

**2. Tag Frequency Panel**
- Horizontal bar chart showing all tags sorted by frequency (most common first)
- Each bar is clickable — clicking a tag filters the timeline below to only show sessions containing that tag
- Show the count number at the end of each bar
- Active filter state should be visually obvious (highlighted tag, "Showing X of Y sessions" indicator)
- A "Clear filter" button when a filter is active

**3. Session Timeline**
- Cards in reverse chronological order (newest first)
- Each card shows:
  - **Date** (prominent, left-aligned or as a timeline marker)
  - **Topic** (session title)
  - **Summary** ("What We Did" text, always visible)
  - **Learnings** (collapsed by default, expandable via click/toggle)
    - Each learning shows its title as the toggle header
    - Expanded state shows the full learning body text
  - **Tag pills** (small rounded badges at the bottom of the card)
- Cards should have subtle visual differentiation (alternating backgrounds or left-border accent)

**4. Search/Filter Bar** (above the timeline)
- Text input that filters sessions and learnings by keyword match
- Searches across: session topics, learning titles, learning bodies, tags
- Real-time filtering as user types
- Show match count: "X sessions match"

### Design Requirements

**Theme:** Dark background (`#0d1117` or similar GitHub-dark), with muted accent colors for tags and highlights. NOT pure black — use charcoal/dark gray.

**Typography:**
- System font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
- Monospace for code snippets: `'SF Mono', 'Fira Code', 'Consolas', monospace`
- Clear hierarchy: large session dates, medium titles, readable body text
- Line height 1.6 for body text

**Layout:**
- Max width 900px, centered
- Tag panel at the top (collapsible on mobile)
- Timeline below, full width within the container
- Responsive: stack on mobile, comfortable on desktop

**Interactions:**
- Smooth transitions for expand/collapse (CSS transitions, not instant)
- Tag click → filter with smooth scroll to timeline
- Search → real-time filter with debounce (150ms)
- `<details>` + `<summary>` elements for expandable learnings (works without JS)
- Enhance with JS for smooth animations, but ensure basic functionality without JS

**Colors for tag pills:**
- Generate distinct but muted colors based on tag name (hash the tag string to pick from a palette)
- Same tag always gets the same color across all cards
- Palette: muted blues, greens, purples, oranges — avoid bright/neon

**Self-contained:**
- ALL CSS inline in `<style>` tags
- ALL JavaScript inline in `<script>` tags
- NO external fonts, CDNs, or dependencies
- NO images — use CSS shapes, borders, and Unicode characters for visual elements
- File should work when opened directly with `open learnings_dashboard.html`

### Code Quality
- Semantic HTML5 (`<article>`, `<section>`, `<header>`, `<details>`, `<summary>`)
- Accessible: proper ARIA labels, keyboard navigation, sufficient color contrast
- Performant: no heavy DOM manipulation, CSS transitions over JS animations
- Clean, readable code (this file may be inspected by the user)

---

## Step 4: Verify and Report

After writing the file:
1. Confirm the file was written: "Dashboard generated at `learnings_dashboard.html`"
2. Report stats: "X sessions, Y learnings, Z unique tags visualized"
3. If any parsing issues were encountered (malformed sections, missing dates), note them

---

## Rules
- NEVER modify the source learnings file — this skill is read-only on the input
- Always overwrite `learnings_dashboard.html` (it's a generated artifact, not hand-edited)
- If the learnings file has no `## Session:` sections (e.g., only the big-picture sections from first-run), generate the dashboard with whatever content exists — don't fail on missing sessions
- The dashboard must look good with 1 session or 50 sessions
- Tag colors must be deterministic — same tag always produces the same color
