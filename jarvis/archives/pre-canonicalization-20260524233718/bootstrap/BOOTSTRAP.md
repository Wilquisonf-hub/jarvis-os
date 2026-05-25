# BOOTSTRAP.md — JARVIS OS First Run

## Instructions for First Run

When you read this file, JARVIS OS is being set up for the first time. Follow these steps in order.

### Step 1: Verify Backup Exists
```bash
ls operations/backups/2026-05-22/
```
If no backup exists, the system has not been backed up. Stop and request backup.

### Step 2: Verify Filesystem Structure
```bash
bash operations/validate.sh
```
All directories and core files must show ✅. Fix any ❌ before continuing.

### Step 3: Verify Identity Files
Ensure the following files exist and match originals:
- SOUL.md — personality, tone, behavior
- AGENTS.md — workspace rules
- IDENTITY.md — identity metadata
- USER.md — about the human

### Step 4: Initialize Core State
Create or verify these files exist:
- core/active.md — current operational state
- core/priority.md — prioritization rules
- core/heartbeat.md — heartbeat state

### Step 5: Connect Operational Files
Copy or link these files into operations/production/:
- TASKS.md → operations/production/TASKS.md
- PROJECTS.md → operations/production/PROJECTS.md
- SCHEDULE.md → operations/production/SCHEDULE.md
- TEAM.md → operations/production/TEAM.md

### Step 6: Set Up Cron Jobs
Verify these cron jobs are configured:
- morning-briefing (6:30 AM daily)
- operational-heartbeat (hourly)
- inbox-triage (every 30min)
- end-of-day-review (9:00 PM daily)
- weekly-ops-review (Monday 9:00 AM)

### Step 7: Final Validation
```bash
bash operations/validate.sh
```
All checks pass? JARVIS OS is ready.

### Step 8: Resume Normal Operations
- Read SOUL.md, AGENTS.md, IDENTITY.md
- Follow AGENTS.md startup protocol
- Begin normal operations

## Verification Checklist

- [ ] Backup exists (Phase 0)
- [ ] Filesystem structure valid (Phase 1)
- [ ] Identity files intact
- [ ] Core state files present
- [ ] Operational files connected
- [ ] Cron jobs configured
- [ ] All validation checks pass

## If Something Is Wrong

1. **Backup exists:** Restore from `operations/backups/2026-05-22/`
2. **Identity files corrupted:** Restore from `identity/recovery/` copies
3. **System unstable:** Enter safe mode, alert human
4. **Cron jobs missing:** Request cron setup assistance

---

*JARVIS OS Bootstrap — when you read this, you're building the foundation*
