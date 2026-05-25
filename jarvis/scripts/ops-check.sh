#!/bin/bash
# ops-check.sh - Quick operational health check
# Usage: bash scripts/ops-check.sh

echo "=== OPERATIONS CHECK ==="
echo ""

# File sizes
echo "File sizes (KB):"
for f in HEARTBEAT.md MEMORY.md TASKS.md TEAM.md PROJECTS.md GOSPER.md AGENTS.md; do
  if [ -f "/Users/wilquison/jarvis/$f" ]; then
    size=$(du -k "/Users/wilquison/jarvis/$f" | cut -f1)
    echo "  $f: ${size}KB"
  else
    echo "  $f: MISSING"
  fi
done

echo ""

# SQLite health
echo "SQLite DB:"
if [ -f "/Users/wilquison/jarvis/memory/ops/tasks.db" ]; then
  size=$(du -k /Users/wilquison/jarvis/memory/ops/tasks.db | cut -f1)
  tables=$(sqlite3 /Users/wilquison/jarvis/memory/ops/tasks.db ".tables" 2>/dev/null)
  task_count=$(sqlite3 /Users/wilquison/jarvis/memory/ops/tasks.db "SELECT COUNT(*) FROM tasks;" 2>/dev/null)
  pending=$(sqlite3 /Users/wilquison/jarvis/memory/ops/tasks.db "SELECT COUNT(*) FROM tasks WHERE status IN ('PENDING','IN_PROGRESS','WAITING','BLOCKED');" 2>/dev/null)
  echo "  tasks.db: ${size}KB"
  echo "  tables: $tables"
  echo "  total tasks: $task_count"
  echo "  active tasks: $pending"
else
  echo "  tasks.db: MISSING"
fi

echo ""

# gog connectivity
echo "gog connectivity:"
result=$(/opt/homebrew/bin/gog gmail search -n 1 in:unread 2>&1)
if echo "$result" | grep -q "ID"; then
  echo "  Gmail: ✅ connected"
else
  echo "  Gmail: ❌ $result"
fi

echo ""
echo "=== END ==="
