## item_139_glass_opacity_setting_solid_soft_glass - Glass opacity setting: solid, soft, glass
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
- Summary: A Settings > Appearance control for panel/card opacity (solid / soft / glass), per the reference shells.
- Keywords: glass, opacity, setting, solid, soft, glass
- Use when: Working on light/dark look or transparency.
- Skip when: Palette or role changes (adr_033).

# Problem
- Light-theme glass (item_111) is fixed at panels 0.92 / cards 0.88 and dark at 0.96 / 0.58; there is no user control.
- All four reference shells expose it: caelestia transparency toggle, DMS popup/panel opacity slider, noctalia solid 1.0 / soft 0.80 / glass 0.55 (src/config/config_types.cpp:192-215).
- Owner 2026-09-30: 'we could always have a setting toggle'.

# Scope
- In:
  - Three presets (solid / soft / glass) scaling the panel, card and kitty background opacity, per mode
  - Applies live; kitty via theme-switch.py
- Out:
  - Real compositor blur (item_116)

# Acceptance criteria
- AC1: Switching the preset changes panel, card and kitty opacity live on light and dark themes.
- AC2: The contrast of text roles still meets the floor at the most transparent preset over a mid-grey wallpaper.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Switching the preset changes panel, card and kitty opacity live on light and dark themes.

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
- Rationale: owner follow-up from the item_111 glass vs opaque review (2026-09-30).

# Notes
- Generated locally by logics-manager.
