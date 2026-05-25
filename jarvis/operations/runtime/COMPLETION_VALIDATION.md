# Completion Validation — Specification

---

## Purpose

Define the criteria and evidence requirements for closing any operational task. This protocol ensures that "COMPLETED" is a verified state, not an aspirational one. Every task close requires proof that the intended outcome was achieved.

**What it is:** The validation rules that gate every task state transition to COMPLETED.
**What it is not:** A new testing framework. Validation uses existing evidence types (file edits, DB entries, message confirmations, screenshots).

---

## Operational Semantics

Completion is a **binary assertion**: the task's objective has been fully achieved. Before any task state transitions to COMPLETED, the runtime must verify the objective against evidence. If evidence is insufficient, the task remains in its current state and the validation failure is logged.

The validation model is:

```
Task Definition → Validation Criteria → Evidence Required → Verification → COMPLETED
```

If any step in this chain fails, the task does not close. There is no partial completion.

---

## Validation Rules by Task Category

### Financial Tasks (revenue, payment, invoicing)
- **Validation criteria:** Payment received and recorded, OR invoice sent with recipient acknowledgment
- **Required evidence:** Bank transaction reference, payment confirmation email, or sent invoice with delivery proof
- **No acceptance of:** "Payment sent" without confirmation, "Invoice ready" without delivery proof

### Communication Tasks (follow-ups, escalations, messages)
- **Validation criteria:** Message delivered to intended recipient AND recipient has responded OR recipient's response window has elapsed (with follow-up logged)
- **Required evidence:** Sent message confirmation + recipient reply, or follow-up chain documenting attempted contact
- **No acceptance of:** "Email sent" without delivery confirmation when confirmation is available

### Procurement Tasks (purchases, quotes, orders)
- **Validation criteria:** Purchase order confirmed by vendor, OR quote received and evaluated, OR alternative source documented
- **Required evidence:** Vendor confirmation (email, message, or system), received quote document, or documented alternative
- **No acceptance of:** "Order placed" without vendor confirmation, "Quote requested" without receipt

### Logistics Tasks (shipping, delivery, logistics)
- **Validation criteria:** Shipment confirmed with tracking, OR delivery acknowledgment received, OR delivery delay documented with resolution
- **Required evidence:** Tracking number + carrier confirmation, recipient delivery receipt, or documented delay with resolution plan
- **No acceptance of:** "Shipped" without tracking, "Delivered" without confirmation

### Administrative Tasks (contracts, approvals, documentation)
- **Validation criteria:** Document signed/approved, OR rejection documented with reasons, OR alternative document produced
- **Required evidence:** Signed document, approval message, rejection with stated reasons, or replacement document
- **No acceptance of:** "Contract sent" without signing confirmation, "Approval pending" as a close reason

### Research / Verification Tasks
- **Validation criteria:** Information verified against source AND documented
- **Required evidence:** Source URL with timestamp, screenshot with context, or verified DB entry
- **No acceptance of:** "Checked" without source reference

### General Default (uncategorized tasks)
- **Validation criteria:** The explicit objective stated in the task definition is achieved
- **Required evidence:** Evidence appropriate to the objective (see above by category, or task-specific)
- **No acceptance of:** "Done" without evidence

---

## Validation Lifecycle

### Phase 1: Objective Extraction
When a task nears completion, the runtime extracts the task's objective from its definition in the task DB.

### Phase 2: Evidence Gathering
The runtime gathers all available evidence related to the task's objective. Evidence is drawn from: task context, file edits, message history, database entries, and external confirmations.

### Phase 3: Verification
Evidence is checked against the validation criteria for the task's category. Each criterion must pass.

### Phase 4: Validation Record
If all criteria pass, a validation record is written to the task context:
```
validation:
  passed_at: <ISO-8601>
  criteria_met: [list of criteria]
  evidence: [list of evidence references]
  validator: "Jarvis" (or USER if USER validates)
```

### Phase 5: State Transition
Only after Phase 4 succeeds does the task state transition to COMPLETED.

---

## Validation Rules

