# Identity Files

These files define the agent's identity and personality. **NEVER modify by automation.**

## Files

### SOUL.md
Agent personality, tone, behavioral rules. Source of truth for voice and behavior.

### AGENTS.md
Agent workspace rules, startup protocol, operational directives.

### IDENTITY.md
Agent identity metadata (name, creature, vibe, emoji, avatar).

### USER.md
About the human operator. Built over time.

### RECOVERY.md
Recovery sequence for identity restoration.

## Safety

- These files are **immutable** for automation
- Only human can modify them
- Backup copies stored in `operations/backups/`
- Recovery copies stored in `operations/recovery/`
