#!/bin/bash
# heartbeat.sh - Scan SQLite tasks.db for overdue/deadlines/followups
# Outputs markdown-formatted heartbeat for HEARTBEAT.md

DB="$HOME/jarvis/memory/ops/tasks.db"
TODAY=$(date +%Y-%m-%d)

echo "# Heartbeat Scan — $(date +%Y-%m-%d_%H:%M)"
echo ""

# Helper: query and format as markdown lines
# Args: sql_query
format_tasks() {
    local sql="$1"
    local results
    results=$(sqlite3 -csv -noheader "$DB" "$sql" 2>/dev/null)
    
    if [ -z "$results" ]; then
        return 1
    fi
    
    echo "$results" | while IFS=',' read -r id title status deadline assigned follow_up; do
        # Trim whitespace
        id=$(echo "$id" | xargs)
        title=$(echo "$title" | xargs)
        status=$(echo "$status" | xargs)
        deadline=$(echo "$deadline" | xargs)
        assigned=$(echo "$assigned" | xargs)
        follow_up=$(echo "$follow_up" | xargs)
        
        echo "id=$id title=$title status=$status deadline=$deadline assigned=$assigned follow_up=$follow_up"
    done
}

# Overdue tasks
echo "## Overdue Tasks"
echo ""
OVERDUE=$(format_tasks "SELECT id, title, status, deadline, assigned_to FROM tasks WHERE deadline < '$TODAY' AND status != 'COMPLETED' ORDER BY deadline LIMIT 20;")
if [ -z "$OVERDUE" ]; then
    echo "No overdue items."
else
    echo "$OVERDUE" | while IFS= read -r line; do
        eval "id=$line" 2>/dev/null
        DAYS=$(( ( $(date -d "$deadline" +%s 2>/dev/null || echo 0) - $(date +%s) ) / 86400 ))
        if [ "$DAYS" -lt 0 ]; then
            TAG="OVERDUE by $((-DAYS))d"
        else
            TAG="$DAYS days left"
        fi
        echo "- **#$id** $title — [$status] | $assigned | $TAG"
    done
fi
echo ""

# Today's deadlines
echo "## Today's Deadlines ($TODAY)"
echo ""
TODAY_TASKS=$(format_tasks "SELECT id, title, status, assigned_to FROM tasks WHERE deadline='$TODAY' AND status != 'COMPLETED' ORDER BY assigned_to LIMIT 20;")
if [ -z "$TODAY_TASKS" ]; then
    echo "No deadlines today."
else
    echo "$TODAY_TASKS" | while IFS= read -r line; do
        eval "id=$line" 2>/dev/null
        echo "- **#$id** $title — [$status] → $assigned"
    done
fi
echo ""

# Today's follow-ups
echo "## Today's Follow-ups ($TODAY)"
echo ""
FOLLOWUPS=$(format_tasks "SELECT id, title, status, deadline, follow_up, assigned_to FROM tasks WHERE follow_up='$TODAY' AND status != 'COMPLETED' ORDER BY assigned_to LIMIT 20;")
if [ -z "$FOLLOWUPS" ]; then
    echo "No follow-ups today."
else
    echo "$FOLLOWUPS" | while IFS= read -r line; do
        eval "id=$line" 2>/dev/null
        echo "- **#$id** $title — [$status] → $assigned (follow-up $follow_up)"
    done
fi
echo ""

# Top person counts
echo "## Pending by Person"
echo ""
for person in Will Gabi Jeniffer Cido Ygor Erika Luan Vivi (i9Store USA) Luan; do
    COUNT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM tasks WHERE assigned_to LIKE '%${person}%' AND status != 'COMPLETED';")
    if [ "$COUNT" -gt 0 ] 2>/dev/null; then
        echo "- **$person**: $COUNT pending"
        sqlite3 -csv -noheader "$DB" "SELECT '#' || id || ' ' || title FROM tasks WHERE assigned_to LIKE '%${person}%' AND status != 'COMPLETED' ORDER BY deadline LIMIT 5;" | xargs -I{} echo "  $person: {}" | sed "s/^/  /"
    fi
done
