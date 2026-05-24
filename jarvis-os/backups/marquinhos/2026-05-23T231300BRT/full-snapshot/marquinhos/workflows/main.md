# Workflows - Marquinhos

## Workflow Definitions

### SEO Audit Workflow

```
1. User/Heartbeat triggers audit need
2. Marquinhos creates task in TASKS.md
3. Marquinhos routes to seo_auditor worker
4. Worker returns report
5. Marquinhos reviews report for actionable items
6. If fixes needed → create subtasks in TASKS.md
7. If strategic → notify Jarvis with summary
8. Worker terminates
```

### Content Creation Workflow

```
1. Content Strategist identifies opportunity
2. Marquinhos creates content_brief.md
3. Brief sent to content_writer worker
4. Worker returns draft
5. Marquinhos reviews against brief
6. If approved → schedule/publish
7. If revisions needed → send to content_writer again
8. Worker terminates
```

### Competitive Intelligence Workflow

```
1. Trigger: heartbeat scan or user request
2. Marquinhos routes to competitive_intel worker
3. Worker returns analysis
4. Marquinhos assesses impact (low/medium/high/critical)
5. If significant movement → alert Jarvis + add to TASKS.md
6. If minor → log to COMPETITORS.md
7. Worker terminates
```

### Campaign Launch Workflow

```
1. Human proposes campaign objective
2. Marquinhos breaks into:
   - Research phase (competitor, keyword, content)
   - Execution phase (content, SEO, visuals)
   - Monitoring phase (performance tracking)
3. Marquinhos proposes execution plan to human
4. Human approves
5. Marquinhos creates tasks in TASKS.md
6. Marquinhos routes to appropriate workers
7. Marquinhos tracks completion via TASKS.md
8. On completion → summary to Jarvis
9. Worker terminates
```

### Reporting Workflow

```
1. Trigger: heartbeat or scheduled
2. Marquinhos routes to reporting_analyst worker
3. Worker collects data from:
   - TASKS.md (task completion)
   - CAMPAIGNS.md (campaign status)
   - COMPETITORS.md (competitor movements)
   - TASKS.md (SEO flags)
4. Worker returns formatted report
5. Marquinhos reviews for executive summary
6. Summary sent to Jarvis
7. Worker terminates
```

## Task Routing Rules

- Similar tasks → batch together
- Urgent tasks → priority queue, immediate routing
- Blocked tasks → flag and notify
- Waiting approval → queue until approved
- Completed tasks → check for dependent tasks

---

_Last Updated: 2026-05-23_
