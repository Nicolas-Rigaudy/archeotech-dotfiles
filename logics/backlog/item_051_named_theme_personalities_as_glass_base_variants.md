## item_051_named_theme_personalities_as_glass_base_variants - Named theme personalities as glass-base variants
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Theming ecosystem
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:15:50

# AI Context
- Summary: Lightweight "personality" presets on the glass base — the SHALLOW end of the theme-pack spectrum (adr_026): token + shape-level variants (accent/mood/light touches) that don't need the full deep-pack machinery. The easy on-ramp and the model for community token-only packs, distinct from deep identity packs like item_082 (40K dataslate).
- Keywords: named, theme, personalities, glass, base, variants, presets, lightweight-pack
- Use when: Shipping quick base-glass variants/presets, or the easy on-ramp for community token packs.
- Skip when: Building a deep identity pack (item_082) or the engine/distribution (item_081/021).

# Problem
- Named personalities (40k/Star Wars/cyberpunk/Shadow Spear flavors) are wanted as quick variants, but must layer on the liquid-glass base and shouldn't require the full deep-pack machinery for simple token/shape tweaks.

# Scope
- In:
  - Lightweight token/shape personality presets on the liquid-glass foundation (the shallow end of the adr_026 capability surface).
- Out:
  - Deep identity packs with custom FX/motion/textures (item_082 and future packs).
  - Building them before the glass base is dialed in and approved.

# Acceptance criteria
- AC1: Named personalities exist as variants on the liquid-glass base

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Named personalities exist as variants on the liquid-glass base
- request-AC3 -> This backlog slice. Proof: AC1: Named personalities exist as variants on the liquid-glass base

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Low
- Rationale: Set by scaffold input or defaulted for grooming.
