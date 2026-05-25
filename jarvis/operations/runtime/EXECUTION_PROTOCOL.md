# Execution Protocol — Specification

---

## Purpose

Define the deterministic execution model for all operational work. This protocol specifies how the runtime identifies, processes, and completes operational tasks — with exact rules for ordering, evidence capture, and state transitions.

**What it is:** The rules for how work gets done, in what order, and how completion is proven.
**What it is not:** A new task manager. It does not replace the task DB. It governs how the agent processes tasks that already exist in the system.

---

## Operational Semantics

Execution follows a strict pipeline:

```
Discovery → Prioritization → Execution → Validation → Evidence → Close
```

Each step has deterministic triggers, required artifacts, and failure escalation paths. No step may be skipped. No step may proceed without completing its required artifacts.

---

## Lifecycle

### Phase 1: Discovery
The runtime discovers work through defined channels (task DB, inbox scan, heartbeat, cron triggers). No ad-hoc task creation outside these channels.

### Phase 2: Prioritization
Discovered work is classified using PRIORITY_RULES.md tiers. T1/T2 tasks preempt all lower-tier work immediately. Priority classification is mandatory before any execution begins.

### Phase 3: Execution
Work is executed following the execution rules below. Each step writes durable evidence.

### Phase 4: Validation
Completion criteria from the task definition are verified against evidence.

### Phase 5: Evidence
All execution artifacts are stored in durable locations (task DB, file system, session logs).

### Phase 6: Close
Task state is updated to COMPLETED only after validation passes. USER is notified if validation failed.

---

## Execution Rules

### ER1: Priority Preemption
When a T1 or T2 task is discovered, all T4/T5 work is immediately suspended. T3 work continues only if it does not conflict with the new high-priority item. Re-suspension point is checkpointed.

### ER2: Deterministic Ordering Within Tier
Within the same priority tier, tasks are ordered by:
1. Deadline proximity (earliest deadline first)
2. Revenue impact (higher revenue first)
3. Multi-agent blocking (more agents blocked = higher priority)
4. Creation date (FIFO for equal priority/impact)

### ER3: Single Thread of Execution
The runtime processes one task at a time within a given tier. Multi-task interleaving is prohibited. A task must reach a checkpoint boundary before switching to the next task in the same tier.

### ER4: Evidence Before State Change
No task state transition (PENDING → IN_PROGRESS, IN_PROGRESS → COMPLETED, etc.) may occur until the corresponding evidence artifact exists. Evidence types:
- **File edit:** For procurement, invoicing, contract work
- **Database update:** For task tracking entries
- **Message confirmation:** For communication tasks (sent + acknowledged)
- **Screenshot/URL:** For verification tasks

### ER5: Checkpoint Boundaries
Checkpoint boundaries occur at:
- Completion of a discrete sub-step
- Receiving an external response
- Task completion
- Priority tier change (ER1)
- Session boundary (implicit checkpoint)

At each checkpoint, the runtime writes: the task ID, current step, next expected action, and any open dependencies.

### ER6: Execution Timeout
If a single task execution exceeds 10 minutes without a checkpoint boundary, the runtime must pause and evaluate whether to continue, escalate to USER, or abandon and log reasons.

### ER7: External Dependency Handling
When work depends on an external party (supplier, client, colleague):
1. Record the dependency in the task context with timestamp
2. Set a deterministic follow-up interval (24h default, task-specific override allowed)
3. Log the follow-up as a cron event or heartbeat item
4. Escalate to USER if no response after the follow-up interval

---

## Examples

### Example 1: Processing a T1 Task
```
1. Discovery: Inbox scan finds "Payment PO#308672" from Marco Guimaraes (Canon)
2. Prioritization: T1 — revenue at risk ($9,620 Panasonic invoice also at risk)
3. Execution: 
   - Check task #47 context
   - Verify payment details against PO#308672
   - Send confirmation to Marco Guimaraes
   - Log confirmation in task #47 context
4. Validation: Payment confirmation received and documented
5. Evidence: Task DB entry updated with confirmation timestamp and attachment reference
6. Close: #47 → COMPLETED
```

### Example 2: Priority Preemption
```
Runtime is processing #43 (RigWheels, T4).
Discovery finds #48 (Panasonic nota, T1 — $9,620 revenue at risk).
Action:
  1. Checkpoint at current RigWheels step: "submitted draft, awaiting review"
  2. Suspend #43
  3. Execute #48 immediately
  4. After #48 completion, resume #43 from checkpoint
```

### Example 3: External Dependency
```
Task: #47 — wait for Marco Guimaraes payment confirmation.
ER7 application:
  1. Dependency recorded: "Marco Guimaraes (Canon) — payment confirmation for PO#308672" at 2026-05-21T14:36
  2. Follow-up interval set: 24h
  3. Follow-up logged: 2026-05-22T14:36 — check email
  4. No response at 2026-05-22T14:36: escalate to USER
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Priority misclassification | Task re-scanned against PRIORITY_RULES.md; correction logged |
| Evidence loss | Task reverts to previous valid state; USER notified |
| External party never responds | ER7 escalation chain: 24h follow-up → 48h follow-up → USER escalation |
| Task exceeds 10min without checkpoint | ER6 timeout — pause, evaluate, escalate if needed |
| Tier conflict (two T1 tasks) | Deadline proximity + revenue impact decides; both logged |
| Session crash during execution | Checkpoint data preserves next action; resume from checkpoint |
| Evidence validation fails | Task reverts to IN_PROGRESS; failure reason logged; USER notified |

---

## Constraints

- **No architecture changes.** Existing task DB, inbox, and heartbeat remain the discovery layer.
- **No new tools.** Execution uses existing tools (exec, edit, write, exec, cron).
- **No parallel execution.** Single-threaded task processing within a tier.
- **10-minute hard limit.** No execution continues beyond 10 minutes without a checkpoint.
- **Evidence is mandatory.** No state change without evidence. This is non-negotiable.
- **Priority rules are binding.** No agent overrides PRIORITY_RULES.md without USER direction.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all execution rules (absolute)

---

*Execution is not creativity. It is discipline.*
