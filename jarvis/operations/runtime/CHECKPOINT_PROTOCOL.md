# Checkpoint Protocol — Specification

---

## Purpose

Define how the runtime captures, stores, and restores execution state at defined boundary points. This ensures that no work is lost or duplicated across session boundaries, crashes, or interruptions.

**What it is:** The specification for durable execution checkpoints at defined boundaries.
**What it is not:** A checkpoint database or file format. Checkpoints use existing storage (task DB, file edits, session logs).

---

## Operational Semantics

A checkpoint is a **complete snapshot of operational state** at a specific point in time. It answers four questions unambiguously:

1. **Where are we?** (current task, current step)
2. **What was done?** (evidence of completed steps)
3. **What comes next?** (next action, next actor, next deadline)
4. **What's open?** (external dependencies, blockers, pending approvals)

A checkpoint is **invalid** if it cannot answer all four questions.

---

## Lifecycle

### Phase 1: Checkpoint Creation
At each checkpoint boundary, the runtime captures the four required fields. Checkpoints are written to the task's context in the task DB or the associated daily log file.

### Phase 2: Checkpoint Validation
The checkpoint is valid if it contains all four fields and references at least one evidence artifact. An invalid checkpoint is not written.

### Phase 3: Checkpoint Usage
When resuming work, the runtime reads the latest valid checkpoint for the task in progress. The checkpoint replaces any need for session history, re-scanning, or discovery.

### Phase 4: Checkpoint Lifecycle
- Valid checkpoints are preserved until task completion.
- Upon task COMPLETION, the final checkpoint is archived in the task record.
- Upon task ABANDONMENT, the final checkpoint is preserved for 7 days, then archived.
- Checkpoints are never deleted while the task remains active.

---

## Checkpoint Structure

Every checkpoint contains:

```
checkpoint:
  timestamp: ISO-8601
  task_id: <task number or reference>
  step_number: <integer, monotonic>
  current_state: <current task state>
  completed_steps: [
    { step: <n>, action: <description>, evidence: <reference>, timestamp: <ISO-8601> }
  ]
  next_action: <specific, actionable description>
  next_actor: <who must perform the next action>
  dependencies: [
    { target: <who/what>, status: <waiting|resolved>, set_at: <ISO-8601> }
  ]
  blockers: [
    { description: <what>, raised_at: <ISO-8601>, severity: <low|medium|high> }
  ]
  priority_at_checkpoint: <tier from PRIORITY_RULES.md>
```

---

## Checkpoint Rules

### CR1: Mandatory Checkpoint Boundaries
Checkpoints are required at:
- Completion of any discrete sub-step
- Receiving an external response (email reply, payment confirmation, etc.)
- Task state transition
- Priority tier change
- Session end (implicit checkpoint — always written)

### CR2: Checkpoint Completeness
A checkpoint that fails to include any of the four required fields (where, done, next, open) is rejected and not written. The runtime retries or escalates.

### CR3: Evidence Binding
Each completed step in the checkpoint must reference at least one evidence artifact. No step exists in a checkpoint without proof of completion.

### CR4: Monotonic Step Numbering
Steps are numbered monotonically per task. Step N+1 is always the next step after N. No step is skipped or reused.

### CR5: Priority at Checkpoint
Every checkpoint records the priority tier at the time of checkpoint creation. If the task's priority has changed since the last checkpoint, the new tier must be noted.

### CR6: Dependency Tracking
Every external dependency is recorded with its target, status, and timestamp. Dependencies that transition from waiting to resolved are logged with the resolution timestamp.

### CR7: Session Boundary Checkpoint
When a session ends (any cause), the runtime writes an implicit checkpoint for every task that was IN_PROGRESS. This is non-optional. It captures the exact state needed to resume.

---

## Examples

### Example 1: Canon C50 Purchase (#46)
```
Task: #46 — Compra Sony FX3 / Canon C50
Checkpoints during execution:

CP1 (step 1):
  completed_steps: [
    { step: 1, action: "Sent PO#308672 to Marco Guimaraes", 
      evidence: "email_ref:po308672", timestamp: "2026-05-21T11:51" }
  ]
  next_action: "Await payment confirmation from Marco Guimaraes"
  next_actor: "Marco Guimaraes (Canon)"
  dependencies: [
    { target: "Marco Guimaraes", status: "waiting", set_at: "2026-05-21T11:51" }
  ]

CP2 (step 2, after Merlin contact — new info):
  completed_steps: [ ... CP1 ... ]
  next_action: "Cross-reference Merlin Canon availability with PO#308672 pricing"
  next_actor: "Will"
  dependencies: [
    { target: "Marco Guimaraes", status: "waiting", set_at: "2026-05-21T11:51" },
    { target: "Merlin Distributor", status: "waiting", set_at: "2026-05-22T10:00" }
  ]
```

### Example 2: Session Crash Recovery
```
Session crashes while sending a follow-up email at step 3 of 5.

On next session:
  1. Read latest checkpoint for the task (CP2)
  2. CP2 says: "next_action: Send follow-up to Marco Guimaraes"
  3. No need to re-discover or re-read email threads
  4. Resume from CP2: send the follow-up
  5. Write CP3 after completion
```

### Example 3: Priority Change Checkpoint
```
Task #43 (RigWheels) was T4. A T1 task (#48) interrupts.

When resuming #43:
  checkpoint records:
    priority_at_checkpoint: T4
    note: "Suspended by T1 preemption (#48). Resumed after #48 completion."
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Checkpoint write fails | Task state remains at previous valid checkpoint; retry once; escalate if second failure |
| Partial checkpoint (missing fields) | Rejected, not written; agent retries with complete data |
| Checkpoint data corruption | Previous valid checkpoint is used; corruption is logged as a governance violation |
| Missing evidence reference | Checkpoint is rejected; step is marked as "unverified" until evidence is attached |
| Monotonic step violation | Step numbers are regenerated on resume; violation is logged |
| Dependency stale (target resolved externally) | Detected at next checkpoint; status updated to "resolved" |
| No checkpoint written at session end | This is a governance violation; triggers audit flag |

---

## Constraints

- **Existing storage only.** Checkpoints use task DB context fields and daily log files. No new storage.
- **No checkpoint format spec.** Checkpoint structure is logical, not serialized. Each task manages its own checkpoint format.
- **No checkpoint database.** Checkpoints live in task context, not in a separate system.
- **No checkpoint encryption or access control.** Checkpoints are workspace files, subject to existing security.
- **Backward compatible.** Existing tasks without checkpoints are treated as having an implicit "step 0, no prior work" checkpoint.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all checkpoint rules (absolute)

---

*Checkpoints are the only thing standing between deterministic execution and chaos.*
