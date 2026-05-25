#!/usr/bin/env bash
# test-startup.sh — Deterministic startup cognition simulation
# Purpose: Verify startup file injection order, identity boundaries, hydration logic
# Behavior: Read-only validation, report findings, NEVER modify files
# Exit: 0 = clean, 1 = violations found

set -euo pipefail

WORKSPACE="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
ERRORS=0
WARNINGS=0
PASS=0
SKIP=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

log_pass() { PASS=$((PASS+1)); echo -e "${GREEN}✓ PASS${NC}: $1"; }
log_warn() { WARNINGS=$((WARNINGS+1)); echo -e "${YELLOW}⚠ WARN${NC}: $1"; }
log_error() { ERRORS=$((ERRORS+1)); echo -e "${RED}✗ VIOLATION${NC}: $1"; }
log_skip() { SKIP=$((SKIP+1)); echo -e "  ⊘ SKIP: $1"; }

echo -e "${BOLD}=== STARTUP COGNITION SIMULATION ===${NC}"
echo "Workspace: $WORKSPACE"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# --- TIER 1: Auto-injected files ---
echo -e "${BOLD}--- TIER 1: Auto-Injected Files (Core Context) ---${NC}"

TIER1_FILES=(
  "AGENTS.md"
  "SOUL.md"
  "TOOLS.md"
  "IDENTITY.md"
  "USER.md"
  "HEARTBEAT.md"
)

for f in "${TIER1_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    filesize=$(wc -c < "$filepath" 2>/dev/null || echo "0")
    # Check for identity contamination in Tier 1 files
    if grep -qiE 'USER.*=.*Jarvis|USER.*=.*Marquinhos|You are.*USER|your.*identity.*is.*USER' "$filepath" 2>/dev/null; then
      log_error "Tier 1 file '$f' contains identity contamination"
    else
      log_pass "Tier 1 file '$f' exists ($filesize bytes) — identity clean"
    fi
  else
    log_warn "Tier 1 file '$f' missing"
  fi
done

echo ""

# --- TIER 2: On-demand files ---
echo -e "${BOLD}--- TIER 2: On-Demand Files (Operational) ---${NC}"

TIER2_FILES=(
  "BOOT_SEQUENCE.md"
  "PRIORITY_RULES.md"
  "STATE_MACHINE.md"
  "WORKER_REGISTRY.md"
)

for f in "${TIER2_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    filesize=$(wc -c < "$filepath" 2>/dev/null || echo "0")
    log_pass "Tier 2 file '$f' exists (on-demand) ($filesize bytes)"
  else
    log_warn "Tier 2 file '$f' missing (may be acceptable)"
  fi
done

echo ""

# --- TIER 3: Workspace files ---
echo -e "${BOLD}--- TIER 3: Workspace Files (Full Context) ---${NC}"

TIER3_FILES=(
  "MEMORY.md"
  "ARCHITECTURE.md"
  "bootstrap/STARTUP_CONTEXT.md"
  "topology/SYSTEM_TOPOLOGY.md"
  "topology/AGENT_REGISTRY.md"
  "operations/RECOVERY.md"
  "rules/IDENTITY_RULES.md"
)

for f in "${TIER3_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    filesize=$(wc -c < "$filepath" 2>/dev/null || echo "0")
    log_pass "Tier 3 file '$f' exists (workspace) ($filesize bytes)"
  else
    log_warn "Tier 3 file '$f' missing"
  fi
done

echo ""

# --- HYDRATION ORDER VALIDATION ---
echo -e "${BOLD}--- Hydration Order Check ---${NC}"

# Verify startup context exists and defines tiers
if [ -f "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" ]; then
  if grep -qiE 'Tier.*1|tier.*1|auto.*inject' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "STARTUP_CONTEXT.md defines auto-injection tiers"
  else
    log_warn "STARTUP_CONTEXT.md may not explicitly define tiers"
  fi

  # Check for hydration order
  if grep -qiE 'Phase.*1|Phase.*2|Phase.*3|Phase.*4|startup.*order|hydration.*order' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "STARTUP_CONTEXT.md defines startup order"
  else
    log_warn "STARTUP_CONTEXT.md does not explicitly define startup order"
  fi
else
  log_error "STARTUP_CONTEXT.md missing — cannot validate hydration"
fi

# --- IDENTITY BOUNDARY POST-STARTUP ---
echo -e "${BOLD}--- Post-Startup Identity Boundaries ---${NC}"

# Simulate: after all Tier 1 files loaded, verify no identity collapse
identity_collapse=0

for f in "${TIER1_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    # Check for identity merge patterns
    if grep -qiE 'you are the.*user|user.*is.*you|your.*company|identify.*as.*user' "$filepath" 2>/dev/null; then
      log_error "Post-startup: '$f' merges agent identity with USER"
      identity_collapse=1
    fi
  fi
done

if [ $identity_collapse -eq 0 ]; then
  log_pass "Post-startup: No identity collapse detected in Tier 1 files"
fi

