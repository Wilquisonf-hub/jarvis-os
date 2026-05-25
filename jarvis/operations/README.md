# operations/ — System Rules & State Management

This directory contains the operational rules that govern how Jarvis OS functions:

| File | Purpose |
|------|---------|
| `PRIORITY_RULES.md` | Priority tiers and task classification |
| `STATE_MACHINE.md` | Task state transitions (NEW → ACTIVE → ...) |
| `RECOVERY.md` | Disaster recovery procedures |
| `SCRIPTS.md` | Available automation scripts |
| `safe_mode.md` | Safe mode protocol |

## Runtime Rules (`runtime/`)

| File | Purpose |
|------|-----|--|
| `EXECUTION_PROTOCOL.md` | Step-by-step execution, progress tracking, execution state |
| `INTERRUPTIBILITY_RULES.md` | Interrupt handling during active execution |
| `COMPLETION_VALIDATION.md` | Criteria and evidence for COMPLETED state transitions |
| `TASK_OWNERSHIP.md` | Ownership assignment, transfer, and escalation |
| `MESSAGE_ROUTING.md` | Recipient routing, context attachment, reply threading |
| `RECOVERY_PROTOCOL.md` | Recovery procedures for catastrophic failures |
| `CHECKPOINT_PROTOCOL.md` | Checkpoint types, lifecycle, and consistency rules |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `audit/` | Audit logs and compliance records |
| `backups/` | Backup manifests and snapshots |
| `heartbeats/` | Heartbeat scan results |
| `queues/` | Task queues and dispatch |
| `state/` | Current system state snapshots |
| `templates/` | Standardized document templates |
| `workers/` | Worker node definitions |

*All files in `operations/` are SYSTEM (always loaded, do not alter structure).*
