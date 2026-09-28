## item_108_toast_osd_and_network_service_hardening - Toast, OSD and network service hardening
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Low
> Theme: Services
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Toast, OSD and network service hardening. Toasts restart each other's timeouts on every arrival or dismiss and ignore the focused monitor (shell.qml:227-330)
- Keywords: toast, osd, network, service, hardening
- Use when: Implementing or reviewing the 0.31 Correctness sweep milestone work on services.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Toasts restart each other's timeouts on every arrival or dismiss and ignore the focused monitor (shell.qml:227-330); the OSD shows on every screen (shell.qml:255).
- Two nmcli monitor processes respawn with no backoff, a CPU spin without NetworkManager (Network.qml:49, VPN.qml:74).
- The Wi-Fi password is passed on argv, visible via ps (Network.qml:182).

# Scope
- In:
  - Per-toast timers; toasts and OSD follow the focused output
  - Exponential backoff for monitors
  - Pass Wi-Fi secrets via stdin or a secrets agent
- Out:
  - Native Networking migration (separate item)

# Acceptance criteria
- AC1: Each toast honours its own timeout and appears on the focused monitor.
- AC2: With NetworkManager stopped, CPU use stays flat.
- AC3: No secret appears in any process command line.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Each toast honours its own timeout and appears on the focused monitor.

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
- Rationale: correctness and security fixes, each small (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
