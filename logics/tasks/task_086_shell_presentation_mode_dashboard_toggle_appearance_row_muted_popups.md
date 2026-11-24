## task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups - Shell presentation mode: dashboard toggle, Appearance row, muted popups
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
> Indicators reviewed: 2026-11-24 17:53:54

# AI Context
- Summary: Presentation service (state file watch + script toggle), dashboard toggle, Appearance ToggleRow, popup gate in shell.qml.
- Keywords: shell, presentation, mode, dashboard, toggle, appearance, row, muted, popups
- Use when: implementing item_187.
- Skip when: work on the Opacity preset or mango opacity rules.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_187_shell_presentation_mode_toggle_and_muted_popups`

# Acceptance criteria
- AC1: Dashboard and Appearance toggles show the real mode and flip it via the script; pressing Super+Shift+O updates both within ~1 s.
- AC2: With the mode on, a notification produces no popup but lands in the notification centre; the DND setting is unchanged.
- AC3: Renders (dark/light, Grimdark) show the toggles in both states; goldens pass except intended dashboard/appearance scenarios.

# Plan
- [x] Services/System/Presentation.qml singleton: FileView on $XDG_RUNTIME_DIR/presentation-mode.state (watchChanges, reload; missing file = off), `active`, `toggle()` via execDetached presentation-mode.sh toggle.
- [x] shell.qml popup gate: return when Presentation.active (DND untouched).
- [x] Appearance pane: ToggleRow "Presentation mode" under Opacity (8px / Prim.Divider / 8px).
- [x] Dashboard: render two placements (hero chip vs toggle strip), owner picks, build the pick.
- [x] shot.sh renders both states, goldens, tests/run.sh, qmllint, qml-reviewer.
- [x] Use `python3 -m logics_manager flow progress task task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups.md` after implementation.

# Validation
- archeotech-shell e3a14ca. tests/run.sh rc=0 (147 qml logic tests). shot.sh renders: IPC presentation on runs the script stub, state file on, Settings row and Super+W GlassButton follow; popups muted, notifications still in the centre; dark/latte/grimdark checked. Goldens skipped at owner request 2026-11-24.
- command: `tests/run.sh + shot.sh renders` | result: passed | date: 2026-11-24
- Finish workflow executed on 2026-11-24.
- Linked backlog/request close verification passed.

# Report
- Placement changed per owner: quick toggle is a stock GlassButton (accent when on) in the Appearance quick panel (Super+W, WallpaperPicker.qml), not the Dashboard; Settings > Appearance has a PRESENTATION card with a ToggleRow. Owner approved the render 2026-11-24.
- Finished on 2026-11-24.
- Linked backlog item(s): `item_187_shell_presentation_mode_toggle_and_muted_popups`
- Related request(s): `req_019_presentation_mode_in_the_shell`

# Links
- Request: `req_019_presentation_mode_in_the_shell`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# AC Traceability
- request-AC1 -> This task. Proof: shot.sh renders, IPC on flips the Super+W GlassButton and the Settings ToggleRow; owner approved 2026-11-24 (archeotech-shell e3a14ca).
- request-AC2 -> This task. Proof: shell.qml onArrived returns before the popup while Presentation.active; notifications still logged to the centre (shot.sh run).
- request-AC3 -> This task. Proof: qs ipc --pid call presentation on/toggle/status in shot.sh, state file and shell agree.
