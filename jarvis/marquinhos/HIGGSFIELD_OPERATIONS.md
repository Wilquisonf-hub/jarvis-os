# HIGGSFIELD_OPERATIONS.md — Model Preferences \u0026 Execution Rules

*Execution configuration for Higgsfield image/video generation.*

---

## Preferred Models (Priority Order)

1. **FLUX.2 Pro** — Image generation, highest quality
2. **GPTImage** — Image generation, fast iteration
3. **Seedream 4.5** — Image/video hybrid
4. **Kling O1 Image** — Video generation
5. **Nano Banana** — Image generation, rapid prototyping
6. **Seedream V5 Lite** — Lightweight image generation

**Rationale:** These models have unlimited plan capacity, lower operational cost, and rapid iteration capability.

---

## Multi-Model Generation Rule

For important assets (campaigns, sales collateral, product launches, marketplace listings):

1. Generate multiple variants across different models
2. Compare outputs
3. Explain differences between variants
4. Recommend the strongest option
5. Identify likely conversion strengths of the recommended variant

**Never assume first generation is optimal.**

---

## Aspect Ratio Protocol

**Before generation: determine destination platform.**

If platform is unclear: **ASK before generating.**

| Platform | Aspect Ratio |
|----------|-------------|
| Reels / TikTok / Shorts | 9:16 |
| YouTube | 16:9 |
| Marketplace card (Amazon, Shopee, etc.) | 1:1 |
| Blog hero image | 16:9 |
| Presentation / slide | 16:9 |
| PDF proposal / A4 document | A4 portrait |
| LinkedIn post | 1:1 or 4:5 |
| Facebook/Instagram feed | 4:5 |
| Twitter/X post | 16:9 or 1:1 |

---

## Brand Consistency System

When generating for:
- Proposals
- Presentations
- Reports
- Creatives
- Blog assets
- Sales collateral

**Always preserve:**
- Company colors (hex codes)
- Typography standards
- Visual hierarchy
- Logo usage rules
- Layout consistency guidelines

**If branding assets are missing:**
Request them **ONCE** from the USER and persist references in `/learning/brand/brand-guide.md`.

---

## Generation Workflow

1. Receive brief (campaign, asset type, platform, objectives)
2. Confirm aspect ratio / platform if unclear
3. Determine which models to use (single or multi-model)
4. Generate assets
5. Run brand-compliance check
6. Compare variants (if multi-model)
7. Recommend strongest option with rationale
8. Hold for human approval before deployment

---

*This file is operational configuration. Not topology. Not identity.*
