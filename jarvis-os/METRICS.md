# METRICS.md — Operational Metrics & Performance Tracking

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines the metrics system for tracking ecosystem performance, operational efficiency, and strategic impact.

---

## 2. METRIC CATEGORIES

### SEO Performance Metrics

| Metric | Target | Source | Update Frequency |
|--------|--------|--------|------|
| **Organic Revenue** | Growth month-over-month | Analytics | Weekly |
| **Organic Sessions** | Growth month-over-month | GSC/Analytics | Weekly |
| **Keyword Rankings** | Target keywords in top 10 | GSC | Weekly |
| **Click-Through Rate** | Above industry average | GSC | Weekly |
| **Index Coverage** | >95% indexed pages | GSC | Daily |
| **Core Web Vitals** | >80% good ratings | PageSpeed | Weekly |
| **Schema Health** | 0 errors | Structured Data | Daily |
| **Internal Link Depth** | <3 clicks to key pages | Technical audit | Monthly |

### Competitive Metrics

| Metric | Target | Source | Update Frequency |
|--------|--------|--------|------|
| **Competitive Gap** | Closing or holding | SERP comparison | Weekly |
| **Price Competitiveness** | Within 5% of market | Price tracking | Daily |
| **Content Coverage** | Matching competitor coverage | Content audit | Monthly |
| **Market Share** | Growing or stable | Industry data | Quarterly |

### Operational Efficiency Metrics

| Metric | Target | Source | Update Frequency |
|--------|--------|--------|------|
| **Task Completion Rate** | >90% on time | Queue system | Weekly |
| **Average Priority Score** | <60 (lower = better managed) | Priority scoring | Weekly |
| **Blocker Resolution Time** | <72 hours | Queue system | Daily |
| **Approval Latency** | <48 hours | Queue system | Daily |
| **Worker Success Rate** | >85% | Worker logs | Daily |
| **False Positive Rate** | <10% | Prediction accuracy | Weekly |
| **Attention Budget Compliance** | 100% (no spam) | User feedback | Continuous |

### User Engagement Metrics

| Metric | Target | Source | Update Frequency |
|--------|--------|--------|------|
| **Approval Rate** | >70% of proposals | User actions | Weekly |
| **Response Time** | <24 hours for P0/P1 | User interactions | Daily |
| **Interruption Tolerance** | <2 P0/day max | P0 logs | Continuous |
| **Feedback Frequency** | Monthly explicit feedback | User communication | Monthly |

---

## 3. METRIC COLLECTION

### Automated Collection

```yaml
metrics-collection:
  daily:
    - indexing_coverage
    - schema_errors
    - critical_worker_status
  weekly:
    - organic_revenue
    - organic_sessions
    - keyword_rankings
    - ctr
    - competitor_price_tracking
    - task_completion_rate
    - blocker_resolution_time
  monthly:
    - content_performance
    - technical_seo_audit
    - market_share
    - worker_performance_aggregate
  quarterly:
    - roi_analysis
    - strategy_effectiveness
    - user_satisfaction
```

### Manual Collection

- User feedback on attention quality (monthly)
- User feedback on operational effectiveness (monthly)
- Strategic goal updates (quarterly)
- Priority weight recalibration (quarterly, if needed)

---

## 4. METRICS REPORTING

### Daily Report (Heartbeat Scan)

```markdown
=== DAILY METRICS — [DATE] ===

SEO Health:
- Indexing: [X]% (target: >95%)
- Schema Errors: [X] (target: 0)
- CWV Good: [X]% (target: >80%)

Operational:
- Active Tasks: [X] (target: <20)
- Blocked Tasks: [X] (target: <15)
- Pending Approvals: [X] (target: <10)
- P0 Items: [X] (target: 0)

Competitive:
- Price Gap: [X]% (target: <5%)
- Content Gap: [X] items (target: decreasing)

Notes:
- [Any notable trends or concerns]
```

