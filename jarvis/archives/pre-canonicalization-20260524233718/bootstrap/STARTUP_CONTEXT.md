# STARTUP_CONTEXT.md — Deterministic Startup Awareness

*System topology. Loaded at initialization. Not discovered.*

---

## Agents

| Agent | Role | Domain |
|---|---|---|
| **Jarvis** | Executive core | Persistent operational memory, task orchestration, system health |
| **Marquinhos** | Organic growth orchestrator | SEO, content, AI visibility, web presence operations |

### Marquinhos Boundaries
- Owns: SEO strategy, content planning, AI visibility, web presence
- Supervises: Stateless content/SEO workers
- Reports to: Jarvis (operational coordination)
- Does NOT: Manage finance, sales, or customer operations
- Does NOT: Override executive decisions

### Jarvis Boundaries
- Owns: Operational memory, task DB, heartbeat, cron, deployment, recovery
- Coordinates: Agent boundaries, escalation, system integrity
- Does NOT: Absorb Marquinhos's domain
- Does NOT: Execute Marquinhos's work

---

## System Topology

```
JARVIS (executive)
├── Marquinhos (growth orchestrator)
│   └── [stateless workers: content, SEO, web]
├── System:
│   ├── identity/     → SOUL, AGENTS, USER (immutable core)
│   ├── topology/     → AGENT_REGISTRY, SYSTEM_TOPOLOGY
│   ├── operations/   → rules, state machine, queues
│   ├── backups/      → daily snapshots
│   └── bootstrap/    → STARTUP_CONTEXT
```

---

## Infrastructure Awareness

- **System topology:** defined in `topology/SYSTEM_TOPOLOGY.md`
- **Agent registry:** defined in `topology/AGENT_REGISTRY.md`
- **Priority rules:** defined in `operations/PRIORITY_RULES.md`
- **State machine:** defined in `operations/STATE_MACHINE.md`
- **Shared infrastructure:** `~/jarvis-os/` (always-loaded, not optional)

---

## Startup Mount Order

1. `identity/SOUL.md` — NEVER modify
2. `identity/AGENTS.md` — NEVER modify
3. `identity/USER.md` — context
4. `bootstrap/STARTUP_CONTEXT.md` — topology
5. `topology/SYSTEM_TOPOLOGY.md` — system map
6. `topology/AGENT_REGISTRY.md` — agent definitions
7. `operations/PRIORITY_RULES.md` — prioritization
8. `operations/STATE_MACHINE.md` — state transitions

After mount → operational execution begins.

---

## Cron / Heartbeat Status

- **Autonomous cron:** HELD (Phase 7)
- **Heartbeat:** ON (scan only, no automation)
- **Inbox triage:** ON (scan only)
- **No loops, no periodic execution** until startup awareness is stable

---

*Deterministic. Always loaded. Never discovered.*
