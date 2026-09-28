## item_120_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet - State-driven OSD, generic panel IPC and keybind cheatsheet
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Shell
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: State-driven OSD, generic panel IPC and keybind cheatsheet. The OSD only fires from keybinds, not from state changes
- Keywords: state, driven, osd, generic, panel, ipc, keybind, cheatsheet
- Use when: Implementing or reviewing the 0.50 Utility layer milestone work on shell.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- The OSD only fires from keybinds, not from state changes; there is no generic panel open <id> IPC so plugin panels cannot be keybound; README claims a keybind trigger that does not exist; no in-shell keybind cheatsheet.

# Scope
- In:
  - OSD driven by audio/brightness state
  - panel open|toggle <id> IPC
  - Cheatsheet panel parsed from the mango config
- Out:

# Acceptance criteria
- AC1: Changing volume from any source shows the OSD.
- AC2: Any panel id can be opened by IPC.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: Changing volume from any source shows the OSD.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: makes plugin panels bindable and the OSD truthful (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
