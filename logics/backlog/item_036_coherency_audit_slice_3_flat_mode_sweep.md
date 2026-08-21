## item_036_coherency_audit_slice_3_flat_mode_sweep - Coherency audit Slice 3 - flat-mode sweep
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Coherency audit
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, audit, slice, flat, mode, sweep
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Flat-mode spike wired only shadows, not accent gradients; several shadows miss shadowStrength gating

# Scope
- In:
  - Add flatMode-aware accent-gradient helper and gate GlassButton/SegmentedControl/ToggleSwitch/SliderRow/SystemStatus/ColorSchemeBody; add x shadowStrength to the listed shadows
- Out:
  - Non-token surfaces

# Acceptance criteria
- AC5: Flat mode flattens accent gradients and all listed shadows respect shadowStrength

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Flat mode flattens accent gradients and all listed shadows respect shadowStrength

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — shadowStrength gating shipped (delivered); remaining: accent-gradient flat-mode gating. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
