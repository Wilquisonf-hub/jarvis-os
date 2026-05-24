# STATE_MACHINE.md — Operational State Engine

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines the explicit operational states for all work items in the ecosystem.
All future operations must follow these state transitions. No ambiguous states.

These states are structural context loaded by all agents. Execution logic lives in the queue files.

---

## 2. TASK STATES

Tasks represent discrete operational items (SEO audits, content pieces, campaigns, incidents, daily ops).

### States

| State | Description | Transitions From | Transitions To |
|-------|-----------|-----------------|----------------|
| `DISCOVERED` | Item identified, not yet assessed | — | PLANNING, BLOCKED, ARCHIVED |
| `PLANNING` | Scope and approach being defined | DISCOVERED | WAITING_APPROVAL, EXECUTING |
| `WAITING_APPROVAL` | Awaiting user approval | PLANNING, BLOCKED | EXECUTING, ARCHIVED, BLOCKED |
| `EXECUTING` | Work in progress | WAITING_APPROVED, PLANNING | REVIEWING, BLOCKED |
| `REVIEWING` | Work complete, awaiting quality/strategic review | EXECUTING | ARCHIVED, EXECUTING (revisions) |
| `COMPLETED` | Approved and closed | REVIEWING | — |
| `BLOCKED` | Unable to proceed (waiting on external dependency) | Any state | WAITING_APPROVAL, PLANNING, ARCHIVED |
| `ARCHIVED` | Closed, no longer active | Any terminal state | — |

### Transition Rules

- **DISCOVERED → PLANNING**: Automatic when assigned to an agent
- **PLANNING → WAITING_APPROVAL**: When approach requires user approval
- **WAITING_APPROVAL → EXECUTING**: Only after user grants approval
- **WAITING_APPROVAL → ARCHIVED**: User rejects
- **WAITING_APPROVAL → BLOCKED**: Dependency unresolvable
- **EXECUTING → REVIEWING**: Work complete, results generated
- **EXECUTING → BLOCKED**: Cannot proceed due to failure/dependency
- **REVIEWING → COMPLETED**: Approved as-is
- **REVIEWING → EXECUTING**: Needs revisions (reopens as EXECUTING)
- **Any → BLOCKED**: External blocker detected
- **BLOCKED → PLANNING**: Blocker resolved, replan
- **BLOCKED → ARCHIVED**: Blocker not actionable
- **Any → ARCHIVED**: User explicitly archives

### Task Status Legend

- **PENDING**: Equivalent to DISCOVERED — initial state
- **IN_PROGRESS**: Equivalent to EXECUTING — actively worked on
- **WAITING**: Equivalent to WAITING_APPROVAL — awaiting action
- **COMPLETED**: Same — closed
- **BLOCKED**: Same — blocked
- **SCHEDULED**: Equivalent to DISCOVERED with planned date

---

## 3. CAMPAIGN STATES

Campaigns are multi-step operational initiatives (SEO campaigns, content series, competitor responses, promotions).

### States

| State | Description | Transitions From | Transitions To |
|-------|-----------|-----------------|----------------|
| `DISCOVERED` | Campaign opportunity identified | — | RESEARCHING, PRIORITIZING |
| `RESEARCHING` | Research and analysis phase | DISCOVERED | PRIORITIZING, ARCHIVED |
| `PRIORITIZING` | Compared against other work items | RESEARCHING, DISCOVERED | WAITING_APPROVAL, ARCHIVED |
| `WAITING_APPROVAL` | Awaiting user approval to launch | PRIORITIZING | EXECUTING, ARCHIVED |
| `EXECUTING` | Campaign active, work in progress | WAITING_APPROVED | MONITORING |
| `MONITORING` | Campaign running, measuring results | EXECUTING | ITERATING, ARCHIVED |
| `ITERATING` | Adjusting based on performance data | MONITORING | MONITORING, ARCHIVED |
| `ARCHIVED` | Campaign complete or terminated | Any terminal state | — |

### Transition Rules

- **DISCOVERED → RESEARCHING**: Automatic research phase
- **RESEARCHING → PRIORITIZING**: Research complete, evaluate priority
- **PRIORITIZING → WAITING_APPROVAL**: Ready to launch, needs approval
- **PRIORITIZING → ARCHIVED**: Not worth pursuing
- **WAITING_APPROVAL → EXECUTING**: Approved
- **WAITING_APPROVAL → ARCHIVED**: Rejected
- **EXECUTING → MONITORING**: Core work complete, measuring
- **MONITORING → ITERATING**: Data shows need for adjustment
- **MONITORING → ARCHIVED**: Performance target met
- **ITERATING → MONITORING**: Adjustment live, measuring again
- **ITERATING → ARCHIVED**: Not improving, terminate

---

## 4. INCIDENT STATES

Incidents are operational problems requiring resolution (ranking drops, SEO errors, system failures, critical blockers).

### States

| State | Description | Transitions From | Transitions To |
|-------|-----------|-----------------|----------------|
| `DETECTED` | Problem identified | — | TRIAGED |
| `TRIAGED` | Root cause and impact assessed | DETECTED | ESCALATED, MITIGATED |
| `ESCALATED` | Requires user attention/approval | TRIAGED | RESOLVED |
| `MITIGATED` | Action taken, impact contained | TRIAGED | RESOLVED |
| `RESOLVED` | Incident fully resolved | ESCALATED, MITIGATED | ARCHIVED |

### Transition Rules

- **DETECTED → TRIAGED**: Automatic triage phase
- **TRIAGED → ESCALATED**: Requires user decision/approval
- **TRIAGED → MITIGATED**: Can resolve without user input
- **ESCALATED → RESOLVED**: User approves solution
- **MITIGATED → RESOLVED**: Mitigation successful
- **RESOLVED → ARCHIVED**: Post-incident complete

### Priority Mapping

- **P0 incident**: DETECTED → TRIAGED → ESCALATED (immediate)
- **P1 incident**: DETECTED → TRIAGED → MITIGATED (same day)
- **P2 incident**: DETECTED → TRIAGED → ESCALATED/MITIGATED (next day)
- **P3 incident**: DETECTED → TRIAGED → RESOLVED (during regular ops)

---

## 5. CROSS-CUTTING RULES

1. **No ambiguous states**: All items must be in one of the defined states
2. **State changes are explicit**: Never implied, always logged
3. **Blocking supersedes**: BLOCKED state overrides all other states
4. **Archived is final**: Archived items can only be reactivated via explicit user action
5. **Transitions follow the table**: No shortcuts
6. **State logged with timestamp**: Every state change recorded in QUEUE files
7. **State visible to all agents**: Structural context for prioritization

---

_This file is structural context. Do not modify without user instruction._
