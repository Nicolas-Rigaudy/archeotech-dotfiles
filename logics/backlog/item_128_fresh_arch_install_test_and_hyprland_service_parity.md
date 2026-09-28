## item_128_fresh_arch_install_test_and_hyprland_service_parity - Fresh-Arch install test and Hyprland service parity
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Distribution
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Fresh-Arch install test and Hyprland service parity. HyprlandService stubs fullscreen detection, client list and layout, breaking fullscreen auto-hide and window brackets there
- Keywords: fresh, arch, install, test, hyprland, service, parity
- Use when: Implementing or reviewing the 1.0 Release milestone work on distribution.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- HyprlandService stubs fullscreen detection, client list and layout, breaking fullscreen auto-hide and window brackets there; no scripted install test exists.

# Scope
- In:
  - Complete HyprlandService parity
  - Scripted fresh-Arch container or VM install that runs the golden suite on both compositors
- Out:

# Acceptance criteria
- AC1: The scripted install passes the goldens on MangoWC and Hyprland.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC1: The scripted install passes the goldens on MangoWC and Hyprland.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: the 1.0 exit test (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
