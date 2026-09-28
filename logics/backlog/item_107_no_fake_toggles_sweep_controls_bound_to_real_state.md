## item_107_no_fake_toggles_sweep_controls_bound_to_real_state - No-fake-toggles sweep: controls bound to real state
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 14:27:44

# AI Context
- Summary: No-fake-toggles sweep: controls bound to real state. ToggleSwitch.qml:74 assigns checked on click, breaking the checked: root.checked binding in ToggleRow.qml:51, so switches detach from real state after one click (verified).
- Keywords: fake, toggles, sweep, controls, bound, real, state
- Use when: Implementing or reviewing the 0.31 Correctness sweep milestone work on settings.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- ToggleSwitch.qml:74 assigns checked on click, breaking the checked: root.checked binding in ToggleRow.qml:51, so switches detach from real state after one click (verified).
- Nothing reads toastTimeout, maxToasts, showOnFullscreen or persistDnd from NotificationsPane.qml:46-76 (verified); toast timeout is hardcoded in NotifToast.qml.
- Grimdark renders dark regardless of Light/Auto, yet the mode control stays enabled (render matrix).
- SystemNotes.qml:54 reads the shell process's own $AWS_PROFILE, always unset or stale; the Power pane calls a dotfiles-only swayidle script.

# Scope
- In:
  - Make ToggleSwitch a controlled component (emit toggled, never self-assign)
  - Wire the four notification settings; persist DnD
  - Disable or hide mode controls a pack does not support; fix AWS readout source; guard dotfiles-only actions
- Out:
  - Notifications v2 features

# Acceptance criteria
- AC1: Every Settings control reflects external state changes after being clicked.
- AC2: Changing each notification setting changes toast behaviour immediately.
- AC3: No Settings control is visible that has no effect in the current configuration.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Every Settings control reflects external state changes after being clicked.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_037_no_fake_toggles_sweep_controls_bound_to_real_state`

# Priority
- Priority: High
- Rationale: directly violates design rule 6 in several places (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_037_no_fake_toggles_sweep_controls_bound_to_real_state`

# Notes
- Task `task_037_no_fake_toggles_sweep_controls_bound_to_real_state` was finished via `logics-manager flow finish task` on 2026-09-28.
