## item_033_per_workspace_wallpapers - Per-workspace wallpapers
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
- Keywords: per, workspace, wallpapers
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Same wallpaper across all tags

# Scope
- In:
  - Different awww image per tag, transition on switch, hook via CompositorService.onTagSwitched
- Out:
  - Standalone until CompositorService lands (multi-compositor dependency)

# Acceptance criteria
- AC2: Wallpaper changes per workspace with a transition on tag switch

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Wallpaper changes per workspace with a transition on tag switch
- request-AC4 -> This backlog slice. Proof: AC2: Wallpaper changes per workspace with a transition on tag switch

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Low
- Rationale: Set by scaffold input or defaulted for grooming.
