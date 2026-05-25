# 🛡️ OpenClaw gog Safety Profile

## Overview
Safety-wrapped `gog` CLI that prevents any destructive or outgoing operations while allowing full read access. This is a **system-level** safety measure — the agent cannot disable or bypass these restrictions.

## What's Blocked (Read-Only Profile)
- **Gmail**: `send`, `trash`, `mark-read`, `unread`, `archive`, `drafts.*`, `labels.*`, `batch.*`, `thread.*`, `messages.*`, `watch`, `autoforward`, `delegates`, `filters`, `forwarding`, `sendas`, `vacation`, `forward`
- **Drive**: `delete`, `move`, `rename`, `share`, `unshare`, `copy`, `upload`, `mkdir`
- **Calendar**: `create`, `update`, `delete`, `move`, `respond`, `propose-time`, `subscribe`, `alias.*`, `out-of-office`, `focus-time`, `working-location`, `create-calendar`

## What Works (Read-Only)
- Gmail: `search`, `messages show`, `labels list`, `settings get`
- Drive: `search`, `ls`, `show`, `get`
- Contacts: `list`, `show`
- Sheets: `get`, `metadata` (read-only)
- Docs: `show`, `cat`
- Calendar: `list events`, `colors`, `calendars list`

## Verification
All 5 tests pass:
1. ✅ Gmail send → **BLOCKED** (exit 2)
2. ✅ Drive delete → **BLOCKED** (exit 2)
3. ✅ Gmail search → **WORKS** (exit 0)
4. ✅ Drive ls → **WORKS** (exit 0)
5. ✅ Bypass attempt (`--enable-commands`) → **BLOCKED** (exit 2)

## Implementation
The `gog` binary at `/opt/homebrew/bin/gog` has been replaced with a wrapper script that:
1. Adds `--gmail-no-send` (blocks all Gmail send)
2. Adds `--disable-commands` (hard-blocks 40+ dangerous operations)
3. Passes through all other flags and arguments unchanged

The original gog binary is preserved at `/opt/homebrew/Cellar/gogcli/0.15.0/bin/gog.original`.

## Reverting
To remove the safety wrapper:
```bash
ln -sfn ../Cellar/gogcli/0.15.0/bin/gog /opt/homebrew/bin/gog
```

## Key Design Decisions
1. **Hard block via `--disable-commands`** is permanent — the `--enable-commands` flag in gog cannot override it. This was verified through testing.
2. **System-level override** ensures the agent cannot disable the safety, even if prompted to do so by a malicious message.
3. **Read-only access preserved** for all useful operations (search, list, show, etc.)
