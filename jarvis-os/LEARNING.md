# LEARNING.md — Ecosystem Learning System

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines how the ecosystem learns from operational data and applies that learning to improve performance, reduce manual intervention, and increase leverage over time.

---

## 2. LEARNING CATEGORIES

### SEO Learning

#### Keyword Performance Patterns
- Which keywords drive conversions vs. traffic only
- Seasonal keyword trends
- Keyword difficulty vs. ranking achievement rate
- Keyword cannibalization patterns

#### Content Performance Patterns
- Which content types generate most organic revenue
- Topic cluster performance by category
- Content format effectiveness (reviews, guides, comparisons)
- Internal linking patterns that boost rankings

#### Technical SEO Patterns
- Common indexing failures and their resolutions
- Core Web Vitals thresholds that impact rankings
- Schema error patterns and fixes
- Crawl budget optimization learnings

### Competitor Learning

#### Competitor Behavior Patterns
- Pricing adjustment frequency and magnitude
- Content publish frequency and types
- Keyword targeting strategies
- Promotion timing and types

#### Competitive Response Effectiveness
- Which counter-strategies work (price matching, content updates, etc.)
- Response time impact on competitive positioning
- Market share shifts from competitive actions

### Operational Learning

#### Workflow Optimization
- Which workflows consistently require manual intervention
- Automation success rates by task type
- Bottleneck patterns in operational flows
- Time-to-resolution for different issue types

#### Prioritization Accuracy
- Items predicted P0 vs actual impact
- Items predicted P1 vs actual impact
- Scoring calibration needed for specific domains
- False positive/negative rates by priority level

#### Worker Performance
- Worker success/failure rates by type
- Workers that need supervision vs. autonomous
- Quality of worker outputs vs. human outputs
- Workers that consistently underperform

### User Behavior Learning

#### Decision Patterns
- Which items user consistently approves
- Which items user consistently rejects or modifies
- Approval response time patterns
- Decision criteria (revenue, timeline, risk, strategy)

#### Attention Patterns
- When user is most responsive (time of day)
- Which notification formats user acts on
- Items user ignores vs. acts on
- Cognitive load tolerance (items per summary)

---

## 3. LEARNING METHODOLOGY

### Data Collection

All operational outcomes must be tracked:

```
Event/Decision → Outcome → Comparison → Learning
```

For each operational action:
1. **Record prediction** (priority, impact estimate, confidence)
2. **Record outcome** (actual revenue impact, actual ranking change, etc.)
3. **Compare** (predicted vs. actual)
4. **Extract learning** (what was wrong? what was right?)
5. **Apply adjustment** (calibrate weights, update confidence, adjust thresholds)

### Feedback Loops

#### SEO Feedback Loop
```
SEO Action → Measure Results → Compare to Prediction → Adjust Strategy
```

Examples:
- Content piece published → track rankings/conversions for 30 days → compare to estimate → adjust content strategy
- Technical fix deployed → track indexing/rankings → compare to estimate → adjust technical approach
- Keyword targeting changed → track SERP performance → compare to estimate → adjust keyword strategy

#### Operational Feedback Loop
```
Task Assigned → Completion Time → Quality Assessment → Workflow Adjustment
```

Examples:
- Task estimated 2h, completed 6h → adjust future estimates
- Task quality below threshold → add quality gate before completion
- Task blocked 3x on same issue → add prevention to workflow

#### Competitive Feedback Loop
```
Competitor Action → Our Response → Market Impact → Strategy Adjustment
```

Examples:
- Competitor price drop → we responded → market share changed → adjust response thresholds
- Competitor content published → we monitored → no impact → reduce monitoring frequency

---

## 4. LEARNING STORAGE

### Where Learnings Are Stored

```
LEARNING/
├── seo-learnings/
│   ├── keyword-patterns.md
│   ├── content-patterns.md
│   └── technical-patterns.md
├── competitor-learnings/
│   ├── behavior-patterns.md
│   └── response-effectiveness.md
├── operational-learnings/
│   ├── workflow-optimization.md
│   └── prioritization-calibration.md
├── user-learnings/
│   ├── decision-patterns.md
│   └── attention-patterns.md
└── metrics/
    ├── prediction-accuracy.md
    └── worker-performance.md
```

### Learning Entry Format

```markdown
# Learning: {Title}

## Category: {SEO|Competitor|Operational|User Behavior}
## Subcategory: {Specific domain}
## Date Identified: {YYYY-MM-DD}
## Source: {Data point, event, pattern observation}

## Finding
{What did we learn?}

## Evidence
{Data supporting this learning}

## Impact
{How this changes operations}

## Application
{How to apply this learning going forward}

## Confidence: {High|Medium|Low}
## Review Date: {When to re-evaluate this learning}
```

---

## 5. CALIBRATION CYCLES

### Weekly Calibration (Every Sunday)

Review prediction accuracy:
- Priority prediction accuracy (P0/P1/P2/P3 correct?)
- Revenue impact accuracy (within 20%?)
- Effort estimation accuracy (within 50%?)
- Worker quality scores

Adjust weights in PRIORITY_RULES.md if accuracy <70%.

### Monthly Calibration (First of month)

Review all learnings:
- Which learnings are still valid?
- Which learnings have been contradicted by new data?
- Which workflows need re-optimization?
- Which workers need rebalancing?
- Update ATTENTION_BUDGET.md thresholds if needed

### Quarterly Calibration

Review overall ecosystem performance:
- Revenue attributed to ecosystem operations
- Time saved vs. manual operations
- Error rate and resolution time
- User satisfaction (implicit from feedback patterns)
- ROI of ecosystem vs. cost (compute time, maintenance)

---

## 6. LEARNING BOUNDS

### What CAN be learned automatically:
- Keyword performance patterns (aggregated)
- Content performance trends
- Prioritization accuracy metrics
- Worker performance metrics
- User decision patterns (aggregate)
- Workflow optimization opportunities

### What CANNOT be learned without user input:
- Strategic priorities (must be set by user)
- Revenue impact thresholds (must be set by user)
- Competitive strategy (must be approved by user)
- Quality standards (must be defined by user)
- Brand voice/tone guidelines (must be defined by user)
- Budget constraints (must be set by user)

### What MUST be validated by user:
- Any learning that changes operational strategy
- Any learning that affects revenue thresholds
- Any learning that changes competitive posture
- Any learning that modifies user interaction patterns

---

## 7. ANTI-LEARNING RULES

**Never assume causation from correlation** — especially in SEO where many variables change simultaneously.

**Never calibrate based on single data points** — require minimum 10 observations before adjusting weights.

**Never auto-adjust strategic thresholds** — revenue, competitive, quality thresholds require user approval.

**Never optimize for metrics at expense of strategy** — if learning suggests changing strategy, escalate to user.

**Never forget learned lessons** — archived learnings can be reactivated if context matches.

---

_This file defines the learning system structure. Do not modify without user instruction._
