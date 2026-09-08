## task_027_visual_builder_drag_and_drop_spatial_zone_representation - Visual Builder drag-and-drop + spatial zone representation
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-09-08 11:18:53

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: visual, builder, drag, drop, spatial, zone, representation
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_022_visual_builder_drag_and_drop_spatial_zone_representation`

# Acceptance criteria
- AC3: Widgets can be dragged between zones on a to-scale spatial mock and order persists
- AC4 (stretch): Dropping a chip onto another chip's group-zone merges them into a combined pill; an incompatibleGroups set blocks invalid combinations with clear affordance

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_027_visual_builder_drag_and_drop_spatial_zone_representation.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_027_visual_builder_drag_and_drop_spatial_zone_representation.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint -I . (3 files, clean); shot.sh --state editmode renders clean; node move_test.js 10/10` | result: passed | date: 2026-09-08
- Finish workflow executed on 2026-09-08.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-08.
- Linked backlog item(s): `item_022_visual_builder_drag_and_drop_spatial_zone_representation`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC3 -> This task. Proof: Implemented in 255ae3f: chip drag handle + per-zone DropAreas + animated drop caret in EditOverlay.qml, atomic ShellConfig.moveEntry/moveConversion. Verified qmllint clean on all 3 files; shot.sh --state editmode renders the overlay error-free; node move-logic test 10/10 (reorder, cross-zone, cross-side, incompatible-reject, nc->notifications convert, config preserved). Source: `255ae3f`
