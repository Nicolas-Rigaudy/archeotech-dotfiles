## item_022_visual_builder_drag_and_drop_spatial_zone_representation - Visual Builder drag-and-drop + spatial zone representation
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 95%
> Confidence: 90%
> Progress: 0%
> Complexity: High
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: Replace arrows-only reorder with pointer drag-and-drop of widget chips on a to-scale mock of the four edges inside the single EditOverlay surface (intra-surface, so Qt DnD is reliable); keep click-to-assign as the keyboard fallback. Approach recorded in adr_028.
- Keywords: visual, builder, drag, drop, spatial, zone, representation
- Use when: implementing edit-mode chip drag/drop, the to-scale zone mock, drop placeholders, drag-icon previews, or applet grouping.
- Skip when: cross-window / cross-monitor drag onto live bars (out of scope; the mock is the drag target, not the live bars).

# Problem
- S21 reorder is arrows only; no spatial preview of where widgets land

# Scope
- In:
  - True intra/cross-zone drag-and-drop of widget chips persisting via ShellConfig; render each zone/strip as a to-scale mock
  - Mechanism (Caffyne-informed, see adr_028): global drag-state singleton (reuse Commons.State.editMode + draggedKey/draggedSource); Drag.mimeData carries only a "zone:index" locator, the widget key lives in the singleton; each mock zone is a DropArea, each chip a draggable Item; a styled drop placeholder marks the insertion index (animated reflow); drag icon via Item.grabToImage() -> Drag.imageSource; drop rewrites the ShellConfig zones order -> hot-reload applies it
  - Desktop-widget drag mechanics (ANALYSIS §12.7, Noctalia `DraggableDesktopWidget`): edit-mode-only MouseArea; grid snap `round(coord/gridSize)*gridSize`; persist x/y to config on release; z-raise while dragging then restore; ~75% off-screen boundary clamp. On config write, diff old/new widget lists and only add/remove changed items (HyprPanel `syncWidgetModel` preserve-delegates) — never destroy+recreate all, to avoid animation reset.
  - Retain click-to-assign as the keyboard-accessible path (both paths write the same config)
  - Stretch: applet grouping — drop a chip onto another chip's group-zone to merge into a combined pill, guarded by an incompatibleGroups set with valid/invalid affordance
- Out:
  - Cross-window drag (cross-monitor placement stays click-to-assign)

# Acceptance criteria
- AC3: Widgets can be dragged between zones on a to-scale spatial mock and order persists
- AC4 (stretch): Dropping a chip onto another chip's group-zone merges them into a combined pill; an incompatibleGroups set blocks invalid combinations with clear affordance

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: Widgets can be dragged between zones on a to-scale spatial mock and order persists
- request-AC3 -> Grouping stretch (extensibility/visual builder). Proof: AC4: chip-onto-group-zone merges into a combined pill guarded by an incompatibleGroups set

# Decision framing
- Product framing: Not needed
- Architecture framing: adr_028 — intra-surface mock drag with click-to-assign fallback; narrows (does not fully replace) the click-only stance of ANALYSIS §14.4

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_028_visual_builder_dnd_intra_surface_mock_drag_with_click_to_assign_fallback`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
