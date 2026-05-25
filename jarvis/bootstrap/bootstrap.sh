#!/bin/bash
# bootstrap.sh — Initialize Jarvis OS on a new server
# Usage: ./bootstrap.sh [--dry-run]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JARVIS_OS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Helpers ---
info()  { echo -e "${BLUE}[INFO]${NC} $1" }
ok()    { echo -e "${GREEN}[ OK ]${NC} $1" }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1" }
err()   { echo -e "${RED}[ERR ]${NC} $1" >&2; exit 1 }

# --- Parse args ---
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    info "Running in dry-run mode"
fi

# ============================================
# Step 1: Verify we're in the right place
# ============================================
info "Step 1: Verify Jarvis OS root"
if [[ ! -d "$JARVIS_OS_ROOT/identity" ]]; then
    err "Not in a valid jarvis-os/ directory. Run this from inside jarvis-os/"
fi
ok "Jarvis OS root: $JARVIS_OS_ROOT"

# ============================================
# Step 2: Verify Git is initialized
# ============================================
info "Step 2: Verify Git initialization"
if [[ -d "$JARVIS_OS_ROOT/.git" ]]; then
    ok "Git repository already initialized"
else
    info "Initializing git repository..."
    if [[ "$DRY_RUN" == true ]]; then
        info "  [DRY-RUN] Would run: git init"
    else
        git init
        git config user.name "Jarvis OS"
        git config user.email "jarvis@local"
    fi
    ok "Git initialized"
fi

# ============================================
# Step 3: Verify required directories
# ============================================
info "Step 3: Verify required directories"
REQUIRED_DIRS=(
    "identity"
    "core"
    "operations"
    "agents"
    "config"
    "bootstrap"
    "deployment"
    "memory"
    "memory/daily"
    "memory/summaries"
    "tasks"
    "projects"
    "skills"
    "reports"
    "workflows"
)

ALL_DIRS_OK=true
for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ -d "$JARVIS_OS_ROOT/$dir" ]]; then
        ok "  $dir"
    else
        warn "  $dir — missing"
        ALL_DIRS_OK=false
    fi
done

if [[ "$ALL_DIRS_OK" == false ]]; then
    err "Missing required directories. Ensure jarvis-os/ structure is complete."
fi

# ============================================
# Step 4: Verify required files
# ============================================
info "Step 4: Verify required files"
REQUIRED_FILES=(
    "identity/SOUL.md"
    "identity/AGENTS.md"
    "identity/IDENTITY.md"
    "identity/USER.md"
    "core/active.md"
    "core/priority.md"
    "core/heartbeat.md"
    "operations/safe_mode.md"
    "config/production.yaml"
    "operations/validate.sh"
    "operations/backup.sh"
    "operations/restore.sh"
)

ALL_FILES_OK=true
for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$JARVIS_OS_ROOT/$file" ]]; then
        ok "  $file"
    else
        warn "  $file — missing"
        ALL_FILES_OK=false
    fi
done

if [[ "$ALL_FILES_OK" == false ]]; then
    err "Missing required files. Check jarvis-os/ structure."
fi

# ============================================
# Step 5: Verify secrets are excluded
# ============================================
info "Step 5: Verify secrets are excluded"
SECRETS_FOUND=0

# Check for common secret patterns in tracked files
SECRETS=$(grep -rn "gh_token\|API_KEY=\|password\s*=\|private_key\|-----BEGIN.*PRIVATE KEY" \
    "$JARVIS_OS_ROOT/" \
    --include="*.sh" --include="*.yaml" --include="*.md" --include="*.json" \
    2>/dev/null | grep -v "placeholder\|ENV_VAR\|YOUR_\|<your\|GITHUB_TOKEN\|gh auth" || true)

if [[ -n "$SECRETS" ]]; then
    warn "Potential secrets found — review before deploying:"
    echo "$SECRETS"
    SECRETS_FOUND=1
else
    ok "  No secrets found in tracked files"
fi

# ============================================
# Step 6: Verify environment variables
# ============================================
info "Step 6: Verify environment configuration"
if [[ -f "$JARVIS_OS_ROOT/.env" ]]; then
    ok "  .env file found"
    if [[ -f "$JARVIS_OS_ROOT/.env.example" ]]; then
        ok "  .env.example found — verify values match"
    else
        warn "  No .env.example found — create one for reference"
    fi
else
    warn "  No .env file found — create one from .env.example"
fi

# ============================================
# Step 7: Create deployment-ready state
# ============================================
info "Step 7: Prepare deployment state"
DEPLOYMENT_STATE="$JARVIS_OS_ROOT/operations/state/deploy-state.json"

if [[ "$DRY_RUN" == true ]]; then
    info "  [DRY-RUN] Would create deployment state"
else
    cat > "$DEPLOYMENT_STATE" << EOF
{
  "version": "0.1.0",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "initialized",
  "environment": "production",
  "git_root": "$JARVIS_OS_ROOT",
  "identity_files": ["SOUL.md", "AGENTS.md", "IDENTITY.md", "USER.md"],
  "required_dirs": [$(for dir in "${REQUIRED_DIRS[@]}"; do echo "\"$dir\","; done | sed 's/,$//')],
  "bootstrap_complete": true
}
EOF
    ok "  Deployment state created: $DEPLOYMENT_STATE"
fi

# ============================================
# Step 8: Run validation
# ============================================
info "Step 8: Run validation"
if [[ -f "$JARVIS_OS_ROOT/operations/validate.sh" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        info "  [DRY-RUN] Would run: bash operations/validate.sh"
    else
        bash "$JARVIS_OS_ROOT/operations/validate.sh"
    fi
else
    warn "  No validate.sh found"
fi

# ============================================
# Done
# ============================================
echo ""
if [[ "$DRY_RUN" == true ]]; then
    info "✅ Bootstrap dry-run complete. No changes made."
else
    ok "✅ Bootstrap complete. Jarvis OS is ready to deploy."
    echo ""
    info "Next steps:"
    echo "  1. Configure environment: cp .env.example .env  (if needed)"
    echo "  2. Deploy:            bash operations/deploy.sh"
    echo "  3. Verify:            bash operations/validate.sh"
    echo "  4. Backup:            bash operations/backup.sh"
fi
