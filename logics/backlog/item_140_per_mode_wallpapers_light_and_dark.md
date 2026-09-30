## item_140_per_mode_wallpapers_light_and_dark - Per-mode wallpapers: light wallpaper for light themes
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85%
> Confidence: 80%
> Progress: 0%
> Complexity: Medium
> Theme: Theme
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Pair each mode with its own wallpaper so light themes sit on a light wallpaper and dark themes on a dark one.
- Keywords: per, mode, wallpapers, light, and, dark
- Use when: Working on light/dark look or transparency.
- Skip when: Palette or role changes (adr_033).

# Problem
- Light glass over a dark, busy wallpaper tints the panel (item_111 renders: hammerhead-shiver-4k); on light wallpapers glass is as clean as opaque.
- Reference: DMS 'Separate light and dark' wallpapers (Modules/Settings/WallpaperColorsTab.qml).
- Candidate light wallpapers: iQuickDev/catppuccin-wallpapers minimalistic/*-cat.png and gradients/* (luminance 0.78-0.90), plus the catalogue's a_snowy_mountain_tops_with_a_grey_sky / waves.png.

# Scope
- In:
  - Wallpaper picker: set a light and a dark wallpaper
  - theme-switch / ColorScheme light-dark schedule switches the wallpaper with the mode
  - Optionally add chosen pastel wallpapers to the catalogue (owner picks)
- Out:
  - Wallpaper-derived palettes

# Acceptance criteria
- AC1: Switching between a light and a dark theme also switches to that mode's wallpaper.
- AC2: With no per-mode wallpaper set, behaviour is unchanged.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Switching between a light and a dark theme also switches to that mode's wallpaper.

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
