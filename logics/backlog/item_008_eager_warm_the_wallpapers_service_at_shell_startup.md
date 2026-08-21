## item_008_eager_warm_the_wallpapers_service_at_shell_startup - Eager-warm the Wallpapers service at shell startup
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Picker feel
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: eager, warm, wallpapers, service, shell, startup
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- First open of the picker is not instant because scan/thumbnail happens lazily

# Scope
- In:
  - Pre-warm the Wallpapers singleton at startup so even first open is instant
- Out:
  - Changing cache location

# Acceptance criteria
- AC5: The first picker open is instant

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: The first picker open is instant
- request-AC4 -> This backlog slice. Proof: AC5: The first picker open is instant

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
