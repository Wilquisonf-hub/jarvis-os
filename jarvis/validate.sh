#!/bin/bash
# validate.sh — Structural integrity check for Jarvis OS
# Run this to verify the workspace is in a valid state

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check() {
  if eval "$2" >/dev/null 2>&1; then
    echo -e "  ${GREEN}✅${NC} $1"
  else
    echo -e "  ${RED}❌${NC} $1"
    ERRORS=$((ERRORS + 1))
  fi
}

warn() {
  echo -e "  ${YELLOW}⚠️${NC} $1"
  WARNINGS=$((WARNINGS + 1))
}

echo "═══════════════════════════════════════"
echo "  Jarvis OS — Structural Validation"
echo "═══════════════════════════════════════"
echo ""

echo "━━━ Identity Symlinks ━━━"
for f in SOUL.md AGENTS.md USER.md MEMORY.md IDENTITY.md RULES.md OPERATIONS.md TEAM.md PROJECTS.md SCHEDULE.md; do
  check "$f symlink exists" "[ -f $f ]"
  check "$f resolves correctly" "readlink -f $f | grep -q 'jarvis-os/identity'"
done

echo ""
echo "━━━ Topology ━━━"
check "topology/AGENT_REGISTRY.md exists" "[ -f topology/AGENT_REGISTRY.md ]"
check "topology/SYSTEM_TOPOLOGY.md exists" "[ -f topology/SYSTEM_TOPOLOGY.md ]"
check "topology/README.md exists" "[ -f topology/README.md ]"

echo ""
echo "━━━ Operations ━━━"
check "operations/PRIORITY_RULES.md exists" "[ -f operations/PRIORITY_RULES.md ]"
check "operations/STATE_MACHINE.md exists" "[ -f operations/STATE_MACHINE.md ]"
check "operations/README.md exists" "[ -f operations/README.md ]"

echo ""
echo "━━━ Bootstrap ━━━"
check "bootstrap/STARTUP_CONTEXT.md exists" "[ -f bootstrap/STARTUP_CONTEXT.md ]"
check "bootstrap/BOOTSTRAP.md removed" "[ ! -f bootstrap/BOOTSTRAP.md ]"

echo ""
echo "━━━ Config Files ━━━"
check ".gitignore exists" "[ -f .gitignore ]"
check ".env.example exists" "[ -f .env.example ]"
check ".env exists" "[ -f .env ]"

echo ""
echo "━━━ jarvis-os Sync ━━━"
check "jarvis-os submodule exists" "[ -d jarvis-os ]"
check "AGENTS.md in sync" "diff AGENTS.md jarvis-os/identity/AGENTS.md >/dev/null 2>&1"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo -e "  ${GREEN}✅ All checks passed${NC}"
elif [ $ERRORS -eq 0 ]; then
  echo -e "  ${YELLOW}⚠️${NC} Passed with $WARNINGS warning(s)"
else
  echo -e "  ${RED}❌ $ERRORS error(s), $WARNINGS warning(s)${NC}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit $ERRORS
