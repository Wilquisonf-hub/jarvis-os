#!/bin/bash
# backup.sh — Timestamped snapshots with integrity verification
# Usage: bash operations/backup.sh [--full] [--incremental] [--verify]
set -euo pipefail

JARVIS_OS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$JARVIS_OS_ROOT"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
BLUE='\033[0;34m'

info()  { echo -e "${BLUE}[INFO]${NC} $1" }
ok()    { echo -e "${GREEN}[ OK ]${NC} $1" }
err()   { echo -e "${RED}[ERR ]${NC} $1" >&2; exit 1 }

# --- Parse args ---
FULL=false
INCREMENTAL=false
VERIFY=false
SKIP_MANIFEST=false

for arg in "$@"; do
    case "$arg" in
        --full)        FULL=true ;;
        --incremental) INCREMENTAL=true ;;
        --verify)      VERIFY=true ;;
        --skip-manifest) SKIP_MANIFEST=true ;;
    esac
done

# ============================================
# Configuration
# ============================================
BACKUP_DIR="$JARVIS_OS_ROOT/operations/backups"
DATE_STAMP=$(date +%Y-%m-%d_%H%M%S)
BACKUP_NAME="backup-$DATE_STAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"
MANIFEST_FILE="$BACKUP_DIR/MANIFEST.md"

# Files to exclude from backup
EXCLUDE_PATTERNS=(
    ".git/" "node_modules/" "dist/" "build/" "*.log" "*.tmp" "*.pid"
    "*.wal" "*.shm" "*.journal" ".DS_Store" "Thumbs.db" "*.bak"
    "operations/backups/*" ".env.local" ".env.*.local" "*.credentials"
    ".secrets" "workspace-state.json" "state/*" "logs/*"
)

# ============================================
# Step 1: Ensure backup directory exists
# ============================================
info "Step 1: Prepare backup directory"
mkdir -p "$BACKUP_DIR"
ok "  $BACKUP_DIR"

# ============================================
# Step 2: Create backup snapshot
# ============================================
info "Step 2: Create snapshot: $BACKUP_NAME"

if [[ "$FULL" == true ]]; then
    info "  Mode: Full backup"
    cp -r "$JARVIS_OS_ROOT/." "$BACKUP_PATH"
else
    if [[ "$INCREMENTAL" == true ]]; then
        info "  Mode: Incremental backup"
        # Find latest existing backup for diff
        LATEST_BACKUP=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "backup-*" | sort | tail -1)
        if [[ -n "$LATEST_BACKUP" ]]; then
            rsync -a --delete \
                --exclude=".git" \
                --exclude="operations/backups/*" \
                "$LATEST_BACKUP/" "$BACKUP_PATH/" 2>/dev/null || \
            cp -r "$JARVIS_OS_ROOT/." "$BACKUP_PATH"
        else
            cp -r "$JARVIS_OS_ROOT/." "$BACKUP_PATH"
        fi
    else
        info "  Mode: Full backup (default)"
        cp -r "$JARVIS_OS_ROOT/." "$BACKUP_PATH"
    fi
fi

# Clean up .git inside backup
if [[ -d "$BACKUP_PATH/.git" ]]; then
    rm -rf "$BACKUP_PATH/.git"
fi

# Remove excluded files
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    find "$BACKUP_PATH" -name "${pattern##*\*}" -type f 2>/dev/null | xargs rm -f 2>/dev/null || true
done

ok "  Snapshot created at: $BACKUP_PATH"

# ============================================
# Step 3: Integrity verification (optional)
# ============================================
if [[ "$VERIFY" == true ]]; then
    info "Step 3: Verify backup integrity"
    
    # Count files
    FILE_COUNT=$(find "$BACKUP_PATH" -type f 2>/dev/null | wc -l | tr -d ' ')
    ok "  File count: $FILE_COUNT"
    
    # Check key files exist
    KEY_FILES=(
        "identity/SOUL.md" "identity/AGENTS.md" "core/active.md"
        "operations/validate.sh" "operations/backup.sh" "config/production.yaml"
    )
    
    for file in "${KEY_FILES[@]}"; do
        if [[ -f "$BACKUP_PATH/$file" ]]; then
            ok "  $file"
        else
            err "  $file — missing from backup!"
        fi
    done
    
    # Create checksums
    CHECKSUM_FILE="$BACKUP_PATH/checksums.md5"
    find "$BACKUP_PATH" -type f -exec md5sum {} \; > "$CHECKSUM_FILE" 2>/dev/null || true
    ok "  Checksums saved to: $CHECKSUM_FILE"
fi

# ============================================
# Step 4: Update manifest
# ============================================
if [[ "$SKIP_MANIFEST" != true ]]; then
    info "Step 4: Update backup manifest"
    
    # Create manifest if it doesn't exist
    if [[ ! -f "$MANIFEST_FILE" ]]; then
        cat > "$MANIFEST_FILE" << 'EOF'
# 📦 Jarvis OS Backup Manifest
## Backups for jarvis-os/ — auto-generated
EOF
    fi
    
    # Get backup size
    BACKUP_SIZE=$(du -sh "$BACKUP_PATH" 2>/dev/null | cut -f1)
    BACKUP_FILE_COUNT=$(find "$BACKUP_PATH" -type f 2>/dev/null | wc -l | tr -d ' ')
    BACKUP_DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Append to manifest
    cat >> "$MANIFEST_FILE" << EOF

## $BACKUP_NAME
- **Timestamp:** $BACKUP_DATE
- **Size:** $BACKUP_SIZE
- **Files:** $BACKUP_FILE_COUNT
- **Source:** $JARVIS_OS_ROOT
- **Verified:** $VERIFY
- **Type:** $(if [[ "$FULL" == true ]]; then echo "full"; elif [[ "$INCREMENTAL" == true ]]; then echo "incremental"; else echo "full"; fi)
EOF
    
    ok "  Manifest updated"
fi

# ============================================
# Step 5: Rotate old backups (keep last 10)
# ============================================
info "Step 5: Backup rotation"
BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "backup-*" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$BACKUP_COUNT" -gt 10 ]]; then
    REMOVE_COUNT=$((BACKUP_COUNT - 10))
    OLD_BACKUPS=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "backup-*" | sort | head -$REMOVE_COUNT)
    info "  Removing $REMOVE_COUNT old backup(s)..."
    echo "$OLD_BACKUPS" | while read -r old_backup; do
        info "  - $(basename "$old_backup")"
        rm -rf "$old_backup"
    done
    ok "  Rotation complete (keeping last 10)"
fi

# ============================================
# Done
# ============================================
echo ""
ok "✅ Backup complete: $BACKUP_NAME ($BACKUP_SIZE)"
echo ""
info "To restore: bash operations/restore.sh $BACKUP_NAME"
info "Manifest: $MANIFEST_FILE"
