## item_150_animated_and_effect_wallpapers_plugin - Animated and effect wallpapers plugin
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
- Summary: Optional plugin: animated or video wallpapers (mpvpaper) and effect overlays (rain, particles, slow parallax), paused on battery or fullscreen.
- Keywords: animated, effect, wallpapers, plugin
- Use when: Animated or effect wallpapers.
- Skip when: Static wallpaper features.

# Problem
- The owner wants effect wallpapers; they cost GPU and battery, so they must be opt-in.

# Scope
- In:
  - Video wallpaper source (mpvpaper)
  - Overlay effects layer
  - Pause on battery, fullscreen or idle
- Out:
  - Shipping large video files in the repo

# Acceptance criteria
- AC1: An animated wallpaper or effect can be enabled from the plugin, runs smoothly, and pauses on battery and fullscreen.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: An animated wallpaper or effect can be enabled from the plugin, runs smoothly, and pauses on battery and fullscreen.

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
- Priority: Low
- Rationale: Showcase value; opt-in and heavier.

# Notes
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.
