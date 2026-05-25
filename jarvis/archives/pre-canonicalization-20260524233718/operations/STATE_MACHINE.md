# STATE_MACHINE.md — Operational State Machine

*State transitions. Loaded at init.*

---

## Task States

| State | Description |
|---|---|
| `PENDING` | Task exists, no work started |
| `IN_PROGRESS` | Work in progress |
| `WAITING` | Blocked on external party |
| `SCHEDULED` | Set for future execution |
| `COMPLETED` | Done |
| `BLOCKED` | Internal blocker |
| `ABANDONED` | Cancelled |

## State Transitions

```
PENDING → IN_PROGRESS → COMPLETED
PENDING → WAITING → PENDING (unblocked)
PENDING → BLOCKED → IN_PROGRESS (resolver found)
IN_PROGRESS → BLOCKED → WAITING → COMPLETED
Any → ABANDONED
```

## Rules

- Transitions must be logged in task context
- No agent can unilaterally move another agent's task without reporting
- `COMPLETED` tasks stay in memory for 30 days, then archive
- `BLOCKED` tasks are flagged in heartbeat scans

---

*Operational rules are structural. Not memory.*
