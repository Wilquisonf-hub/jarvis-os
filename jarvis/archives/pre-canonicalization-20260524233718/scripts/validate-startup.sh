#!/usr/bin/env bash
# validate-startup.sh — Verify startup context integrity
set -uo pipefail

ROOT="/Users/wilquison/jarvis/jarvis-os"
PASS=0
FAIL=0
WARN=0

check() {
  local file="$1"
  local desc="$2"
  if [ -f "$ROOT/$file" ]; then
    size=$(wc -c < "$ROOT/$file" | tr -d ' ')
    if [ "$size" -gt 0 ]; then
      echo "✅ $desc ($size bytes)"
      ((PASS++))
    else
      echo "❌ EMPTY: $desc ($file)"
      ((FAIL++))
    fi
  else
    echo "❌ MISSING: $desc ($file)"
    ((FAIL++))
  fi
}

echo "=== Startup Context Validation ==="
echo ""

echo "--- Boot Order Check ---"
check "bootstrap/STARTUP_CONTEXT.md" "1. STARTUP_CONTEXT"
check "topology/SYSTEM_TOPOLOGY.md" "2. SYSTEM_TOPOLOGY"
check "topology/AGENT_REGISTRY.md" "3. AGENT_REGISTRY"
check "operations/PRIORITY_RULES.md" "4. PRIORITY_RULES"
check "operations/STATE_MACHINE.md" "5. STATE_MACHINE"

echo ""
echo "--- Identity Check ---"
check "identity/SOUL.md" "SOUL.md (immutable)"
check "identity/AGENTS.md" "AGENTS.md (immutable)"
check "identity/USER.md" "USER.md (context)"

echo ""
echo "--- Consistency Check ---"

# Verify STARTUP_CONTEXT lists the same agents as AGENT_REGISTRY
if [ -f "$ROOT/bootstrap/STARTUP_CONTEXT.md" ] && [ -f "$ROOT/topology/AGENT_REGISTRY.md" ]; then
  if grep -q "Marquinhos" "$ROOT/bootstrap/STARTUP_CONTEXT.md" && grep -q "Marquinhos" "$ROOT/topology/AGENT_REGISTRY.md"; then
    echo "✅ Agent consistency: Marquinhos in both STARTUP_CONTEXT and AGENT_REGISTRY"
    ((PASS++))
  else
    echo "❌ Agent mismatch: Marquinhos not in both files"
    ((FAIL++))
  fi

  if grep -q "Jarvis" "$ROOT/bootstrap/STARTUP_CONTEXT.md" && grep -q "Jarvis" "$ROOT/topology/AGENT_REGISTRY.md"; then
    echo "✅ Agent consistency: Jarvis in both STARTUP_CONTEXT and AGENT_REGISTRY"
    ((PASS++))
  else
    echo "❌ Agent mismatch: Jarvis not in both files"
    ((FAIL++))
  fi
fi

echo ""
echo "--- Cron Hold Check ---"
# Check if cron hold is noted
if [ -f "$ROOT/bootstrap/STARTUP_CONTEXT.md" ]; then
  if grep -qi "held\|HELD\|hold\|no loops\|no periodic" "$ROOT/bootstrap/STARTUP_CONTEXT.md"; then
    echo "✅ Cron hold noted in STARTUP_CONTEXT"
    ((PASS++))
  else
    echo "⚠️  WARNING: Cron hold status not explicit in STARTUP_CONTEXT"
    ((WARN++))
  fi
fi

echo ""
echo "=== Result: ✅ $PASS passed | ❌ $FAIL failed | ⚠️  $WARN warnings ==="
exit $FAIL
