## req_015_fix_bluetooth_device_removal_and_silent_panel_buttons - Fix bluetooth device removal and silent panel buttons
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: bluetoothd segfaults on RemoveDevice and the panel connect and trash buttons fail without feedback.
- Keywords: fix, bluetooth, device, removal, silent, panel, buttons
- Use when: picking up this shell fix.
- Skip when: working on another area of the shell.

# Needs
- bluetoothd segfaults on RemoveDevice and the panel connect and trash buttons fail without feedback.

# Context
- bluez 5.87-2 segfaults on RemoveDevice.
- The connect and trash buttons show no error when the call fails.

# Acceptance criteria
- AC1: Removing a device no longer crashes bluetoothd, by a workaround or an upstream fix.
- AC2: The connect and trash buttons show an error toast on failure.
- AC3: The bluez bug is reported upstream if not already known.

# Definition of Ready (DoR)
- [ ] Problem statement is explicit and user impact is clear.
- [ ] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- none

# Backlog
- none

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

