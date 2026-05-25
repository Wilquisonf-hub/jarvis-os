# Heartbeat Definitions

## Heartbeat Cycles

### Morning Briefing
- **Schedule:** 6:30 AM America/Sao_Paulo daily
- **Trigger:** Cron job `morning-briefing`
- **Actions:**
  1. Scan inbox for actionable items
  2. Check TASKS.md for today's deadlines
  3. Check HEARTBEAT.md for carryovers
  4. Generate Daily Briefing
  5. Update core/heartbeat.md

### Heartbeat Scan
- **Schedule:** Hourly (operational-heartbeat)
- **Trigger:** Cron job `operational-heartbeat`
- **Actions:**
  1. Scan for overdue tasks (2d+, 1d+, today)
  2. Check for blocked tasks
  3. Check for high-priority items
  4. Update core/active.md
  5. Update core/heartbeat.md
  6. Log to operations/logs/change.log

### EOD Review
- **Schedule:** 9:00 PM America/Sao_Paulo daily
- **Trigger:** Cron job `end-of-day-review`
- **Actions:**
  1. Scan completed vs pending tasks
  2. Identify carryovers
  3. Generate EOD Review
  4. Update core/active.md

### Weekly Review
- **Schedule:** Monday 9:00 AM America/Sao_Paulo
- **Trigger:** Cron job `weekly-ops-review`
- **Actions:**
  1. Review team bottlenecks
  2. Review delegation effectiveness
  3. Review priority rules effectiveness
  4. Generate Weekly Review
  5. Update core/priority.md if needed

### Gmail Scan
- **Schedule:** Every 30 minutes
- **Trigger:** Cron job `inbox-triage`
- **Actions:**
  1. Scan inbox for actionable items
  2. Filter for noise (newsletters, marketing)
  3. Extract tasks, deadlines, blockers
  4. Update TASKS.md if new items found
  5. Update core/active.md inbox_count

## Heartbeat Output

Each heartbeat generates:
1. Update to `core/active.md` (operational state)
2. Update to `core/heartbeat.md` (scan state)
3. Entry in `operations/logs/change.log`
4. Carryover detection
5. Deadline alerts

## Safety Rules

- Heartbeat scans are **read-only** for tasks
- Only inbox scan creates new tasks
- Never overwrite SOUL.md, AGENTS.md
- Never auto-escalate without human confirmation
- Resource limit: max 3 concurrent heartbeat actions
