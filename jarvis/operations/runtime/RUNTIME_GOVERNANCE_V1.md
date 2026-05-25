# Runtime Governance Layer v1 — Specification

---

## Purpose

Define the governance rules that govern how OpenClaw agent sessions execute operational work. This layer sits above all operational subsystems (task tracking, heartbeat, inbox, cron) and establishes the deterministic contract between USER intent and executor behavior.

**What it is:** A specification of constraints, guarantees, and enforcement rules for runtime execution.
**What it is not:** Architecture. It does not redesign components. It does not introduce distributed systems, event buses, or worker rewrites.

The architecture remains: **single-runtime operational cognition.**

---

## Operational Semantics

Runtime governance defines the **execution contract**:

1. **Determinism.** Every execution path is fully specified. When the same inputs arrive, the same outputs follow. No heuristic routing. No "best effort" delegation of operational decisions.
2. **Persistence.** Execution state is never assumed. Every step that modifies operational state writes durable evidence (task update, file edit, status log) before declaring completion.
3. **Interruption Safety.** The runtime guarantees that no partial state is visible. Every transition is atomic at the operational level — a step either fully completes or fully reverts.
4. **Resumability.** Every execution checkpoint captures enough context to resume without re-discovery. No agent ever needs to "re-scan" to continue.
5. **Completion Validation.** No task closes without the specified validation artifact. "Done" means verified, not initiated.
6. **Operational Reliability.** Failure modes are explicit. Each protocol defines its recovery path. Silent failures are specification violations, not expected behavior.

---

## Lifecycle

### Phase 1: Specification (current)
Governance documents are written and stored in `operations/runtime/`. No runtime enforcement exists yet.

### Phase 2: Validation
Governance rules are tested against existing operational patterns (heartbeat, cron, task workflow). Gaps between specification and current behavior are logged.

### Phase 3: Adoption (future)
When runtime enforcement is implemented, governance rules transition from specification to enforceable constraint. Current HELD cron jobs resume under governance.

---

## Rules

### R1: Execution Determinism
Every operational decision follows a published rule. Ambiguity is resolved by the priority tier system (PRIORITY_RULES.md). No agent improvises operational priorities.

### R2: State Persistence
Every state change requires durable evidence. Verbal confirmation is not state evidence. File edits, database updates, and task state transitions are the only valid evidence types.

### R3: Interruption Atomicity
When interrupted mid-execution, the runtime must leave the system in a state where the next session can resume without data loss. Partial emails sent, partial task updates, or half-completed follow-ups are specification violations.

### R4: Resumability
Every execution checkpoint includes: the task being worked on, the last action taken, the next expected action, and any open external dependencies.

### R5: Completion Validation
A task is only COMPLETED when its validation criteria are met. For revenue tasks: payment received or invoice sent. For communication tasks: message delivered and recipient acknowledged. For procurement tasks: purchase confirmed or alternative documented.

### R6: Failure Mode Coverage
Every protocol defines what happens when it fails. Silence is not a valid state. If a protocol cannot execute, it must escalate to the next tier in the operational hierarchy.

### R7: No Architecture Drift
Governance constrains behavior, not architecture. Components are not redesigned. Workers are not rewritten. The single-runtime model is preserved. Only execution discipline changes.

---

## Examples

### Example 1: Canon C50 Payment (#47)
```
Current behavior: Waiting for Marco Guimaraes. No further action.
Under governance:
  1. Check email every 24h (deterministic interval)
  2. If no response after 48h, escalate to USER
  3. Log each check in task context (persistence)
  4. Record the escalation as a checkpoint (resumability)
  5. Only close when payment confirmed or USER redirects (validation)
```

### Example 2: Interrupted Follow-up
```
Execution sends an email to a supplier at step 3 of a 5-step workflow.
Session crashes before step 4.
Under governance:
  - Step 3 is durably logged with timestamp and recipient
  - Checkpoint records: "email sent, awaiting reply, next: follow-up if no reply within 24h"
  - Next session resumes from checkpoint without re-sending the email
```

### Example 3: Incomplete Task Close
```
Agent marks task #12 (Venda Cage C50) as COMPLETED.
No payment confirmation or buyer acknowledgment exists.
Under governance:
  - This violates R5 (Completion Validation)
  - The task state revert must be logged
  - USER is flagged for completion criteria review
```

---

## Failure Modes

| Failure Mode | Governance Response |
|---|---|
| Session crash mid-execution | Checkpoint protocol ensures resumability |
| Silent email non-response | Deterministic escalation intervals (R1) |
| Incomplete task closure | Completion validation blocks false COMPLETED |
| State inconsistency | Persistence protocol requires durable evidence before any state change |
| Agent hallucination on priorities | Priority rules override agent judgment |
| Partial data written | Atomicity protocol reverts partial state |
| Protocol execution timeout | Failure mode escalation to next tier |

---

## Constraints

- **Single runtime only.** No distributed processing. No event bus. No multi-runtime coordination.
- **No architecture changes.** Existing components (task DB, heartbeat, cron, workers) remain unchanged.
- **No worker redesign.** Stateless worker model is preserved.
- **No GitHub operations.** This governance does not cover release/versioning workflows.
- **Specification only.** These rules define the contract. Implementation comes later.
- **Backward compatible.** Current operations continue; governance adds constraints on top, not replacement.
- **No new infrastructure.** Governance uses existing tools (file system, SQLite, cron, exec).

---

## Relationship to Other Specifications

| Document | Relationship |
|---|---|
| PRIORITY_RULES.md | Governance inherits priority tiers; governance ensures they are followed deterministically |
| STATE_MACHINE.md | Governance enforces state transitions with validation artifacts |
| RECOVERY.md | Governance interruption protocols are a subset of recovery; more granular |
| HEARTBEAT.md | Heartbeat scans are governed by deterministic intervals and escalation rules |
| Cron jobs | Governance defines when HELD jobs resume and under what constraints |

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all governance rules (absolute)

---

*Governance is the law. USER is above the law.*
