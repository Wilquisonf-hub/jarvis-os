# Workflow Definitions

## What is a Workflow?

A workflow is a repeatable operational sequence that may involve multiple steps, files, or agents. Workflows are **not** cron jobs — they're manual or event-triggered sequences.

## Defined Workflows

### 1. New Task Intake
**Trigger:** Human reports new task or inbox scan finds actionable item
**Steps:**
1. Add to TASKS.md with priority and status
2. Add to memory/daily/ if today's date
3. Notify human if priority is URGENT or HIGH
**Output:** Task in TASKS.md, daily memory updated

### 2. Task Completion
**Trigger:** Human reports task completed or status update
**Steps:**
1. Update TASKS.md status to COMPLETED
2. Add to memory/daily/ completed tasks
3. Update core/active.md carryover_count
**Output:** TASKS.md updated, memory updated

### 3. Staging to Production
**Trigger:** Human triggers deploy or heartbeat promotes file
**Steps:**
1. Validate staging file
2. Copy to operations/production/
3. Update core/heartbeat.md
**Output:** Production file updated

### 4. Backup + Snapshot
**Trigger:** Scheduled cron or human request
**Steps:**
1. Run backup.sh
2. Compress snapshot to operations/snapshots/
3. Update change.log
**Output:** Backup in operations/backups/, snapshot in operations/snapshots/

### 5. Recovery
**Trigger:** File corruption, identity loss, or manual trigger
**Steps:**
1. Check RECOVERY.md
2. Restore from latest backup
3. Verify integrity
4. Resume operations
**Output:** System restored to last known good state

### 6. Daily Briefing
**Trigger:** 6:30 AM cron
**Steps:**
1. Read TASKS.md for today's deadlines
2. Read HEARTBEAT.md for carryovers
3. Read core/active.md for blockers
4. Generate briefing text
5. Update memory/daily/BRIEFING.md
**Output:** Daily Briefing ready for human

### 7. EOD Review
**Trigger:** 9:00 PM cron
**Steps:**
1. Scan TASKS.md for COMPLETED tasks
2. Scan TASKS.md for overdue carryovers
3. Generate EOD Review
4. Update core/active.md
**Output:** EOD Review ready for human

### 8. Weekly Ops Review
**Trigger:** Monday 9:00 AM cron
**Steps:**
1. Review TEAM.md bottlenecks
2. Review TASKS.md completion rate
3. Review priority rules effectiveness
4. Generate Weekly Review
**Output:** Weekly Review ready for human

## Workflow Registry

| Workflow | Trigger | Steps | Output |
|----------|---------|-------|--------|
| New Task Intake | Event | 3 steps | Task in TASKS.md |
| Task Completion | Event | 3 steps | TASKS.md updated |
| Staging → Prod | Manual | 3 steps | Prod file updated |
| Backup + Snapshot | Cron/Manual | 3 steps | Backup + snapshot |
| Recovery | Event | 4 steps | System restored |
| Daily Briefing | Cron (6:30 AM) | 5 steps | Briefing text |
| EOD Review | Cron (9:00 PM) | 4 steps | EOD Review text |
| Weekly Review | Cron (Mon 9:00 AM) | 4 steps | Weekly Review text |

---

*Workflows — automation through repeatability*
