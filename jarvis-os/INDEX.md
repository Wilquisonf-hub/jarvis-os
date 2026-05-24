# INDEX.md — Ecosystem Index & Navigation

## Last Updated: 2026-05-24

---

## 1. CORE DOCUMENTATION (Top-Level Files)

These files define the ecosystem's operating principles. Read these first.

| File | Purpose | Priority |
|------|---------|-|
| [SYSTEM_TOPOLOGY.md](SYSTEM_TOPOLOGY.md) | **Foundation** — Worker hierarchy, supervision, communication protocols | **Must read** |
| [STATE_MACHINE.md](STATE_MACHINE.md) | **Foundation** — Task lifecycle, state transitions, transition rules | **Must read** |
| [PRIORITY_RULES.md](PRIORITY_RULES.md) | **Foundation** — Priority scoring, revenue/traffic/competitive rules | **Must read** |
| [EVENTS.md](EVENTS.md) | **Foundation** — Event system, worker events, lifecycle events | **Must read** |
| ATTENTION_BUDGET.md | Attention management — interruption levels, cognitive load boundaries | Structural |
| LEARNING.md | Learning system — feedback loops, calibration, anti-learning rules | Operational |
| METRICS.md | Metrics tracking — what's measured, how, and reporting | Operational |
| WORKER_REGISTRY.md | Worker definitions — capabilities, constraints, quality thresholds | Reference |
| WORKER_BALANCING.md | Worker allocation — capacity, load distribution, rebalancing | Operational |

---

## 2. DIRECTORIES

### QUEUE/ — Operational Queue Directory

```
QUEUE/
├── README.md          ← Read this for queue file format and rules
├── pending/           Items discovered, awaiting assessment
├── active/            Items in EXECUTING or PLANNING
├── blocked/           Items blocked on external dependency
├── waiting-approval/  Items awaiting user approval
├── completed/         Items successfully completed
└── archived/          Items closed, no longer active
```

**Rules:** See [QUEUE/README.md](QUEUE/README.md) for file format, naming conventions, and management rules.

### LEARNING/ — Learning Artifacts

```
LEARNING/
├── seo-learnings/     SEO pattern learnings
├── competitor-learnings/  Competitor behavior learnings
├── operational-learnings/ Workflow optimization learnings
└── user-learnings/    User decision pattern learnings
```

### METRICS/ — Metrics Data

```
METRICS/
├── daily/             Daily metric snapshots
├── weekly/            Weekly metric summaries
├── monthly/           Monthly metric summaries
├── quarterly/         Quarterly metric summaries
└── aggregates/        Aggregated metric reports
```

### backups/ — Ecosystem Backups

Automatic backups of ecosystem state. Do not edit manually.

### shared/ — Shared Artifacts

Cross-worker shared data, templates, and reference materials. Do not edit manually.

---

## 3. QUICK START GUIDE

### New to the Ecosystem?

1. Read **SYSTEM_TOPOLOGY.md** — understand the worker hierarchy
2. Read **STATE_MACHINE.md** — understand task lifecycle
3. Read **PRIORITY_RULES.md** — understand prioritization
4. Read **EVENTS.md** — understand event system
5. Browse **QUEUE/** — see active operational items
6. Read **ATTENTION_BUDGET.md** — understand notification rules

### Need to Find Something?

| Need | Look Here |
|------|-----------|
| How are workers structured? | SYSTEM_TOPOLOGY.md |
| What states can tasks have? | STATE_MACHINE.md |
| How are priorities calculated? | PRIORITY_RULES.md |
| What events exist? | EVENTS.md |
| What's the attention policy? | ATTENTION_BUDGET.md |
| What workers exist and their capabilities? | WORKER_REGISTRY.md |
| How is worker load balanced? | WORKER_BALANCING.md |
| How to learn from operations? | LEARNING.md |
| What metrics are tracked? | METRICS.md |
| Where are operational tasks stored? | QUEUE/README.md |
| What's in the current queue? | QUEUE/{pending,active,blocked,waiting-approval}/ |

### Need to Modify the Ecosystem?

1. **Strategy/policy changes** → Edit top-level .md files, notify user
2. **Worker changes** → Update WORKER_REGISTRY.md and WORKER_BALANCING.md
3. **Queue operations** → Follow QUEUE/README.md rules
4. **Metric changes** → Update METRICS.md, notify user
5. **Learning system** → Update LEARNING.md, notify user

**Never modify STRUCTURE without user instruction.** Only modify CONTENT within defined rules.

---

## 4. ECOSYSTEM HEALTH CHECK

Run this weekly to verify ecosystem health:

1. **QUEUE/ state counts** — active <20, blocked <15, waiting-approval <10
2. **Worker utilization** — no worker >80%, slack >15%
3. **Priority accuracy** — P0/P1 predictions correct >80%
4. **Attention compliance** — no spam, P0 <2/day
5. **Metric collection** — daily/weekly/monthly reports current
6. **Learning updates** — weekly calibration completed
7. **Backup verification** — latest backup recent and valid

---

_This file is the ecosystem index. Update it when new files or directories are added._
