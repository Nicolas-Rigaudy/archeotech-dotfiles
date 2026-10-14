## item_148_per_monitor_wallpapers - Per-monitor wallpapers
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
- Summary: Pick a different wallpaper per output (laptop, portrait DP-3, ultrawide) from the picker; wallpaper-set routes each image to its output.
- Keywords: per, monitor, wallpapers
- Use when: Multi-monitor wallpaper setups.
- Skip when: Per-workspace wallpapers (item_033).

# Problem
- All outputs show the same wallpaper (portrait outputs only get a cropped or blurred variant of it).

# Scope
- In:
  - Picker: choose the target output (all or one)
  - Per-output slots, combined with per-mode
  - wallpaper-set: apply an image to one output
- Out:
  - Spanning one image across outputs

# Acceptance criteria
- AC1: Each connected output can show its own wallpaper set from the picker, and it survives a restart.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: Each connected output can show its own wallpaper set from the picker, and it survives a restart.

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
- Rationale: Owner runs three outputs at work.

# Notes
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.
