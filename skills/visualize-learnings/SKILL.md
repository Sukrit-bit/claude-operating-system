---
name: visualize-learnings
description: Generate a magazine-quality interactive HTML page from the project's learnings file, using the visual-explainer design system
---

Transform a project's learnings file into a visually rich, editorially-designed HTML page. Not a data dashboard — a visual explanation of what was learned, designed to the same quality bar as the `/visual-explainer` skill.

This skill can be invoked standalone or is called by the `/learnings` skill as Part C.

---

## Step 1: Locate and Read

1. Look for `learnings_for_Sukrit.md` in the current project root
2. If not found, ask the user which file to visualize
3. Read the entire file
4. Also read the visual-explainer's design references before generating:
   - `~/.claude/skills/visual-explainer/references/css-patterns.md` — layout, depth tiers, animations, responsive patterns
   - `~/.claude/skills/visual-explainer/references/libraries.md` — font pairings, Mermaid theming, Chart.js, anime.js

---

## Step 2: Parse the Data

Extract from the learnings file:

- **Overview sections:** Big Picture, How the Codebase is Structured, Technologies Used (if present — first-run format)
- **Sessions:** Each `## Session:` block (date, topic, "What We Did" summary, individual learnings)
- **Learnings:** Each `####` heading within a session (title + body text)
- **Tags:** If the file contains `Tags:` lines, extract them. If not, infer tags from content keywords
- **Bugs and debugging stories:** Extract any bug-related content for the bug gallery
- **Patterns and principles:** Extract any engineering principles or recurring patterns

Count: total sessions, total learnings, total unique tags, tags by frequency.

---

## Step 3: Choose Aesthetic Direction

**Do not default to dark theme with blue accents.** Pick a direction that fits the project's personality:

**Preferred for learnings:**
- **Editorial** — Serif headlines (Instrument Serif or Crimson Pro), generous whitespace, muted earth tones or deep navy + gold. Feels like a well-designed journal.
- **Paper/ink** — Warm cream `#faf7f5` background, terracotta/sage accents, informal feel. Feels like handwritten notes elevated to print quality.

**Also acceptable:**
- **Blueprint** — Technical drawing feel, subtle grid background, deep slate/blue, monospace labels. Good for highly technical projects.
- **IDE-inspired** — Use a specific named palette (Catppuccin, Rosé Pine, Gruvbox, Nord). Must commit to the actual palette.

**Forbidden:**
- Neon dashboard (cyan + magenta + purple on dark)
- Inter/Roboto with violet/indigo accents
- Gradient text on headings
- Animated glowing box-shadows

**Vary the choice.** If this project already has a visual-explainer output in a particular aesthetic, pick a different one.

---

## Step 4: Generate the HTML Page

Write a single self-contained HTML file to `learnings_dashboard.html` in the project root.

### Design System Requirements

**Typography:** Pick a distinctive font pairing. Load via Google Fonts CDN with system font fallback.

Good pairings for learnings:
- Instrument Serif + JetBrains Mono (editorial, refined)
- IBM Plex Sans + IBM Plex Mono (reliable, readable)
- Bricolage Grotesque + Fragment Mono (bold, characterful)
- DM Sans + Fira Code (technical, precise)

**Forbidden as body font:** Inter, Roboto, Arial, Helvetica, system-ui alone.

**Color:** Use CSS custom properties for the full palette. Define: `--bg`, `--surface`, `--border`, `--text`, `--text-dim`, and 3-5 accent colors with dim variants. Support both light and dark via `prefers-color-scheme`.

Good palettes: terracotta + sage, deep blue + gold, teal + slate, rose + cranberry.

**Depth hierarchy:** Use four surface tiers:
- **Hero** (elevated + accent-tinted) — for the project overview and key stats
- **Elevated** (shadow) — for session cards
- **Default** (flat) — for standard content
- **Recessed** (inset) — for code blocks and secondary detail

**Backgrounds:** Never flat solid. Use subtle gradients, faint grid patterns, or gentle radial glows.

**Animation:** Staggered fade-ins on load. Mix types: `fadeUp` for cards, `fadeScale` for stats, `countUp` for numbers. Respect `prefers-reduced-motion`. No glowing, pulsing, or breathing effects.

### Required Page Sections

