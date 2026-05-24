# Memory Directory

## Purpose

Persistent state for Marquinhos (orchestration state, not worker state).

## What Goes Here

- Campaign memory (active campaign context)
- Task memory (current execution state)
- Relationship memory (key contacts, patterns)
- Learning memory (what worked, what didn't)

## What Does NOT Go Here

- Worker results (ephemeral — report and discard)
- Raw data dumps (summarize, don't store)
- Jarvis data (not your workspace)

## File Structure

```
memory/
  campaigns/ — active campaign context
  tasks/ — current task execution state
  relationships/ — key contact info
  learnings/ — lessons learned
  benchmarks/ — baseline data
```

---

_Last Updated: 2026-05-23_
