# Architecture — jarvis-os v2 (Operational Side)

> **Status:** Planning — jarvis-os v1 was the stable cognition baseline.
> v2 is the operational refactor for the executive operations system (current session).

---

## Phase Map

### Phase 1 — Foundation ✅
- Architecture spec (this file) — 2026-05-25
- Task ownership spec — 2026-05-25
- Message routing spec — 2026-05-25
- Recovery protocol spec — 2026-05-25
- Completion validation spec — 2026-05-25
- Runtime rules (checkpoint, execution, interruptibility) — 2026-05-25

### Phase 2 — Infrastructure (planned)
- Task DB migration (add owner, validation, routing fields)
- Recovery log system
- Post-recovery validation automation
- Golden snapshot extension to operational state

### Phase 3 — Integration (planned)
- Runtime rules enforced in session startup
- Cross-file dependency validation
- Recovery testing procedures

### Phase 4 — Governance (planned)
- Audit trail for all operational decisions
- Priority drift detection
- Ownership accountability reporting

---

## Architecture Decisions

| # | Decision | Rationale | Consequence |
|-|-|---|-|-|
| AD1 | One file per rule | Clear ownership, easy to find, no cross-referencing chaos | ~7 files, each ~200 lines. Manageable. |
| AD2 | Rules use existing evidence | No new file types, no new tools | Validation uses files/DB/messages already in the system |
| AD3 | USER overrides everything | Governance must be human-ultimate | No automation can override USER direction |
| AD4 | Recovery is reconstruction, not restoration | Backups may be stale; evidence is fresher | Recovery may produce different state than pre-failure — that's OK if consistent |
| AD5 | Ownership is singular, not shared | Shared ownership = no ownership | Clear accountability, even if the owner is an agent |
| AD6 | No new infrastructure | jarvis-os is minimal | All rules use existing task DB, files, messaging |

---

## Runtime Rule Map

```
operations/runtime/
├── CHECKPOINT_PROTOCOL.md    — Checkpoint types, lifecycle, consistency
├── COMPLETION_VALIDATION.md  — Evidence criteria for task completion
├── EXECUTION_PROTOCOL.md     — Step-by-step execution rules
├── INTERRUPTIBILITY_RULES.md — Interrupt handling during execution
├── MESSAGE_ROUTING.md        — Recipient routing, context, threading
├── RECOVERY_PROTOCOL.md      — Catastrophic failure recovery
└── TASK_OWNERSHIP.md         — Ownership assignment, transfer, escalation
```

---

*This is the operational architecture — not a replacement for jarvis-os v1, but a parallel track for executive operations.*
