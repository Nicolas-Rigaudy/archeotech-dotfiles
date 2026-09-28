## item_045_edit_mode_stragglers_onto_3d_glass_theme - Edit mode + stragglers onto 3D/glass theme
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 10%
> Complexity: Medium
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: edit, mode, stragglers, onto, glass, theme
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- EditOverlay/WidgetPalette and any other un-migrated panels don't follow the 3D/glass theme

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
