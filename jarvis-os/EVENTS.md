# EVENTS.md — Operational Event System

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines the operational events that trigger system behavior.
Events drive queueing, prioritization, worker spawning, summaries, and escalation.
No autonomous chaos — everything routes through queues and prioritization.

---

## 2. EVENT CATEGORIES

### SEO Events

| Event ID | Name | Trigger | Priority | Routing |
|----------|------|-------|--------|------|
| `SEO_001` | `NEW_GSC_DROP` | Traffic/impressions drop >15% on key page | P1 | analytics-worker → Jarvis |
| `SEO_002` | `NEW_GSC_GAIN` | Significant ranking improvement | P3 | analytics-worker → Marquinhos (log) |
| `SEO_003` | `INDEXING_FAILURE` | Page fails to index or removed from index | P1 | technical-seo-worker → Jarvis |
| `SEO_004` | `CANONICAL_ISSUE` | Duplicate content / canonical conflict detected | P2 | technical-seo-worker → Marquinhos |
| `SEO_005` | `CORE_WEB_VITALS_DEGRADATION` | CWV score drops below threshold | P2 | technical-seo-worker → Marquinhos |
| `SEO_006` | `SERP_POSITION_GAIN` | Target keyword moves up 3+ positions | P3 | analytics-worker → Marquinhos (log) |
| `SEO_007` | `SERP_POSITION_DROP` | Target keyword drops 3+ positions | P1 | analytics-worker → Marquinhos → Jarvis |
| `SEO_008` | `AI_SEARCH_VISIBILITY_DROP` | Loss of AI overview/sponsored snippet | P2 | ai-visibility-worker → Marquinhos |
| `SEO_009` | `SCHEMA_ERROR` | Structured data validation error | P2 | technical-seo-worker → Marquinhos → Jarvis |
| `SEO_010` | `INTERNAL_LINKING_GAP` | Discovered high-opportunity internal link | P3 | product-seo-worker → Marquinhos |

### Competitor Events

| Event ID | Name | Trigger | Priority | Routing |
|----------|------|-------|--------|------|
| `COMP_001` | `NEW_COMPETITOR_CHANGE` | Competitor price/product/content change | P2 | competitor-monitor-worker → Marquinhos → Jarvis |
| `COMP_002` | `COMPETITOR_PRICE_DROP` | Direct competitor drops price on overlapping product | P1 | competitor-monitor-worker → Marquinhos → Jarvis |
| `COMP_003` | `COMPETITOR_CONTENT_PUBLISH` | Competitor publishes new comparison/buyer guide | P2 | competitor-monitor-worker → Marquinhos |
| `COMPETITOR_004` | `COMPETITOR_NEW_CAMPAIGN` | Competitor launches new promotion/campaign | P2 | competitor-monitor-worker → Marquinhos → Jarvis |
| `COMP_005` | `COMPETITOR_RANKING_GAIN` | Competitor gains significant SERP position | P3 | competitor-monitor-worker → Marquinhos |

### Content Events

| Event ID | Name | Trigger | Priority | Routing |
|----------|------|-------|--------|------|
| `CNT_001` | `NEW_TOPIC_CLUSTER` | Identified untapped content opportunity | P3 | blog-research-worker → Marquinhos |
| `CNT_002` | `NEW_CONTENT_DRAFT` | Content draft complete | P2 | content review queue |
| `CNT_003` | `CONTENT_PERFORMANCE_LOW` | Published content underperforming expectations | P2 | analytics-worker → Marquinhos → Jarvis |
| `CNT_004` | `CONTENT_DECAY_ALERT` | Published content losing rankings over time | P2 | analytics-worker → Marquinhos |
| `CNT_005` | `CONTENT_GAP_EXPOSED` | Competitor outranks us on high-value topic | P2 | blog-research-worker → Marquinhos → Jarvis |

### Analytics Events

| Event ID | Name | Trigger | Priority | Routing |
|----------|------|-------|--------|------|
| `ANA_001` | `TRAFFIC_SPIKE` | Sudden organic traffic increase | P2 | analytics-worker → Marquinhos → Jarvis |
| `ANA_002` | `CONVERSION_DROP` | Conversion rate drops >10% | P1 | analytics-worker → Marquinhos → Jarvis |
| `ANA_003` | `FUNNEL_BOTTLENECK` | Identified critical drop-off in conversion funnel | P2 | analytics-worker → Marquinhos → Jarvis |
| `ANA_004` | `CTR_OPportunity` | High impression page with low CTR | P3 | analytics-worker → product-seo-worker → Marquinhos |
| `ANA_005` | `NEW_HIGH_INTENT_KEYWORD` | Keyword with commercial intent emerging | P2 | blog-research-worker → Marquinhos → Jarvis |
| `ANA_006` | `TRAFFIC_SOURCE_SHIFT` | Significant change in traffic mix | P3 | analytics-worker → Marquinhos |

