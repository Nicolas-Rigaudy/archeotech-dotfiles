## task_052_input_settings_pane_keyboard_layout_repeat_touchpad - Input settings pane: keyboard layout, repeat, touchpad
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 85%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-07 10:58:56

# AI Context
- Summary: Settings > Input on MangoWC: per-keyboard layouts via mango devicerules (one layout per keyboard), key repeat, touchpad; written to ~/.config/mango/archeotech-input.conf (sourced by the mango config) + layout-preserving reload.
- Keywords: input, settings, pane, keyboard, layout, repeat, touchpad
- Use when: Keyboard layout, repeat or touchpad behaviour.
- Skip when: Hyprland input (hyprland.conf).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_136_input_settings_keyboard_layout_repeat_touchpad`

# Acceptance criteria
- AC1: Changing layouts or repeat rate in the pane applies live and survives a restart, and the pane shows the active values.
- AC2: Touchpad toggles apply live on MangoWC.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_052_input_settings_pane_keyboard_layout_repeat_touchpad.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_052_input_settings_pane_keyboard_layout_repeat_touchpad.md` after implementation.

# Validation
- archeotech-shell f8f4c4d + dotfiles 818a85c (source-optional=archeotech-input.conf after the config's own input keys; generated file git-ignored). Isolated: pane renders with 3 simulated keyboards; the conf holds only changed keys + one devicerule per configured keyboard and parses in mango with no rule errors; write+reload is one chain (atomic write, skip when unchanged, save/restore the active xkb layout around reload_config); Input is instantiated at boot so a missing conf is re-synced from config.json. qml-reviewer blockers fixed (write/reload race, layout reset, comma in identifiers) plus: only changed keys written, 'Not applied' after a settled reload, no per-poll rebuild, 900 ms debounce, dedupe by vendor:product. tests 45/45, py 13/13, golden 25/25 (settings-* updated: Input in the sidebar). Pending owner: real keyboards + whether touchpad keys apply on reload.
- Owner test 2026-10-07: rules written + sourced but matched=false on all keyboards, pane said 'mango rejected the rule'. Root cause from mango 0.17.5 source (src/input/keyboard.c keyboard_create/find_device_rule, src/config/parse_config.c reset_option): device rules are applied only when a device is created; reload_config re-applies pointer settings (reapply_pointer) but not device rules. Matching is exact strcmp on name or vendor:product:name (our identifiers are right). Fixed the misleading status (archeotech-shell 4dee586): 'Saved: replug' / built-in 'next login'.

# Report
- Not started.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner 2026-10-07: layouts follow the KEYBOARD, not the display profile (mango 0.17.5 devicerule gives a keyboard its own keymap). Verified in a nested mango (shot.sh --mango-line): a rule takes ONE layout ('kb_layout:us,fr' -> 'Invalid device rule format: fr'), colons in values are fine, the keyword is 'devicerule' (docs say device_rule). Owner chose: Ajazz '3141:65021:2.4G Dongle' = us(altgr-intl) (accents via AltGr), built-in '1:1:AT Translated Set 2 keyboard' = fr; 'Default' keyboards keep the global fr,us + Alt+Shift.
