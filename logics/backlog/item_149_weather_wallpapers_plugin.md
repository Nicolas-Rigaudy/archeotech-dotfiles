## item_149_weather_wallpapers_plugin - Weather wallpapers plugin
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
- Summary: Optional plugin: map the current weather (clear, cloudy, rain, snow, fog, night) to a set of wallpapers; uses the wallpaper source contract.
- Keywords: weather, wallpapers, plugin
- Use when: Weather-driven wallpaper.
- Skip when: A weather bar widget alone (may share the provider).

# Problem
- The owner wants the wallpaper to follow the weather.

# Scope
- In:
  - Weather provider with no API key (Open-Meteo), location from config
  - Condition to wallpaper-set mapping in plugin settings
  - Respects light/dark mode
- Out:
  - Core shell changes beyond the source contract

# Acceptance criteria
- AC1: With the plugin active, a change of weather condition switches to a wallpaper from that condition's set.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: With the plugin active, a change of weather condition switches to a wallpaper from that condition's set.

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
- Rationale: Nice to have; needs item_146 and item_126.

# Notes
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.