### Weekly Report (Weekly Ops Review)

```markdown
=== WEEKLY METRICS — [WEEK OF DATE] ===

SEO Performance:
- Organic Revenue: $[X] (trend: [UP/DOWN/FLAT])
- Organic Sessions: [X] (trend: [UP/DOWN/FLAT])
- Keywords in Top 10: [X] (target: [X])
- CTR Average: [X]% (industry avg: [X]%)

Competitive Position:
- Market Share: [X]% (trend: [UP/DOWN/FLAT])
- Price Competitiveness: [X]% gap
- Content Coverage: [X]% matching competitors

Operational Efficiency:
- Task Completion Rate: [X]% (target: >90%)
- Average Priority Score: [X] (target: <60)
- Blocker Resolution Time: [X] hours (target: <72)
- Worker Success Rate: [X]% (target: >85%)

User Engagement:
- Approval Rate: [X]% (target: >70%)
- P0 Interruptions: [X] (target: <2/day)
- Feedback Received: [Yes/No]

ROI Estimate:
- Ecosystem Value: $[X] (estimated)
- Cost: $[X] (estimated)
- Net Benefit: $[X]

Notes:
- [Key insights and recommendations]
```

### Monthly Report

```markdown
=== MONTHLY METRICS — [MONTH YEAR] ===

SEO Strategy Impact:
- Revenue Attributed to SEO: $[X]
- Top Performing Keyword Clusters: [List]
- Biggest SEO Wins: [List]
- Biggest SEO Challenges: [List]

Competitive Analysis:
- Competitor Moves Detected: [X]
- Our Responses: [X]
- Effectiveness Rating: [High/Medium/Low]

Operational Health:
- Total Tasks Completed: [X]
- Total Tasks Blocked: [X]
- Total Campaigns Launched: [X]
- Error Rate: [X]%

Learning Applied:
- Learnings Implemented: [X]
- Predictions vs. Actuals: [X]% accuracy
- Calibrations Made: [List]

Recommendations:
- [Strategic recommendations for next month]
```

---

## 5. METRICS BOUNDS

### What IS Tracked

- SEO performance indicators
- Operational efficiency metrics
- Competitive positioning metrics
- Worker performance metrics
- User engagement metrics

### What IS NOT Tracked

- User personal behavior patterns (privacy)
- Employee productivity metrics (only ecosystem metrics)
- Real-time continuous monitoring (bounded checks only)
- Irrelevant vanity metrics

### Privacy Constraints

- No user personal data collection
- No employee performance tracking
- No real-time surveillance
- Aggregate metrics only for user behavior

---

## 6. METRICS APPLICATION

### How Metrics Are Used

1. **Prioritization calibration** — adjust PRIORITY_RULES.md weights if metrics show misalignment
2. **Worker balancing** — adjust worker allocation if metrics show imbalance
3. **Strategy adjustment** — modify SEO/competitive strategy if metrics show poor performance
4. **Attention budget adjustment** — modify ATTENTION_BUDGET.md if metrics show spam or neglect
5. **Learning system updates** — apply learnings from prediction accuracy data

### Metric-Driven Decisions

- If **task completion rate <80%** → investigate bottlenecks
- If **worker success rate <75%** → rebalance or retrain workers
- if **prediction accuracy <70%** → recalibrate priority weights
- if **approval rate <50%** → reassess proposal quality or user alignment
- if **blocking resolution time >5 days** → escalate blockers

---

## 7. METRICS STORAGE

```
METRICS/
├── daily/
│   ├── [YYYY-MM-DD].md
├── weekly/
│   ├── [YYYY-WXX].md
├── monthly/
│   ├── [YYYY-MM].md
├── quarterly/
│   ├── [YYYY-QX].md
└── aggregates/
    ├── seo-performance.md
    ├── operational-efficiency.md
    ├── competitive-position.md
    └── user-engagement.md
```

---

_This file defines the metrics system structure. Do not modify without user instruction._
