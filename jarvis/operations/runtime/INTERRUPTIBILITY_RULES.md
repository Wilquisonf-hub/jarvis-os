# Interruptibility Rules — Specification

---

## Purpose

Define how the runtime handles interruption at every point during execution and guarantees that the system is left in a safe, resumable state. This protocol ensures that no operation — regardless of when it's interrupted — leaves the system in an inconsistent state.

**What it is:** The rules for safe interruption at any point during execution.
**What it is not:** A crash recovery system. Interruption handling is a subset of recovery; this protocol covers the common case (session end, abort, timeout) while RECOVERY.md covers catastrophic failure.

---

## Operational Semantics

Interruption is treated as **an expected operational event**, not an anomaly. The runtime must:

1. **Detect** interruption points
2. **Freeze** all mutable state at the interruption boundary
3. **Checkpoint** the frozen state
4. **Verify** the checkpoint is valid
5. **Release** all held resources
6. **Confirm** the safe state before termination

---

## Lifecycle

### Phase 1: Interruption Detection
The runtime identifies interruption via: session end, explicit abort command, timeout, or external signal. Detection is immediate — no polling delay.

### Phase 2: State Freeze
All mutable operations are paused at their current boundary. No new writes begin. Existing partial writes are completed or rolled back to the last consistent point.

### Phase 3: Checkpoint Write
A valid checkpoint is written per the CHECKPOINT_PROTOCOL.md. All tasks in progress receive a session-boundary checkpoint.

### Phase 4: Verification
The checkpoint is validated (all four fields present, evidence bound, monotonic steps). If invalid, the runtime retries or falls back to the previous checkpoint.

### Phase 5: Termination
Once the checkpoint is confirmed valid, the session terminates. The system state is deterministic and resumable.

---

## Interruption Rules

### IR1: Interruption Points Are Safe
Every execution step in the EXECUTION_PROTOCOL.md defines checkpoint boundaries. Interruption at any checkpoint boundary is safe — the system state is fully captured. Interruption between checkpoint boundaries is handled by the most recent valid checkpoint.

### IR2: No Partial Writes
No mutable state is written partially. A state change is either fully applied or fully rolled back. If the runtime is interrupted during a write:
- The write is detected as incomplete
- The previous state is preserved
- The incomplete write is not visible to any system component

### IR3: Interrupted External Actions
If an external action is interrupted mid-execution (e.g., email partially sent, database update partial):
1. The action is identified as incomplete
2. The incomplete action is NOT applied
3. A checkpoint records: "action initiated at <time>, interrupted at <time>, not applied"
4. The next session resumes the action from the start (never partially)

### IR4: Priority Reassessment on Resume
When a session resumes after interruption:
1. The runtime re-reads HEARTBEAT.md (fresh scan)
2. Priority classification is re-evaluated against current state
3. If a higher-priority task has emerged during interruption, it pre-empts the interrupted task (ER1)

### IR5: Resource Release
On interruption, all held resources are released:
- Open file handles
- exec session processes
- Pending cron triggers (if applicable)
- Network connections (if applicable)

Resources are not leaked across session boundaries.

### IR6: Interruption During USER Communication
If interruption occurs during a message to the USER:
1. The message content is preserved in a checkpoint
2. On resume, the message is re-sent (never partially delivered)
3. The USER is not left in an ambiguous state ("did they get it?")

### IR7: Cron Job Interruption
If a cron job execution is interrupted:
1. The cron job state is NOT marked as completed
2. The next scheduled run processes the job as if the previous run never started
3. The interrupted run's checkpoint is preserved for analysis

---

## Examples

### Example 1: Email Send Interruption
```
Agent is composing an email to Marco Guimaraes about PO#308672.
Session crashes mid-composition.

Under IR3:
  - Email is NOT sent (partial content is not applied)
  - Checkpoint records: "email to Marco Guimaraes re: PO#308672 — initiated 17:03, interrupted 17:04, not sent"
  - Next session: email is composed from scratch and sent
  - No duplicate email; no partial email; no ambiguity
```

### Example 2: Session End Mid-Task
```
Agent is processing task #48 (Panasonic nota) at step 4 of 7.
Session ends (timeout).

Under IR7 + CHECKPOINT_PROTOCOL:
  - Session-boundary checkpoint written (CR7)
  - Checkpoint captures: current step (4), completed steps (1-3), next action (step 5: draft invoice)
  - Next session: resumes from step 5, no re-discovery needed
  - HEARTBEAT.md is re-read; if priority changed, ER1 preemption applies
```

### Example 3: Cron Job Interruption
```
Inbox triage cron job starts at 14:00 but crashes at 14:03.
Under IR7:
  - Job state remains "not completed"
  - Next scheduled run (14:30) processes fresh, ignoring the failed run
  - Failed run's checkpoint is preserved for debugging
  - No double-processing of inbox items
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Interruption during write | Write is detected as incomplete; previous state preserved; IR2 applies |
| Interruption during checkpoint write | Previous valid checkpoint is used; current interruption is logged as governance violation |
| Interruption during external action | IR3: action is rolled back, not applied; re-executed on resume |
| Resource leak on interruption | IR6: all resources enumerated and released; leak is governance violation |
| Priority stale after interruption | IR4: priority re-evaluated on resume against fresh HEARTBEAT.md |
| USER message not delivered | IR6: message content preserved; re-sent on resume |
| Cron job double-processing | IR7: interrupted jobs are never marked complete; next run is fresh |

---

## Constraints

- **No new interruption detection mechanism.** Uses existing session lifecycle (start/end/timeout).
- **No interrupt signal protocol.** Interruption is session-boundary-based, not message-based.
- **No distributed interruption handling.** Single runtime only.
- **No interruption queuing.** Interruptions are immediate; no queue of pending interruptions.
- **Backward compatible.** Existing sessions already terminate; this protocol adds checkpoint requirements to termination.
- **No interruption logging overhead.** Interruption events are logged in the session boundary checkpoint, not in a separate log.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all interruptibility rules (absolute)

---

*Interruption is not failure. It is an expected state. The system must be ready for it at every moment.*
