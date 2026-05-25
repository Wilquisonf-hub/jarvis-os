# Core Runtime Files

These files are read on every agent turn. They define the operational state.

## Required Files

### active.md
Current operational context. Updated after each heartbeat scan.

Fields:
- `scan`: last scan timestamp
- `inbox_count`: unread actionable items
- `carryover_count`: pending carryovers
- `deadline_count`: deadlines within 24h
- `critical`: list of critical blockers
- `next_action`: next recommended action

### priority.md
Task and message prioritization rules.

Fields:
- `rules`: prioritization rules (one per line)
- `examples`: example scenarios and their priority
- `escalation`: escalation path

### heartbeat.md
Current heartbeat state.

Fields:
- `last_scan`: timestamp
- `status`: OK | WARNING | CRITICAL
- `issues`: list of detected issues
- `actions_taken`: what was done this cycle

## Read Order

1. active.md — current state
2. priority.md — how to prioritize
3. heartbeat.md — what changed

## Safety

- These files are **read-only** during normal operation
- Only written by: heartbeat cron, manual override, or recovery process
- Never auto-delete or truncate

---

*Core runtime files — keep lightweight*
