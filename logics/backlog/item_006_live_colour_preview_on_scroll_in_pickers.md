## item_006_live_colour_preview_on_scroll_in_pickers - Live colour preview on scroll in pickers
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Picker feel
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: live, colour, preview, scroll, pickers
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- No live palette preview while scrolling the wallpaper carousel; wallpaper-set.sh is heavy so live-apply-on-scroll is avoided

# Scope
- In:
  - Add --print-color to wallpaper-set.sh (extract accent, print, don't apply) + in-shell preview palette
- Out:
  - Applying the wallpaper live on every scroll tick

# Acceptance criteria
- AC5: Scrolling the wallpaper picker previews the extracted palette without applying

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Scrolling the wallpaper picker previews the extracted palette without applying
- request-AC1 -> This backlog slice. Proof: AC5: Scrolling the wallpaper picker previews the extracted palette without applying

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
