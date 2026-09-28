## item_045_edit_mode_stragglers_onto_3d_glass_theme - Edit mode + stragglers onto 3D/glass theme
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45

# AI Context
- Summary: Migrate the visual-builder edit mode (EditOverlay) off hand-rolled flat rectangles onto the shared 3D/glass primitives; delivered.
- Keywords: edit, mode, stragglers, glass, primitives, SegmentedControl, GlassButton, StateLayer, EditOverlay
- Use when: Touching EditOverlay styling or the shared control primitives it now consumes.
- Skip when: Reworking the edit-mode drag-and-drop logic (out of scope) or the clock-overlap defect (separate).

# Problem
- EditOverlay/WidgetPalette and any other un-migrated panels don't follow the 3D/glass theme

# Outcome (2026-09-28)
- Delivered in archeotech-shell commit `38b5167`. The visual-builder edit mode now consumes the shared primitives instead of hand-rolled flat rectangles:
  - Type-switches (Bar/Strip/Holder/Off, x4) -> `SegmentedControl`; added opt-in `vertical` support to that primitive (horizontal use in Settings verified unchanged) so vertical sides get a proper recessed-track control.
  - Done / Framed / Manage buttons -> `GlassButton` (Done is `active` as the primary CTA).
  - Banner / Library / Config-popup cards -> `glassSheenTop/Bot` fill + `RectangularShadow` (the shell's floating-panel language); side mocks -> sheen fill.
  - Chips + library tiles -> `surfaceCard` sheen (shared scale) + a `stateHover` wash overlay, replacing the flat surface1<->surface2 swap.
  - Deleted `WidgetPalette.qml` (0 references; superseded by the always-visible Library).
- Reviewed by qml-reviewer: ship (no blocking/should-fix); drag/drop/config logic byte-identical, only the visual layer changed. Renders verified headless (editmode + settings SegmentedControl regression check); hover/config-popup/drag eyeballed live by the owner.
- Out of scope / follow-up: the "clock-overlap defect" named in this item's priority rationale is a separate layout bug, not AC5, and was NOT addressed here.

# Scope
- In:
  - Migrate EditOverlay/WidgetPalette (chip/tile hover+press) onto shared GlassButton/StateLayer/tokens; audit for other stragglers
- Out:
  - Drag-and-drop rework (tracked separately)

# Acceptance criteria
- AC5: Edit mode and any straggler panels use the shared 3D/glass primitives

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Edit mode and any straggler panels use the shared 3D/glass primitives
- request-AC3 -> This backlog slice. Proof: AC5: Edit mode and any straggler panels use the shared 3D/glass primitives

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: Edit mode is the busiest screen and shows the clock-overlap defect (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
