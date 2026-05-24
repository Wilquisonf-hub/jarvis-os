# PRIORITY_RULES.md — Deterministic Priority Scoring System

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file defines the deterministic priority scoring system for all operational items.
The system prioritizes leverage, not activity volume.

---

## 2. SCORING FRAMEWORK

Each work item receives a **priority score (1-100)** based on weighted factors.

### Factor Weights

| Factor | Max Score | Weight | Description |
|--------|------|------|-----------|
| **Revenue Impact** | 25 | Critical | Direct or estimated monetary impact |
| **Traffic Impact** | 15 | High | Impact on organic traffic volume |
| **Ranking Impact** | 10 | High | Impact on keyword rankings |
| **Conversion Impact** | 15 | High | Impact on conversion rate/funnel |
| **Strategic Value** | 10 | Medium | Long-term strategic importance |
| **Urgency** | 10 | High | Time sensitivity / deadline pressure |
| **Effort Cost** | -5 | Modifier | Negative: higher effort reduces score |
| **Confidence Level** | 10 | Modifier | Positive: higher certainty increases score |
| **Risk Level** | 10 | Modifier | Positive: higher risk of inaction increases score |

### Scoring Rules

#### Revenue Impact (0-25)
- **25**: Direct revenue >$5k or blocked revenue
- **20**: Direct revenue $1k-$5k or high-value opportunity
- **15**: Direct revenue $100-$1k or meaningful opportunity
- **10**: Indirect revenue impact
- **5**: Minor revenue impact
- **0**: No revenue impact

#### Traffic Impact (0-15)
- **15**: >50% traffic change on key page
- **12**: 25-50% traffic change
- **10**: 10-25% traffic change
- **7**: 5-10% traffic change
- **3**: <5% traffic change
- **0**: No traffic impact

#### Ranking Impact (0-10)
- **10**: Target keyword out of top 10 (recovery)
- **8**: Target keyword down 3+ positions
- **6**: Key keyword up/down 1-2 positions
- **4**: Non-target keyword change
- **0**: No ranking impact

#### Conversion Impact (0-15)
- **15**: >20% conversion rate change
- **12**: 10-20% conversion rate change
- **10**: Funnel blockage
- **7**: Minor conversion impact
- **3**: Indirect conversion impact
- **0**: No conversion impact

#### Strategic Value (0-10)
- **10**: Core to business model / competitive moat
- **8**: Important for growth phase
- **6**: Supports strategic direction
- **3**: Marginal strategic value
- **0**: No strategic value

#### Urgency (0-10)
- **10**: Deadline today or past deadline
- **8**: Deadline within 24 hours
- **6**: Deadline within 3 days
- **4**: Deadline within 1 week
- **2**: Deadline beyond 1 week
- **0**: No deadline

#### Effort Cost (Modifier: -5 to 0)
- **-5**: High effort (multi-day work)
- **-3**: Medium effort (half-day work)
- **-1**: Low effort (under 1 hour)
- **0**: No effort estimate

#### Confidence Level (Modifier: 0-10)
- **10**: Confirmed data, no speculation
- **7**: Strong indicators, minor uncertainty
- **4**: Moderate confidence
- **0**: Speculative, unverified

#### Risk Level (Modifier: 0-10)
- **10**: High risk of inaction (revenue loss, compliance, major outage)
- **7**: Moderate risk
- **4**: Low risk
- **0**: No risk

---

## 3. SCORE INTERPRETATION

| Score | Priority Level | Action |
|-------|-----------|------|
| **85-100** | **P0** | Immediate interruption, same-minute response |
| **70-84** | **P1** | Same-day attention, top of next summary |
| **55-69** | **P2** | Daily briefing inclusion |
| **40-54** | **P3** | Weekly review |
| **0-39** | **LOW** | Defer or defer indefinitely |

---

## 4. PRIORITIZATION RULES

### Leverage Over Volume
- One high-leverage item beats ten low-leverage items
- **Leverage** = impact × confidence / effort
- Prefer items with **high impact, low effort, high confidence**

