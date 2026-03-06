---
name: visualize-learnings
description: Generate a Learning Studio — a concept-first, visually rich HTML page that teaches technical concepts from a project's learnings file. Uses architecture diagrams, synthesized deep dives, retrieval practice, and the visual-explainer design system.
---

Transform a project's learnings file into a **Learning Studio** — a single HTML page designed to help you internalize technical concepts in 1-2 hours. Not a knowledge repository. Not a prettified markdown dump. A learning experience with synthesized knowledge, visual diagrams, and active recall.

This skill can be invoked standalone or is called by the `/learnings` skill as Part C.

**Core principle:** Organize by concept, not by session. Sessions are when you learned something. Concepts are what you learned. The "what" is infinitely more useful than the "when."

---

## Step 1: Locate and Read

1. Look for `learnings_for_Sukrit.md` in the current project root
2. If not found, ask the user which file to visualize
3. Read the entire file
4. Also read the visual-explainer's design references before generating:
   - `~/.claude/skills/visual-explainer/references/css-patterns.md` — layout, depth tiers, animations, overflow protection
   - `~/.claude/skills/visual-explainer/references/libraries.md` — font pairings, Mermaid theming, Chart.js, anime.js
   - `~/.claude/skills/visual-explainer/references/responsive-nav.md` — sidebar nav with scroll-spy

---

## Step 2: Parse the Data

Extract from the learnings file:

- **Overview sections:** Big Picture, How the Codebase is Structured, Technologies Used, LLM Pipeline, Email Design (whatever intro sections exist)
- **Sessions:** Each `## Session:` block (date, topic, summary, individual learnings)
- **Learnings:** Each `####` heading within a session (title + body text + code examples)
- **Tags:** Extract from `Tags:` lines. If absent, infer from content keywords
- **Bugs and debugging stories:** Extract bug-related content (look for "bug", "broke", "failed", "root cause", "fix")
- **Code examples:** Preserve code blocks — these are critical for deep dives
- **Patterns and principles:** Extract engineering principles, rules, and recurring patterns

Count: total sessions, total learnings, total unique tags, tags by frequency.

---

## Step 3: Cluster Learnings by Concept

**This is the critical step that transforms a repository into a learning tool.**

Group individual learnings into **concept clusters** — domains of related knowledge. Do NOT organize by session.

### How to cluster:

1. **Tag co-occurrence:** Learnings sharing 2+ tags likely belong to the same cluster
2. **Content similarity:** Learnings about the same system, API, or pattern cluster together
3. **Causal chains:** If learning A explains why learning B matters, they cluster together

### Target: 4-7 clusters per project

Too few = too broad to learn from. Too many = feels like a bulleted list again.

### Example clusters (from a data pipeline project):
- **API Integration & Rate Limiting** — YouTube API, retry patterns, fallback strategies, silent failures
- **Pipeline Architecture** — idempotency, resume-safety, status management, multi-source aggregation
- **LLM & Prompt Engineering** — prompt design, context engineering, specification patterns, output control
- **Email & Frontend Delivery** — HTML email constraints, visual hierarchy, CSS limitations, client compatibility
- **Process & Meta-Engineering** — session management, documentation patterns, checklists, context budgets

### For each cluster, determine:
- **Cluster name** — a clear, memorable domain label (2-4 words)
- **Member learnings** — which learnings belong (a learning can appear in multiple clusters if it bridges domains)
- **Key patterns** — the 2-4 most important transferable patterns in this cluster
- **Failure cases** — what breaks when you get this wrong
- **Related clusters** — which other clusters connect to this one and why

---

## Step 4: Synthesize Knowledge

For each cluster, **synthesize** — do not list. Write original explanatory content:

### a. TL;DR (2-3 sentences)
Not "here are 5 learnings about rate limiting." Instead: "Rate limiting is the default state of every external API you'll use. The critical insight is distinguishing silent failures (API returns None) from explicit errors (API throws). Your defense: status codes that differentiate 'no data exists' from 'failed to fetch', plus exponential backoff with jitter."

### b. Architecture/Pattern Diagram
Design a Mermaid diagram for each cluster. Pick the right diagram type:
- **Flowchart** — for processes, pipelines, decision trees
- **State machine** — for retry/backoff/failure patterns
- **Sequence diagram** — for API interaction patterns
- **ER diagram** — for data model relationships
- **Mind map** — for concept relationships within a cluster

The diagram must teach. Label edges with WHY, not just WHAT. Show the failure paths, not just the happy path.

### c. Retrieval Practice Questions (2-3 per cluster)
Generate questions from the actual failures and patterns. These must be:
- **Specific** — reference actual systems, APIs, or patterns from the project
- **Causal** — ask WHY something happens, not just WHAT
- **Failure-grounded** — "What goes wrong if you don't..."

Example: "Your transcript API returns None instead of raising RateLimitError. What's the downstream impact, and how should your status model handle this?"

Answers are in collapsible `<details>` elements.

---

