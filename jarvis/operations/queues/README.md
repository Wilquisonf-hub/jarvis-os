# Queues

## Inbox Queue
- **Purpose:** Unread actionable items
- **Trigger:** Every 30 minutes
- **Max items:** No limit (filtered by priority)
- **Output:** TASKS.md entries

## Task Mutation Queue
- **Purpose:** Pending task updates
- **Trigger:** On status change
- **Action:** Log to change.log, update TASKS.md

## Notification Queue
- **Purpose:** Human notifications
- **Trigger:** Urgent items found
- **Action:** Alert human via channel

## Queue Management
- All queues are in-memory during operation
- Persisted to operations/state/queues.json on exit
- Cleared after processing

