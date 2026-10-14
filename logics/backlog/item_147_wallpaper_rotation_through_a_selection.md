## item_147_wallpaper_rotation_through_a_selection - Wallpaper rotation through a selection
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Core rotation mode: cycle a chosen selection (folder, favourites, or the wallpapers that suit the current light/dark mode) on an interval, in order or shuffled, with a skip action.
- Keywords: wallpaper, rotation, through, selection
- Use when: Slideshow or rotating wallpapers.
- Skip when: Weather or animated wallpapers (plugins).

# Problem
- The owner wants the wallpaper to roll through a selection automatically.

# Scope
- In:
  - Selection: all, favourites (mark in the picker), or by tone (light/dark/both)
  - Interval, order or shuffle, skip next (IPC + keybind)
  - Respects light/dark mode via the brightness tones
- Out:
  - Per-monitor different rotations (later)

# Acceptance criteria
- AC1: With rotation active, the wallpaper changes every interval through the chosen selection, honours shuffle and skip, and only uses wallpapers that suit the current mode.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: With rotation active, the wallpaper changes every interval through the chosen selection, honours shuffle and skip, and only uses wallpapers that suit the current mode.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `logics/request/req_006_wallpaper_modes.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Most-asked core option; small, offline.

# Notes
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.
