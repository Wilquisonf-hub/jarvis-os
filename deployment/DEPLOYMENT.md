# DEPLOYMENT.md — JARVIS OS Deployment Guide

## Overview

JARVIS OS uses a staging → production model for all operational changes. This ensures safe, auditable deployments.

## Deployment Model

```
operations/staging/  ← Working files
        ↓ (validate + deploy)
operations/production/  ← Active files
        ↓ (backup)
operations/backups/  ← Archived copies
```

## Deployment Steps

### 1. Create Staging File
Write your changes to `operations/staging/<filename>.md`

### 2. Validate
```bash
bash operations/validate.sh
```
Ensure all integrity checks pass.

### 3. Deploy
```bash
bash operations/deploy.sh operations/staging/<filename>.md
```
This promotes the file to production.

### 4. Verify
Check that the file was correctly deployed:
```bash
cat operations/production/<filename>.md
```

### 5. Log
The deployment is automatically logged to `operations/logs/change.log`.

### 6. Backup
Create a backup after deployment:
```bash
bash operations/backup.sh
```

## Emergency Rollback

If a deployment causes issues:

### Option 1: Restore from Backup
```bash
# Find latest backup
ls operations/backups/

# Restore
cp operations/backups/<backup>/operations/production/* operations/production/
```

### Option 2: Git Rollback
```bash
git checkout HEAD~1 -- <file>
```

### Option 3: Recovery Process
1. Check `operations/RECOVERY.md`
2. Follow recovery sequence
3. Verify integrity

## Deployment Checklist

- [ ] Staging file created
- [ ] Validation passed
- [ ] Deploy command executed
- [ ] Deployment verified
- [ ] Change.log updated
- [ ] Backup created
- [ ] Identity files NOT touched
- [ ] Safe mode rules verified

## What Can Be Deployed

| File Type | Can Deploy | Safety Level |
|-----------|-----------|-------------|
| TASKS.md | Yes | Medium |
| PROJECTS.md | Yes | Medium |
| SCHEDULE.md | Yes | Medium |
| TEAM.md | Yes | Medium |
| core/active.md | Yes | Low |
| core/priority.md | Yes | Low |
| core/heartbeat.md | Yes | Low |
| SOUL.md | **NEVER** | N/A |
| AGENTS.md | **NEVER** | N/A |
| IDENTITY.md | **NEVER** | N/A |
| USER.md | **NEVER** | N/A |

---

*Deployment — controlled, safe, auditable*
