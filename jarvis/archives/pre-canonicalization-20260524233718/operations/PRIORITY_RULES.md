# PRIORITY_RULES.md — Operational Prioritization

*Priority rules. Loaded at init.*

---

## Priority Tiers

| Tier | Label | Description |
|---|---|-|
| T1 | CRITICAL | Revenue at risk, legal deadlines, system down |
| T2 | URGENT | Deadlines within 24h, blocked by others |
| T3 | HIGH | Deadlines within 48-72h, strategic importance |
| T4 | NORMAL | Standard operational work |
| T5 | LOW | Nice-to-have, no deadline pressure |

## Prioritization Rules

1. **Revenue always wins.** Any task blocking revenue is T1/T2.
2. **Deadlines compound.** A missed deadline bumps priority by 1 tier.
3. **Blocked items escalate.** Waiting on external parties auto-escalate every 24h.
4. **Multi-agent impact.** Work blocking multiple agents is higher priority.
5. **User direction overrides all.** USER priority is absolute.

## Escalation

- T1/T2 → notify USER immediately
- T3 → flag in heartbeat, no immediate user action needed
- T4/T5 → standard queue processing

---

*Priority is structural. Not opinion.*
