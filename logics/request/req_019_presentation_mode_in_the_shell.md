## req_019_presentation_mode_in_the_shell - Presentation mode in the shell: toggle, Appearance row, muted popups
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: shell
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 17:53:54

# AI Context
- Summary: Presentation mode (dotfiles scripts/presentation-mode.sh) reachable from the shell with real state, and notification popups muted while it is on.
- Keywords: presentation, mode, shell, toggle, appearance, row, muted, popups
- Use when: changing presentation mode, its shell toggles or the popup gate.
- Skip when: changing the theme Opacity preset (Glass/Solid).

# Needs
- When presenting or screen sharing, programs (e.g. LibreOffice) must open opaque so the wallpaper does not show through; the wallpaper itself stays.
- The mode must be reachable from the shell (not only Super+Shift+O), stay in sync with the keybind both ways, and keep popups quiet while on.

# Context
- Script shipped in archeotech-dotfiles bc60cf1 (Super+Shift+O); state file $XDG_RUNTIME_DIR/presentation-mode.state.
- Mango applies opacity at map only, so the mode affects windows opened afterwards (kitty switches live).

# Acceptance criteria
- AC1: A quick toggle in the Appearance quick panel (Super+W) and a Settings > Appearance row both reflect the real script state and run the script on click.
- AC2: Notification popups are muted while the mode is on; notifications still reach the notification centre.
- AC3: The keybind and the shell agree both ways (IPC target `presentation` toggle/on/off/status).

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- `scripts/presentation-mode.sh`

# Backlog
- `item_187_shell_presentation_mode_toggle_and_muted_popups`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
