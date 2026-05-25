# Safe Mode Rules

## When Safe Mode Activates

Safe mode activates automatically when:
1. Cron jobs failing repeatedly (3+ failures in a row)
2. System detects instability in operational files
3. Unusual file activity (deletion, corruption, unexpected modifications)
4. Resource limit breach (too many concurrent operations)
5. Human triggers `/jarvis-os safe-mode`

## Safe Mode Behavior

1. **Stop all automation** — no cron jobs, no inbox scans, no heartbeat
2. **Alert the human** — brief notification of what triggered safe mode
3. **Protect identity files** — lock SOUL.md, AGENTS.md, IDENTITY.md, USER.md
4. **Preserve state** — snapshot current state before any action
5. **Wait for human** — don't resume until human confirms

## Safe Mode Commands

| Command | Action |
|---------|--------|
| `/jarvis-os safe-mode` | Enter safe mode |
| `/jarvis-os safe-mode exit` | Exit safe mode (human only) |
| `/jarvis-os safe-mode status` | Check safe mode status |

## Resource Limits (Always Active)

| Resource | Limit |
|----------|-------|
| Cron job concurrency | 3 max |
| Inbox scan interval | 15min minimum |
| Heartbeat scan interval | 10min minimum |
| Task mutations per scan | 0 (read-only) |
| File writes per operation | 10 max |
| Subagent spawns per hour | 0 (disabled) |
| Cron job timeout | 180s |
| Cron job failure threshold | 3 before alert |

## Alert Conditions

- 3+ consecutive cron failures → alert
- Identity file modified → alert + safe mode
- Recovery files missing → alert
- Backup older than 24h → alert

---

*Safe mode — your safety net*
