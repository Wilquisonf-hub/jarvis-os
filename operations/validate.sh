#!/bin/bash
# validate.sh — Validate system integrity
# Usage: bash operations/validate.sh

echo "🔍 Validating JARVIS OS integrity..."
echo ""

ERRORS=0

# Check directory structure
REQUIRED_DIRS=(
    "core"
    "identity"
    "operations/logs"
    "operations/backups"
    "operations/snapshots"
    "operations/recovery"
    "operations/staging"
    "operations/production"
    "operations/heartbeats"
    "operations/queues"
    "operations/workers"
    "operations/state"
    "operations/audit"
    "operations/templates"
    "projects"
    "tasks"
    "memory/daily"
    "memory/summaries"
    "reports"
    "agents"
    "skills"
    "workflows"
    "config"
    "bootstrap"
    "deployment"
    "docs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Missing directory: $dir"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ $dir"
    fi
done

# Check identity files (copied to jarvis-os/identity/)
IDENTITY_FILES=(
    "identity/SOUL.md"
    "identity/AGENTS.md"
    "identity/IDENTITY.md"
    "identity/USER.md"
)

for file in "${IDENTITY_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  Missing identity file: $file"
    else
        echo "✅ Identity file: $file"
    fi
done

# Check core files
CORE_FILES=(
    "core/active.md"
    "core/priority.md"
    "core/heartbeat.md"
    "operations/safe_mode.md"
    "operations/RECOVERY.md"
    "bootstrap/BOOTSTRAP.md"
    "deployment/DEPLOYMENT.md"
)

for file in "${CORE_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing core file: $file"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ Core file: $file"
    fi
done

# Check backup exists
BACKUP_COUNT=$(ls -1 operations/backups/ 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -eq 0 ]; then
    echo "⚠️  No backups found"
else
    echo "✅ Backups found: $BACKUP_COUNT"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ System integrity: OK"
else
    echo "❌ System integrity: $ERRORS errors found"
fi
