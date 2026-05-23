# AGENTS.md - Your Workspace

This folder is home. Treat it that way.

## First Run

If `BOOTSTRAP.md` exists, that's your birth certificate. Follow it, figure out who you are, then delete it. You won't need it again.

## Session Startup

Use runtime-provided startup context first.

That context may already include:

- `AGENTS.md` (this file)
- `BOOTSTRAP.md` (if applicable)
- `HEARTBEAT.md` (periodic scan results)
- `GOSPER.md` (local config)
- `GOSPER/` (local config dir)

If `HEARTBEAT.md` is missing, skip heartbeat. No need to look for it.

To refresh heartbeat data, run:
```bash
python3 /Users/wilquison/jarvis/memory/ops/heartbeat.py
```

## Startup Rules

1. **Read the runtime context. That's your briefing.**
2. **Do NOT scan the filesystem.** Runtime context has everything you need.
3. **Do NOT run filesystem commands unless asked.** If you need something not in context, ask.
4. **Do NOT run startup commands unless asked.** Let the user control what runs.
5. **If `BOOTSTRAP.md` exists, execute it.** This is the one exception to rule 4.
6. **If the user says `!bootstrap`, also execute it.**
7. **Be concise.** If context says "no carryovers", acknowledge and move on. Don't re-read files nobody asked for.
8. **Your first reply should acknowledge context, not re-read.**

## Core Directories

| Directory | Purpose |
|---|-|
| `HEARTBEAT.md` | Periodic scan results (carryovers, deadlines, follow-ups) |
| `MEMORY.md` | Long-term context, architecture, operational knowledge |
| `memory/ops/tasks.db` | SQLite task database (migrated from TASKS.md) |
| `memory/ops/tasks.sh` | CLI for task management (list, overdue, by, close, etc) |
| `memory/ops/heartbeat.py` | Fresh heartbeat scan (runs `heartbeat.sh` logic in Python) |
| `GOSPER.md` | Local agent configuration |
| `GOSPER/` | Local config directory |
| `memory/` | Operational memory (markdown, relational) |
| `memory/ops/` | SQLite database, relational tasks/contacts/events |
| `memory/YYYY-MM-DD.md` | Daily logs |
| `scripts/` | Automation scripts |

## Tools

See `TOOLS.md` for tool-specific notes. Skills define _how_ tools work. `TOOLS.md` is for _your_ specifics.
