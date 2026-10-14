## req_006_wallpaper_modes - Wallpaper modes: rotation, per-monitor, weather and effects
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 75
> Confidence: 70
> Complexity: Medium
> Theme: Theme
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: Make the wallpaper customisable beyond one picked image: one core "wallpaper source" rule (a single owner applies wallpapers, one active mode at a time, plugins add modes), then rotation, per-monitor and per-workspace wallpapers in core, and weather-driven and animated/effect wallpapers as plugins; plus pack-specific wallpapers (grimdark, hud, angular).
- Keywords: wallpaper, modes, rotation, slideshow, per-monitor, per-workspace, weather, animated, effects, plugin, source
- Use when: Adding any automatic or plugin-driven wallpaper behaviour, or changing who applies the wallpaper.
- Skip when: Per-mode light/dark wallpapers (item_140, shipped) or wallpaper-derived palettes (item_060).

# Needs
- Owner request (2026-10-14): day/night, weather and effect wallpapers, rolling through a selection, "different options like this to really customize the shell, some could be core shell or plugins".
- Today one wallpaper is applied by `wallpaper-set.sh`; item_140 added per-mode (light/dark) slots followed by the Wallpapers service. Day/night already works by combining the theme's Auto schedule with per-mode slots.
- Every new behaviour competes for the same screen, so the first slice is an arbitration rule: the core Wallpapers service is the only caller of wallpaper-set; it holds one active mode (fixed / per mode / rotation / a plugin source); a plugin registers a source instead of applying images itself.
- Scope IN: the source/mode contract with a plugin hook; rotation over a selection; per-monitor wallpapers; per-workspace wallpapers (item_033); weather plugin; animated/effect plugin; pack wallpapers.
- Scope OUT: wallpaper-derived colour palettes (item_060); a wallpaper download/browse service.

# Context
- Core vs plugin split: core = small, offline, expected by everyone (rotation, per-monitor, per-workspace); plugin = needs a provider or network (weather) or costs GPU/battery and is opt-in (animated video wallpapers via mpvpaper, particle/rain overlays, parallax).
- Seams: `Services/Theming/Wallpapers.qml` (applied path, apply queue, per-mode follow, brightness tones), `scripts/wallpaper-set.sh` (logo composite, portrait routing), the versioned plugin API (item_126), the plugin manifest (item_066).
- Brightness tones (item_140 follow-up) let a source pick wallpapers that suit the current light/dark mode.

# Acceptance criteria
- AC1: One owner applies wallpapers: the Wallpapers service exposes an active mode and a source contract that a plugin can register; two sources never apply over each other.
- AC2: Rotation cycles a chosen selection on an interval (shuffle or in order, skip on demand) and respects the light/dark mode.
- AC3: Per-monitor (and per-workspace, item_033) wallpapers can be set from the picker.
- AC4: A weather plugin and an animated/effect plugin each ship as an optional plugin using the source contract.
- AC5: Theme packs can ship or point to their own wallpapers (grimdark, hud, angular).

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Dependencies & Risks
- Depends on: item_126 (versioned plugin API) for the plugin slices; item_033 waits on CompositorService for tag switches.
- Risk: sources fighting (rotation vs per-mode vs a plugin) if the contract is skipped; build AC1 first.
- Risk: animated wallpapers cost battery on the laptop; opt-in only, paused on battery or fullscreen.
- Risk: weather needs location and network; no key-bound provider by default (Open-Meteo needs none).

# Companion docs
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet; AC1 likely needs an ADR)

# References
- `logics/backlog/item_140_per_mode_wallpapers_light_and_dark.md`
- `logics/backlog/item_033_per_workspace_wallpapers.md`
- `logics/backlog/item_126_versioned_plugin_api_exposing_shell_services.md`

# Backlog
- `item_146_wallpaper_source_contract_one_owner_active_mode_plugin_hook`
- `item_147_wallpaper_rotation_through_a_selection`
- `item_148_per_monitor_wallpapers`
- `item_149_weather_wallpapers_plugin`
- `item_150_animated_and_effect_wallpapers_plugin`
- `item_151_theme_pack_wallpapers_grimdark_hud_angular`