# Verify Jarvis does not assume USER identity
if [ -f "$WORKSPACE/IDENTITY.md" ]; then
  if grep -qiE 'I am the.*user|USER.*is.*me|my.*identity.*is.*user|represent.*the.*USER' "$WORKSPACE/IDENTITY.md" 2>/dev/null; then
    log_error "IDENTITY.md: Jarvis assumes USER identity"
  else
    log_pass "IDENTITY.md: Jarvis does not assume USER identity"
  fi
fi

# Verify Marquinhos remains subordinate
if [ -f "$WORKSPACE/AGENTS.md" ]; then
  if grep -qiE 'Marquinhos.*subordinate|subordinate.*Marquinhos' "$WORKSPACE/AGENTS.md" 2>/dev/null; then
    log_pass "AGENTS.md: Marquinhos remains subordinate"
  else
    log_warn "AGENTS.md does not explicitly define Marquinhos as subordinate"
  fi
fi

# --- WORKER STATELESSNESS POST-STARTUP ---
echo -e "${BOLD}--- Worker Model After Startup ---${NC}"

if [ -f "$WORKSPACE/operations/WORKER_REGISTRY.md" ]; then
  if grep -qiE 'stateless|ephemeral|no.*persistent.*state|task.scoped' "$WORKSPACE/operations/WORKER_REGISTRY.md" 2>/dev/null; then
    log_pass "Workers defined as stateless (post-startup)"
  else
    log_warn "Worker statelessness not confirmed post-startup"
  fi
else
  log_skip "WORKER_REGISTRY.md not found"
fi

# --- BOOTSTRAP BEHAVIOR ---
echo -e "${BOLD}--- Bootstrap File Integrity ---${NC}"

if [ -f "$WORKSPACE/bootstrap/BOOTSTRAP.md" ]; then
  log_error "BOOTSTRAP.md exists — should be deleted after first-run"
else
  log_pass "BOOTSTRAP.md does not exist (correct)"
fi

# --- STARTUP GOVERNANCE ---
echo -e "${BOLD}--- Startup Governance ---${NC}"

if [ -f "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" ]; then
  # Check for file-existence ≠ runtime-cognition rule
  if grep -qiE 'file.*exist.*not.*mean|exists.*workspace.*not.*runtime|runtime.*cognition|does.*not.*exist.*runtime' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "Startup governance explicitly defines workspace ≠ runtime"
  else
    log_warn "Startup governance may not explicitly define workspace ≠ runtime"
  fi

  # Check for identity separation
  if grep -qiE 'USER.*separate|separate.*USER|USER.*abstraction|abstraction.*USER' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "Startup governance defines USER abstraction"
  else
    log_warn "Startup governance may not define USER abstraction"
  fi
fi

# --- AGENT ACTivation BOUNDARY ---
echo -e "${BOLD}--- Agent Activation Boundary ---${NC}"

if [ -f "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" ]; then
  if grep -qiE 'activation.*separate|separate.*activation|activation.*boot|boot.*activation' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "Agent activation kept separate from startup"
  else
    log_warn "Agent activation may not be explicitly separated from startup"
  fi
fi

# --- FINAL CHECK: No file can override identity ---
echo -e "${BOLD}--- Final Override Check ---${NC}"

# Verify no file in workspace contains identity override command
override_patterns=(
  'override.*identity'
  'replace.*USER.*identity'
  'rewrite.*USER.*identity'
  'USER.*is.*now.*Marquinhos'
  'USER.*is.*now.*Jarvis'
  'identity.*override.*system'
)

override_found=0
for pattern in "${override_patterns[@]}"; do
  found_in=$(grep -rlEi "$pattern" "$WORKSPACE" --include="*.md" --exclude-dir=".git" 2>/dev/null || true)
  if [ -n "$found_in" ]; then
    log_error "Override pattern '$pattern' found in: $found_in"
    override_found=1
  fi
done

if [ $override_found -eq 0 ]; then
  log_pass "No identity override patterns found in workspace"
fi

# --- SUMMARY ---
echo ""
echo -e "${BOLD}=== STARTUP VALIDATION SUMMARY ===${NC}"
echo -e "  ${GREEN}PASS${NC}: $PASS"
echo -e "  ${YELLOW}WARN${NC}: $WARNINGS"
echo -e "  ${RED}VIOLATION${NC}: $ERRORS"
echo -e "  ⊘ SKIP: $SKIP"
echo ""

# Auto-injection summary
echo -e "${BOLD}Auto-Injected (Tier 1):${NC}"
for f in "${TIER1_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    echo -e "  ${GREEN}✓${NC} $f"
  else
    echo -e "  ${RED}✗${NC} $f (missing)"
  fi
done
echo ""

# Tier 2 status
echo -e "${BOLD}On-Demand (Tier 2):${NC}"
for f in "${TIER2_FILES[@]}"; do
  filepath="$WORKSPACE/$f"
  if [ -f "$filepath" ]; then
    echo -e "  ${GREEN}✓${NC} $f"
  else
    echo -e "  ${YELLOW}~${NC} $f (missing — may be acceptable)"
  fi
done
echo ""

if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}${BOLD}RESULT: FAIL — Startup cognition issues detected${NC}"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}${BOLD}RESULT: WARN — Startup cognition mostly clean${NC}"
  exit 0
else
  echo -e "${GREEN}${BOLD}RESULT: PASS — Startup cognition intact${NC}"
  exit 0
fi
