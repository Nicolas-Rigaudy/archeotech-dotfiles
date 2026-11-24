## item_187_shell_presentation_mode_toggle_and_muted_popups - Shell presentation mode: dashboard toggle, Appearance row, muted popups
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: shell
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 17:53:55

# AI Context
- Summary: Shell UI for presentation mode (dotfiles scripts/presentation-mode.sh, bc60cf1): a dashboard toggle and a Settings > Appearance ToggleRow bound to the script's state file, plus notification popups muted while it is on.
- Keywords: presentation, screen share, opacity, transparency, dnd, popups, dashboard, appearance
- Use when: changing presentation mode, its toggles or the popup gate.
- Skip when: changing the theme Opacity preset (Glass/Solid) itself.

# Problem
- Owner showed LibreOffice in a meeting and the wallpaper showed through it (mango focused_opacity 0.85 / unfocused 0.5).
- Mango sets a window's opacity once at map and never re-applies it (no window-rule reapply in reset_option), so the old zen-opacity-toggle never worked; presentation-mode.sh makes NEW windows opaque (setoption) and kitty opaque live (socket).
- The mode is only reachable by Super+Shift+O; the owner wants it in the shell too, and wants popups muted while presenting.

# Scope
- In:
  - a Presentation service: watches $XDG_RUNTIME_DIR/presentation-mode.state (FileView, watchChanges), `active` bool; `toggle()` runs presentation-mode.sh (no optimistic state flip: state comes from the file, so the keybind and shell stay in sync both ways).
  - Dashboard toggle (placement picked by the owner from rendered options).
  - Settings > Appearance ToggleRow "Presentation mode" under Opacity, same service.
  - Notification popups suppressed while active (shell.qml popup gate), still stored in the notification centre; the user's own DND setting untouched.
- Out:
  - making already-open windows opaque (mango limitation; would need an upstream dispatcher).
  - changing the wallpaper (owner, 2026-11-24: not wanted).

# Acceptance criteria
- AC1: Dashboard and Appearance toggles show the real mode and flip it via the script; pressing Super+Shift+O updates both within ~1 s.
- AC2: With the mode on, a notification produces no popup but lands in the notification centre; the DND setting is unchanged.
- AC3: Renders (dark/light, Grimdark) show the toggles in both states; goldens pass except intended dashboard/appearance scenarios.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Owner, 2026-11-24: wants the toggle in BOTH the dashboard and Settings > Appearance; popups muted while presenting; wallpaper must stay.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_019_presentation_mode_in_the_shell`
- Primary task(s): `task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups`

# Priority
- Priority: Medium
- Rationale: Owner asked for it right after using the keybind in a meeting; the keybind already covers the need.

# Notes
- Generated locally by logics-manager.
- Task `task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups` was finished via `logics-manager flow finish task` on 2026-11-24.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |


# Tasks
- `task_086_shell_presentation_mode_dashboard_toggle_appearance_row_muted_popups`
