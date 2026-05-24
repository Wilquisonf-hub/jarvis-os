# Workers/Agents Configuration

## Worker Registry

Marquinhos manages these worker classes (defined in AGENTS.md):

| Worker | Model | Purpose |
|---|---|---|
| seo_auditor | gemma4 | SEO analysis and audit |
| content_strategist | mistral-medium 3.5 | Content planning and strategy |
| competitive_intel | deepseek-r1 8b/14b | Competitor analysis |
| content_writer | qwen3.6 | Content creation |
| visual_operator | qwen3.6 | Visual asset generation |
| reporting_analyst | gemma4 | Reports and summaries |

## Worker Rules

1. Ephemeral — no state between runs
2. Stateless — no memory
3. Execute only — no delegation
4. Terminate after completion
5. Max 3 simultaneously
6. Queue-based execution

## Queue Management

When max workers reached:
- New tasks go to queue/
- Tasks are batched by type
- Priority ordering within batches
- Auto-start when workers free up
