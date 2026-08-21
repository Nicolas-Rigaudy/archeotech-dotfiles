## item_018_lock_screen_customization_widgets_settings_pane - Lock screen customization / widgets Settings pane
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Lock screen
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: lock, screen, customization, widgets, settings, pane
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- hyprlock is driven by a static text file with no live QML/IPC; cannot configure from a pane today

# Scope
- In:
  - Config-generator that emits hyprlock.conf from a config model; Settings pane for element toggles, layout presets, phrase list, clock format; store in Persistence.Config
- Out:
  - Arbitrary QML widgets on the lock surface

# Acceptance criteria
- AC2: A Lock Screen pane regenerates hyprlock.conf from user choices with a default Console preset

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: A Lock Screen pane regenerates hyprlock.conf from user choices with a default Console preset
- request-AC3 -> This backlog slice. Proof: AC2: A Lock Screen pane regenerates hyprlock.conf from user choices with a default Console preset

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
