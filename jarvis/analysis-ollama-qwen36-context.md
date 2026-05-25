# Analysis: ollama/qwen3.6 Context Injection vs OpenClaw Config

## Executive Summary

**Verdict: No config changes are needed for Qwen3.6 on Ollama.** The model's 262K context window provides sufficient headroom for OpenClaw's context injection, and all critical config fields (bootstrap, context limits, context injection mode) are already set to sensible defaults.

---

## 1. Context Budget Breakdown

### Bootstrap Files (AGENTS.md, SOUL.md, MEMORY.md, etc.)
| Source | Bytes | Estimated tokens |
|---|---|---|
| Bootstrap files (per-file max) | 12,000 | ~15K |
| Total bootstrap (all files) | 60,000 | ~75K |
| **Default budget** | **60,000** | **~75K** |

### Startup Context (one-shot on reset/new)
| Source | Chars | Estimated tokens |
|---|---|---|
| Daily memory (last 2 days) | 1,200 each | ~1.5K each |
| Max total startup | 2,800 | ~3.5K |

### Skills List
| Source | Chars | Estimated tokens |
|---|---|---|
| Skills prompt injection | 18,000 (default) | ~22K |

### Memory Search
| Source | Chars | Estimated tokens |
|---|---|---|
| memory_get max excerpt | 12,000 | ~15K |
| Default lines returned | 120 | ~15K |

### Per-Agent (jarvis)
| Source | Chars/Tokens | Estimated tokens |
|---|---|---|
| bootstrapMaxChars (jarvis) | 12,000 | ~15K |
| bootstrapTotalMaxChars (jarvis) | 60,000 | ~75K |
| skillsLimits.maxSkillsPromptChars (jarvis) | inherited 18,000 | ~22K |
| contextLimits.memoryGetMaxChars | 12,000 | ~15K |
| contextLimits.toolResultMaxChars | 16,000 | ~20K |

### Total Estimated Context Budget at Runtime
| Component | Tokens |
|---|---|
| System prompt base | ~2K |
| Bootstrap files | ~75K |
| Startup context | ~3.5K |
| Skills list | ~22K |
| Memory search excerpts | ~15K |
| Memory files (memory_get) | ~15K |
| Tool results | ~20K |
| **Total before conversation** | **~152K** |
| **Remaining for conversation** | **~110K** |

---

## 2. Current Configuration State

| Setting | Current Value | Source |
|---|---|---|
| **contextInjection** | `"always"` (default) | Not set in config |
| **bootstrapMaxChars** | `12,000` (default) | Not set in config |
| **bootstrapTotalMaxChars** | `60,000` (default) | Not set in config |
| **skillsLimits.maxSkillsPromptChars** | `18,000` (default) | Not set in config |
| **contextLimits.memoryGetMaxChars** | `12,000` (default) | Not set in config |
| **contextLimits.toolResultMaxChars** | `16,000` (default) | Not set in config |
| **startupContext.enabled** | `true` (default) | Not set in config |
| **startupContext.maxTotalChars** | `2,800` (default) | Not set in config |
| **startupContext.dailyMemoryDays** | `2` (default) | Not set in config |

**All values are OpenClaw defaults. Nothing is explicitly tuned.**

---

## 3. Analysis & Recommendations

### No Changes Needed (Current State is Fine)

Your current config is working correctly for Qwen3.6's 262K context window:

1. **Bootstrap files** (~75K tokens) fit comfortably within the budget
2. **Startup context** is minimal (~3.5K tokens) 
3. **Skills list** at default 18K is reasonable
4. **Conversation headroom** of ~110K is plenty for typical use

### If You Want to Be More Conservative (Optional)

Only consider tuning if you have:
- **Very large workspace files** (SOUL.md, AGENTS.md, MEMORY.md all heavily populated)
- **Heavy memory search results** (120+ lines of memory excerpts)
- **Long-running sessions** that need compaction to fire earlier

Potential optional tweaks (none required):

```json5
// If workspace files are heavy, reduce per-file budget:
agents.defaults.bootstrapMaxChars: 8000

// If you have many memory files with lots of content:
agents.defaults.startupContext.dailyMemoryDays: 1

// If skills list is bloated with disabled plugins:
skills.limits.maxSkillsPromptChars: 10000

// If context pruning would help long sessions:
agents.defaults.contextPruning: {
  mode: "cache-ttl",
  ttl: "1h",
  keepLastAssistants: 3,
}
```

### Key Finding

The most impactful setting is **`agents.defaults.contextInjection: "continuation-skip"`** (not currently set). This would skip re-injecting bootstrap files on continuation turns, reducing per-turn token usage significantly in active conversations. This is the only recommendation that would actually save tokens during normal use.

---

## 4. Config Field Reference (for future reference)

| Field | Controls | Default | Per-agent override |
|---|---|---|---|
| `agents.defaults.contextInjection` | When bootstrap files are injected | `"always"` | `agents.list[].contextInjection` |
| `agents.defaults.bootstrapMaxChars` | Max chars per bootstrap file | `12,000` | `agents.list[].bootstrapMaxChars` |
| `agents.defaults.bootstrapTotalMaxChars` | Max total chars across bootstrap files | `60,000` | `agents.list[].bootstrapTotalMaxChars` |
| `agents.defaults.startupContext.maxTotalChars` | One-shot reset/new context budget | `2,800` | No |
| `agents.defaults.startupContext.dailyMemoryDays` | How many recent memory files to include | `2` | No |
| `agents.defaults.startupContext.maxFileBytes` | Max per-file size for startup context | `16,384` | No |
| `agents.defaults.startupContext.maxFileChars` | Max per-file chars for startup context | `1,200` | No |
| `agents.defaults.contextLimits.memoryGetMaxChars` | Max excerpt chars from memory_get | `12,000` | `agents.list[].contextLimits.memoryGetMaxChars` |
| `agents.defaults.contextLimits.toolResultMaxChars` | Max chars for tool results | `16,000` | `agents.list[].contextLimits.toolResultMaxChars` |
| `agents.defaults.contextLimits.memoryGetDefaultLines` | Default lines returned by memory_get | `120` | No |
| `agents.defaults.contextLimits.postCompactionMaxChars` | AGENTS.md excerpt cap post-compaction | `1,800` | No |
| `skills.limits.maxSkillsPromptChars` | Max chars for skills list in prompt | `18,000` | `agents.list[].skillsLimits.maxSkillsPromptChars` |

---

## 5. Bottom Line

**Current config: A+ for Qwen3.6.** 152K base context leaves 110K for conversation. Your 262K context window gives you ~42% utilization at baseline. Only consider tuning if you're hitting compaction frequently or running long sessions.

The single most useful improvement would be setting `contextInjection: "continuation-skip"` to avoid redundant bootstrap injection on every turn during active conversations.
