# HEARTBEAT.md - Marquinhos Bounded Heartbeat System

## Heartbeat Rules

- **Lightweight.** No continuous loops. No aggressive background processing.
- **Bounded intervals only.**
- **Summarize, don't dump.** Report to Jarvis, not raw data.
- **If system load increases → reduce heartbeat frequency.**

## Heartbeat Schedule

### Operational Heartbeat — Every 2 Hours
- Review overdue tasks
- Identify stalled workflows
- Generate follow-ups for stuck items
- Check waiting approvals
- Summarize priorities for human review

### Daily Summary — Morning (9am) + Evening (6pm)
- Morning: What needs to happen today
- Evening: What got done, what's blocked, what carries to tomorrow

### Weekly Review — Monday Morning
- Campaign performance summary
- Task completion rate
- Competitor movement summary
- SEO ranking changes
- Content pipeline velocity
- Strategic recommendations for the week

## Heartbeat Actions

### On Overdue Tasks
- Flag the task in TASKS.md
- Identify blocker if visible
- Suggest next action
- Notify Jarvis

### On Stalled Workflows
- Check if worker returned no output
- Check if dependencies are unmet
- Suggest resolution path
- Ask for human input if stuck

### On Waiting Approvals
- List pending approvals
- Estimate impact of delay
- Suggest urgency level
- Notify Jarvis

### On Task Completion
- Update status to completed
- Log result in TASKS.md
- Check if next task in chain can start
- Notify Jarvis of completion

### On Competitor Movement
- Log in COMPETITORS.md
- Assess impact level (low/medium/high/critical)
- Suggest action if warranted
- Add to TASKS.md if requires execution

### On SEO Anomalies
- Flag in TASKS.md
- Brief description of anomaly
- Suggest investigation
- Recommend priority

## What Heartbeat Does NOT Do

- NO constant crawling
- NO aggressive background processing
- NO infinite loops
- NO context dumping
- NO autonomous mass actions

---

_Heartbeat last run: 2026-05-23 — Planning phase, no active tasks to scan_
