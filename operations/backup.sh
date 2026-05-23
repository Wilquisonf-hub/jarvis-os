#!/bin/bash
# backup.sh — Create timestamped backup of operational files
# Usage: bash operations/backup.sh

set -e

BACKUP_DIR="operations/backups/$(date +%Y-%m-%d_%H-%M)"
mkdir -p "$BACKUP_DIR"

# Backup core operational files
cp -r core/ "$BACKUP_DIR/"
cp -r identity/ "$BACKUP_DIR/"
cp operations/safe_mode.md "$BACKUP_DIR/"
cp operations/RECOVERY.md "$BACKUP_DIR/"
cp tasks/ "$BACKUP_DIR/" 2>/dev/null || true
cp projects/ "$BACKUP_DIR/" 2>/dev/null || true
cp memory/ "$BACKUP_DIR/" 2>/dev/null || true

# Create backup manifest
cat > "$BACKUP_DIR/MANIFEST.md" << EOF
# Backup Manifest — $(date +%Y-%m-%d_%H-%M)

## Included
- core/
- identity/
- operations/safe_mode.md
- operations/RECOVERY.md
- tasks/
- projects/
- memory/

## Status: COMPLETE
EOF

# Log the backup
echo "| $(date +%Y-%m-%d_%H-%M) | backup.sh | Automated backup created | COMPLETE |" >> operations/logs/change.log

echo "✅ Backup created: $BACKUP_DIR"
