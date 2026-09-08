## task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges - WYSIWYG bar/strip-shaped builder mock (edit-in-place at edges)
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
> Indicators reviewed: 2026-09-08 11:48:44

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: wysiwyg, bar, strip, shaped, builder, mock, edit, place, edges
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_097_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges`

# Acceptance criteria
- AC1: Each side shows a to-scale, edge-pinned bar/strip silhouette with left/center/right (or single-lane) drop sections matching the live orientation; dropping a widget previews where it lands and persists.
- AC2: Chips read as bar-widget pills with hover-revealed gear/remove and no reorder arrows; a drag-to-trash target removes a chip on drop.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_028_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint -I . clean; shot.sh --state editmode renders WYSIWYG bar/strip mocks clean (3 iterations)` | result: passed | date: 2026-09-08
- Finish workflow executed on 2026-09-08.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-08.
- Linked backlog item(s): `item_097_wysiwyg_bar_strip_shaped_builder_mock_edit_in_place_at_edges`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC3 -> This task. Proof: Implemented in 0c09270: EditOverlay side mocks rewritten as edge-pinned bar/strip silhouettes (horizontal top/bottom, vertical left/right) with left/center/right (or single-lane) DropArea sections mirroring live Bar.qml; hover-reveal gear/remove, no arrows; drag-to-trash target. Verified qmllint -I . clean; shot.sh --state editmode renders the WYSIWYG mocks error-free across 3 iterations (center-widget z-order fix confirmed). Source: `0c09270`
