# Recovery Guide

## Recovery Priority

### Level 1: Full Restore (catastrophic)
1. Check REPOSITORY for git rollback
2. Check latest backup in `operations/backups/`
3. Restore all files from backup
4. Verify identity files (SOUL.md, AGENTS.md, IDENTITY.md)
5. Re-enable cron jobs
6. Resume operations

### Level 2: Partial Restore (partial corruption)
1. Identify corrupted files
2. Find latest valid backup for those files
3. Restore selectively
4. Verify system integrity

### Level 3: Identity Recovery (personality loss)
1. Restore from `identity/recovery/` copies
2. Verify SOUL.md matches original
3. Verify AGENTS.md matches original
4. Resume operations

## Recovery Scripts

```bash
# Full recovery
bash operations/recovery/full-restore.sh

# Selective recovery
bash operations/recovery/partial-restore.sh <file>

# Identity recovery
bash operations/recovery/identity-recovery.sh
```

## Verification Checklist

- [ ] All identity files match original
- [ ] All operational files present
- [ ] Cron jobs restored
- [ ] Task database intact
- [ ] Inbox scan functional
- [ ] Heartbeat functional

---

*Last updated: 2026-05-22*
