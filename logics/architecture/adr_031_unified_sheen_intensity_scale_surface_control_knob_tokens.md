## adr_031_unified_sheen_intensity_scale_surface_control_knob_tokens - Unified sheen-intensity scale (surface/control/knob tokens)
> Date: 2026-09-11
> Status: Proposed
> Related request: (none yet)
> Related backlog: `item_050_gradient_sheen_on_nested_cards_experiment`
> Related task: (none yet)
> Drivers: (drivers to document)
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Sheen intensity is defined once as a named three-tier scale in `Commons/Appearance.qml`; every sheened surface reads a token, never a bare multiplier.

# Context
- The top-lit sheen (`sheenHi`/`sheenLo`, the gradient twin of `shadowStrength`) was applied with per-call-site magic multipliers scattered across 8 files: `1.06, 1.08, 1.12, 1.16, 1.18, 1.20, 1.22, 1.30`.
- item_050 asked whether nested cards should take sheen at all; answering it "yes" would have added a 9th arbitrary value, deepening the drift. This violated the "nothing hardcoded — in one place" design rule and made cohesion a matter of luck.

# Decision
- Add `Appearance.sheen` as `readonly QtObject` tiers, each an `{hi, lo}` multiplier pair, chosen by surface role (bigger surfaces need less lift than tiny knobs to read the same):
  - `sheen.surface` = 1.13 / 1.16 — cards, resting buttons, MetalSurface housings.
  - `sheen.control` = 1.18 / 1.13 — accent fills: toggles, slider tracks, segmented, status bars, swatches.
  - `sheen.knob`    = 1.22 / 1.15 — tiny thumbs / knob borders.
- All 8 call sites feed a tier into the existing `sheenHi`/`sheenLo` helpers (which still collapse in `depthFlat`). Nested cards take `sheen.surface`; `MetalSurface`'s fallback fill honours `topLit` so flush bar housings collapse both stops to the base colour.
- Steel/plate pack shading (`Appearance.steel`, `Qt.lighter(steel.hi, …)`) is a separate subsystem and intentionally out of scope.

# Consequences
- One place to tune sheen; new surfaces pick a tier instead of inventing a value, so cohesion is enforced by construction.
- A few surfaces shifted slightly to their tier value (e.g. nested cards 1.16/1.20 → 1.13/1.16; slider-knob border 1.30 → knob.lo 1.15) — a deliberate, minor cohesion trade for consistency.
- Follow-up: if a knob's edge-outline contrast needs to diverge from its fill sheen, give knobs a dedicated border token rather than reusing `knob.lo`.

# References
- Related request: (none yet)
- Related backlog: `item_050_gradient_sheen_on_nested_cards_experiment`
- Related task: (none yet)
