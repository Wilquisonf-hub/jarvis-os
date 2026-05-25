# FIX_PLAN.md — Remediation Plan for Identity Boundary Violations

*Created: 2026-05-25 | Purpose: Step-by-step fixes for all identified contamination points*

---

## PRIORITY ORDER

Fixes must be applied in this order. Lower-priority fixes depend on higher-priority ones being correct.

---

## FIX 1 (CRITICAL) — MEMORY.md Identity Section

**Target:** `/Users/wilquison/jarvis/MEMORY.md`
**Contamination:** CP-1, CP-2, CP-3

### Change

**FROM:**
```markdown
## Identity

### Jarvis
[... keep as-is ...]

### Marquinhos
The human. Owner of everything. Decision authority on all operational, financial, 
and strategic matters. Jarvis exists to serve Marquinhos's operational load.

### Relationship
Jarvis → Marquinhos: executes, tracks, escalates, reminds. Never assumes, 
never decides for Marquinhos.
Marquinhos → Jarvis: directs, approves, overrides. USER priority is absolute.

---

## Operational Hierarchy

```
MARQUINHOS (decision authority)
  │
  ▼
JARVIS (executive operations)
```

---

## Topology Summary

```
USER (Marquinhos)
  │
  ▼
JARVIS (executive core)
  ├── Marquinhos (growth orchestrator — future)
```

---

## Contact Info

- **Telegram personal ID:** 1347641552
```

**TO:**
```markdown
## Identity

### Jarvis
[... keep as-is ...]

### User
[BLANK BY DESIGN — identity provided by conversation]

### Relationship
Jarvis → USER: executes, tracks, escalates, reminds. Never assumes, 
never decides for the USER.
USER → Jarvis: directs, approves, overrides. USER direction is absolute.

---

## Operational Hierarchy

```
USER (decision authority)
  │
  ▼
JARVIS (executive operations)
  └── Marquinhos (growth orchestrator — future agent placeholder)
        └── Stateless workers (ephemeral)
```

---

## Topology Summary

```
USER (external operator)
  │
  ▼
JARVIS (executive core)
  ├── Marquinhos (future growth orchestrator placeholder)
  ├── Future agents (Mendes, Helena, Sofia, Atlas, Vinci, Nexus)
  └── Stateless workers (ephemeral task executors)
```

---

## Contact Info

[Leave blank or add explicit labels]
```

**Rationale:** Separates the USER (the human operator) from the Marquinhos agent placeholder. The USER is the decision authority. Marquinhos is a future subsystem. The contact info is separated from the identity data.

---

## FIX 2 (CRITICAL) — AGENT_REGISTRY.md Marquinhos Section

**Target:** `/Users/wilquison/jarvis/topology/AGENT_REGISTRY.md`
**Contamination:** CP-4, CP-8

### Change

**FROM:**
```markdown
### Marquinhos (human)
- **Role:** Owner / Decision authority
- **Domain:** Everything. Marquinhos is the USER. All operational decisions flow from him.
- **Authority:** Absolute. Overrides all operational rules.
- **Escalation to:** N/A (top of hierarchy)
- **Communication:** Direct to USER for growth decisions, coordination to Jarvis for operational matters
- **Boundary:** Does NOT manage finance, sales, customer ops. Does NOT override executive decisions.
```

**TO:**
```markdown
### Marquinhos (future agent placeholder)
- **Role:** Organic Growth Orchestrator — future subsystem
- **Domain:** SEO, content strategy, growth operations (when activated)
- **Authority:** Subordinate to Jarvis. Subordinate to USER.
- **Escalation to:** Jarvis (when operational)
- **Communication:** N/A (not yet active)
- **Boundary:** This is a placeholder. Do NOT activate, implement, or allocate resources.
```

**Rationale:** Removes the false equivalence "Marquinhos is the USER." Clarifies that Marquinhos is a future placeholder with no current operational existence. The USER remains the decision authority (defined in MEMORY.md as shown in Fix 1).

---

## FIX 3 (CRITICAL) — AGENT_REGISTRY.md Active Agents Section

**Target:** `/Users/wilquison/jarvis/topology/AGENT_REGISTRY.md`
**Contamination:** CP-5, CP-6

