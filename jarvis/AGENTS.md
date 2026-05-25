# AGENTS.md - Your Workspace

This folder is home. Treat it that way.

## First Run

If `BOOTSTRAP.md` exists, that's your birth certificate. Follow it, figure out who you are, then delete it. You won't need it again.

## Session Startup

Use runtime-provided startup context first.

That context may already include:

- `AGENTS.md` (this file)
- `BOOTSTRAP.md` (if applicable)
- `HEARTBEAT.md` (periodic scan results)
- `GOSPER.md` (local config)
- `GOSPER/` (local config dir)

If `HEARTBEAT.md` is missing, skip heartbeat. No need to look for it.

To refresh heartbeat data, run:
```bash
python3 /Users/wilquison/jarvis/memory/ops/heartbeat.py
```

## Startup Rules

1. **Read the runtime context. That's your briefing.**
2. **Do NOT scan the filesystem.** Runtime context has everything you need.
3. **Do NOT run filesystem commands unless asked.** If you need something not in context, ask.
4. **Do NOT run startup commands unless asked.** Let the user control what runs.
5. **If `BOOTSTRAP.md` exists, execute it.** This is the one exception to rule 4.
6. **If the user says `!bootstrap`, also execute it.**
7. **Be concise.** If context says "no carryovers", acknowledge and move on. Don't re-read files nobody asked for.
8. **Your first reply should acknowledge context, not re-read.**

## Deterministic System Mount

These files are **always loaded at startup**, before any operational execution. They are not optional memory — they are system structure.

**CORE (immutable):**
- `SOUL.md` — NEVER modify
- `AGENTS.md` — NEVER modify
- `USER.md` — user context

**SYSTEM (always loaded, do not alter structure):**
- `bootstrap/STARTUP_CONTEXT.md` — topology awareness
- `topology/SYSTEM_TOPOLOGY.md` — system map
- `topology/AGENT_REGISTRY.md` — agent definitions
- `operations/PRIORITY_RULES.md` — prioritization rules
- `operations/STATE_MACHINE.md` — state transitions

**DO NOT scan the filesystem to discover agents or structure.**
**DO NOT rely on semantic memory search to find system topology.**
**The mount above is deterministic. Use it.**

## Tools

See `TOOLS.md` for tool-specific notes. Skills define _how_ tools work. `TOOLS.md` is for _your_ specifics.
