# Task Ownership — Specification

---

## Purpose

Define how operational tasks are assigned, tracked, and transferred between agents and contacts. This protocol ensures that every task has a clear owner, that ownership changes are explicit, and that no task falls through the gap between unowned or ambiguously-owned states.

**What it is:** The rules for task ownership assignment, tracking, and transfer.
**What it is not:** An assignment system. Task ownership is a governance rule applied to existing task records, not a new assignment mechanism.

---

## Operational Semantics

Every operational task MUST have exactly one owner at all times. The owner is the entity responsible for advancing the task toward completion. Ownership is not shared. If multiple entities are involved, one is designated as primary owner; others are listed as contributors.

```
Task Definition → Owner Assignment → Execution → Ownership Transfer (if needed) → Closure
```

---

## Ownership Rules

### TO1: Mandatory Ownership
Every task in the task DB must have an owner field populated. A task without an owner is INVALID and must be assigned before any execution begins. Default assignment: the task creator or the executor who discovers the task.

### TO2: Single Primary Owner
Each task has exactly one primary owner. Secondary participants are contributors, not co-owners. The primary owner is responsible for advancing the task and reporting its status.

### TO3: Ownership Transfer
Ownership may be transferred between agents/contacts under these conditions:
1. **User-directed:** USER explicitly assigns the task to a new owner
2. **Capability-based:** The current owner cannot execute the next required action (e.g., lack of access, knowledge); task is transferred to the entity that can
3. **Escalation-based:** The task is T1/T2 and the current owner is not responding; task is escalated to USER or a higher-tier agent

Ownership transfer requires:
- Logging the transfer in the task context with timestamp and reason
- Updating the task DB owner field
- Notifying the previous owner (if applicable)

### TO4: Ownership Retention
Once assigned, the owner retains ownership until:
- The task is COMPLETED (owner becomes "closer")
- The task is ABANDONED (ownership is recorded for audit)
- The task is explicitly transferred (per TO3)
- USER redirects ownership

Ownership is NOT automatically transferred by time, priority change, or task state change.

### TO5: Unresponsive Owner Escalation
If the primary owner does not advance the task within the escalation interval:
- T1/T2 tasks: escalate after 4h of no advancement
- T3 tasks: escalate after 12h of no advancement
- T4/T5 tasks: escalate after 24h of no advancement

Escalation means: USER is notified, and USER assigns a new owner or provides direction.

### TO6: Agent-Specific Ownership Rules
| Agent | Ownership Constraints |
|---|---|
| Jarvis | Owns all system-level tasks (heartbeat, cron, recovery) |
| USER | Owns all decisions that require discretion (approvals, priority changes, direction) |
| Marquinhos | Not yet operational — placeholder only |
| External contacts | Own their own responses (supplier replies, client confirmations) |

### TO7: Task Creation Ownership
When a task is created (via inbox scan, cron trigger, or manual entry):
- The creating agent is the temporary owner
- The temporary ownership must be confirmed or transferred within the same execution cycle
- If the creating agent cannot own the task (e.g., task requires external action), it is assigned to the responsible external party with "WAITING" state

---

## Ownership Lifecycle

### Phase 1: Assignment
Task is created or discovered. Owner is assigned per TO1. For tasks from inbox/heartbeat: the executor assigns ownership based on task content and existing patterns.

### Phase 2: Active Ownership
The owner advances the task according to the EXECUTION_PROTOCOL. The owner is responsible for:
- Executing the next action
- Updating the task state
- Logging progress in task context
- Reporting blockers
- Initiating escalation if stuck

### Phase 3: Transfer (if needed)
Per TO3. Transfer is logged, notified, and effective immediately upon logging.

### Phase 4: Closure Ownership
The owner who completes the task's validation (per COMPLETION_VALIDATION) is recorded as the closer. The closer and owner may differ (e.g., USER closes a task the agent was advancing).

### Phase 5: Post-Closure
Closed tasks retain their owner/closer records for 30 days for audit purposes. After 30 days, ownership records are archived with the task.

---

## Examples

### Example 1: Task Discovery and Assignment
```
Inbox scan finds: "Marco Guimaraes — Payment PO#308672"
Executor: Jarvis

Per TO1:
  - Task #47 already exists in task DB
  - Current owner: Will (per existing records)
  - Jarvis maintains Will as owner
  - Jarvis adds execution evidence to #47 context
  - Next session: Jarvis checks #47 progress and escalates if needed (TO5)
```

### Example 2: Ownership Transfer
```
Task: #5 — Comprar FX30 com Yuri Delta
Current owner: Will
Problem: Will doesn't have contact info for Yuri Delta
Executor: Jarvis (who has the info)

Per TO3:
  - Transfer reason: "Capability gap — Will lacks contact info"
  - Transfer logged in task context with timestamp
  - Task DB owner updated to: Jarvis
  - Will notified in task context
  - Jarvis executes the purchase
```

### Example 3: Unresponsive Owner Escalation
```
Task: #48 — Panasonic nota $9,620
Owner: Gabi
Last advancement: 2026-05-20 (2 days ago)
Priority: T1 (revenue at risk)

Per TO5:
  - T1 escalation interval: 4h (but task is 2 days stale)
  - Escalation triggered
  - USER notified: "Task #48 overdue 2 days — revenue $9,620 at risk. Owner Gabi has not advanced since 2026-05-20. USER direction needed."
  - USER may: reassign, provide direction, or override close
```

### Example 4: USER-Close Override
```
Task: #43 — RigWheels Proposta
Owner: Will
Status: PENDING for 2 days

USER command: "Fecha #43. Não preciso mais."

Result:
  - Task closed as COMPLETED
  - Closer recorded: USER
  - Original owner (Will) retains ownership record for audit
  - Close reason logged: "USER directed close"
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Task created without owner | TO1: task is INVALID; assignment required before execution |
| Owner leaves (no contact) | TO3: task is reassigned to next capable agent; USER notified |
| Shared ownership (ambiguous) | TO2: primary owner must be designated; co-ownership is a violation |
| Owner advances but doesn't log | Task appears stale; escalated per TO5 |
| Ownership transfer not logged | Transfer is not valid; previous owner remains responsible |
| Transfer during active execution | Transfer is valid; new owner assumes immediately; previous owner notified |
| Post-closure audit gap | Records retained for 30 days per Phase 5; gap is governance violation |

---

## Constraints

- **No ownership database.** Ownership is stored in existing task DB fields.
- **No ownership notifications system.** Notifications use existing channels (task context, heartbeat, USER messages).
- **No automatic reassignment by time.** Reassignment requires explicit condition (TO3) or escalation (TO5).
- **No ownership inheritance.** When an owner cannot act, the task does not auto-assign; it escalates or is manually reassigned.
- **No ownership delegation chains.** Direct assignment only. No sub-delegation without logging.
- **Backward compatible.** Existing tasks with owners retain their owners. Tasks without owners are assigned per TO1.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all ownership rules (absolute)

---

*Every task has one owner. If it has none, it is broken. If it has two, it is broken. One owner. One responsibility.*
