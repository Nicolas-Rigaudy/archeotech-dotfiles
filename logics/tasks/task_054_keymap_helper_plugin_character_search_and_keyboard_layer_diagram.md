## task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram - Keymap helper plugin: character search and keyboard layer diagram
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
> Indicators reviewed: 2026-10-12 15:18:42

# AI Context
- Summary: Bundled `keymap` plugin module: per-keyboard character search, 4-level keyboard diagram, click to copy; data from real xkb keymaps + the Compose table via modules/keymap/keymap-data.py.
- Keywords: keymap, helper, plugin, character, search, keyboard, layer, diagram
- Use when: changing the keymap plugin, its data script, or how plugin panels open from a keybind (`ipc call panel toggle`).
- Skip when: per-keyboard layout settings (item_136) or the compositor shortcuts sheet (item_145).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_144_keymap_helper_plugin`

# Acceptance criteria
- AC1: Searching "e" on the Ajazz (us altgr-intl) lists é è ê ë and their capitals with the exact combos from the keymap and Compose tables.
- AC2: The diagram shows the AltGr layer of the selected keyboard's real layout, and clicking a character copies it.

# Plan
- [x] `modules/keymap/keymap-data.py` (+ `tests/py/test_keymap_data.py`): keyboards from Settings → Input + global xkb layouts, xkbcli keymaps, Compose dead-key sequences, combos per character.
- [x] `Keymap.qml`: keyboard pills, search (char / letter / name), result tiles with combos, keyboard diagram, wl-copy.
- [x] Shell: `panel` IPC target (any panel id), Strip fallback for plugin panels + manifest `panel.side`; shot.sh `--state panel:<id>`.
- [ ] Owner check on the live bar; dotfiles Super+Shift+K → `qs -c archeotech ipc call panel toggle plugin:keymap`.
- [ ] Use `python3 -m logics_manager flow progress task task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram.md` after implementation.

# Validation
- python3 -m unittest discover -s tests/py: 23 OK (test_keymap_data 10 cases: us altgr-intl e family exact combos (AC1), fr dead-key base level, ISO by layout id, typed key bodies, keyboards from Settings > Input); tests/run.sh 57/57; golden.sh 25/25 after editmode-* updated for the new Plugins tile; qml-reviewer: no blocking, should-fixes applied; isolated renders 1920x1200: bottom panel, vertical left strip, fr AZERTY board, us-intl search 'e' with keys lit.
- Shell cfdf2b0: tests/run.sh 58/58, tests/py 24 OK, token-lint 0, golden.sh 25/25 (editmode-* updated), qml-reviewer findings applied (tab switch via IPC resets search, header elide, min list height, memoised parse, number-row-only collapse); isolated renders: left strip (owner config) Shortcuts on the AZERTY (Super & … ç, & key lit) and Characters 'e', bottom placement.
- Finish workflow executed on 2026-10-12.
- Linked backlog/request close verification passed.

# Report
- Shell dca04bc: modules/keymap (module.json, Keymap.qml, keymap-data.py), panel IPC target, Strip fallback for plugin panels + manifest panel.side, shot.sh --state panel:<id>. Dotfiles: Super+Shift+K bound. Pending: owner check on the live bar (AC2 click-to-copy needs a real clipboard).
- Owner approved the Keyboard panel UI/UX 2026-10-12 (shell 2af2dcf). Click-to-copy with the real clipboard was not separately confirmed by the owner.
- Finished on 2026-10-12.
- Linked backlog item(s): `item_144_keymap_helper_plugin`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner 2026-10-12: results as one line per letter form (é | É) grouped by letter, read top to bottom (cards and 2-column grid rejected); keymap merged into the Super+K panel as one core Keyboard panel (tabs Shortcuts | Characters, shared keyboard picker + diagram), shortcuts keyed to the selected keyboard's labels (Super+1 vs Super+&). The plugin was removed; panel id stays keybinds (owner's left-strip icon).
- Owner 2026-10-12: decluttered header (shell 2af2dcf): one row = segmented Shortcuts|Characters + wide search (count in the hint, 'copied' notice inside the field), keyboard picker moved to a dropdown in the diagram header next to the legend, title/status line and close button dropped (Esc / click outside), one muted key-hints footer (errors show there). Gates: tests 58/58, token-lint 0, golden 25/25.
