# Operational Scripts

## Available Scripts

### backup.sh
Create timestamped backup of all operational files.
```bash
bash operations/backup.sh
```

### deploy.sh
Promote staging files to production.
```bash
bash operations/deploy.sh <source-file>
```

### validate.sh
Validate system integrity.
```bash
bash operations/validate.sh
```

### heartbeat.sh
Run heartbeat scan.
```bash
bash operations/heartbeat.sh
```

## Script Registry

| Script | Location | Purpose |
|--------|----------|---------|
| backup.sh | operations/ | Create backups |
| deploy.sh | operations/ | Stage → prod |
| validate.sh | operations/ | Integrity check |
| heartbeat.sh | operations/ | Heartbeat scan |

---

*Operational scripts — automation is the goal, safety is the prerequisite*
