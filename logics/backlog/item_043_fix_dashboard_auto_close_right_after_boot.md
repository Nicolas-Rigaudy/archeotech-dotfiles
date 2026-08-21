## item_043_fix_dashboard_auto_close_right_after_boot - Fix dashboard auto-close right after boot
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Dashboard bug
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: fix, dashboard, auto, close, right, after, boot
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- S14 openAuto shows the dashboard ~4s on login; opening manually in that window collides with the auto-hide timer and snaps shut

# Scope
- In:
  - Cancel/ignore the auto-hide once the user opens the dashboard manually
- Out:
  - Rewriting openAuto

# Acceptance criteria
- AC2: Manually opening the dashboard during the boot window keeps it open

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Manually opening the dashboard during the boot window keeps it open

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
