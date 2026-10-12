## item_145_shortcuts_panel_replace_rofi - Shortcuts panel: themed searchable keybind sheet replacing the rofi menu
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Shell
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Replace the Super+K rofi keybind sheet (dotfiles show-keybinds.sh) with a shell panel in the Archeotech design language: searchable, grouped, built from the live mango config.
- Keywords: keybinds, shortcuts, cheat sheet, super k, rofi, mango, panel
- Use when: Working on the keybind sheet or Super+K.
- Skip when: Typing characters / layouts (item_144).

# Problem
- Super+K runs ~/.local/bin/show-keybinds.sh, a plain rofi menu outside the shell's theme and design language (owner 2026-10-12).

# Scope
- In:
  - A shell panel opened by Super+K (shell IPC), themed like the rest (cards, SegmentedControl/search, tokens).
  - Built from the real mango config: bind/binds lines with their comments as descriptions, grouped by section, key codes shown as the key labels of the active layout (code:10 -> 1 on QWERTY, & on AZERTY).
  - Search by key or action.
- Out:
  - Editing keybinds.

# Acceptance criteria
- AC1: Super+K opens the themed panel listing every mango keybind with a readable description, searchable.
- AC2: code: binds show the key as labelled on the keyboard in use.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Super+K opens the themed panel listing every mango keybind with a readable description, searchable.

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
- Rationale: owner request 2026-10-12; daily-use panel outside the design language.

# Notes
- Generated locally by logics-manager.
