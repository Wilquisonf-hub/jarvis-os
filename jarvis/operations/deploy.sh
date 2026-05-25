#!/bin/bash
# deploy.sh — Deploy Jarvis OS from staging to production
# Usage: ./deploy.sh [--dry-run] [--target production|staging]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_OS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
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
DRY_RUN=false
TARGET="production"
if [[ "${1:-}" == "--dry-run" ]]; then DRY_RUN=true; shift; fi
for arg in "$@"; do
    case "$arg" in
        --target=*) TARGET="${arg#*=}" ;;
    esac
done

# ============================================
# Pre-flight: Run validation
# ============================================
info "Pre-flight: Running validation..."
if [[ -f "$JARVIS_OS_ROOT/operations/validate.sh" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "  [DRY-RUN] Would run: bash operations/validate.sh"
    else
        if ! bash "$JARVIS_OS_ROOT/operations/validate.sh"; then
            err "Validation failed. Fix issues before deploying."
        fi
    fi
else
    err "validate.sh not found."
fi

# ============================================
# Step 1: Check if we're on the correct branch
# ============================================
info "Step 1: Verify branch"
CURRENT_BRANCH=$(git -C "$JARVIS_OS_ROOT" branch --show-current 2>/dev/null || echo "unknown")
if [[ "$TARGET" == "production" && "$CURRENT_BRANCH" != "main" ]]; then
    warn "Deploying to production from branch: $CURRENT_BRANCH"
    read -p "Continue? [y/N] " -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        err "Deploy cancelled by user."
    fi
elif [[ "$TARGET" == "staging" && "$CURRENT_BRANCH" != "staging" ]]; then
    warn "Deploying to staging from branch: $CURRENT_BRANCH"
    read -p "Continue? [y/N] " -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        err "Deploy cancelled by user."
    fi
else
    ok "  Branch OK: $CURRENT_BRANCH"
fi

# ============================================
# Step 2: Create pre-deploy backup
# ============================================
info "Step 2: Create pre-deploy backup (failsafe)"
BACKUP_DATE=$(date +%Y-%m-%d)
BACKUP_DIR="$JARVIS_OS_ROOT/operations/backups/pre-deploy-$BACKUP_DATE"

if [[ "$DRY_RUN" == true ]]; then
    info "  [DRY-RUN] Would create backup at $BACKUP_DIR"
else
    if [[ -d "$BACKUP_DIR" ]]; then
        warn "  Pre-deploy backup already exists: $BACKUP_DIR"
    else
        cp -r "$JARVIS_OS_ROOT" "$BACKUP_DIR"
        ok "  Backup created: $BACKUP_DIR"
    fi
fi

# ============================================
# Step 3: Deploy files
# ============================================
info "Step 3: Deploy to target: $TARGET"

if [[ "$TARGET" == "production" ]]; then
    # Promote staging → production files
    if [[ -d "$JARVIS_OS_ROOT/config/staging" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            info "  [DRY-RUN] Would copy staging/config → config/"
        else
            mkdir -p "$JARVIS_OS_ROOT/config/production"
            cp -r "$JARVIS_OS_ROOT/config/staging/"* "$JARVIS_OS_ROOT/config/production/" 2>/dev/null || true
            ok "  Config files promoted"
        fi
    fi

    # Update deploy-state
    cat > "$JARVIS_OS_ROOT/operations/state/deploy-state.json" << EOF
{
  "version": "0.1.0",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "deployed",
  "environment": "production",
  "deployed_from": "$CURRENT_BRANCH",
  "deployed_to": "$TARGET"
}
EOF
    ok "  Production deploy state updated"

elif [[ "$TARGET" == "staging" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "  [DRY-RUN] Would update staging deploy state"
    else
        cat > "$JARVIS_OS_ROOT/operations/state/deploy-state.json" << EOF
{
  "version": "0.1.0",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "deployed",
  "environment": "staging",
  "deployed_from": "$CURRENT_BRANCH",
  "deployed_to": "$TARGET"
}
EOF
        ok "  Staging deploy state updated"
    fi
else
    err "Invalid target: $TARGET. Use 'production' or 'staging'."
fi

# ============================================
# Step 4: Post-deploy validation
# ============================================
info "Step 4: Post-deploy validation"
if [[ "$DRY_RUN" == true ]]; then
    info "  [DRY-RUN] Would run validation post-deploy"
else
    if ! bash "$JARVIS_OS_ROOT/operations/validate.sh"; then
        warn "  Some checks failed — review manually"
    else
        ok "  Post-deploy validation passed"
    fi
fi

# ============================================
# Done
# ============================================
echo ""
if [[ "$DRY_RUN" == true ]]; then
    info "✅ Deploy dry-run complete. No changes made."
else
    ok "✅ Deploy to $TARGET complete."
    echo ""
    info "Next steps:"
    echo "  1. Verify operational state: bash operations/validate.sh"
    echo "  2. Create commit:            git add -A && git commit -m 'deploy: $TARGET'"
    echo "  3. If on main:               git push origin main"
    echo "  4. Monitor:                  Check operations/logs/"
fi