## Step 5: Extract Architecture

From the learnings file's overview sections (Big Picture, Codebase Structure, Technologies Used, LLM Pipeline), generate:

1. **System architecture diagram** — Mermaid flowchart showing components, data flow, external APIs, and storage. Annotate key decision points with WHY that architecture was chosen.

2. **Subsystem detail** — If the file describes a specific subsystem in depth (e.g., an LLM pipeline, an email delivery chain), generate a focused diagram for it.

3. **Technology map** — Visual grid of technologies used, grouped by layer (frontend, backend, APIs, infrastructure).

If the learnings file has no overview sections, skip the Architecture Gallery and note this in the output.

---

## Step 6: Choose Aesthetic Direction

**Editorial** is the default for Learning Studios — it signals "this is a place for serious learning."

**Typography:** Instrument Serif + JetBrains Mono (refined, editorial, textbook feel)
**Palette:** Deep blue + gold (`#1e3a5f` + `#d4a73a`) — premium, sophisticated
**Both light and dark themes** via `prefers-color-scheme`

**Depth hierarchy:**
- **Hero** (elevated + accent-tinted) — project overview and growth stats
- **Elevated** (shadow) — deep dive cards, architecture gallery
- **Default** (flat) — concept map, principles wall
- **Recessed** (inset) — bug museum, session journal, code blocks

**Forbidden:** Neon dashboards, Inter/Roboto, violet/indigo accents, gradient text, animated glowing shadows, emoji in headers. See visual-explainer anti-slop rules.

**Vary the choice** if the project already has a visual-explainer output in this aesthetic.

---

## Step 7: Generate the HTML Page

Write a single self-contained HTML file to `learnings_dashboard.html` in the project root.

### Page Structure — THE Information Hierarchy

```
[1. Hero — 5% of attention, growth stats]
     ↓
[2. Concept Map — 30%, THE navigation hub, Mermaid diagram]
     ↓
[3. Deep Dives — 40%, where learning happens, one per cluster]
     ↓
[4. Architecture Gallery — 10%] [5. Bug Museum — 10%] [6. Principles Wall — 5%]
     ↓
[7. Session Journal — appendix, collapsed, 0% unless specifically needed]
```

Filters and search are NOT the top-level navigation. A **sticky sidebar** with concept map domains serves as the nav, with scroll-spy highlighting.

### Section Specifications

**1. Hero: "Your Technical Growth"** (hero depth)
- Project name, large and prominent
- One-line description (from Big Picture)
- 3 stat cards: concepts mastered (= cluster count), bugs conquered (= bug count), sessions completed
- Growth sparkline — SVG showing learning distribution over time (which weeks had the most learnings)
- Two CTAs: "Explore the Concept Map" (scrolls to §2) / "Test Your Knowledge" (scrolls to first retrieval practice)

**2. Concept Map** (default depth — THE primary view)
- Mermaid diagram showing all concept clusters as nodes
- Node size or visual weight proportional to number of learnings in the cluster
- Edges connecting related clusters, labeled with the relationship (e.g., "failures feed into", "depends on", "pattern shared with")
- Each node is clickable — scrolls to its Deep Dive section
- Mermaid zoom controls required (+/−/reset, Ctrl+scroll, click-drag pan)
- Use `flowchart TD` layout. Apply custom `themeVariables` matching the page palette.
- Surround with a brief intro: "These are the technical domains you've developed expertise in across [N] sessions."

**3. Deep Dives** (elevated depth — one card per concept cluster)
Each cluster gets a self-contained `<article>` with:

- **Cluster heading** — large, memorable name with learning count badge
- **TL;DR** — 2-3 sentence synthesis (from Step 4a). Styled as a lead paragraph.
- **Pattern Diagram** — Mermaid diagram for this cluster (from Step 4b). With zoom controls.
- **Key Patterns** — 2-4 pattern cards, each with:
  - Pattern name as a short rule ("Always distinguish 'no data' from 'fetch failed'")
  - 1-2 sentence explanation
  - Code example if available (from the learnings file, in a recessed code block)
  - "When to apply" — one line
- **Failure Cases** — What breaks when you get this wrong. Red/warm-bordered cards with:
  - What happened (1 sentence)
  - Root cause (1 sentence)
  - Prevention pattern (1 sentence)
- **Connected Concepts** — Clickable links to related deep dive sections with relationship label
- **Retrieval Practice** — 2-3 questions in `<details>/<summary>` elements. Summary shows the question, details reveal the answer. Style the toggle distinctively (e.g., a "?" icon or "Test yourself" label).

**4. Architecture Gallery** (elevated depth)
- System architecture diagram (from Step 5). Full-width Mermaid with zoom controls.
- Subsystem diagrams if applicable
- Technology grid — CSS Grid cards grouped by layer, not a bulleted list
- Each diagram annotated with key decision text below it
- Skip this section entirely if the learnings file has no overview/structure sections

