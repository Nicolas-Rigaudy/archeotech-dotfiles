## item_010_move_thumbnail_cache_to_freedesktop_shared_path - Move thumbnail cache to freedesktop shared path
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Picker feel
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: move, thumbnail, cache, freedesktop, shared, path
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Thumb cache is app-private; file managers can't reuse it

# Scope
- In:
  - Optionally move cache to ~/.cache/thumbnails so file managers reuse it
- Out:
  - Mandating the shared path

# Acceptance criteria
- AC4: Thumbnail cache can live at the freedesktop shared path

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: Thumbnail cache can live at the freedesktop shared path

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
