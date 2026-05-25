# ops/ — Relational Operational Memory

Lightweight SQLite database for operational tracking.

## Files

- `tasks.db` — SQLite database with tasks, contacts, events tables

## Schema

### tasks
- id, title, description
- priority (URGENT/HIGH/MEDIUM/LOW/SCHEDULED)
- status (PENDING/IN_PROGRESS/WAITING/COMPLETED/DELAYED/DELEGATED/BLOCKED)
- category (PERSONAL/BUSINESS/DELEGATED/FOLLOW_UP)
- assigned_to, deadline, follow_up, reminder
- dependencies, notes, project, source

### contacts
- id, name, role, company, email, phone
- reliability (reliable/inconsistent/unknown)
- last_contact, notes

### events
- id, type (email/calendar/task_update/deadline/follow_up/bottleneck)
- summary, related_task, related_contact, timestamp, resolved

## Usage

```bash
# Query overdue tasks
sqlite3 tasks.db "SELECT * FROM tasks WHERE deadline < datetime('now') AND status != 'COMPLETED' ORDER BY priority DESC;"

# Query assigned to Gabi
sqlite3 tasks.db "SELECT * FROM tasks WHERE assigned_to = 'Gabi' AND status != 'COMPLETED';"
```

## Maintenance

- Run `openclaw tasks audit` periodically
- Archive completed tasks quarterly
- Do NOT migrate to graph database. Keep it simple.