**5. Bug Museum** (recessed depth)
- Organized by **bug class** (not by session):
  - Silent Failures
  - Status Mismatches
  - Data Drift / Staleness
  - Configuration Errors
  - (whatever classes emerge from the data)
- Each bug: compact card with What → Why → Fix → Prevent
- Visual class indicators (colored left border per class)
- Link to the relevant Deep Dive section

**6. Principles Wall** (default depth)
- Cross-cutting principles extracted from all learnings
- Card grid (2-3 columns), each principle is:
  - A short memorable rule (1 sentence)
  - One line of context (where you learned this)
- These should be insights you can internalize in 10 seconds each
- Examples: "Checklists scale, vigilance doesn't" / "Defense in depth: validate at every layer boundary"

**7. Session Journal** (recessed depth — APPENDIX)
- **Collapsed by default** via `<details>/<summary>`
- Labeled clearly: "Reference Archive — Session-by-Session Log"
- Each session expandable: date, topic, summary, individual learnings
- This is for reference lookup, not primary consumption
- Reverse chronological order

### Sidebar Navigation
- Sticky left sidebar on desktop (collapses to horizontal bar on mobile)
- Lists: Hero / Concept Map / each Deep Dive cluster name / Architecture / Bug Museum / Principles / Sessions
- Scroll-spy highlighting — active section highlighted as you scroll
- Follows the responsive-nav.md pattern from visual-explainer references

### Technical Requirements
- Single self-contained `.html` file
- CSS in `<style>` tags, JS in `<script>` tags
- Google Fonts via CDN `<link>` (with system font fallback)
- Mermaid via ESM CDN — REQUIRED (not optional — concept map and deep dive diagrams need it)
- Optional: anime.js via CDN for entrance animations (10+ elements)
- Optional: Chart.js for growth sparkline (or use inline SVG)
- Semantic HTML5 (`<article>`, `<section>`, `<nav>`, `<details>`, `<summary>`)
- Both light and dark theme support via `prefers-color-scheme`
- Responsive layout — readable on mobile
- No overflow on any viewport width
- Safe DOM methods (createElement, textContent) — avoid innerHTML with dynamic data
- Mermaid: always `theme: 'base'` with custom `themeVariables`. Never define `.node` as a page-level CSS class.

---

## Step 8: Quality Checks

Before delivering, verify against these gates:

1. **The learning test** — Could someone spend 1-2 hours with this page and walk away understanding the project's technical architecture, key patterns, and common pitfalls? If the answer is "they'd need to read the markdown file too," the page has failed.
2. **The concept test** — Is the primary organization by concept, not by session? Is the concept map the first thing after the hero? Are deep dives synthesized explanations, not lists of session learnings?
3. **The diagram test** — Are there at least N+1 Mermaid diagrams (1 concept map + 1 per deep dive)? Do they teach, not just decorate?
4. **The retrieval test** — Are there specific, causal questions per cluster? Could a reader test themselves?
5. **The hierarchy test** — Squint at the page. Can you see the information hierarchy? Is the concept map prominent? Is the session journal clearly an appendix?
6. **The squint test** — Blur eyes. Sections visually distinct? Depth tiers evident?
7. **The swap test** — Replace fonts/colors with a generic dark theme. Still distinguishable from a template?
8. **Both themes** — Toggle OS light/dark. Both look intentional?
9. **No overflow** — Resize browser. No clipping or escaping.
10. **The slop test** — Inter/Roboto with violet accents? Gradient text on headings? Emoji icons? Glowing cards? Uniform card grid? If 2+ present, regenerate.

---

## Step 9: Deliver and Report

1. Write to `learnings_dashboard.html` in the project root
2. Open in browser: `open learnings_dashboard.html`
3. Report:
   ```
   Learning Studio generated:
   - [N] concept clusters: [list cluster names]
   - [N] architecture diagrams
   - [N] retrieval practice questions
   - [N] bug entries in museum
   - [N] principles extracted
   - [N] sessions in reference archive
   ```
4. Note any parsing issues or sections skipped due to insufficient data

---

## Rules

- NEVER modify the source learnings file — read-only on input
- Always overwrite `learnings_dashboard.html` (generated artifact, gitignored)
- The concept map and deep dives are the CORE of the page. Everything else is supporting.
- Diagrams are mandatory, not optional. If a cluster has no natural diagram, use a mind map showing concept relationships.
- Retrieval questions must be specific to THIS project's learnings. Generic textbook questions are a failure.
- Session journal is an APPENDIX — collapsed by default, at the bottom, visually recessed. Never the primary content.
- Tag filters are NOT top-level navigation. They are a secondary tool within sections, if included at all.
- Must work with 1 session or 50 sessions. With few sessions, clusters may be small — that's fine.
- Synthesis means original explanatory text, not copy-pasted learning entries. The deep dive TL;DRs should read like a knowledgeable person explaining the topic, not like a list of bullet points reformatted.
- Code examples from the learnings file are valuable — preserve and feature them in the relevant deep dive's Key Patterns section.
