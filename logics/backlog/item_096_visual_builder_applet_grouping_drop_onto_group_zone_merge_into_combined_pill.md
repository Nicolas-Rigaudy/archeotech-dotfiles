## item_096_visual_builder_applet_grouping_drop_onto_group_zone_merge_into_combined_pill - Visual Builder applet grouping (drop-onto-group-zone merge into combined pill)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 80
> Confidence: 70
> Progress: 0%
> Complexity: High
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: The deferred AC4 stretch of item_022/task_027 — merge two widget chips into one combined pill by dropping one onto another's group-zone, guarded by an incompatibleGroups set with a valid/invalid affordance.
- Keywords: visual, builder, applet, grouping, drop, onto, group, zone, merge, combined, pill
- Use when: building chip-onto-chip grouping on top of the shipped drag-and-drop (task_027).
- Skip when: plain intra/cross-zone chip drag (already delivered in task_027).

# Problem
- task_027 shipped drag-and-drop reorder + cross-zone/cross-side chip moves (AC3). The grouping stretch (item_022 AC4) was deliberately deferred to keep that slice reviewable — this item carries it.

# Scope
- In:
  - Drop a chip onto another chip's reserved group-zone to merge both into a combined pill; render the grouped pill in the builder mock and persist the grouping via ShellConfig.
  - An `incompatibleGroups` set that blocks invalid merges, with a clear valid/invalid affordance during the drag (mirrors task_027's accent/red caret).
- Out:
  - The base drag/drop mechanism (delivered in task_027); cross-window/cross-monitor drag (out per adr_028).

# Acceptance criteria
- AC1: Dropping a chip onto another chip's group-zone merges them into a combined pill and the grouping persists across a hot-reload.
- AC2: An incompatibleGroups set blocks invalid combinations, surfaced with a clear valid/invalid affordance before the drop lands.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: extends the visual-builder DnD chain (task_027) with the deferred grouping stretch.

# Decision framing
- Product framing: Not needed
- Architecture framing: adr_028 (grouping section) — the incompatibleGroups contract relates to the plugin/registry contract (ADR 010/016); revisit whether a new ADR is warranted at grooming.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_028_visual_builder_dnd_intra_surface_mock_drag_with_click_to_assign_fallback`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
