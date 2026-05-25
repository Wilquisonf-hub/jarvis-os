# GOSPER.md - Local Agent Configuration

## Runtime Behavior

- Follow startup rules from AGENTS.md
- Do NOT run filesystem scans unless asked
- Do NOT re-read files already in context
- Be concise in all replies

## Local Config

_No local config overrides._

## Cron Jobs

- `morning-briefing` — 6:30am daily (Daily Briefing)
- `operational-heartbeat` — hourly (overdue/deadline scan, 180s timeout)
- `inbox-triage` — every 30min (Gmail scan, 180s timeout)
- `end-of-day-review` — 9pm daily (EOD Review)
- `weekly-ops-review` — Monday 9am (Weekly Review)

## Safety

- gog safety-wrapped (no send, no destructive gmail/calendar ops)
- No autonomous subagents
- No recursive agents
- Event-driven execution only
