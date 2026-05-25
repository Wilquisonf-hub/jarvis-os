# MEMORY.md - Long-Term Context

## Architecture

### Single-Agent Operational Core (2026-05-21)
- No subagents, no recursive agents, no autonomous swarms
- Lightweight cron jobs for heartbeat/inbox/reviews
- SQLite relational memory (`memory/ops/tasks.db`)
- Human-readable markdown files as source of truth
- Event-driven execution only
- Stability over autonomy

### Cron Jobs
- `morning-briefing` — 6:30am daily (Daily Briefing)
- `operational-heartbeat` — hourly (overdue/deadline scan)
- `inbox-triage` — every 30min (Gmail scan)
- `end-of-day-review` — 9pm daily (EOD Review)
- `weekly-ops-review` — Monday 9am (Weekly Review)

### Operational Memory
- `memory/ops/tasks.db` — SQLite tasks, contacts, events
- `memory/ops/tasks.sh` — CLI: list/status/overdue/today/followups/by/close/add/notes
- `memory/ontology/` — legacy, keep but do not expand
- `memory/YYYY-MM-DD.md` — daily logs
- `HEARTBEAT.md` — auto-updated status

## Projects
[Track active projects, their status, key contacts, next steps]

## People
[Contacts, vendors, clients, employees — who they are, what they handle, patterns]

## Business Priorities
[Current strategic focus areas, active initiatives]

## Recurring Tasks
[Patterns that repeat — daily checks, weekly reviews, monthly deadlines]

## Frequently Delayed
[People, tasks, or patterns that keep slipping. Call them out.]

## Work Habits
[User's schedule patterns, preferences, productivity peaks, communication style]

## Operational Patterns
[What works, what doesn't, lessons learned from past operations]

## Key Dates
[Deadlines, milestones, recurring important dates]

## Security Configuration

### gog Safety Profile (ACTIVE)
- `/opt/homebrew/bin/gog` is replaced with a safety-wrapped script that:
- Original binary at: `/opt/homebrew/Cellar/gogcli/0.15.0/bin/gog.original`
- Full docs: `/Users/wilquison/jarvis/gog-safety-profiles/README.md`

### Tools

Skills provide your tools. When you need one, check its `SKILL.md`. Keep local notes in `TOOLS.md`.

### gog Safety Profile (ACTIVE)
- `/opt/homebrew/bin/gog` is replaced with a safety-wrapped script that:
- Original binary at: `/opt/homebrew/Cellar/gogcli/0.15.0/bin/gog.original`
- Full docs: `/Users/wilquison/jarvis/gog-safety-profiles/README.md`

# TOOLS.md - Local Notes
Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.
