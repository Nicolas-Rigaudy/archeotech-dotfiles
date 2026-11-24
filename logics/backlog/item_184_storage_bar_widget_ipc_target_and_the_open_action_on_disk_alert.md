## item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert - Storage bar widget, IPC target and the Open action on disk-alert
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Storage
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:33:40

# AI Context
- Summary: Storage bar widget with warn/critical colours, the storage IPC target and the disk-alert notification Open action.
- Keywords: storage, bar, widget, ipc, target, open, action, disk, alert
- Use when: Wiring the bar widget, IPC or the low-space notice to the panel.
- Skip when: Notification actions themselves (item_119).

# Problem
- The panel must be reachable from the bar and from the low-space notice.

# Scope
- In:
  - Widgets/Bar/StorageWidget.qml: used-space ring or bar, warn/critical colours from the same thresholds as disk-alert (configSchema), click opens the panel, hover card with free space.
  - IpcHandler target storage: open, toggle, rescan.
  - Dotfiles: disk-alert's notification carries an Open action that calls the storage IPC (after item_119 lands notification actions); docs/TOOLS.md and the shell docs describe the module and the source format.
- Out:
  - Notification actions themselves (item_119).

# Acceptance criteria
- AC4: The widget colour follows the thresholds, clicking it opens the panel, and qs ipc call storage open opens it in the isolated session.
- AC4: With item_119 actions in place, the disk-alert notice's Open button opens the panel.
- AC5: The docs describe the source format and the owner's private sources.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: The widget colour follows the thresholds, clicking it opens the panel, and qs ipc call storage open opens it in the isolated session.
- request-AC5 -> This backlog slice. Proof: AC4: With item_119 actions in place, the disk-alert notice's Open button opens the panel.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_008_storage_module`
- Architecture decision(s): (none yet)
- Request: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
- Primary task(s): `task_085_orchestrate_the_storage_module`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
