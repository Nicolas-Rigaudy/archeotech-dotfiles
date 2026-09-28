## item_127_portability_hardening_for_strangers_machines - Portability hardening for strangers' machines
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Distribution
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Portability hardening for strangers' machines. Without jq no modules or packs are found (jq undeclared)
- Keywords: portability, hardening, strangers, machines
- Use when: Implementing or reviewing the 1.0 Release milestone work on distribution.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Without jq no modules or packs are found (jq undeclared); theme-switch.py overwrites starship, fish and swaylock configs; amixer -c 0, hci0, pacman and kitty are hardcoded; idle and night-light settings only work with the owner's dotfiles; Sway/niri get no workspaces.

# Scope
- In:
  - Opt-in theme-switch targets per app
  - Declared dependencies and a dependency health pane in Settings
  - Machine-specific values become settings
- Out:
  - Niri/Sway services (item_089)

# Acceptance criteria
- AC1: On a machine without the owner's dotfiles, no Settings control silently does nothing and no user config is overwritten without opt-in.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC1: On a machine without the owner's dotfiles, no Settings control silently does nothing and no user config is overwritten without opt-in.

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
- Rationale: required for the public 1.0 (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
