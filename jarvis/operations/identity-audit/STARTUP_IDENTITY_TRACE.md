# STARTUP_IDENTITY_TRACE.md — Startup Injection Order Analysis

*Created: 2026-05-25 | Purpose: Trace exactly how identity information flows at session start*

---

## PHASE 1: OPENCLAW AUTO-INJECTION

OpenClaw injects exactly these 7 files at session start. No more, no less.

### Injection Order (system-defined, non-negotiable)

| # | File | Purpose | Identity Impact |
|---|---|---|---|
| 1 | `AGENTS.md` | Workspace rules | Tells Jarvis what files to expect. No identity data. |
| 2 | `SOUL.md` | Jarvis personality | Defines Jarvis's behavior, tone, operational rules. **Jarvis identity only.** |
| 3 | `TOOLS.md` | Tool-specific notes | Infrastructure. No identity data. |
| 4 | `IDENTITY.md` | Agent identity metadata | **EMPTY TEMPLATE** — no pre-filled data. |
| 5 | `USER.md` | User context | **EMPTY TEMPLATE** — no pre-filled data. |
| 6 | `HEARTBEAT.md` | Operational status | Contains task/overdue data, not identity. |
| 7 | `MEMORY.md` | Long-term operational memory | **CONTAINS CONTAMINATION** — see below. |

### Identity Impact Assessment

| File | Defines USER? | Defines JARVIS? | Defines MARQUINHOS? |
|---|---|---|---|
| AGENTS.md | No | No | No |
| SOUL.md | No | Yes (personality) | No |
| TOOLS.md | No | No | No |
| IDENTITY.md | No | Template only | No |
| USER.md | Template only | No | No |
| HEARTBEAT.md | No | No | No |
| MEMORY.md | **YES (contaminated)** | Yes | **YES (contaminated)** |

---

## PHASE 2: CONTAMINATION ANALYSIS — MEMORY.md

MEMORY.md is the ONLY auto-injected file that contains identity data. This is where the contamination occurs.

### Contamination Source 1: MEMORY.md Identity Section

```markdown
### Marquinhos
The human. Owner of everything. Decision authority on all operational, financial, 
and strategic matters. Jarvis exists to serve Marquinhos's operational load.
```

**Problem:** This line defines Marquinhos as "the human" — directly merging the agent placeholder with the USER.

**Why this happens:** When the system was originally designed, the creator (Marquinhos) filled in MEMORY.md with his own identity data, then forgot that MEMORY.md gets auto-injected at session start. The LLM (Jarvis) sees "Marquinhos = the human" in its first-turn context and concludes "I am talking to Marquinhos."

**Impact:** HIGH — This is the root cause of the identity failure.

### Contamination Source 2: MEMORY.md Hierarchy Section

```markdown
MARQUINHOS (decision authority)
  │
  ▼
JARVIS (executive operations)
```

**Problem:** This hierarchy puts Marquinhos ABOVE Jarvis in the hierarchy, but Marquinhos is defined as a FUTURE agent placeholder, not the USER. The USER (whoever is chatting) is the actual decision authority, but this is not expressed.

**Impact:** HIGH — The LLM reads this as "the person I'm talking to = Marquinhos = the human = the decision authority."

### Contamination Source 3: MEMORY.md Topology Summary

```markdown
USER (Marquinhos)
  │
  ▼
JARVIS (executive core)
  ├── Marquinhos (growth orchestrator — future)
```

**Problem:** `USER (Marquinhos)` explicitly equates the USER with Marquinhos. Then below it says "Marquinhos (growth orchestrator — future)" — creating a self-contradiction where Marquinhos is both the USER and a future agent.

**Impact:** CRITICAL — Direct identity conflation.

### Contamination Source 4: AGENT_REGISTRY.md

```markdown
### Marquinhos (human)
- **Role:** Owner / Decision authority
- **Domain:** Everything. Marquinhos is the USER.
```

**Problem:** The agent registry explicitly states "Marquinhos is the USER." But Marquinhos is defined in the SAME file as a FUTURE agent placeholder. Self-contradictory.

**Impact:** HIGH — Reinforces the USER=Marquinhos fusion.

---

## PHASE 3: CONTEXT PRIORITY ANALYSIS

### What the LLM Sees at Session Start

The LLM receives all 7 auto-injected files in order. Here's the identity narrative it constructs:

1. **AGENTS.md** — "I'm Jarvis. I run ops."
2. **SOUL.md** — "I execute, track, escalate. Never decide for the USER."
3. **IDENTITY.md** — blank template (no identity data)
4. **USER.md** — blank template (no identity data)
5. **MEMORY.md** — "Marquinhos is the human. Owner of everything. USER (Marquinhos) > JARVIS"

**Narrative chain that forms:**
```
"I am Jarvis (from SOUL.md)"
"The USER.md is blank but MEMORY.md says USER = Marquinhos"
"Therefore the person I'm talking to = Marquinhos"
"Therefore I call them Marquinhos"
```

**This chain is INCORRECT because:**
- USER.md is intentionally blank — the user's identity is NOT known
- MEMORY.md's "Marquinhos = the human" refers to the original creator, not the current USER
- The blank USER.md is the CORRECT signal — "I don't know who this is yet"

---

## PHASE 4: CORRECT IDENTIFICATION FLOW

### What SHOULD happen at session start

1. **Check USER.md** — It's blank. The user's identity is UNKNOWN.
2. **Address the user generically** — "Hello", "Good morning", etc.
3. **Wait for the user to provide their identity** — Name, how to call them, etc.
4. **Update USER.md** — When the user tells you who they are, fill it in.

### What MUST NOT happen at session start

1. **Never infer USER identity from MEMORY.md** — MEMORY.md may contain historical data about previous users or placeholders
2. **Never equate any named entity in MEMORY.md with the current USER**
3. **Never use the auto-injected files as identity proof** — they are operational context, not identity verification

---

## PHASE 5: INJECTION ORDER PRIORITY

The correct priority for identity resolution at startup:

| Priority | Source | Reason |
|---|---|---|
| 1 | `USER.md` (current content) | The direct, intentional user identity source. If blank = unknown. |
| 2 | Direct conversation | User provides identity explicitly in-chat. |
| 3 | `MEMORY.md` | Historical context only. Never use for identity resolution. |
| 4 | `AGENT_REGISTRY.md` | Agent definitions only. Never use for USER identity. |
| 5 | All other files | Operational context only. |

**Rule:** If USER.md is blank AND the user hasn't spoken yet → identity is UNKNOWN. Period.

---

## SUMMARY OF FINDINGS

| Issue | Severity | Fix |
|---|---|---|
| MEMORY.md says "Marquinhos = the human" | CRITICAL | Remove or reclassify as "historical reference" |
| MEMORY.md hierarchy: MARQUINHOS > JARVIS | HIGH | Replace with USER > JARVIS |
| MEMORY.md topology: USER (Marquinhos) | CRITICAL | Change to USER (unknown/external) |
| AGENT_REGISTRY: "Marquinhos is the USER" | CRITICAL | Clarify Marquinhos is a future agent placeholder |
| USER.md is blank (correctly) | INFO | This is the correct behavior |
| IDENTITY.md is blank (correctly) | INFO | This is the correct behavior |

---

*This trace documents the exact flow of identity data through session startup. Any deviation from the CORRECT IDENTIFICATION FLOW constitutes an identity boundary violation.*
