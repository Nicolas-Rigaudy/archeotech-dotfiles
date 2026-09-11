## item_050_gradient_sheen_on_nested_cards_experiment - Gradient sheen on nested cards experiment
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Aesthetic experiment
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: Decide (and, if yes, ship) whether nested cards take a top-lit sheen; resolved YES via a shared sheen-intensity scale.
- Keywords: gradient, sheen, nested, cards, experiment, tokens, design-language
- Use when: Touching card/surface shading or the sheen-intensity tokens in Commons/Appearance.
- Skip when: Working on colour palette values or steel/plate pack shading (separate subsystem).

# Problem
- Nested cards use flat surfaceCard; unclear if they want the sheen treatment

# Outcome (2026-09-11)
- Decision: YES — nested cards (DashCard/SettingsCard, and any MetalSurface fallback fill) take a subtle top-lit sheen in glass packs, collapsing to flat in depthFlat mode.
- Generalised beyond the experiment: the per-site sheen multipliers (1.06..1.30 scattered across 8 files) were unified into a single named scale `Appearance.sheen.{surface,control,knob}` — surface 1.13/1.16, control 1.18/1.13, knob 1.22/1.15 — so all sheened surfaces speak one design language from one place.
- Also fixed: MetalSurface fallback now honours the `topLit` contract so flush bar housings (BarSegment) don't pick up card sheen.
- Delivered in archeotech-shell commit `df5e991` (9 QML files). Verified headless via shot.sh (dashboard + settings/appearance).

# Scope
- In:
  - Try glassSheenTop/Bot (or softer) on DashCard/SettingsCard/notif cards once flat card language is settled
- Out:
  - Shipping before evaluation

# Acceptance criteria
- AC5: A decision is made on whether nested cards take the sheen

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: A decision is made on whether nested cards take the sheen

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
