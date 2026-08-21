## item_015_auto_hide_sides_in_fullscreen - Auto-hide sides in fullscreen
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Compositor UX
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: auto, hide, sides, fullscreen
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Bars/strips eat a sliver of screen; annoying in fullscreen presentations/video/games

# Scope
- In:
  - Auto-detect fullscreen -> hide sides + reveal on exit (holder-reveal reuse); manual force-hide keybind/setting via a ShellState hidden gate
- Out:
  - New chrome for the collapsed state

# Acceptance criteria
- AC2: Sides auto-hide on fullscreen and can be force-hidden manually, reappearing correctly

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Sides auto-hide on fullscreen and can be force-hidden manually, reappearing correctly
- request-AC4 -> This backlog slice. Proof: AC2: Sides auto-hide on fullscreen and can be force-hidden manually, reappearing correctly

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
