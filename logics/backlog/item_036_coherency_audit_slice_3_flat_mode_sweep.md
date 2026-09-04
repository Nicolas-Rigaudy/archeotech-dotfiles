## item_036_coherency_audit_slice_3_flat_mode_sweep - Coherency audit Slice 3 - flat-mode sweep
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Coherency audit
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-04 10:54:59

# AI Context
- Summary: Coherency Slice 3 — gate accent gradients on flatMode for GlassButton/SegmentedControl/ToggleSwitch/SliderRow/SystemStatus/ColorSchemeBody (shadowStrength gating already shipped 2026-08-21). Widened 2026-09-04 to sweep BOTH modes respectively: each listed component must render coherently in 3D/glass (gradient + gated shadow present and correct) AND flatten cleanly in flat mode, with a clean toggle between the two.
- Keywords: coherency, audit, slice, flat, glass, 3d, mode, sweep, accent, gradient, shadowStrength, flatMode
- Use when: Auditing per-component coherence across flat and 3D/glass modes, or wiring flatMode-aware accent-gradient gating.
- Skip when: Working on non-token surfaces, or the flat<->glass toggle rollout itself (item_012).

# Problem
- Flat-mode spike wired only shadows, not accent gradients; several shadows miss shadowStrength gating

# Scope
- In:
  - Add flatMode-aware accent-gradient helper and gate GlassButton/SegmentedControl/ToggleSwitch/SliderRow/SystemStatus/ColorSchemeBody; add x shadowStrength to the listed shadows
  - Sweep BOTH modes respectively per listed component: verify 3D/glass renders coherently (accent gradient + shadowStrength-gated shadow present and correct) AND flat mode flattens the gradient + honours shadowStrength; confirm the flat<->glass toggle transition is clean for each. shot.sh both states per component.
- Out:
  - Non-token surfaces
  - The flat<->glass toggle rollout itself (item_012) — this slice consumes the toggle to verify, it does not build it

# Acceptance criteria
- AC5: Flat mode flattens accent gradients and all listed shadows respect shadowStrength

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Flat mode flattens accent gradients and all listed shadows respect shadowStrength

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — shadowStrength gating shipped (delivered); remaining: accent-gradient flat-mode gating. Keep Ready.
- Scope widening 2026-09-04: the roadmap slice name "flat-mode sweep" undersold the milestone exit signal ("every surface passes the coherency audit"). Since 0.26 rolls out both the flat<->glass toggle (item_012) and the 3D/glass theme (item_045), a flat-only sweep would certify half the surface. Widened to audit each listed component in BOTH modes respectively (3D/glass coherent + flat flattens + clean toggle). AC5 unchanged — the concrete deliverable is still the flat-mode accent-gradient gating; the 3D-side check is verification, not new build.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_021_coherency_audit_slice_3_flat_mode_sweep`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Tasks
- `task_021_coherency_audit_slice_3_flat_mode_sweep`

# Notes
- Task `task_021_coherency_audit_slice_3_flat_mode_sweep` was finished via `logics-manager flow finish task` on 2026-09-04.
