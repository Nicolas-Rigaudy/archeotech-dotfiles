## task_053_shortcuts_panel_themed_searchable_keybind_sheet_replacing_the_rofi_menu - Shortcuts panel: themed searchable keybind sheet replacing the rofi menu
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
> Indicators reviewed: 2026-10-12 14:20:03

# AI Context
- Summary: Super+K shortcuts panel in the shell, parsed live from the mango config, replacing the rofi show-keybinds.sh list.
- Keywords: shortcuts, panel, themed, searchable, keybind, sheet, replacing, rofi, menu
- Use when: changing the keybind sheet, its parser (KeybindsLogic.js) or how shortcut-only panels open.
- Skip when: editing the binds themselves (mango config) or the keymap helper (item_144).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_145_shortcuts_panel_replace_rofi`

# Acceptance criteria
- AC1: Super+K opens the themed panel listing every mango keybind with a readable description, searchable.
- AC2: code: binds show the key as labelled on the keyboard in use.

# Plan
- [x] Pure parser `Services/Compositor/KeybindsLogic.js` (+ `tests/qml/tst_keybindslogic.qml`): comment above a bind = description, runs merged, categories by action, code: keys as US / AZERTY labels.
- [x] `KeybindsPanel.qml` (bottom strip, search, masonry category cards), PanelRegistry + `keybinds` IPC; Strip fallback host for shortcut-only panels; optional opener icon.
- [x] shot.sh: mango config copied into the fake HOME as data; `--state keybinds`.
- [ ] Owner promotes; dotfiles Super+K rebound to `qs -c archeotech ipc call keybinds toggle`; retire show-keybinds.sh.
- [ ] Use `python3 -m logics_manager flow progress task task_053_shortcuts_panel_themed_searchable_keybind_sheet_replacing_the_rofi_menu.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_053_shortcuts_panel_themed_searchable_keybind_sheet_replacing_the_rofi_menu.md` after implementation.

# Validation
- tests/run.sh 56/56 (tst_keybindslogic 10 cases); golden.sh 25/25 after editmode-* updated for the new Shortcuts library tile; token-lint 0; qml-reviewer blocking merge bug fixed (bare spawn binds no longer merge); isolated renders at 1920x1200 with the owner's real 118 shortcuts, search and empty states.
- Finish workflow executed on 2026-10-12.
- Linked backlog/request close verification passed.

# Report
- Shell ec0facf: KeybindsLogic.js + KeybindsPanel.qml, keybinds IPC + optional opener icon, Strip fallback host for shortcut-only panels, shot.sh copies the mango config into the fake HOME. Dotfiles: Super+K bound to the panel (Hyprland keeps show-keybinds.sh). code: keys show US / AZERTY labels together (AC2). Limits: source= includes not followed; Hyprland binds not parsed. Awaiting owner check on the live bar.
- Owner review 2026-10-12: reorganised as category rail + description-first list (shell 3436033), implementation asides dropped; owner approved. Verified on a bottom strip, a vertical left strip and a top-bar dropdown; Shortcuts icon added to the owner's left strip.
- Finished on 2026-10-12.
- Linked backlog item(s): `item_145_shortcuts_panel_replace_rofi`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
