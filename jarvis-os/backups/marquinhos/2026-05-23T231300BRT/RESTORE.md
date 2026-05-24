# RESTORE.md — Marquinhos Recovery Procedure

## Snapshot ID
`2026-05-23T23:13:00BRT`

## Location
`/Users/wilquison/jarvis-os/backups/marquinhos/2026-05-23T231300BRT/full-snapshot/`

## Full Restore Procedure

### Step 1: Stop Current Marquinhos
1. Close any active sessions with Marquinhos
2. Stop any running heartbeat processes

### Step 2: Backup Current State
```bash
# Backup current marquinhos workspace BEFORE restore
cp -r /Users/wilquison/marquinhos /Users/wilquison/marquinhos.pre-restore-$(date +%Y%m%d%H%M%S)
```

### Step 3: Restore from Snapshot
```bash
# Remove current workspace
rm -rf /Users/wilquison/marquinhos

# Restore from backup
cp -r /Users/wilquison/jarvis-os/backups/marquinhos/2026-05-23T231300BRT/full-snapshot/marquinhos /Users/wilquison/marquinhos
```

### Step 4: Verify Restore
```bash
# Verify all files are present
ls -la /Users/wilquison/marquinhos/

# Verify key files
ls -la /Users/wilquison/marquinhos/SOUL.md
ls -la /Users/wilquison/marquinhos/AGENTS.md
ls -la /Users/wilquison/marquinhos/gsc-client-secret.json
```

### Step 5: Restart Marquinhos
1. Open OpenClaw workspace
2. Select agent "marquinhos"
3. Verify SOUL.md is loaded correctly
4. Verify worker definitions are present
5. Check heartbeat system is active
6. Run initial heartbeat to confirm operation

## Partial Restore

If only specific files need restoration:

```bash
# Restore a single file
cp /Users/wilquison/jarvis-os/backups/marquinhos/2026-05-23T231300BRT/full-snapshot/marquinhos/SOUL.md /Users/wilquison/marquinhos/SOUL.md
```

## Verification Checklist

- [ ] SOUL.md loaded correctly
- [ ] AGENTS.md has all worker definitions
- [ ] OPERATIONS.md shows correct current state
- [ ] RULES.md has all operating rules
- [ ] HEARTBEAT.md has correct schedule
- [ ] TASKS.md has task registry
- [ ] Competitors.md has competitor data
- [ ] CONTENT_PIPELINE.md has content pipeline
- [ ] gsc-client-secret.json is present and valid
- [ ] All templates are present
- [ ] All workflows are intact
- [ ] Heartbeat system is operational
- [ ] Worker system is functional
- [ ] No data loss occurred

## Rollback Procedure

If restore fails:

```bash
# Restore pre-restore backup
cp -r /Users/wilquison/marquinhos.pre-restore-YYYYMMDDHHMMSS /Users/wilquison/marquinhos
```

## Notes

- This snapshot captures the complete state of Marquinhos as of 2026-05-23T23:13:00BRT
- All operational data, configs, and system files are included
- Worker definitions, heartbeat schedules, and task registry are preserved
- GSC API credentials are included (ensure secure handling)
- Restore procedure tested and verified
