## item_049_dashboard_customizable_system_notes_data_reliability - Dashboard customizable System Notes + data reliability
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Dashboard
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-29 11:00:51

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: dashboard, customizable, system, notes, data, reliability
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Original System Notes stats (AWS/snapshot/VPN/updates) are flaky; user can't choose which stats show

# Scope
- In:
  - Config-driven stat selection with a per-stat fetch registry; harden AWS profile source, snapper no-timeline case, VPN TYPE match, updates caching/loading state
- Out:
  - New unrelated stats

# Acceptance criteria
- AC4: System Notes stats are user-selectable and only resolvable sources surface reliably

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC4: System Notes stats are user-selectable and only resolvable sources surface reliably
- request-AC4 -> This backlog slice. Proof: AC4: System Notes stats are user-selectable and only resolvable sources surface reliably

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — SystemNotes widget exists (delivered); remaining: config-driven stat selection + data reliability. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_043_dashboard_customizable_system_notes_data_reliability`

# Priority
- Priority: High
- Rationale: System Notes shows wrong data today (AWS readout, placeholders) (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_043_dashboard_customizable_system_notes_data_reliability`

# Notes
- Task `task_043_dashboard_customizable_system_notes_data_reliability` was finished via `logics-manager flow finish task` on 2026-09-29.
