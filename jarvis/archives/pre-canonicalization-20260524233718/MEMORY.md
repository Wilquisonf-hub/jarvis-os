# MEMORY.md - Long-Term Context

## Contact Info

- **Telegram personal ID:** 1347641552

## Architecture

### Jarvis OS v2 — 7-Phase Infrastructure (2026-05-24)
- **7-phase deterministic architecture:** bootstrap, deterministic mount, topology, directory restructuring, validation, identity boundaries, cron hold
- Full jarvis-os submodule at `jarvis-os/` with identity, operations, deployment, config
- Root workspace merged with all structural directories (bootstrap, topology, operations, queue, scripts, etc.)
- SQLite relational memory (`memory/ops/tasks.db`)
- Human-readable markdown files as source of truth
- Event-driven execution only
- Stability over autonomy

### Cron Jobs (HELD — 2026-05-22)
**STATUS: PAUSED** — jarvis-os v2 7-phase refactor in progress. Cron jobs will resume after Phase 7 completion and root workspace merge.
- `morning-briefing` — 6:30am daily (Daily Briefing) ⏸ HELD
- `operational-heartbeat` — hourly (overdue/deadline scan) ⏸ HELD
- `inbox-triage` — every 30min (Gmail scan) ⏸ HELD
- `end-of-day-review` — 9pm daily (EOD Review) ⏸ HELD
- `weekly-ops-review` — Monday 9am (Weekly Review) ⏸ HELD

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
