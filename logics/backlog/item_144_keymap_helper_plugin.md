## item_144_keymap_helper_plugin - Keymap helper plugin: character search and keyboard layer diagram
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Input
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-10-12 15:18:42

# AI Context
- Summary: An archeotech-shell plugin (module) that answers "how do I type X" for the keyboard in use: search by character or base letter, a keyboard diagram with Shift/AltGr layers, click to copy. Generic for any xkb layout.
- Keywords: keymap, keyboard, layout, altgr, dead keys, compose, accents, cheat sheet, plugin, module
- Use when: Building or extending the keymap helper module.
- Skip when: Per-keyboard layout configuration (item_136) or compositor keybinds (item_145).

# Problem
- With per-keyboard layouts (item_136), the external keyboard is us(altgr-intl): French characters need AltGr combos and dead keys the owner has to look up (a static sheet exists: dotfiles docs/KEYBOARD-US-INTL.md).
- Owner 2026-10-12: wants it in the shell as a plugin, generic for any custom keymap/layout.

# Scope
- In:
  - Module in archeotech-shell modules/ (panel-content + bar/strip opener), enabled from Settings > Plugins.
  - Data from the real keymap (xkbcli compile-keymap --layout/--variant) and the system Compose tables for dead-key sequences, for the layouts set per keyboard in Settings > Input (fallback: the global xkb layouts).
  - Search: a character (è, €, «) or a base letter ("e" lists é è ê ë É È Ê Ë with their combos).
  - Keyboard diagram with base / Shift / AltGr / AltGr+Shift layers; dead keys highlighted.
  - Click a character to copy it to the clipboard.
  - Keybind Super+Shift+K opens it (Super+K stays the shortcuts sheet, item_145).
- Out:
  - Editing layouts (item_136), compositor shortcuts (item_145).

# Acceptance criteria
- AC1: Searching "e" on the Ajazz (us altgr-intl) lists é è ê ë and their capitals with the exact combos from the keymap and Compose tables.
- AC2: The diagram shows the AltGr layer of the selected keyboard's real layout, and clicking a character copies it.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Searching "e" on the Ajazz (us altgr-intl) lists é è ê ë and their capitals with the exact combos from the keymap and Compose tables.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: owner request 2026-10-12 after moving the Ajazz to US International; also a real showcase for the plugin API.

# Notes
- Generated locally by logics-manager.
- Task `task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram` was finished via `logics-manager flow finish task` on 2026-10-12.

# Tasks
- `task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram`
