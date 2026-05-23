# JARVIS OS — Operational Framework

> Persistent Intelligence + Stateless Execution + Filesystem Persistence + Safe Automation

## Overview

JARVIS OS is a portable, filesystem-first operational architecture for the Jarvis agent (OpenClaw). It provides:

- **State persistence** via files, not conversation memory
- **Recovery** through immutable backups and snapshots
- **Safety** via staging/prod separation and resource limits
- **Portability** — clone, migrate, or replicate across environments

## Architecture

```
jarvis-os/
├── README.md              # This file
├── core/                  # Core runtime files
├── identity/              # SOUL, AGENTS, IDENTITY, USER
├── operations/            # Operational infrastructure
│   ├── logs/              # change.log, audit trails
│   ├── backups/           # Timestamped backups
│   ├── snapshots/         # Compressed recovery snapshots
│   ├── recovery/          # RECOVERY.md
│   ├── staging/           # Pre-production testing
│   ├── production/        # Active operational files
│   ├── heartbeats/        # Heartbeat definitions
│   ├── queues/            # Queue configurations
│   ├── workers/           # Worker definitions
│   ├── state/             # Runtime state files
│   ├── audit/             # Audit logs
│   ├── templates/         # File templates
│   └── safe_mode.md       # Safe mode rules
├── projects/              # Active project definitions
├── tasks/                 # Task definitions
├── memory/                # Long-term and daily memory
│   ├── daily/
│   └── summaries/
├── reports/               # Generated reports
├── agents/                # Agent configurations
├── skills/                # Skills definitions
├── workflows/             # Workflow definitions
├── config/                # Environment configs
├── bootstrap/             # BOOTSTRAP.md
├── deployment/            # DEPLOYMENT.md, migration, recovery
└── docs/                  # Documentation
```

## Safety Guarantees

1. **Identity protection** — SOUL.md, AGENTS.md, identity never modified by automation
2. **Staging-first** — all experiments validated in staging before production promotion
3. **Immutable backups** — timestamped snapshots before any major change
4. **Resource limits** — hard caps on concurrency, depth, spawn rates
5. **Safe mode** — automatic reduction if instability detected

## Quick Reference

| Command | Action |
|---------|--------|
| `/jarvis-os bootstrap` | Full system bootstrap |
| `/jarvis-os backup` | Create timestamped backup |
| `/jarvis-os deploy <from>` | Promote staging to production |
| `/jarvis-os recover <snapshot>` | Restore from snapshot |
| `/jarvis-os safe-mode` | Enter safe mode |
| `/jarvis-os validate` | Validate system integrity |

## Recovery Priority

1. RECOVERY.md → rebuild sequence
2. Latest backup → file restoration
3. REPOSITORY → git rollback
4. Identity files → personality preservation

---

*Created: 2026-05-22 | Version: 1.0.0 | Status: Phase 1 complete*