### VR1: Mandatory Validation
No task transitions to COMPLETED without a validation record in its context. A task without validation evidence in its context is GUARANTEED to remain in its current state.

### VR2: Category-Appropriate Criteria
Each task is classified into a validation category. The criteria for that category are mandatory. No category's criteria are relaxed without USER direction.

### VR3: Evidence Binding
Every validation criterion that passes must be bound to at least one evidence artifact. A criterion cannot pass on assertion alone.

### VR4: USER Override
USER can override any validation criterion with an explicit command. When USER directs a task close, VR1-VR3 are suspended for that task only.

### VR5: Incomplete Validation Escalation
If validation fails (criteria not met, evidence insufficient):
1. The task state reverts to the last valid non-COMPLETED state
2. The failure is logged in the task context
3. If the task is T1/T2, USER is notified
4. The task remains open for retry

### VR6: Time-Bound Validation
Some validation criteria have time bounds (e.g., "delivery acknowledgment within 24h"). If the time bound expires before evidence is available, the task cannot be marked COMPLETED — it must be escalated per VR5.

### VR7: Multi-Step Task Validation
For tasks with multiple discrete objectives (e.g., "purchase FX3 AND negotiate price AND confirm delivery"), ALL objectives must pass validation before the task closes. Partial completion is not valid.

---

## Examples

### Example 1: Panasonic Invoice (#48) — Financial
```
Task: #48 — Nota Cobrança Panasonic $9,620
Objective: Issue and deliver invoice to Panasonic for $9,620

Validation:
  Category: Financial
  Criteria:
    [ ] Invoice created with correct amount ($9,620) ✓
    [ ] Invoice delivered to Panasonic ✓
    [ ] Panasonic acknowledgment received ✗ (not yet)
  
  Result: FAIL — missing criteria
  Action: Task remains PENDING. Follow-up logged for 2026-05-23.
```

### Example 2: Canon C50 Sale (#12) — Procurement
```
Task: #12 — Venda Cage C50
Objective: Sell Cage C50 to Canon at agreed price

Validation:
  Category: Procurement (sale side)
  Criteria:
    [ ] Buyer confirmation received ✓
    [ ] Payment received ✓
    [ ] Cage C50 shipped with tracking ✓
  
  Result: PASS — all criteria met
  Validation record written.
  State transition: WAITING → COMPLETED
```

### Example 3: USER Override
```
Task: #43 — RigWheels Proposta (still pending vendor reply)
USER command: "Fecha o #43 como concluído, não preciso mais."

Result: VR4 applies — USER override.
  Task closes as COMPLETED.
  Override reason logged: "USER directed close despite incomplete criteria."
```

---

## Failure Modes

| Failure Mode | Protocol Response |
|---|---|
| Evidence disappears after validation | Validation record preserved; if evidence is critical and lost, task reverts to IN_PROGRESS |
| Criteria misclassification | Task re-classified; validation re-run against correct criteria |
| Time-bound criterion expires | VR6: task cannot close; escalation per VR5 |
| Multi-step partial completion | VR7: all steps must pass; task remains open with all step results logged |
| USER silent (no direction on validation failure) | VR5: USER is notified; task remains open |
| Validation record corruption | Previous valid validation is used; corruption is logged |

---

## Constraints

- **No new evidence types.** All evidence uses existing mechanisms (files, DB, messages, URLs).
- **No validation framework.** Validation is logical rules applied at close time, not an automated test suite.
- **No category taxonomy expansion.** The categories listed are the full taxonomy. If a task doesn't fit, it uses the General Default category.
- **No validation delay.** Validation is synchronous with the close action — it does not run asynchronously.
- **Backward compatible.** Existing COMPLETED tasks are assumed valid. Only future close actions require validation.

---

## Document Control

- **Version:** 1.0
- **Date:** 2026-05-25
- **Status:** Specification
- **Owner:** Jarvis (executive core)
- **Approval:** USER direction overrides all validation rules (absolute)

---

*COMPLETED means verified. Not started. Not attempted. Verified.*
