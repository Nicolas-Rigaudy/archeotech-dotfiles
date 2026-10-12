## adr_034_keyboard_panel_core_keymap_data_from_real_xkb_keymaps - Keyboard panel in core; keymap data from the real xkb keymaps
> Date: 2026-10-12
> Status: Accepted
> Related request: `req_005_2026_09_28_audit_upgrade_program`
> Related backlog: `item_144_keymap_helper_plugin`, `item_145_shortcuts_panel_replace_rofi`
> Related task: `task_053_shortcuts_panel_themed_searchable_keybind_sheet_replacing_the_rofi_menu`, `task_054_keymap_helper_plugin_character_search_and_keyboard_layer_diagram`
> Drivers: owner decisions 2026-10-12; per-keyboard layouts (item_136) make the same shortcut a different key per keyboard (Super+1 vs Super+&)
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Shortcuts (Super+K) and the character helper (Super+Shift+K) are one core Keyboard panel with two tabs, built from the compositor config and the real xkb keymaps of the keyboards in use.

# Context
- The rofi `show-keybinds.sh` list was hand-written and stale. With per-keyboard layouts, a `code:N` bind is a physical key whose label differs per keyboard, and keysym binds resolve through the keyboard's layout.
- The character helper started as a plugin (owner: "idk if it needs to be in the base version or as a plugin"). Once the owner asked for shortcuts to follow the selected keyboard, both views needed the same keymap data, keyboard picker and diagram.
- Plugins load by file:// URL and cannot import Commons or shell services, so a core panel cannot depend on a plugin's data.

# Decision
- One core panel, id `keybinds` (kept so existing strip icons and binds still work), in `Modules/Shell/Panels/Content/KeybindsPanel.qml` + `Keyboard/` (ShortcutsView, CharactersView, KeyDiagram). The tab is `Commons.State.keyboardTab`; IPC `keybinds toggle` / `keybinds characters` opens or switches it. The keymap plugin was removed.
- Keyboard data comes from `scripts/keymap-data.py`: keyboards from Settings → Input (`input.keyboardLayouts`) plus the compositor's global layouts (mango `xkb_rules_*`, Hyprland via `hyprctl`); each layout compiled with `xkbcli compile-keymap`; dead-key sequences from the locale's Compose table; per-keycode labels so `code:N` binds show the selected keyboard's key. Nothing is hand-maintained per layout.
- Shortcuts are parsed live from the mango config (`Services/Compositor/KeybindsLogic.js`, pure + tested): the comment above a bind is its description, categories come from the action.
- Generic plumbing kept from the plugin phase: `ipc call panel toggle <id>` for any panel, Strip hosting of shortcut-only panels (PanelRegistry side, or a plugin manifest's `panel.side`).

# Consequences
- Labels and combos are always the system's truth; a new layout needs no code. Cost: `xkbcli` (libxkbcommon) and python3 at runtime; one ~0.2 s script run per panel open.
- A personal `~/.XCompose` is not read; its sequences are not shown.
- Hyprland: the Characters tab works (global layout); the Shortcuts tab reads mango binds only.
- UI rules settled by the owner: lists read top to bottom (one line per letter form, é | É), one header row (tab switch + wide search), the keyboard choice sits on the diagram it changes, key hints in a footer.
