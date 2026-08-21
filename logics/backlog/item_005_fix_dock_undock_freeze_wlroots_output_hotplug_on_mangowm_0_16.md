## item_005_fix_dock_undock_freeze_wlroots_output_hotplug_on_mangowm_0_16 - Fix dock-undock freeze (wlroots output-hotplug) on mangowm 0.16
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Stability
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: fix, dock, undock, freeze, wlroots, output, hotplug, mangowm
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Unplugging the dock hangs MangoWC completely (even laptop kbd/trackpad dead); wlroots output-hotplug hang; distribution-blocking for laptop+dock users

# Scope
- In:
  - Verify whether mangowm->wlroots 0.20.2 update resolves it; record in DECISIONS or file upstream report
- Out:
  - Patching wlroots itself

# Acceptance criteria
- AC4: Dock-undock no longer freezes the compositor, or a robust fallback path is confirmed

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: Dock-undock no longer freezes the compositor, or a robust fallback path is confirmed

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
