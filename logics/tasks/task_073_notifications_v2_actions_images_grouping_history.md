## task_073_notifications_v2_actions_images_grouping_history - Notifications v2: actions, images, grouping, history
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 30%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: Notifications v2; persisted history done, actions, images, grouping and keyboard navigation wait on visual choices.
- Keywords: notifications, actions, images, grouping, history
- Use when: Working on Services/System/Notifications.qml or the notification center.
- Skip when: Toast look and the OSD.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_119_notifications_v2_actions_images_grouping_history`

# Acceptance criteria
- AC1: A notification with actions exposes working buttons.
- AC2: History survives a shell reload.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_073_notifications_v2_actions_images_grouping_history.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_073_notifications_v2_actions_images_grouping_history.md` after implementation.

# Validation
- command: tests/run.sh 86 pass (new tst_notificationslogic.qml), tests/py 35 OK, qmllint-ci rc 0, token-lint 0; headless shot.sh on night/fallback: 3 notify-send notifications, nested qs killed and relaunched, center opened by IPC on the new instance shows all 3 (notif-history-after-restart.png); the same run on the old code shows an empty center (notif-history-control-old-code.png). Renders in cr-0w/local/state/night/shots/fallback-2026-10-21/ | result: passed | date: 2026-10-21. A Quickshell hot reload could not be triggered in the nested session (rewriting shell.qml did not reload it), so the reload path (re-attaching kept notifications by id) is covered by the unit test only.

# Report
- AC2 (shell night/fallback, 13e04f0): the center's list is written to ~/.local/share/archeotech/notifications.json (debounced, newest 100 entries, no live objects) and read back at startup. It restores once before any write, so an empty startup list never overwrites the file, and notifications that arrive during the read stay after the restored ones. After a hot reload the server's kept notifications (keepOnReload) are re-attached by id, so dismissing one still closes it for the app. Logic in Services/System/NotificationsLogic.js.
- Paused, visual choices: AC1 action buttons and inline reply (actionsSupported is still false: turning it on without buttons would tell apps actions work), images, per-app grouping and keyboard navigation in the center. Each needs a layout decision first; candidates are a button row under the body vs chips on the right, and grouped stacks vs app headers.
- Note: notification text now sits on disk in the user's data dir. The limit (100) is a constant, not a setting.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
