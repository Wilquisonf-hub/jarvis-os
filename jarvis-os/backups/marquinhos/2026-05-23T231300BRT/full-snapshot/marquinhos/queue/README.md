# Queue Management

## Queue Purpose

Task queue for bounded, prioritized worker execution.

## Queue Structure

Tasks enter queue when:
- All 3 workers are busy
- Task is approved but not yet time-sensitive
- Task is waiting on dependencies

## Queue Priorities

1. **critical** — immediate (but only if workers available)
2. **high** — next available slot
3. **medium** — batched with similar tasks
4. **low** — weekend/handoff window

## Queue Batching Rules

- Group similar worker types together
- Max 5 tasks per batch
- Minimum 2-minute gap between batches
- No new batch until current batch completes

## Queue Commands

- `add [task_id] [priority]` — add to queue
- `remove [task_id]` — remove from queue
- `list` — show all queued tasks
- `clear` — remove all queued tasks
- `batch [type]` — batch all tasks of a worker type

---

_Last Updated: 2026-05-23_
