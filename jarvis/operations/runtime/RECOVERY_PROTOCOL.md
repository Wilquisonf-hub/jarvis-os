# Recovery Protocol — Specification

---

## Purpose

Define how the runtime recovers from catastrophic failures — session loss, data corruption, inconsistent state, or any failure mode that leaves the system in an undefined operational state. This protocol is the last line of defense when everything else fails.

**What it is:** The recovery procedures for catastrophic failure scenarios where the system state is inconsistent, corrupted, or unknown.
**What it is not:** A backup system. Recovery uses existing state (task DB, daily logs, checkpoints) and does not create separate backup infrastructure.

---

## Operational Semantics

When a catastrophic failure occurs, the system's operational state is **unknown**. The recovery process treats the state as potentially corrupted and rebuilds it from the most recent verifiable state. Recovery is deterministic: the same failure always produces the same recovery procedure.

```
Failure → State Assessment → Restore from Last Known Good → Validate → Resume
```

---

## Failure Categories

### FC1: Session Loss
- **Description:** The runtime session ends unexpectedly without a valid checkpoint for one or more in-progress tasks.
- **Likelihood:** High
- **Impact:** Medium — work can be recovered from daily logs and task context

### FC2: Task DB Corruption
- **Description:** The task database file is corrupted, unreadable, or contains inconsistent data.
- **Likelihood:** Low
- **Impact:** Critical — operational state is lost

### FC3: State Inconsistency
- **Description:** Task states in the DB do not match the evidence in task context (e.g., task shows COMPLETED but evidence shows IN_PROGRESS).
- **Likelihood:** Medium
- **Impact:** Medium — requires reconciliation

### FC4: External System Corruption
- **Description:** External systems (email, CRM, task tracker) have inconsistent state that conflicts with the local task DB.
- **Likelihood:** Medium
- **Impact:** High — requires resolution before operational resume

### FC5: Complete System Loss
- **Description:** All local state files (task DB, daily logs, checkpoints) are lost or inaccessible.
- **Likelihood:** Low
- **Impact:** Critical — requires USER intervention

---

## Recovery Procedures

### RP1: Session Loss Recovery
**Trigger:** A task is IN_PROGRESS with no valid checkpoint written (CR7 violation or checkpoint failure).

**Procedure:**
1. Read HEARTBEAT.md for the most recent scan (last known state)
2. Read the daily log for the last active date to find in-progress tasks
3. For each in-progress task:
   a. Read task context for the last valid checkpoint or progress entry
   b. If no checkpoint exists, re-discover the task's state by reading the task's associated files/emails
   c. Create a new checkpoint for the task with step "0" (recovery step)
   d. Resume from the last known good step
4. If discovery fails for any task, mark it WAITING and escalate to USER

**Constraint:** Do not assume any state. Re-discover everything from evidence.

### RP2: Task DB Corruption Recovery
**Trigger:** Task DB file cannot be read, is malformed, or contains invalid data.

**Procedure:**
1. Check for the last golden snapshot in `archives/golden/`
2. If a golden snapshot exists (within 7 days), restore the task DB from the snapshot
3. If no recent golden snapshot exists, reconstruct the task DB:
   a. Scan HEARTBEAT.md for the most recent task list
   b. Cross-reference with daily logs for any tasks not in HEARTBEAT.md
   c. Create a new task DB with all discovered tasks
   d. Mark all recovered tasks as PENDING (state unknown)
4. Notify USER of recovery: "Task DB was corrupted. Recovered <N> tasks from HEARTBEAT.md and daily logs. All tasks marked PENDING. Verify and update priorities."

**Constraint:** Recovery is a best-effort reconstruction. The USER must verify task list and priorities.

### RP3: State Inconsistency Resolution
**Trigger:** Task state in DB does not match evidence in task context.

**Procedure:**
1. Identify the inconsistency:
   - Task shows COMPLETED but evidence shows IN_PROGRESS → revert to IN_PROGRESS
   - Task shows IN_PROGRESS but evidence shows COMPLETED → verify closer and mark COMPLETED
   - Task shows PENDING but evidence shows WAITING → update to WAITING
2. Log the inconsistency in the task context with timestamp and resolution
3. Update the task DB to match the evidence
4. If the inconsistency involves a COMPLETED task with insufficient validation, re-validate per COMPLETION_VALIDATION.md

**Constraint:** Evidence always wins. The task DB is the source of record for state, but evidence determines what that state should be.

### RP4: External System Conflict Resolution
**Trigger:** External system state (email, CRM) conflicts with local task DB state.

**Procedure:**
1. Identify the conflict:
   - External: invoice sent (confirmed) / Local: invoice PENDING
   - External: contract signed (confirmed) / Local: contract PENDING
   - External: payment received (confirmed) / Local: payment WAITING
2. Determine authoritative source:
   - For financial tasks: bank records > external confirmations > local state
   - For communication tasks: recipient acknowledgment > sender sent > local state
   - For procurement tasks: vendor confirmation > local state
