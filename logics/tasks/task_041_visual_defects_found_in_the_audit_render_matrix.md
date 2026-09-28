## task_041_visual_defects_found_in_the_audit_render_matrix - Visual defects found in the audit render matrix
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 16:25:16

# AI Context
- Summary: Fix the audit's visual defects that survive on current main: launcher dead space (footer, fixed height) and the bare media idle state (designed empty state); record the rest (stacking not reproducible, carousel spill intended, edit-mode banner split to item_130).
- Keywords: visual, defects, found, audit, render, matrix
- Use when: Touching Launcher.qml footer/row caps or MediaPanel's idle state.
- Skip when: Edit mode layout (item_130) or carousel clipping (kept by owner decision).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_109_visual_defects_found_in_the_audit_render_matrix`

# Acceptance criteria
- AC1: Each listed defect is absent in its golden scenario across dark, light and flat.

# Plan
- [x] 1. Re-render every listed defect on current main (436dc27) and reproduce the stacking with the new shot.sh --exec + qs ipc --pid.
- [x] 2. Owner decisions: edit-mode banner -> separate design review (item_130); carousel spill kept; launcher fixed height with the space filled; media designed empty state.
- [x] 3. Launcher footer (count + key hints), typing-mode row cap 4.
- [x] 4. Media idle: glyph, title, hint, installed-player buttons via execDetached.
- [x] 5. qml-reviewer, land on main by path, closeout.
- [x] Use `python3 -m logics_manager flow progress task task_041_visual_defects_found_in_the_audit_render_matrix.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_041_visual_defects_found_in_the_audit_render_matrix.md` after implementation.

# Validation
- Isolated renders (shot.sh, archeotech-shell main 436dc27 vs worktree): all five audit defects re-rendered on current main. Stacking: shot.sh --state dashboard / --exec 'qs ipc --pid $QSPID call dashboard openAuto', then launcher open -> launcher replaces the dashboard on main, not reproducible. Launcher (temporary PROBE query injection): content area measured 383px; no query / 'blender' (1 result) / 'e' (68) / 'zzqx' (0) render with the footer and no overlap (about 20px gap under the 3rd recents-mode row); also light (latte) and flat. Media idle A/B dark, light, flat vs main: designed empty state, Spotify detected as installed. Qt6 qmllint: no new warning classes. qml-reviewer: ship; should-fixes applied (Flow fillWidth, list height floored at the footer, blank count while loading) and re-rendered.
- command: `shot.sh isolated renders A/B (launcher 4 query cases, media idle dark/light/flat, stacking repro via --exec qs ipc --pid); qmllint; qml-reviewer` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Landed on archeotech-shell main as 05f202c (Launcher.qml, MediaPanel.qml, scripts/shot.sh). Launcher: fixed height kept (owner), footer with count + key hints pinned at the bottom, typing-mode row cap 5->4, list height floored at the footer. Media: idle state = glyph, 'Nothing playing', hint, one GlassButton per installed player (command -v over a candidate list, launched with Quickshell.execDetached; replaces the hard-coded spotify-launcher chip); idle panel 440 x 296. shot.sh: --exec scripts get $QSPID. Not changed by owner decision: carousel peek (intended), edit-mode banner (item_130 design review). Stacking over the dashboard was an artifact of the audit's leaked second quickshell, not a shell bug.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_109_visual_defects_found_in_the_audit_render_matrix`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: the audit's launcher dead space and bare media idle state fixed in archeotech-shell 05f202c (renders across dark, light, flat); the stacking defect shown to be a render artifact, carousel peek kept by owner decision, edit-mode banner split to item_130. Golden scenarios for these land with item_068.