**1. Hero Section** (hero depth)
- Project name, large and prominent
- A one-line description of what this project is (from Big Picture section)
- Key stats as large hero numbers: total sessions, total learnings, total unique tags
- Last updated date
- This section should dominate the viewport on load

**2. Project Overview** (elevated depth, collapsible via `<details>`)
- Big Picture content — what the project is and why it matters
- Architecture/structure visualization — if the learnings file describes the codebase structure, render it as a visual (CSS Grid cards or Mermaid diagram, not raw code block)
- Technologies used — as a card grid, not a bulleted list

**3. Tag Landscape** (default depth)
- Visual tag frequency display — horizontal bars or a weighted tag cloud
- Each tag is clickable to filter the timeline
- Tags use deterministic colors from the chosen palette (hash tag name to select)
- Show clear filter state and count

**4. Session Timeline** (the main body)
- Cards in reverse chronological order (newest first)
- Each card uses elevated depth with a left accent border
- Card contents:
  - **Date** as a styled monospace label with colored dot indicator
  - **Topic** as a prominent heading
  - **Summary** — always visible, well-typeset
  - **Learnings** — each as a collapsible `<details>/<summary>` element
    - Title as the toggle header
    - Body text with proper prose formatting (paragraph spacing, inline code styling)
  - **Tag pills** at the bottom — styled with the tag's deterministic color
- Vary visual weight: the most recent session card can be slightly more prominent

**5. Bug Gallery** (if bugs/debugging content exists)
- Extract bug stories from learnings into a dedicated section
- Each bug as a card with: what happened, root cause, fix
- Visual severity/type indicators (styled spans, not emoji)
- This section makes bugs scannable separate from the timeline

**6. Patterns and Principles** (if engineering principles exist)
- Extract repeated themes, principles, and patterns
- Present as a card grid with short titles and descriptions
- These are the cross-cutting insights, not session-specific

**7. Search/Filter Bar** (sticky, above the timeline)
- Text input that filters across all sections by keyword
- Real-time filtering with debounce
- Show match count

### Technical Requirements

- Single self-contained `.html` file
- CSS in `<style>` tags, JS in `<script>` tags
- Google Fonts via CDN `<link>` (with system font fallback)
- Optional: Mermaid via ESM CDN for architecture diagrams
- Optional: anime.js via CDN for entrance animations (10+ elements)
- Semantic HTML5 (`<article>`, `<section>`, `<header>`, `<details>`, `<summary>`)
- Both light and dark theme support via `prefers-color-scheme`
- Responsive layout — readable on mobile
- No overflow on any viewport width
- Use safe DOM methods (createElement, textContent) — avoid innerHTML with dynamic data

---

## Step 5: Quality Checks

Before delivering, verify against these gates:

1. **The squint test** — Blur your eyes. Can you perceive hierarchy? Are sections visually distinct?
2. **The swap test** — Would replacing fonts and colors with a generic dark theme make it indistinguishable from a template? If yes, push the aesthetic further.
3. **Both themes** — Toggle OS between light and dark. Both must look intentional.
4. **Information completeness** — Does it capture all sessions and learnings from the source file?
5. **No overflow** — Resize browser. No clipping or escaping.
6. **The slop test** — Would a developer think "AI generated this"? Check for:
   - Inter/Roboto with violet gradient accents
   - Gradient text on every heading
   - Emoji icons in section headers
   - Glowing animated cards
   - Perfectly uniform card grid with no hierarchy
   - If 2+ present, regenerate with a constrained aesthetic

---

## Step 6: Deliver and Report

1. Write to `learnings_dashboard.html` in the project root
2. Open in browser: `open learnings_dashboard.html`
3. Report: "Dashboard generated — X sessions, Y learnings, Z tags visualized"
4. Note any parsing issues (malformed sections, missing dates)

---

## Rules

- NEVER modify the source learnings file — read-only on input
- Always overwrite `learnings_dashboard.html` (generated artifact)
- If the learnings file has no `## Session:` sections, generate with whatever content exists
- Must look good with 1 session or 50 sessions
- Tag colors must be deterministic — same tag always produces the same color
- Sections 5 and 6 (Bug Gallery, Patterns) are optional — only include if the content exists
- The output should feel like opening a well-designed magazine, not a developer tool
