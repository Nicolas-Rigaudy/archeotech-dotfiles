## item_136_input_settings_keyboard_layout_repeat_touchpad - Input settings pane: keyboard layout, repeat, touchpad
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85%
> Confidence: 80%
> Progress: 0%
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: New Input pane for keyboard and pointer settings, applied through the compositor.
- Keywords: settings, input, settings, keyboard, layout, repeat, touchpad
- Use when: Implementing this Settings addition picked from the item_134 audit.
- Skip when: Working on other Settings panes; see item_134 for the full comparison.

# Problem
- No keyboard or pointer settings exist; the AZERTY built-in / QWERTY external switch (Alt+Shift) lives only in mango config.
- Reference: DMS Keyboard + Mouse & touchpad tabs.

# Scope
- In:
  - Keyboard layouts and switch shortcut, repeat delay/rate
  - Touchpad natural scroll, tap-to-click, pointer speed, disable-while-typing
  - Values read back from the compositor config they write
- Out:
  - Per-device rules beyond internal vs external

# Acceptance criteria
- AC1: Changing layouts or repeat rate in the pane applies live and survives a restart, and the pane shows the active values.
- AC2: Touchpad toggles apply live on MangoWC.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Changing layouts or repeat rate in the pane applies live and survives a restart, and the pane shows the active values.

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
- Rationale: owner picked it from the item_134 settings audit (2026-09-29).

# Notes
- Generated locally by logics-manager.
