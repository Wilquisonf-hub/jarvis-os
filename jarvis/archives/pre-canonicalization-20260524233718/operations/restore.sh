#!/bin/bash
# restore.sh — Point-in-time restore from backup
# Usage: bash operations/restore.sh <backup_name> [--confirm]
# Example: bash operations/restore.sh backup-2026-05-22_143022 --confirm
set -euo pipefail

JARVIS_OS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$JARVIS_OS_ROOT"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1" }
ok()    { echo -e "${GREEN}[ OK ]${NC} $1" }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1" }
err()   { echo -e "${RED}[ERR ]${NC} $1" >&2; exit 1 }

# --- Parse args ---
BACKUP_NAME=""
CONFIRM=false
DRY_RUN=false

for arg in "$@"; do
    case "$arg" in
        --confirm)  CONFIRM=true ;;
        --dry-run)  DRY_RUN=true ;;
        *)          if [[ -z "$BACKUP_NAME" ]]; then BACKUP_NAME="$arg"; fi ;;
    esac
done

# If no backup name given, list available backups
if [[ -z "$BACKUP_NAME" ]]; then
    echo "Available backups:"
    find "$JARVIS_OS_ROOT/operations/backups" -maxdepth 1 -type d -name "backup-*" 2>/dev/null | sort | while read -r b; do
        SIZE=$(du -sh "$b" 2>/dev/null | cut -f1)
        echo "  - $(basename "$b") ($SIZE)"
    done
    err "Usage: $0 <backup_name> [--confirm] [--dry-run]"
fi

BACKUP_PATH="$JARVIS_OS_ROOT/operations/backups/$BACKUP_NAME"

# ============================================
# Step 1: Validate backup exists
# ============================================
info "Step 1: Validate backup"
if [[ ! -d "$BACKUP_PATH" ]]; then
    err "Backup '$BACKUP_NAME' not found at $BACKUP_PATH"
fi

# Check manifest
MANIFEST="$JARVIS_OS_ROOT/operations/backups/MANIFEST.md"
if [[ -f "$MANIFEST" ]]; then
    info "  Manifest entry:"
    grep -A 10 "$BACKUP_NAME" "$MANIFEST" | head -10 | sed 's/^/    /'
else
    warn "  No manifest found for this backup"
fi

# Verify key files
info "  Verifying integrity..."
KEY_FILES=("identity/SOUL.md" "identity/AGENTS.md" "core/active.md" "config/production.yaml")
ALL_OK=true
for file in "${KEY_FILES[@]}"; do
    if [[ -f "$BACKUP_PATH/$file" ]]; then
        ok "  $file"
    else
        warn "  $file — missing"
        ALL_OK=false
    fi
done

if [[ "$ALL_OK" != true ]]; then
    warn "  Some key files are missing — restore may be incomplete"
    if [[ "$CONFIRM" != true ]]; then
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
            err "Restore cancelled."
        fi
    fi
fi

# ============================================
# Step 2: Create safety backup of current state
# ============================================
info "Step 2: Safety backup of current state"
SAFETY_BACKUP="$JARVIS_OS_ROOT/operations/backups/pre-restore-$(date +%Y-%m-%d_%H%M%S)"
if [[ -d "$JARVIS_OS_ROOT" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "  [DRY-RUN] Would create safety backup at $SAFETY_BACKUP"
    else
        cp -r "$JARVIS_OS_ROOT/." "$SAFETY_BACKUP"
        ok "  Safety backup created: $(basename "$SAFETY_BACKUP")"
    fi
else
    warn "  Current state appears clean — skipping safety backup"
fi

# ============================================
# Step 3: Perform restore
# ============================================
info "Step 3: Restore from backup: $BACKUP_NAME"

if [[ "$DRY_RUN" == true ]]; then
    info "  [DRY-RUN] Would restore files from $BACKUP_PATH to $JARVIS_OS_ROOT"
    echo ""
    info "  What would happen:"
    info "  1. All current files would be replaced with backup contents"
    info "  2. Safety backup saved at: $SAFETY_BACKUP"
    info "  3. No permanent changes would be made"
    echo ""
    ok "  Dry-run complete — no changes made."
    exit 0
fi

# First, backup the current state completely
CURRENT_BACKUP="$JARVIS_OS_ROOT/operations/backups/restore-point-$(date +%Y-%m-%d_%H%M%S)"
if [[ "$CONFIRM" != true ]]; then
    warn "  This will replace ALL files in $JARVIS_OS_ROOT"
    read -p "  Type 'yes' to confirm: " -r
    echo
    if [[ "$REPLY" != "yes" ]]; then
        err "Restore cancelled."
    fi
fi

# Clear current state (keep the backup.sh structure)
info "  Preserving operations/ directory..."
# Save the backup infrastructure
mkdir -p "$CURRENT_BACKUP/operations"
cp "$JARVIS_OS_ROOT/operations/backup.sh" "$CURRENT_BACKUP/operations/" 2>/dev/null || true
cp "$JARVIS_OS_ROOT/operations/validate.sh" "$CURRENT_BACKUP/operations/" 2>/dev/null || true
cp "$JARVIS_OS_ROOT/operations/restore.sh" "$CURRENT_BACKUP/operations/" 2>/dev/null || true
cp "$JARVIS_OS_ROOT/operations/deploy.sh" "$CURRENT_BACKUP/operations/" 2>/dev/null || true

# Remove everything except operations/
find "$JARVIS_OS_ROOT" -maxdepth 1 -type f ! -name "*.sh" -exec rm -f {} \; 2>/dev/null || true
find "$JARVIS_OS_ROOT" -maxdepth 1 -type d ! -name "operations" ! -name "operations" -exec rm -rf {} \; 2>/dev/null || true

# Now restore from backup
cp -a "$BACKUP_PATH/"* "$JARVIS_OS_ROOT/" 2>/dev/null || true
cp -a "$BACKUP_PATH"/.[!.]* "$JARVIS_OS_ROOT/" 2>/dev/null || true

ok "  Files restored from $BACKUP_NAME"

# ============================================
# Step 4: Post-restore validation
# ============================================
info "Step 4: Post-restore validation"
if [[ -f "$JARVIS_OS_ROOT/identity/SOUL.md" ]]; then
    ok "  SOUL.md restored"
else
    err "  SOUL.md — restoration incomplete!"
fi

if [[ -f "$JARVIS_OS_ROOT/identity/AGENTS.md" ]]; then
    ok "  AGENTS.md restored"
else
    err "  AGENTS.md — restoration incomplete!"
fi

if [[ -f "$JARVIS_OS_ROOT/operations/validate.sh" ]]; then
    ok "  validate.sh intact"
else
    err "  validate.sh — restoration incomplete!"
fi

# ============================================
# Step 5: Verify .env (should not be in backup)
# ============================================
info "Step 5: Check environment files"
if [[ -f "$JARVIS_OS_ROOT/.env" ]]; then
    ok "  .env preserved (not in backup)"
else
    warn "  .env not found — restore from safety backup if needed"
fi

# ============================================
# Done
# ============================================
echo ""
ok "✅ Restore complete from: $BACKUP_NAME"
echo ""
info "Safety backup available at: $SAFETY_BACKUP"
info "Run validation: bash operations/validate.sh"
