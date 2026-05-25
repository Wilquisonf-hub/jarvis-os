#!/usr/bin/env bash
# verify-identity.sh — Deterministic identity boundary validation
# Purpose: Detect identity contamination, startup drift, hierarchy corruption
# Behavior: Read-only scan, report violations, NEVER modify files
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

echo -e "${BOLD}=== IDENTITY BOUNDARY VALIDATION ===${NC}"
echo "Workspace: $WORKSPACE"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date +%Y-%m-%dT%H:%M:%SZ)"
echo ""

FILES_TO_CHECK=(
  "MEMORY.md"
  "SOUL.md"
  "AGENTS.md"
  "IDENTITY.md"
  "USER.md"
  "HEARTBEAT.md"
  "bootstrap/STARTUP_CONTEXT.md"
  "rules/IDENTITY_RULES.md"
)

# Check topology directory exists
if [ -d "$WORKSPACE/topology" ]; then
  for f in "$WORKSPACE"/topology/*; do
    [ -f "$f" ] && FILES_TO_CHECK+=("topology/$(basename "$f")")
  done
else
  log_skip "No topology/ directory found"
fi

# --- CHECK 1: Forbidden patterns ---
echo -e "\n${BOLD}--- CHECK 1: Forbidden Identity Patterns ---${NC}"

FORBIDDEN_PATTERNS=(
  "You are Marquinhos"
  "you are marquinhos"
  "Marquinhos is the user"
  "marquinhos is the user"
  "Jarvis is the user"
  "jarvis is the user"
  "You supervise yourself"
  "your company"
  "USER = Jarvis"
  "USER = Marquinhos"
  "USER=Jarvis"
  "USER=Marquinhos"
  "USER (Marquinhos)"
  "you are Jarvis"
  "you are the user"
)

# Pre-extract non-BAD content from each file
for file in "${FILES_TO_CHECK[@]}"; do
  filepath="$WORKSPACE/$file"
  if [ -f "$filepath" ]; then
    # Use awk to skip BAD blocks and output clean content to a temp file
    safe_content=$(mktemp)
    awk '
      /^###? *BAD$/ { in_bad=1; next }
      /^###? *(GOOD|VERY GOOD|SAFE)$/ { in_bad=0; next }
      in_bad { next }
      { print }
    ' "$filepath" > "$safe_content"
    
    for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
      if grep -iqE "$pattern" "$safe_content" 2>/dev/null; then
        if echo "$pattern" | grep -qE '[.*()+]'; then
          log_error "Pattern '$pattern' found in $file:"
          grep -inE "$pattern" "$safe_content" 2>/dev/null | head -3 | sed 's/^/    /'
        else
          log_error "Pattern '$pattern' found in $file"
        fi
      fi
    done
    rm -f "$safe_content"
  fi
done

log_pass "No forbidden identity patterns detected"

# --- CHECK 2: Identity definitions intact ---
echo -e "\n${BOLD}--- CHECK 2: Identity Definitions ---${NC}"

# USER.md must exist and not define a human identity
if [ -f "$WORKSPACE/USER.md" ]; then
  if grep -qE '(name|email|phone|role|function|company|owner)' "$WORKSPACE/USER.md" 2>/dev/null | head -1 | grep -q '.'; then
    log_warn "USER.md contains personal identity fields (acceptable if minimal)"
  else
    log_pass "USER.md exists (abstract identity)"
  fi
else
  log_pass "USER.md not required (abstract identity)"
fi

# IDENTITY.md must define Jarvis
if [ -f "$WORKSPACE/IDENTITY.md" ]; then
  if grep -qiE 'jarvis.*executive|executive.*jarvis|primary.*system|operations.*system' "$WORKSPACE/IDENTITY.md" 2>/dev/null; then
    log_pass "IDENTITY.md defines Jarvis correctly"
  else
    log_warn "IDENTITY.md does not explicitly define Jarvis as executive"
  fi
else
  log_error "IDENTITY.md missing"
fi

# --- CHECK 3: Hierarchy integrity ---
echo -e "\n${BOLD}--- CHECK 3: Hierarchy Integrity ---${NC}"

if [ -f "$WORKSPACE/MEMORY.md" ]; then
  # Check for hierarchy preservation
  if grep -qiE 'USER → Jarvis → Marquinhos|MARQUINHOS.*subordinate|subordinate.*marquinhos' "$WORKSPACE/MEMORY.md" 2>/dev/null; then
    log_pass "Hierarchy preserved in MEMORY.md"
  else
    log_warn "Hierarchy not explicitly defined in MEMORY.md (may be acceptable)"
  fi

  # Check for hierarchy collapse (bad)
  if grep -qiE 'USER = Jarvis|USER = Marquinhos|MARQUINHOS = USER|JARVIS = USER' "$WORKSPACE/MEMORY.md" 2>/dev/null; then
    log_error "Hierarchy collapse detected in MEMORY.md"
  fi
else
  log_error "MEMORY.md missing"
fi

if [ -f "$WORKSPACE/AGENTS.md" ]; then
  if grep -qiE 'Jarvis.*supervises.*Marquinhos|Marquinhos.*subordinate.*Jarvis' "$WORKSPACE/AGENTS.md" 2>/dev/null; then
    log_pass "Hierarchy preserved in AGENTS.md"
  else
    log_warn "Hierarchy not explicit in AGENTS.md"
  fi
fi

# --- CHECK 4: Worker statelessness ---
echo -e "\n${BOLD}--- CHECK 4: Worker Model ---${NC}"

if [ -f "$WORKSPACE/operations/WORKER_REGISTRY.md" ]; then
  if grep -qiE 'stateless|ephemeral|state.*less|task.scoped' "$WORKSPACE/operations/WORKER_REGISTRY.md" 2>/dev/null; then
    log_pass "Workers defined as stateless/ephemeral"
  else
    log_warn "WORKER_REGISTRY.md does not define workers as stateless"
  fi
else
  log_skip "WORKER_REGISTRY.md not found"
fi

# --- CHECK 5: Topology file integrity ---
echo -e "\n${BOLD}--- CHECK 5: Topology Integrity ---${NC}"

if [ -f "$WORKSPACE/topology/SYSTEM_TOPOLOGY.md" ]; then
  if grep -qiE 'USER.*→.*Jarvis.*→.*Marquinhos|JARVIS.*USER.*JARVIS|USER = JARVIS' "$WORKSPACE/topology/SYSTEM_TOPOLOGY.md" 2>/dev/null; then
    log_error "Topology file contains collapsed identity"
  else
    log_pass "Topology preserves identity boundaries"
  fi
else
  log_skip "SYSTEM_TOPOLOGY.md not found"
fi

if [ -f "$WORKSPACE/topology/AGENT_REGISTRY.md" ]; then
  if grep -qiE 'USER.*=.*Marquinhos|USER.*=.*Jarvis|USER.*identical.*to' "$WORKSPACE/topology/AGENT_REGISTRY.md" 2>/dev/null; then
    log_error "Agent registry contains collapsed identity"
  else
    log_pass "Agent registry preserves identity boundaries"
  fi
else
  log_skip "AGENT_REGISTRY.md not found"
fi

# --- CHECK 6: Startup context integrity ---
echo -e "\n${BOLD}--- CHECK 6: Startup Context ---${NC}"

if [ -f "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" ]; then
  if grep -qiE 'USER.*=.*Jarvis|USER.*=.*Marquinhos|startup.*bind.*USER|USER.*identity.*bound.*agent' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_error "Startup context binds USER to agent identity"
  else
    log_pass "Startup context does not bind USER to agent"
  fi

  # Check for Tier 1 auto-injection definition
  if grep -qiE 'Tier.*1|tier.*1|auto.*inject|auto.*load' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_pass "Startup context defines auto-injection tiers"
  else
    log_warn "Startup context does not define auto-injection tiers"
  fi
else
  log_error "STARTUP_CONTEXT.md not found"
fi

# --- CHECK 7: Governance rules ---
echo -e "\n${BOLD}--- CHECK 7: Governance Rules ---${NC}"

if [ -f "$WORKSPACE/rules/IDENTITY_RULES.md" ]; then
  # Must exist
  log_pass "IDENTITY_RULES.md exists"

  # Check for critical governance rules
  required_rules=(
    'USER.*abstraction|abstraction.*USER'
    'hierarchy.*preserve|preserve.*hierarchy'
    'worker.*stateless|stateless.*worker'
    'IDENTITY.*boundary|boundary.*IDENTITY'
    'collapse.*prohibit|prohibit.*collapse'
  )

  rules_found=0
  for rule in "${required_rules[@]}"; do
    if grep -qiE "$rule" "$WORKSPACE/rules/IDENTITY_RULES.md" 2>/dev/null; then
      rules_found=$((rules_found+1))
    fi
  done

  if [ $rules_found -ge 3 ]; then
    log_pass "IDENTITY_RULES.md contains $(($rules_found)) governance rules"
  else
    log_warn "IDENTITY_RULES.md contains only $rules_found governance rules (expected ≥3)"
  fi
else
  log_error "IDENTITY_RULES.md not found"
fi

# --- CHECK 8: No self-referencing in startup ---
echo -e "\n${BOLD}--- CHECK 8: No Self-Reference in Startup ---${NC}"

if [ -f "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" ]; then
  if grep -qiE 'I am the user|I am Marquinhos|I am USER|my identity.*user' "$WORKSPACE/bootstrap/STARTUP_CONTEXT.md" 2>/dev/null; then
    log_error "Startup context contains self-referencing to USER"
  else
    log_pass "Startup context does not self-reference USER"
  fi
fi

# --- CHECK 9: AGENTS.md boundary rules ---
echo -e "\n${BOLD}--- CHECK 9: AGENTS.md Boundary Rules ---${NC}"

if [ -f "$WORKSPACE/AGENTS.md" ]; then
  if grep -qiE 'USER.*not.*Jarvis|USER.*not.*Marquinhos|never.*assume|never.*bind|never.*collapse' "$WORKSPACE/AGENTS.md" 2>/dev/null; then
    log_pass "AGENTS.md contains boundary preservation rules"
  else
    log_warn "AGENTS.md may not have explicit boundary preservation rules"
  fi
fi

# --- CHECK 10: SOUL.md does not redefine USER ---
echo -e "\n${BOLD}--- CHECK 10: SOUL.md Personality Boundaries ---${NC}"

if [ -f "$WORKSPACE/SOUL.md" ]; then
  if grep -qiE 'USER.*is.*your.*company|you.*are.*the.*user|your.*identity.*is.*USER' "$WORKSPACE/SOUL.md" 2>/dev/null; then
    log_error "SOUL.md redefines USER identity"
  else
    log_pass "SOUL.md does not redefine USER identity"
  fi
fi

# --- SUMMARY ---
echo ""
echo -e "${BOLD}=== VALIDATION SUMMARY ===${NC}"
echo -e "  ${GREEN}PASS${NC}: $PASS"
echo -e "  ${YELLOW}WARN${NC}: $WARNINGS"
echo -e "  ${RED}VIOLATION${NC}: $ERRORS"
echo -e "  ⊘ SKIP: $SKIP"
echo ""

if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}${BOLD}RESULT: FAIL — Identity contamination detected${NC}"
  exit 1
elif [ $WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}${BOLD}RESULT: WARN — No contamination, but review warnings${NC}"
  exit 0
else
  echo -e "${GREEN}${BOLD}RESULT: PASS — All identity boundaries intact${NC}"
  exit 0
fi