### Approval/Operations Events

| Event ID | Name | Trigger | Priority | Routing |
|----------|------|-------|--------|------|
| `APR_001` | `USER_APPROVAL_GRANTED` | User grants pending approval | P0/P1 | Resume blocked queue item |
| `APR_002` | `USER_APPROVAL_DENIED` | User rejects request | P2 | Archive or replan queue item |
| `TASK_001` | `TASK_OVERDUE` | Task exceeds deadline | P1 | Escalate to user via P1 summary |
| `TASK_002` | `TASK_COMPLETION` | Task successfully completed | P3 | Log in completed queue, update state |
| `TASK_003` | `TASK_BLOCKED` | Task encounters blocker | P2 | Move to blocked queue, notify if P1+ |
| `INC_001` | `SYSTEM_ERROR` | Operational system failure | P0 | Immediate user alert |
| `INC_002` | `WORKER_FAILURE` | Worker execution fails | P2 | Retry once, then alert Jarvis |

---

## 3. EVENT ROUTING LOGIC

### Routing Rules

```
SEO events → Marquinhos → Workers → Marquinhos → Jarvis
Competitor events → Marquinhos → Workers → Marquinhos → Jarvis
Content events → Marquinhos → Workers → Marquinhos → Jarvis
Analytics events → Marquinhos → Workers → Marquinhos → Jarvis
Approval events → Direct to relevant queue
Task events → Direct to queue management
Incident events → Immediate escalation path
```

### Escalation Logic

| Priority | Action | Timeline |
|----------|------|------|
| **P0** | Immediate user interruption (P0 alert) | Within 15 minutes |
| **P1** | Same-day operational summary | Included in next P1 summary |
| **P2** | Daily briefing inclusion | Included in daily briefing |
| **P3** | Weekly review only | Included in weekly digest |

### Queue Integration

When an event is triggered:

1. **Create queue entry** in appropriate queue (`pending/`, `blocked/`, etc.)
2. **Assign priority score** based on PRIORITY_RULES.md
3. **Route to owner** (Jarvis or Marquinhos)
4. **Spawn workers** if analysis is needed (max 3 concurrent)
5. **Set state** per STATE_MACHINE.md
6. **Log timestamp** of event creation
7. **Check dependencies** before processing

---

## 4. EVENT MONITORING

### Sources

- **GSC API**: Rankings, impressions, clicks, CTR, indexing status
- **PostHog API**: Traffic, conversions, funnel data
- **Competitor monitoring**: Price tracking, content detection, SERP monitoring
- **Technical SEO tools**: Core Web Vitals, schema validation, crawl errors
- **Task system**: Overdue items, completion events, blockers
- **User actions**: Approvals, denials, manual flags

### Detection Methods

- **Automated**: API polling, scheduled checks (bounded, not continuous)
- **Manual**: User flagging, agent detection during routine ops
- **Trigger-based**: Threshold-based alerts (e.g., traffic drop >15%)

### Bounds

- **No continuous monitoring** — bounded checks only
- **No constant polling** — heartbeat-based with cooldown
- **No infinite loops** — single-trigger events only
- **No redundant detections** — deduplicate within cooldown period

---

## 5. EVENT PROCESSING FLOW

```
Event detected
    → Validate (is this real? is this duplicate?)
    → Assign priority score (PRIORITY_RULES.md)
    → Determine routing (Jarvis vs Marquinhos)
    → Check existing queue for similar items
    → Create/update queue entry
    → If needs analysis → spawn worker (max 3)
    → Worker returns result
    → Marquinhos synthesizes (if applicable)
    → Add to appropriate attention level (ATTENTION_BUDGET.md)
    → Wait for next summary/interruption cycle
    → If P0 → immediate alert
```

---

## 6. EVENT ARCHITECTURE RULES

1. **Events are triggers, not actions** — they create work items, they don't execute work
2. **All events go through queues** — no bypass of queue system
3. **Events are prioritized, not just sorted by time** — leverage matters more than recency
4. **Events are deduplicated** — similar events within cooldown period are merged
5. **Events have clear owners** — Jarvis or Marquinhos, never both
6. **Events are logged with full context** — source, timestamp, impact estimate
7. **Events respect attention budget** — P0/P1/P2/P3 determined by PRIORITY_RULES.md

---

_This file is structural context. Do not modify without user instruction._
