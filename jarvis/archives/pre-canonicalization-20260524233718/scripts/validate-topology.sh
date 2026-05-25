#!/usr/bin/env bash
# validate-topology.sh — Verify topology integrity
set -uo pipefail

ROOT="/Users/wilquison/jarvis/jarvis-os"
PASS=0
FAIL=0
WARN=0

check() {
  local file="$1"
  local desc="$2"
  if [ -f "$ROOT/$file" ]; then
    echo "✅ $desc"
    ((PASS++))
  else
    echo "❌ MISSING: $desc ($file)"
    ((FAIL++))
  fi
}

warn() {
  local file="$1"
  local desc="$2"
  if [ ! -d "$ROOT/$file" ]; then
    echo "⚠️  DIR MISSING: $desc ($file)"
    ((WARN++))
  else
    echo "✅ DIR $desc"
    ((PASS++))
  fi
}

echo "=== Topology Validation ==="
echo ""

echo "--- Core Files ---"
check "identity/SOUL.md" "SOUL.md"
check "identity/AGENTS.md" "AGENTS.md"
check "identity/USER.md" "USER.md"

echo ""
echo "--- Bootstrap ---"
check "bootstrap/STARTUP_CONTEXT.md" "Startup Context"

echo ""
echo "--- Topology ---"
check "topology/SYSTEM_TOPOLOGY.md" "System Topology"
check "topology/AGENT_REGISTRY.md" "Agent Registry"

echo ""
echo "--- Operations ---"
check "operations/PRIORITY_RULES.md" "Priority Rules"
check "operations/STATE_MACHINE.md" "State Machine"

echo ""
echo "--- Directories ---"
warn "learning" "Learning dir"
warn "metrics" "Metrics dir"
warn "queue/pending" "Queue pending"
warn "queue/active" "Queue active"
warn "queue/blocked" "Queue blocked"
warn "queue/waiting-approval" "Queue waiting-approval"
warn "queue/completed" "Queue completed"
warn "queue/archived" "Queue archived"
warn "shared" "Shared dir"
warn "scripts" "Scripts dir"

echo ""
echo "--- Queue Structure ---"
for q in pending active blocked waiting-approval completed archived; do
  if [ -d "$ROOT/queue/$q" ]; then
    count=$(find "$ROOT/queue/$q" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "  ✅ queue/$q — $count files"
  else
    echo "  ❌ queue/$q — MISSING"
    ((FAIL++))
  fi
done

echo ""
echo "=== Result: ✅ $PASS passed | ❌ $FAIL failed | ⚠️  $WARN warnings ==="
exit $FAIL
