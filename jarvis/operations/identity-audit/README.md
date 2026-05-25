# operations/identity-audit/ — README

*Created: 2026-05-25*

## Purpose

Forensic audit of the identity boundary contamination that caused Jarvis to address you as "Marquinhos" instead of asking your name first.

## Files

| File | Purpose |
|---|---|
| `IDENTITY_BOUNDARIES.md` | Defines the four permanent identity boundaries (USER, JARVIS, MARQUINHOS, WORKERS) and the rules that keep them separate |
| `STARTUP_IDENTITY_TRACE.md` | Traces exactly how identity data flows through session startup — which files inject what, in what order, and how the contamination happens |
| `CONTAMINATION_POINTS.md` | Catalogs 10 contamination points (4 critical, 3 high, 3 medium) with exact file locations, content, and root cause analysis |
| `FIX_PLAN.md` | Step-by-step remediation: 6 fixes in priority order, verification tests, rollback plan |

## Root Cause

MEMORY.md is auto-injected at session start. It contains:
- "Marquinhos = the human"
- A hierarchy: MARQUINHOS (decision authority) → JARVIS
- A topology: USER (Marquinhos) → JARVIS

This makes every session begin with the false premise "the person I'm talking to = Marquinhos."

USER.md is intentionally blank — but the LLM ignores that because the auto-injected MEMORY.md overrides it.

## The Fix

1. Clean MEMORY.md: remove USER=Marquinhos equation, add boundary warning
2. Clean AGENT_REGISTRY.md: remove "Marquinhos is the USER" statement
3. Verify USER.md/IDENTITY.md remain blank
4. Run verification tests

## Scope

This is a DOCUMENTATION audit only. No files were modified. All changes are proposed in FIX_PLAN.md and require your approval before application.
