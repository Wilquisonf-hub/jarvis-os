# Runtime State

This directory stores ephemeral state between operations.

## Files
- queues.json — Current queue state
- worker-status.json — Worker health status
- lock-file — Prevents concurrent operations

## Rules
- State files are auto-generated
- Never manually edit state files
- Reset state on safe mode entry
- Clear state on system shutdown

