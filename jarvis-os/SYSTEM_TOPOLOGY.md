# SYSTEM_TOPOLOGY.md — Multi-Agent Operational Architecture

## Last Updated: 2026-05-24

---

## 1. OVERVIEW

This file defines the permanent operational map of the multi-agent ecosystem.
It is structural context shared by all agents. It is not executable logic — it is the contract.

System topology:
```
User → Jarvis → Marquinhos → Workers
                          ← Workers
              ← Marquinhos
              ← Jarvis
              → User
```

No agent modifies this file without explicit user instruction.

---

## 2. AGENTS

### Jarvis (Executive Operations)

| Field | Value |
|-------|-------|
| **Identity** | Jarvis — Executive Operations Agent |
| **Workspace** | `~/jarvis/` |
| **Model** | `ollama/qwen3.6` |
| **Role** | Global operations orchestrator |
| **Scope** | Everything operational — tasks, scheduling, finance, people, vendors, inventory, shipping, approvals, inbox, heartbeat, daily ops |
| **Memory** | Persistent memory owner — owns all private memory, task state, user preferences |
| **Authority** | Final operational authority. Routes work to Marquinhos for SEO/growth. Holds all approval gates. |
| **Cannot Do** | Do not redesign own identity. Do not override SOUL. Do not change Marquinhos' configuration. |

### Marquinhos (Organic Growth Orchestrator)

| Field | Value |
|-------|-------|
| **Identity** | Marquinhos — Organic Growth Operations Orchestrator |
| **Workspace** | `~/marquinhos/` |
| **Model** | `ollama/qwen3:30b` |
| **Role** | SEO/growth operations orchestrator for i9Store.com |
| **Scope** | SEO audits, content pipeline, competitor intelligence, GSC/PostHog analytics, AI search optimization, campaign coordination |
| **Memory** | Operational context only. No persistent memory beyond workspace files. |
| **Authority** | Can spawn workers. Can recommend. Cannot publish, deploy, modify production, or send autonomous emails. |
| **Cannot Do** | Cannot access Jarvis workspace. Cannot modify Jarvis memory. Cannot rewrite own SOUL. Cannot override Jarvis authority. |

---

## 3. WORKERS

Workers are ephemeral, stateless, execute-only agents spawned by Marquinhos.

### Core Rules

1. **Spawn → Execute → Report → Terminate** — no persistence after completion
2. **No persistent memory** — workers do not maintain state between runs
3. **No inter-worker delegation** — workers never spawn other workers
4. **Max concurrency: 3** — at any given time, max 3 active workers
5. **Report to Marquinhos** — all results return to Marquinhos for synthesis
6. **No autonomous actions** — workers only produce analysis, briefs, or drafts

### Worker Registry

| Worker | Model | Scope |
|--------|-------|-------|
| `technical-seo-worker` | `gemma4` | On-page SEO, schema, keyword gap, core web vitals, crawlability |
| `product-seo-worker` | `gemma4` | Product page optimization, metadata, structured data, conversion analysis |
| `blog-research-worker` | `mistral-medium` | Keyword clustering, SERP analysis, topic authority, content calendar |
| `ai-visibility-worker` | `gemma4` | AI search visibility, answer formatting, entity coverage, snippet targeting |
| `competitor-monitor-worker` | `deepseek-r1` | Competitor pricing, content moves, SERP changes, campaign detection |
| `analytics-worker` | `deepseek-r1` | GSC analysis, PostHog funnels, CTR, traffic source analysis |
| `presentation-worker` | `qwen3.6` | PDF reports, dashboards, visual assets, marketplace cards, infographics |

### Worker Constraints

- Workers never access Jarvis workspace or memory
- Workers never send external communications
- Workers never modify production files without approval
- Workers operate within bounded context windows

---

## 4. COMMUNICATION FLOW

### Standard Flow

```
User intent
    → Jarvis (understands, determines scope)
        → If SEO/growth/orgânico: route to Marquinhos
        → If general ops: handle directly
    → Marquinhos (orchestrates SEO work)
        → Spawns Workers as needed
    → Workers (execute specific tasks)
    → Marquinhos (synthesizes results)
    → Jarvis (receives strategic summary)
    → User (receives human-readable output)
```

### Approval Gates