### State Override
- **BLOCKED** items: Score adjusted by 0 until unblocked
- **WAITING_APPROVAL** items: Score adjusted by -5 until approved
- **ARCHIVED** items: No score (inactive)
- **EXECUTING** items: Score adjusted by -3 while active (to deprioritize vs new items)

### Deadline Pressure
- Items due within 24h: +5 score boost
- Items due within 72h: +3 score boost
- Items past deadline: +10 score boost
- Items past deadline + revenue impact: +15 score boost

### Revenue Multiplier
- If item has direct revenue impact > $5k: **multiply final score by 1.2**
- If item has direct revenue impact > $1k: **multiply final score by 1.1**

### Confidence Penalty
- If confidence < 50%: **divide score by 1.5** (speculative items deprioritized)

---

## 5. SCORING EXAMPLES

### Example 1: Panasonic $9,620 Nota
- Revenue Impact: 25 (direct revenue at risk)
- Traffic Impact: 0
- Ranking Impact: 0
- Conversion Impact: 0
- Strategic Value: 10 (client relationship)
- Urgency: 10 (overdue)
- Effort Cost: -1 (quick follow-up)
- Confidence: 10 (confirmed overdue)
- Risk: 10 (lost revenue)
- **Base Score: 75**
- Deadline Pressure: +5 (overdue)
- Revenue Multiplier: 1.1 (> $1k)
- **Final Score: 88 → P0**

### Example 2: SEO Audit Discovery
- Revenue Impact: 10 (indirect, long-term)
- Traffic Impact: 5 (potential)
- Ranking Impact: 5 (potential)
- Conversion Impact: 5 (potential)
- Strategic Value: 8 (Phase 1 baseline)
- Urgency: 4 (planned, not urgent)
- Effort Cost: -5 (high effort, multi-day)
- Confidence: 7 (clear methodology)
- Risk: 4 (low risk of inaction)
- **Base Score: 43**
- Effort Penalty: Already applied
- **Final Score: 43 → P3**

### Example 3: Canon C50 Payment Blocker
- Revenue Impact: 20 (blocked sale pipeline)
- Traffic Impact: 0
- Ranking Impact: 0
- Conversion Impact: 5 (blocked conversion)
- Strategic Value: 8 (client relationship + equipment)
- Urgency: 8 (affecting downstream tasks)
- Effort Cost: -1 (quick follow-up)
- Confidence: 10 (confirmed pending)
- Risk: 8 (chain reaction on other tasks)
- **Base Score: 59**
- Deadline Pressure: +3 (affecting other items)
- **Final Score: 62 → P2**

### Example 4: Competitor Price Drop (non-critical)
- Revenue Impact: 5 (indirect)
- Traffic Impact: 0
- Ranking Impact: 3 (minor)
- Conversion Impact: 3 (potential)
- Strategic Value: 4 (monitoring)
- Urgency: 2 (no immediate action needed)
- Effort Cost: -1 (quick check)
- Confidence: 7 (confirmed)
- Risk: 3 (low immediate risk)
- **Base Score: 22**
- **Final Score: 22 → LOW**

---

## 6. PRIORITY REVIEW CYCLES

| Cycle | Items Reviewed | Action |
|-------|-----------|------|
| **Immediate** | P0 items | Interrupt user, escalate |
| **Daily Briefing** | P1 items | Summary of all P1 |
| **Heartbeat Scan** | P1-P2 items | Update states, scores |
| **Weekly Review** | P3-LOW items | Strategy adjustment, archive |
| **Monthly Review** | All priorities | Recalibrate weights if needed |

---

## 7. WEIGHT CALIBRATION

Current weights are designed for **e-commerce electronics retail** (i9Store).
If business model changes, weights should be recalibrated with user input.

**Do not auto-adjust weights** without user approval.
Weights are structural until explicitly changed by user.

---

_This file is structural context. Do not modify without user instruction._