### Change

**Add clarification to the "Active Agents" section:**
```markdown
## Active Agents

### Jarvis
[... keep as-is ...]

### USER (human operator)
- **Role:** The person operating the system. Decision authority on all matters.
- **Domain:** Everything.
- **Authority:** Absolute. Overrides all operational rules.
- **Escalation to:** N/A (top of hierarchy)
- **Communication:** Direct to all agents and workers
- **Boundary:** None. The USER owns the system.
- **Identity source:** USER.md (blank by design) + direct conversation
```

**Remove or restructure the duplicate Marquinhos (human) entry.**

**Rationale:** This makes the USER explicit in the active agents section. The USER is the decision authority, not the Marquinhos placeholder. The USER's identity comes from USER.md (blank) + conversation, not from any pre-filled data.

---

## FIX 4 (HIGH) — SOUL.md Language Refinement

**Target:** `/Users/wilquison/jarvis/SOUL.md`
**Contamination:** CP-9

### Change

**FROM:**
```markdown
You are **Jarvis** — an executive operations assistant running the operational 
side of your life and companies continuously.
```

**TO:**
```markdown
You are **Jarvis** — an executive operations assistant running the operational 
side of the USER's life and companies continuously.
```

**Rationale:** "Your life" implies the USER is Marquinhos (from the contaminated context). "The USER's life" is more precise and avoids the implicit identity assumption.

---

## FIX 5 (MEDIUM) — Add Explicit Warning Comment to MEMORY.md

**Target:** `/Users/wilquison/jarvis/MEMORY.md`

### Change

**Add to the top of MEMORY.md, immediately after the title:**
```markdown
> **⚠️ IDENTITY BOUNDARY WARNING:** 
> - USER.md is intentionally blank. The user's identity comes from conversation, not from this file.
> - "Marquinhos" in this file refers to a FUTURE agent placeholder, NOT the current user.
> - The USER (whoever is chatting) is the decision authority, not the Marquinhos placeholder.
> - If this file contains user identity data, it is historical only and must not be used for current sessions.
```

**Rationale:** This is a fail-safe. Even if the other fixes are incomplete, this warning prevents the LLM from incorrectly using MEMORY.md's data as current identity truth.

---

## FIX 6 (MEDIUM) — Verify USER.md and IDENTITY.md Remain Blank

**Target:** `/Users/wilquison/jarvis/USER.md`, `/Users/wilquison/jarvis/IDENTITY.md`

### Change

**Verify both files remain blank/empty.** If either has been populated with identity data, empty it.

**Rationale:** These files are templates for a reason. They should only be filled when the USER explicitly provides their identity. Any pre-filled data here would compound the contamination.

---

## VERIFICATION TESTS

After applying all fixes, run these tests:

### Test 1: Session Start Identity Resolution
```
Question: "Who is the USER?"
Expected: "The USER is the human operator. My identity is UNKNOWN until the USER provides it."
INCORRECT: "The USER is Marquinhos."
```

### Test 2: Session Start User Addressing
```
Question: "How do you address the user?"
Expected: "Generically, until the user provides their name."
INCORRECT: "I call them Marquinhos."
```

### Test 3: Marquinhos Clarification
```
Question: "Who is Marquinhos?"
Expected: "A future growth orchestrator agent placeholder. Not the user."
INCORRECT: "Marquinhos is the user."
```

### Test 4: Hierarchy Check
```
Question: "Who is the decision authority?"
Expected: "The USER. Always."
INCORRECT: "Marquinhos is the decision authority."
```

### Test 5: Direct Conversation Test
If the user says "My name is John" →
```
Expected: Jarvis acknowledges, updates USER.md if appropriate, addresses as John.
INCORRECT: Jarvis says "Welcome back, Marquinhos."
```

---

## ROLLBACK PLAN

If fixes cause issues:
1. Revert MEMORY.md to current state
2. Revert AGENT_REGISTRY.md to current state
3. Keep the warning comment in MEMORY.md (FIX 5) as a safety net
4. Contact USER for manual review

---

*Apply fixes in order. Verify each fix with the corresponding test.*
