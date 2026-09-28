## item_119_notifications_v2_actions_images_grouping_history - Notifications v2: actions, images, grouping, history
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Notifications
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Notifications v2: actions, images, grouping, history. actionsSupported is false (Services/System/Notifications.qml:18)
- Keywords: notifications, actions, images, grouping, history
- Use when: Implementing or reviewing the 0.50 Utility layer milestone work on notifications.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- actionsSupported is false (Services/System/Notifications.qml:18); no images, grouping, persisted history or keyboard navigation in the notification center.

# Scope
- In:
  - Actions and inline reply, images, per-app grouping, persisted history, keyboard navigation
- Out:

# Acceptance criteria
- AC1: A notification with actions exposes working buttons.
- AC2: History survives a shell reload.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: A notification with actions exposes working buttons.

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
- Rationale: notifications are bare compared to every peer shell (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
