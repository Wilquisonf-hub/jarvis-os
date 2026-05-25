#!/usr/bin/env python3
"""heartbeat.sh - Scan tasks.db for overdue/deadlines/followups. Output: markdown."""

import sqlite3
import sys
from datetime import datetime, date
from pathlib import Path

DB = Path.home() / "jarvis" / "memory" / "ops" / "tasks.db"
TODAY = date.today().isoformat()

def run(sql):
    conn = sqlite3.connect(str(DB))
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()
    conn.close()
    return rows

def fmt_date(d):
    try:
        delta = (datetime.strptime(d, '%Y-%m-%d').date() - date.today()).days
        if delta < 0:
            return f"OVERDUE by {-delta}d"
        return f"{delta} days left"
    except:
        return d

print(f"# Heartbeat Scan — {datetime.now().strftime('%Y-%m-%d_%H:%M')}")
print()

# Overdue
print("## Overdue Tasks")
print()
rows = run(f"SELECT id, title, status, deadline, assigned_to FROM tasks WHERE deadline < '{TODAY}' AND status != 'COMPLETED' ORDER BY deadline LIMIT 20")
if not rows:
    print("No overdue items.")
for r in rows:
    print(f"- **#{r['id']}** {r['title']} — [{r['status']}] | {r['assigned_to']} | {fmt_date(r['deadline'])}")
print()

# Today's deadlines
print(f"## Today's Deadlines ({TODAY})")
print()
rows = run(f"SELECT id, title, status, assigned_to FROM tasks WHERE deadline='{TODAY}' AND status != 'COMPLETED' ORDER BY assigned_to LIMIT 20")
if not rows:
    print("No deadlines today.")
for r in rows:
    print(f"- **#{r['id']}** {r['title']} — [{r['status']}] → {r['assigned_to']}")
print()

# Today's follow-ups
print(f"## Today's Follow-ups ({TODAY})")
print()
rows = run(f"SELECT id, title, status, deadline, follow_up, assigned_to FROM tasks WHERE follow_up='{TODAY}' AND status != 'COMPLETED' ORDER BY assigned_to LIMIT 20")
if not rows:
    print("No follow-ups today.")
for r in rows:
    print(f"- **#{r['id']}** {r['title']} — [{r['status']}] → {r['assigned_to']} (follow-up {r['follow_up']})")
print()

# Pending by person
print("## Pending by Person")
print()
persons = ["Will", "Gabi", "Jeniffer", "Cido", "Ygor", "Erika", "Luan", "Vivi"]
for p in persons:
    count = run(f"SELECT COUNT(*) as c FROM tasks WHERE assigned_to LIKE '%{p}%' AND status != 'COMPLETED'")
    c = count[0]['c'] if count else 0
    if c > 0:
        print(f"- **{p}**: {c} pending")
        tasks = run(f"SELECT id, title FROM tasks WHERE assigned_to LIKE '%{p}%' AND status != 'COMPLETED' ORDER BY deadline LIMIT 5")
        for t in tasks:
            print(f"  - #{t['id']} {t['title']}")