3. Update local state to match the authoritative source
4. Log the resolution in the task context

**Constraint:** The authoritative source is defined per task category. Do not guess.

### RP5: Complete System Loss Recovery
**Trigger:** All local state files are lost or inaccessible.

**Procedure:**
1. Check for remote backups or cloud-synced versions of task DB, daily logs, and HEARTBEAT.md
2. If remote backups exist, restore them
3. If no remote backups exist:
   a. Notify USER: "Complete system loss detected. Local state files are unavailable. Please provide the latest versions of task DB, HEARTBEAT.md, and daily logs from another source."
   b. Wait for USER-provided files
   c. Upon receipt, validate and restore
4. If USER cannot provide files:
   a. Operate from memory only (no task DB)
   b. USER must re-input all active tasks
   c. No automation until state is restored

**Constraint:** This is a catastrophic scenario. USER involvement is mandatory. The agent cannot recover from complete state loss alone.

---

## Recovery Rules

### RR1: Recovery is Never Automatic for FC5
Complete system loss (FC5) always requires USER notification and involvement. The agent does not attempt to recover alone.

### RR2: All Recovery Actions Are Logged
Every recovery action — including state changes, task reassignments, and priority adjustments — is logged in the task context and a recovery log at `operations/runtime/RECOVERY_LOG.md`.

### RR3: Post-Recovery Validation
After any recovery:
1. All task states are verified against evidence
2. Priority classification is re-evaluated against current HEARTBEAT.md
3. All owners are confirmed (per TASK_OWNERSHIP.md)
4. A summary is sent to USER: "Recovered from <failure type>. <N> tasks restored. <N> tasks marked WAITING for confirmation. <N> priorities updated."

### RR4: Golden Snapshot Priority
If a golden snapshot exists (from ARCHITECTURE.md), it is the preferred recovery source for task DB reconstruction. Snapshots older than 7 days are not used without USER confirmation.

### RR5: Evidence Preservation
During any recovery, existing evidence files are NEVER deleted or overwritten. Evidence is preserved and used for reconstruction. Only the task DB state is rebuilt.

---

## Examples

### Example 1: Session Loss Recovery
```
Session crashes while processing task #47 (Canon payment).
No checkpoint written for #47.

Recovery:
  1. Read daily log for 2026-05-22
  2. Find: "Step 3 of 7 — composing confirmation email to Marco Guimaraes"
  3. No checkpoint exists → create recovery checkpoint for #47
  4. Read task context for last known state (step 2: PO sent)
  5. Resume from step 3 (compose email)
  6. Notify USER: "Session crashed during #47. Resumed from step 3. No data loss."
```

### Example 2: Task DB Corruption
```
Task DB is unreadable.

Recovery:
  1. Check archives/golden/ — no recent snapshot
  2. Read HEARTBEAT.md (2026-05-22) — discover 45 active tasks
  3. Cross-reference daily logs — add 3 tasks not in HEARTBEAT.md
  4. Reconstruct task DB with 48 tasks, all marked PENDING
  5. Notify USER: "Task DB corrupted. Recovered 48 tasks. All marked PENDING. Please verify priorities."
```

### Example 3: State Inconsistency
```
Task #48 shows COMPLETED in task DB.
Task context shows: invoice sent, no confirmation.

Recovery:
  1. Evidence shows: invoice sent, no confirmation received
  2. COMPLETION_VALIDATION.md criteria not met (no acknowledgment)
  3. Task state reverted to PENDING
  4. Inconsistency logged: "Task was incorrectly marked COMPLETED. State reverted to PENDING based on evidence."
  5. Follow-up scheduled for 2026-05-23
```

### Example 4: Complete System Loss
```
All files deleted.

Recovery:
  1. No remote backups found
  2. Notify USER: "Complete system loss. All local state files are unavailable. Please provide task DB, HEARTBEAT.md, and daily logs."
  3. Wait for USER response
  4. Restore from USER-provided files
  5. Validate and resume
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Recovery log itself is corrupted | Recovery log is recreated on next recovery event; data loss in recovery log is acceptable |
| Golden snapshot is also corrupted | Use HEARTBEAT.md + daily logs (RP2 fallback) |
| Recovery creates new conflicts | Post-recovery validation (RR3) catches and resolves |
| USER is unavailable during recovery | Agent operates with recovered state; notifies USER when available |
| Recovery is incomplete | Task remains in recovered state; USER verifies and corrects |

---

## Constraints

- **No new backup infrastructure.** Recovery uses existing state (task DB, daily logs, golden snapshots).
- **No automated recovery for FC5.** USER involvement is mandatory for complete state loss.
- **No recovery without logging.** Every recovery action is logged.
- **No evidence deletion.** Evidence is preserved during all recovery operations.
- **No recovery state assumption.** All state is re-derived from evidence. Nothing is assumed.
- **Backward compatible.** Existing recovery procedures (if any) are replaced by this protocol.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all recovery rules (absolute)

---

*Recovery is not restoration. It is reconstruction from evidence. When everything is lost, evidence is all that remains.*
