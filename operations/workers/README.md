# Workers

## Worker: Inbox Scanner
- **Cron:** Every 30 min
- **Action:** Scan Gmail, extract tasks
- **Output:** TASKS.md entries

## Worker: Heartbeat Scanner
- **Cron:** Hourly
- **Action:** Scan for overdue/deadline items
- **Output:** core/active.md updates

## Worker: EOD Review
- **Cron:** 9:00 PM daily
- **Action:** Generate EOD summary
- **Output:** EOD Review

## Worker: Morning Briefing
- **Cron:** 6:30 AM daily
- **Action:** Generate daily briefing
- **Output:** Briefing text

## Worker: Weekly Review
- **Cron:** Mon 9:00 AM
- **Action:** Generate weekly summary
- **Output:** Weekly Review

## Worker Constraint
- Max 3 concurrent workers
- Timeout: 180s per worker
- Failure threshold: 3 before safe mode

