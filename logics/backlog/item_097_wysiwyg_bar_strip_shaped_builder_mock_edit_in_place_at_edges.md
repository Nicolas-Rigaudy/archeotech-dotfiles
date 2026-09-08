## item_097_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges - WYSIWYG bar/strip-shaped builder mock (edit-in-place at edges)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90
> Confidence: 85
> Progress: 100%
> Complexity: High
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-08 11:48:44

# AI Context
- Summary: Follow-up to task_027 — replace the abstract "square cards of chips" builder mock with edit-in-place, to-scale bar/strip silhouettes pinned to each real edge (KDE-Plasma-style edit mode with the shell's modern glass styling), so a drop shows where a widget actually lands.
- Keywords: wysiwyg, bar, strip, shaped, builder, mock, edit, place, edges
- Use when: reworking EditOverlay layout so the drop targets look like the real bar/strip.
- Skip when: the drag/drop mechanics themselves (delivered in task_027) — this is the visual/spatial layer over them.

# Problem
- task_027 delivered working chip drag-and-drop but onto abstract square container cards; the mock gives no sense of the resulting bar/strip. The user wants KDE-edit-mode fidelity: edit on the actual bar/strip shape at its edge.

# Scope
- In:
  - Each side renders as its true silhouette pinned to its edge: horizontal bar (top/bottom) with left/center/right sections laid out like the live Bar.qml (left-anchored, centered, right-anchored); vertical bar (left/right) with the three sections stacked; strip/holder as a single thin lane. Orientation-aware.
  - Chips styled as clean bar-widget pills (icon + label, glass); config gear + remove × reveal on hover; reorder arrows removed (drag replaces them).
  - A per-side floating toolbar (Bar/Strip/Holder/Off type switch + Add).
  - A drag-to-trash target that appears during a drag; dropping a chip on it removes it.
  - Reuse the task_027 drag machinery unchanged (State drag props, ShellConfig.moveEntry/moveConversion, DropArea + animated caret).
- Out:
  - Live-instantiated real widgets inside the mock (representative styled pills only); applet grouping (item_096); cross-window/monitor drag (adr_028).

# Acceptance criteria
- AC1: Each side shows a to-scale, edge-pinned bar/strip silhouette with left/center/right (or single-lane) drop sections matching the live orientation; dropping a widget previews where it lands and persists.
- AC2: Chips read as bar-widget pills with hover-revealed gear/remove and no reorder arrows; a drag-to-trash target removes a chip on drop.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: raises the visual-builder DnD (task_027) to WYSIWYG edit-in-place fidelity.

# Decision framing
- Product framing: Not needed
- Architecture framing: extends adr_028 (the intra-surface mock); no new ADR — same drag machinery, richer mock geometry.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_028_visual_builder_dnd_intra_surface_mock_drag_with_click_to_assign_fallback`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges`

# Priority
- Priority: High
- Rationale: Directly requested UX; the core value of the visual builder.

# Notes
- Generated locally by logics-manager.
- Task `task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges` was finished via `logics-manager flow finish task` on 2026-09-08.

# Tasks
- `task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges`
