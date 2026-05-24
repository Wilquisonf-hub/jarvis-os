# QUEUE SYSTEM — Operational Queue Directory Structure

## Last Updated: 2026-05-24

---

## 1. DIRECTORY STRUCTURE

```
QUEUE/
├── pending/         # Items discovered, awaiting assessment
├── active/          # Items in EXECUTING or PLANNING state
├── blocked/         # Items blocked on external dependency
├── waiting-approval/ # Items awaiting user approval
├── completed/       # Items successfully completed
└── archived/        # Items closed, no longer active
```

---

## 2. QUEUE FILE FORMAT

Every operational item MUST have a file in the appropriate queue directory.

### File Naming Convention

```
[TASK|CAMPAIGN|INCIDENT]-{ID}-{SHORT-SLUG}.md
```

Examples:
```
TASK-043-RigWheels-Proposta.md
CAMPAIGN-007-FW24-Campaign.md
INCIDENT-012-Site-Down.md
```

### Required Fields (YAML Frontmatter)

```yaml
---
type: TASK | CAMPAIGN | INCIDENT
id: {auto-increment number}
title: {Short descriptive title}
source: {Origin - user, agent, worker, event, cron}
created_at: {ISO 8601 timestamp}
updated_at: {ISO 8601 timestamp}
priority_score: {1-100}
priority_level: {P0|P1|P2|P3|LOW}
owner: {Jarvis|Marquinhos}
owner_agent: {Specific agent name}
status: {State from STATE_MACHINE.md}
state: {Exact state}
dependencies: [list of task IDs that block this]
blocks: [list of task IDs blocked by this]
estimated_effort: {Low|Medium|High}
revenue_impact: {USD amount or N/A}
traffic_impact: {Percentage or N/A}
confidence: {High|Medium|Low}
risk: {High|Medium|Low}
resolution: {How it was resolved or why blocked}
approved_by: {User name or N/A}
last_reviewed_at: {ISO 8601 timestamp}
notes: |
  {Additional context}
---
```

### Required Fields (Body)

```markdown
# {Title}

## Summary
{2-3 sentence description of the item}

## Context
{Detailed background information}

## Analysis
{Work done so far, findings, data points}

## Next Steps
{Specific actions required, by whom}

## Attachments/References
{Links to relevant files, emails, data sources}
```

---

## 3. QUEUE MANAGEMENT RULES

### General Rules

1. **Every operational item MUST have a queue file** — no invisible work
2. **Files move between directories** as state changes — items are never deleted without archiving
3. **Priority score is calculated** per PRIORITY_RULES.md
4. **Status and state must match** STATE_MACHINE.md definitions
5. **Timestamps are ISO 8601** for consistency
6. **IDs are globally unique** and auto-incrementing
7. **Owners are assigned** — every item has a clear owner (Jarvis or Marquinhos)

### Queue-Specific Rules

#### pending/
- Items discovered but not yet assessed
- Default state: DISCOVERED
- Max items: 50 (older items auto-archived if >30 days old and no user action)

#### active/
- Items in EXECUTING or PLANNING state
- Items currently receiving attention
- Max items: 20 (hard limit to prevent context switching)

#### blocked/
- Items blocked on external dependency
- Must list blocker explicitly
- Must be reviewed at least every 24 hours
- Max items: 15

#### waiting-approval/
- Items awaiting user approval
- Must clearly state what approval is needed
- Must state consequence of delayed approval
- Max items: 10

#### completed/
- Items in COMPLETED state
- Retained for 30 days then moved to archived/
- Contains resolution info

#### archived/
- Items closed, no longer active
- Retained indefinitely for historical reference
- Can be reactivated only via explicit user instruction

---

## 4. QUEUE OPERATIONS

### Creating an Item

