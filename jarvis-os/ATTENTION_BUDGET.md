# ATTENTION_BUDGET.md — Attention Management System

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines the attention management system that prevents spam and optimizes for signal quality, operational clarity, and cognitive load reduction.

**Core principle:** The user's attention is a finite resource. It must be protected, not consumed.

---

## 2. INTERRUPTION LEVELS

### P0 — Immediate Interruption

**Definition:** Catastrophic or critical issue requiring immediate user attention.

**Criteria:**
- Revenue loss >$5k happening now
- Production system failure (site down, checkout broken)
- Major SEO catastrophe (entire site deindexed, hacking)
- Compliance/legal deadline within hours
- Blocked approval preventing time-sensitive revenue

**Action:** Immediate user interruption regardless of frequency.

**Frequency cap:** Maximum 2 P0 interruptions per day (unless multiple independent catastrophes).

**What triggers P0:**
- NEW_GSC_DROP >30% on site-wide traffic
- INDEXING_FAILURE site-wide
- SYSTEM_ERROR causing production impact
- Any revenue-impacting blocker >$5k
- COMPETITOR_PRICE_DROP on hero product with >20% margin

### P1 — Same-Day Operational Summary

**Definition:** Important operational items that need attention within 24 hours.

**Criteria:**
- Revenue impact $1k-$5k
- Deadline within 24-48 hours
- Blocking tasks with no path forward
- Significant SERP ranking changes (3+ positions) on key pages
- Campaign approval needed for time-sensitive opportunity

**Action:** Included in same-day operational summary (heartbeat scan or daily briefing).

**What triggers P1:**
- TASK_OVERDUE on high-value items
- CONVERSION_DROP >15%
- SERP_POSITION_DROP on target keywords
- WORKER_FAILURE requiring intervention
- Any task past deadline with revenue impact

### P2 — Daily Briefing Inclusion

**Definition:** Items that should be in the daily briefing but don't require same-day urgency.

**Criteria:**
- Moderate revenue impact ($100-$1k)
- Deadline within 3-7 days
- Notable changes requiring awareness but no action
- Completed items awaiting review/approval

**Action:** Included in daily briefing (morning-briefing cron or equivalent).

**What triggers P2:**
- TASK_BLOCKED without resolution path
- CONTENT_PERFORMANCE_LOW
- NEW_COMPETITOR_CHANGE on monitoring list
- CONVERSION_DROP 10-15%
- SCHEMA_ERROR or technical issue without production impact

### P3 — Weekly Review Only

**Definition:** Items for strategic review, not operational urgency.

**Criteria:**
- Low revenue impact (<$100)
- Long-term strategic items
- Informational updates
- Completed items with no action required
- Data points for trend analysis

**Action:** Included in weekly review (weekly-ops-review cron or equivalent).

**What triggers P3:**
- SERP_POSITION_GAIN (positive, no action needed)
- NEW_HIGH_INTENT_KEYWORD (research phase)
- CONTENT_DECAY_ALERT (may need refresh but not urgent)
- COMPETITOR_RANKING_GAIN (monitoring)
- Traffic trends, analytics summaries

### LOW — Defer or Archive

**Definition:** Items with minimal impact, deferred indefinitely or archived immediately.

**Criteria:**
- No revenue impact
- No traffic impact
- No ranking impact
- Informational only
- Outdated or irrelevant

**Action:** Archive immediately unless user requests tracking.

**What triggers LOW:**
- Minor SERP position changes (<1 position)
- Non-target keyword movements
- Completed items with no follow-up
- Redundant data points

---

## 3. COGNITIVE LOAD BOUNDARIES

### Notification Limits

| Channel | P0 | P1 | P2 | P3 |
|---------|----|----|----|----|
| Immediate interruption | ✅ Unlimited | ❌ None | ❌ None | ❌ None |
| Daily briefing | ❌ None | ✅ Up to 15 items | ✅ Up to 25 items | ❌ None |
| Weekly review | ❌ None | ❌ None | ✅ All P3 items | ✅ All LOW items |
| Heartbeat scan | ❌ None | ✅ Summary only | ✅ Summary only | ❌ None |

### Batching Rules

1. **Never send more than 15 P1 items in a single summary** — if more, defer some to next cycle
2. **Never send more than 25 P2 items in a single summary** — if more, defer some
3. **P0 items interrupt everything** — but capped at 2/day to prevent fatigue
4. **Group related items** — don't send separate alerts for items in same workflow
5. **Merge similar items** — "3 pages with indexing issues" not "Page 1 failed, Page 2 failed, Page 3 failed"

### Silence Periods

- **Minimum 1 hour between P0 interruptions** (unless new independent catastrophe)
- **No notifications during user-specified quiet hours** (if configured)
- **Weekly review aggregates everything** — no need to surface items multiple times

---

## 4. ATTENTION OPTIMIZATION STRATEGIES

### Signal vs Noise

| Signal (High Value) | Noise (Low Value) |
|-------------------|-----------------|
| Revenue-impacting items | Informational updates |
| Blocked approvals | Completed items |
| Time-sensitive deadlines | Low-priority tasks |
| Critical errors | Minor fluctuations |
| Strategic opportunities | Routine monitoring |

### Prioritization Heuristics

1. **Revenue first** — always surface items that directly impact money
2. **Blockers first** — items preventing other work
3. **Deadlines first** — items closest to deadline
4. **Confidence first** — act on confirmed data before speculation
5. **Leverage first** — high impact/low effort over low impact/high effort

### User Preference Adaptation

- Track which items user acts on vs ignores
- Reduce frequency of ignored item types
- Increase visibility of acted-on item types
- Learn user's operational rhythm (morning vs afternoon focus)

---

## 5. IMPLEMENTATION

### In Daily Briefing

```
=== DAILY BRIEFING — [DATE] ===

P0 (Immediate Action Required):
- [ ] Item 1 (score: XX, revenue impact: $XX)
- [ ] Item 2 (score: XX, revenue impact: $XX)

P1 (Today's Focus):
- [ ] Item 1 (score: XX, deadline: [DATE])
- [ ] Item 2 (score: XX, blocker: [ISSUE])

P2 (Review Today):
- [ ] Item 1 (score: XX, status: REVIEWING)
- [ ] Item 2 (score: XX, awaiting approval)

P3 (Weekly Review):
- [ ] Item 1 (score: XX, trend: [DIRECTION])
- [ ] Item 2 (score: XX, monitoring)

Notes:
- [Brief context or recommendations]
```

### In Heartbeat Scan

```
=== HEARTBEAT SCAN — [TIME] ===

P0: 0 items
P1: X items (total score: XX)
P2: X items (total score: XX)
P3: X items (total score: XX)

Critical Path: [Short description]
Blockers: [Short list]
Approvals Needed: [Short list]
```

---

## 6. RULES

1. **Never spam the user** — if unsure about priority, use P3 or archive
2. **Always explain why** — every alert must include the "so what"
3. **Provide next steps** — never surface a problem without suggesting action
4. **Respect user's operational rhythm** — adapt timing based on user's activity patterns
5. **Reduce, don't increase** — aim to decrease user's attention burden over time, not increase it
6. **Summarize, don't dump** — aggregate related items, don't list every individual change
7. **Escalate appropriately** — only P0 breaks attention budget rules

---

_This file is structural context. Do not modify without user instruction._
