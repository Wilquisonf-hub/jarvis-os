# WORKER_REGISTRY.md — Marquinhos Workers

*Canonical worker definitions. Workers are ephemeral, stateless, task-scoped, and auto-terminate after execution.*

---

## Division: SEO / Content

| Worker | Model | Responsibility |
|--------|-------|----------------|
| seo-analyst | qwen3.6 30b | Keyword research, competitive analysis, SEO audits, performance tracking |
| content-strategist | qwen3.6 30b | Content planning, editorial calendar, topic clusters, search intent mapping |
| content-writer | qwen3.6 30b | Article writing, blog posts, SEO copy, AI-optimized content |

---

## Division: Creative Operations

| Worker | Model | Responsibility |
|--------|-------|----------------|
| creative-director | qwen3.6 30b | Campaign visual strategy, creative briefing, style direction, platform adaptation, messaging consistency, asset planning, conversion-focused creative planning |
| image-generation | gemma4 | Higgsfield image orchestration, batch generations, model comparison, blog illustrations, thumbnails, marketplace graphics, product visuals, social creatives |
| video-generation | qwen3.6 30b | Video concepts, short-form content planning, Higgsfield video orchestration, motion creative prompts, ad creative generation |
| presentation-builder | qwen3.6 30b | PDF generation, sales quotations, PowerPoint structures, dashboards, executive reports, A4 proposals, pitch decks, analytics presentations |
| brand-compliance | gemma4 | Enforce brand consistency, validate colors, validate typography, maintain visual identity, verify logo usage, validate presentation consistency |

---

## Worker Model Rules

- Workers are **ephemeral** — created per task, destroyed after completion
- Workers are **stateless** — no persistent cognition outside orchestration
- Workers do **NOT own decisions** — they execute, report, and dissolve
- Workers operate under Marquinhos authority for growth domain
- Workers can be directed by Marquinhos for task execution
- Workers escalate to Jarvis for operational coordination issues
- Workers escalate to USER for growth decisions that require human input

---

*Workers are operational mechanisms. Not agents. Not persistent.*
