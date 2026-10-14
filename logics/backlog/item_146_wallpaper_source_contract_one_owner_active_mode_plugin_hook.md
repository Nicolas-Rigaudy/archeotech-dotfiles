## item_146_wallpaper_source_contract_one_owner_active_mode_plugin_hook - Wallpaper source contract: one owner, active mode, plugin hook
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
- Summary: Make the Wallpapers service the only caller of wallpaper-set, with one active wallpaper mode (fixed, per mode, rotation, or a registered plugin source) and a source hook plugins use instead of applying images themselves.
- Keywords: wallpaper, source, contract, owner, active, mode, plugin, hook
- Use when: Adding any automatic wallpaper behaviour or a plugin that changes the wallpaper.
- Skip when: Picker UI polish.

# Problem
- Rotation, per-mode, weather and effect wallpapers all want the screen; without one owner they overwrite each other (per-mode already re-applies its slot on every mode flip).

# Scope
- In:
  - Active mode in config + Settings selector
  - Source contract: a source proposes the next wallpaper (path or a live surface) for an output and the current light/dark mode
  - Plugin registration through the versioned plugin API (item_126)
  - ADR for the contract
- Out:
  - The sources themselves (sibling items)

# Acceptance criteria
- AC1: Only the Wallpapers service applies wallpapers; one mode is active at a time; a plugin source can be registered and selected, and two sources never apply over each other.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Only the Wallpapers service applies wallpapers; one mode is active at a time; a plugin source can be registered and selected, and two sources never apply over each other.

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
- Priority: High
- Rationale: Every other wallpaper slice builds on it.

# Notes
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.
