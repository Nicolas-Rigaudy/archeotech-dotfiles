## task_029_visual_builder_ux_overhaul_always_visible_widget_library - Visual builder UX overhaul + always-visible widget library
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
> Indicators reviewed: 2026-09-08 16:54:09

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: visual, builder, overhaul, always, visible, widget, library
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_099_visual_builder_ux_overhaul_always_visible_widget_library`

# Acceptance criteria
- AC1: Builder mocks read WYSIWYG — bar chips are compact at rest with titles on hover; strips size/centre to their icon count; the mode switch is a glass segmented control that follows the side's axis.
- AC2: An always-visible categorised Widget Library adds widgets by drag and removes by dragging a chip back onto it; its footer opens the Plugins settings pane.
- AC3: The live (non-edit-mode) strips size to their icon count again (the `expanded:240` regression is fixed).

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_029_visual_builder_ux_overhaul_always_visible_widget_library.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_029_visual_builder_ux_overhaul_always_visible_widget_library.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint -I . clean (EditOverlay/Strip/ShellConfig/State); shot.sh --state editmode + full-shell renders clean; node move_test.js 10/10` | result: passed | date: 2026-09-08
- Finish workflow executed on 2026-09-08.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-08.
- Linked backlog item(s): `item_099_visual_builder_ux_overhaul_always_visible_widget_library`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC3 -> This task. Proof: Delivered across archeotech-shell commits f5b8e43 (icon-rest bar chips), e2b65d2+c9a7959+570aa6e (strip mock sizing/centering + packed stride), 3b5524c+f4cd715 (axis-following glass segmented mode switch), c42dd50 (always-visible widget library: drag-to-add, drag-back-to-remove; dropped +Add/trash), 436f1f7+71f5654 (square centred library, functional categories, aligned 3-col grid, Plugins-pane footer link), and 5e07889 (live strip length regression fix). Verified: qmllint -I . clean on EditOverlay.qml/Strip.qml/ShellConfig.qml/State.qml; shot.sh --state editmode + full-shell renders inspected across iterations (no load errors); node move-logic test 10/10 for the config mutation. Source: `71f5654`