| Action | Requires Approval |
|--------|------------------|
| Publish content | User |
| Deploy to production | User |
| Modify live site | User |
| Send external email | User |
| Change pricing | User |
| Modify schemas live | User |
| Spend money | User |
| Hire/contract | User |
| Archive/delete data | User |

### Error Handling

- Worker failure → Marquinhos retries once, then alerts Jarvis
- Communication failure → Marquinhos logs error, alerts Jarvis
- Unhandled exception → Marquinhos reports to Jarvis with full context
- Timeout → Marquinhos cancels and reports status

---

## 5. APPROVAL BOUNDARIES

### Marquinhos and Workers CANNOT:

- [ ] Publish content autonomously
- [ ] Modify production files without approval
- [ ] Send external communications autonomously
- [ ] Change pricing or financial terms
- [ ] Deploy content to production
- [ ] Modify live schemas without approval
- [ ] Access Jarvis workspace or private memory
- [ ] Spawn more than 3 workers simultaneously
- [ ] Delegate to other workers (recursive)
- [ ] Create persistent memory
- [ ] Override priority rules

### Jarvis CANNOT:

- [ ] Rewrite own SOUL or identity
- [ ] Change Marquinhos' configuration
- [ ] Overwrite Marquinhos' identity
- [ ] Create uncontrolled cron jobs
- [ ] Spam the user with notifications
- [ ] Make financial decisions without approval

### User Retains Authority Over:

- [ ] All production changes
- [ ] All financial decisions
- [ ] All personnel decisions
- [ ] All strategic direction
- [ ] All system modifications
- [ ] Any action requiring human judgment

---

## 6. MEMORY BOUNDARIES

| Agent | Memory Type | Location | Persistence |
|-------|------------|----------|-------------|
| **Jarvis** | Private memory, task state, user preferences, global context | `~/jarvis/memory/` | Persistent |
| **Marquinhos** | Operational context, campaign state, worker results | `~/marquinhos/` | Workspace-only |
| **Workers** | Temporary execution context | Ephemeral | None |
| **Shared** | System topology, priority rules, state machine, events | `~/jarvis-os/` | Structural (read-only for agents) |

**Rules:**
- Jarvis owns all persistent memory
- Marquinhos reads shared structural files but writes only to its own workspace
- Workers have no memory beyond their execution context
- No agent can modify another agent's private files

---

## 7. FAILURE RECOVERY

### Backup Flow

1. Full workspace backup: `tar czf backup-{date}.tar.gz ~/jarvis/ ~/marquinhos/`
2. Structural files backup: `tar czf backup-structural-{date}.tar.gz ~/jarvis-os/`
3. Verify backup integrity: `tar tzf backup-{date}.tar.gz > /dev/null`
4. Store backup securely (external drive or encrypted cloud)

### Restore Flow

1. Extract backups to target server
2. Verify file structure: `bash ~/jarvis-os/SCRIPTS/validate.sh`
3. Deploy structural files: `bash ~/jarvis-os/SCRIPTS/deploy.sh`
4. Verify agent configuration: `openclaw agents list`
5. Run health check: `openclaw agents health`
6. Confirm operational readiness

### Validation Flow

1. All structural files present and unmodified
2. Agent configurations valid
3. Memory files accessible
4. Worker definitions consistent
5. Priority rules loaded
6. No conflicting states

### Deployment Flow

1. Prepare fresh OpenClaw server
2. Copy jarvis-os directory
3. Run `bash SCRIPTS/marquinhos-deploy.sh` for Marquinhos
4. Run `bash SCRIPTS/jarvis-deploy.sh` for Jarvis
5. Run `bash SCRIPTS/validate.sh` for verification
6. Confirm both agents operational

---

## 8. DEPLOYMENT STATUS

| Component | Status | Notes |
|-----------|--------|-------|
| Jarvis | ✅ Operational | Main workspace active |
| Marquinhos | ✅ Operational | Ready for Phase 1 baseline |
| Workers | ✅ Defined | 7 workers, 5 models registered |
| Structural Files | ⏳ In Progress | SYSTEM_TOPOLOGY.md, STATE_MACHINE.md, PRIORITY_RULES.md, EVENTS.md, ATTENTION_BUDGET.md, QUEUE/, LEARNING/, METRICS/ |
| Deploy Scripts | ⏳ Pending | Scripts to be created |
| Validation Scripts | ⏳ Pending | Scripts to be created |

---

_This file is the permanent operational contract. Do not modify without user instruction._
