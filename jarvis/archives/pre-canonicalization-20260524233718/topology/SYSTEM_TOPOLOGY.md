# SYSTEM_TOPOLOGY.md — System Architecture Map

*Structural topology. Loaded at init. Not discovered.*

---

## Architecture

```
USER
  │
  ▼
JARVIS (Executive Core)
  │
  ├── Marquinhos (Growth Orchestrator)
  │     └── Stateless Workers (content, SEO, web)
  │
  ├── SYSTEM TOPOLOGY (this file)
  ├── AGENT REGISTRY (AGENT_REGISTRY.md)
  ├── PRIORITY RULES (PRIORITY_RULES.md)
  ├── STATE MACHINE (STATE_MACHINE.md)
  │
  └── OPERATIONAL MEMORY (memory/ directory)
        ├── ops/tasks.db        (SQLite)
        ├── ops/tasks.sh        (CLI)
        ├── ops/heartbeat.py    (Scanner)
        └── YYYY-MM-DD.md       (Daily logs)
```

---

## Infrastructure Layout

| Path | Purpose | Load? |
|---|---|-|
| `bootstrap/STARTUP_CONTEXT.md` | Deterministic startup awareness | ALWAYS |
| `topology/SYSTEM_TOPOLOGY.md` | System architecture | ALWAYS |
| `topology/AGENT_REGISTRY.md` | Agent definitions | ALWAYS |
| `operations/PRIORITY_RULES.md` | Prioritization rules | ALWAYS |
| `operations/STATE_MACHINE.md` | State transitions | ALWAYS |
| `identity/SOUL.md` | Agent personality | NEVER modify |
| `identity/AGENTS.md` | Workspace config | NEVER modify |
| `identity/USER.md` | User context | CONTEXT |
| `memory/` | Operational memory | RUNTIME |
| `operations/queues/` | Task queues | RUNTIME |
| `operations/backups/` | Snapshots | EVENT |

---

## Critical Constraints

1. **Deterministic > Probabilistic.** System structure is mounted, not searched.
2. **Awareness ≠ Absorption.** Knowing about an agent is not becoming that agent.
3. **Specialization preserved.** No cognitive fusion between agents.
4. **Workers are stateless.** No persistent cognition outside orchestration.
5. **Autonomous cron HELD.** No loops until startup awareness is stable.
6. **Identity boundaries are absolute.** SOUL.md is immutable.

---

*Topology is structural infrastructure. Not operational memory.*
