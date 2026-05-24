# WORKER_BALANCING.md — Worker Allocation and Load Management

## Last Updated: 2026-05-24

---

## 1. PURPOSE

This file manages worker allocation, load distribution, and capacity planning across the ecosystem.

---

## 2. CURRENT ALLOCATION

| Worker | Capacity | Utilization | Status | Notes |
|--------|----------|-------------|--------|-------|
| SEO Research | 20% | 15% | ✅ Under-utilized | Can absorb more SEO work |
| Technical SEO | 15% | 12% | ✅ Under-utilized | Monitoring is lightweight |
| Content Strategy | 15% | 10% | ✅ Under-utilized | No active campaigns |
| Competitive Intel | 10% | 8% | ✅ Under-utilized | Monitoring is passive |
| Ops Coordination | 20% | 18% | ⚠️ Near capacity | Heavy task load |
| Reporting | 10% | 6% | ✅ Under-utilized | Reports are periodic |
| Email | 10% | 7% | ✅ Under-utilized | Inbox manageable |

**Total Utilization:** 76%
**Available Slack:** 24%

---

## 3. LOAD MANAGEMENT RULES

### Allocation Principles

1. **High-impact workers get priority allocation** — SEO and Ops Coordination are highest priority
2. **No worker exceeds 80% utilization** — prevent burnout and quality degradation
3. **Slack is maintained at 15-20%** — for emergency/overflow work
4. **Rebalance when utilization shifts >20% for a worker** — not from minor fluctuations

### Rebalancing Triggers

| Trigger | Action |
|---------|--------|
| Worker utilization >80% for 3+ days | Rebalance 5-10% to under-utilized worker |
| Worker accuracy <70% for 7+ days | Reduce allocation 5%, investigate root cause |
| New high-impact work type emerges | Temporarily boost relevant worker, rebalance next cycle |
| Worker capability expansion | Increase allocation by 5%, decrease least impactful by 5% |

### Current Rebalancing Recommendations

- **SEO Research**: Can absorb +5% (currently 15% utilized of 20% capacity)
- **Technical SEO**: Can absorb +5% (currently 12% utilized of 15% capacity)
- **Ops Coordination**: Needs -5% (currently 18% utilized of 20% capacity) — **rebalance to SEO Research or Technical SEO**

---

## 4. WORKER ONCALL ROTATION

### Oncall Schedule

| Day | Primary On-call | Secondary On-call |
|-----|------|---------|-----|--|
| Monday | Ops Coordination | Email |
| Tuesday | SEO Research | Competitive Intel |
| Wednesday | Technical SEO | Reporting |
| Thursday | Content Strategy | Ops Coordination |
| Friday | SEO Research | Technical SEO |
| Saturday | Competitive Intel | Email |
| Sunday | Reporting | Competitive Intel |

### Oncall Responsibilities

- Handle P0 interruptions
- Escalate unresolved issues to user
- Monitor worker health
- Coordinate cross-worker emergencies

### Oncall Coverage

- **Weekdays**: 9am-6pm BRT primary coverage
- **Weekends**: Async monitoring only, escalate to user if P0
- **Holidays**: Async monitoring only, escalate to user if P0

---

## 5. WORKER EMERGENCY PROTOCOLS

### Worker Failure

If a worker fails (repeated errors, quality drop, unresponsiveness):

1. **Detect failure** — automated monitoring alerts
2. **Assess impact** — determine which tasks/workflows are affected
3. **Redistribute work** — move tasks to healthy workers
4. **Notify user** — if impact is P0/P1
5. **Investigate root cause** — after restoration
6. **Update WORKER_REGISTRY.md** — if capabilities/constraints change

### Overflow Handling

If total workload exceeds total capacity:

1. **Identify lowest-priority items** — based on PRIORITY_RULES.md
2. **Defer or archive** — items with priority <40
3. **Escalate to user** — if deferral causes risk
4. **Request user intervention** — for critical items that can't be deferred

---

## 6. CAPACITY PLANNING

### Quarterly Capacity Review

- Review all worker utilization metrics
- Assess new work types requiring coverage
- Evaluate worker performance vs. expectations
- Adjust allocations based on strategic priorities
- Update WORKER_REGISTRY.md and this file

### Annual Capacity Planning

- Review ROI per worker
- Evaluate need for new worker types
- Assess automation opportunities to reduce need for workers
- Budget for worker costs (compute, maintenance)
- Set strategic direction for worker ecosystem

---

## 7. BALANCING ACTIONS

### Immediate Actions Needed

1. **Rebalance Ops Coordination** — reduce by 5%, add to SEO Research
   - Reason: Ops Coordination near capacity, SEO Research has slack
   - New allocation: Ops Coordination 15%, SEO Research 25%

2. **Monitor Technical SEO** — currently under-utilized but critical
   - Reason: Technical issues can spike unexpectedly
   - Keep at 15% for buffer

3. **Consider reducing Competitive Intel** — if no major competitor moves
   - Reason: Currently 10% but passive monitoring doesn't need high capacity
   - Reduce to 5%, redistribute to SEO Research or Content Strategy

### Proposed New Allocation

| Worker | Current | Proposed | Change |
|--------|---------|----------|--------|
| SEO Research | 20% | 25% | +5% |
| Technical SEO | 15% | 15% | 0% |
| Content Strategy | 15% | 15% | 0% |
| Competitive Intel | 10% | 5% | -5% |
| Ops Coordination | 20% | 15% | -5% |
| Reporting | 10% | 10% | 0% |
| Email | 10% | 10% | 0% |
| **Total** | **100%** | **100%** | **0%** |

---

_This file manages worker allocation. Do not modify without user instruction._