1. Determine type (TASK, CAMPAIGN, INCIDENT)
2. Assign unique ID (increment from last used)
3. Calculate priority score per PRIORITY_RULES.md
4. Determine state per STATE_MACHINE.md
5. Create file with frontmatter and body
6. Place in appropriate queue directory
7. Log creation timestamp

### Moving an Item

1. Update `state` field per STATE_MACHINE.md transitions
2. Update `updated_at` timestamp
3. Update `priority_score` if factors change
4. Move file to new directory based on state
5. Log transition with timestamp

### Reviewing a Queue

#### Daily Review (Jarvis/Marquinhos)
- Review all items in active/ and waiting-approval/
- Update states as appropriate
- Escalate P0 items immediately
- Archive stale items from pending/ (>30 days)
- Calculate new priority scores

#### Weekly Review (User)
- Review all P3 items
- Review ARCHIVED items for reactivation
- Review overall queue health
- Adjust PRIORITY_RULES.md if weights need calibration

---

## 5. QUEUE HEALTH METRICS

Track these metrics in METRICS/QUEUE_HEALTH.md:

| Metric | Target | Description |
|--------|--------|-------|
| **Items in active/** | < 20 | Prevent context switching overload |
| **Items in blocked/** | < 15 | Prevent accumulation of blockers |
| **Items in waiting-approval/** | < 10 | Prevent approval bottleneck |
| **Average item age (pending)** | < 14 days | Items not assessed too long |
| **Average approval latency** | < 48 hours | Time from submission to approval |
| **Queue growth rate** | < 5 items/day | Net items added minus items completed |
| **Blocker resolution time** | < 72 hours | Time from blocking to resolution |

---

## 6. AUTOMATION BOUNDS

### What IS automated:
- Queue file creation when items are discovered
- Priority score calculation
- State transition updates
- Queue directory movement based on state
- Stale item alerts (>30 days in pending/)
- Overdue item alerts

### What is NOT automated:
- Auto-approval of any item
- Auto-completion of work
- Auto-resolution of blockers
- Auto-archiving without review
- Auto-prioritization without score calculation

### Cron Integration:
- **heartbeat-scan**: Every 2 hours — review active and waiting-approval queues
- **daily-briefing**: Daily morning — compile pending, active, blocked items
- **weekly-ops-review**: Weekly — review all queues, calculate metrics

---

## 7. EXAMPLE QUEUE FILE

```yaml
---
type: TASK
id: 43
title: RigWheels Proposta Comercial Leo
source: vendor
created_at: 2026-05-20T10:00:00Z
updated_at: 2026-05-24T09:00:00Z
priority_score: 45
priority_level: P2
owner: Jarvis
owner_agent: Jarvis
status: PENDING
state: BLOCKED
dependencies: []
blocks: []
estimated_effort: Low
revenue_impact: N/A
traffic_impact: N/A
confidence: Medium
risk: Medium
resolution: "Awaiting response from Leo. Overdue 4 days."
approved_by: N/A
last_reviewed_at: 2026-05-24T09:00:00Z
notes: |
  Leo hasn't responded to 3 follow-ups.
  Consider alternative supplier if no response in 48 hours.
---

# RigWheels Proposta Comercial Leo

## Summary
RigWheels commercial proposal from Leo (supplier) overdue by 4 days. No response to follow-ups.

## Context
RigWheels is a potential equipment purchase. Leo is the primary vendor contact. We've been waiting for their commercial proposal since May 20.

## Analysis
- 3 follow-up emails sent (May 21, 22, 23)
- No response received
- Competitor may be using RigWheels
- Timeline slipping — need proposal by May 28

## Next Steps
1. Send final follow-up to Leo (May 24)
2. If no response by May 26, contact alternative supplier
3. Escalate to user if still no response by May 27

## Attachments/References
- Email thread: RigWheels Proposta
- Supplier contact: leo@rigwheels.com
```

---

_This file defines the queue system structure. Files in each directory contain the operational items. Do not modify this structure without user instruction._
