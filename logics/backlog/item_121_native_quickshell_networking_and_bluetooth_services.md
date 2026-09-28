## item_121_native_quickshell_networking_and_bluetooth_services - Native Quickshell Networking and Bluetooth services
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Services
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Native Quickshell Networking and Bluetooth services. Networking and Bluetooth still shell out to nmcli/bluetoothctl though native Quickshell modules exist
- Keywords: native, quickshell, networking, bluetooth, services
- Use when: Implementing or reviewing the 0.50 Utility layer milestone work on services.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Networking and Bluetooth still shell out to nmcli/bluetoothctl though native Quickshell modules exist; SystemClock, LazyLoader, IdleMonitor, ToplevelManager are also unused; JsonAdapter is documented in ADR-009 but not used.

# Scope
- In:
  - Migrate Network, VPN and Bluetooth services to native modules
  - Adopt SystemClock and LazyLoader where they remove timers or always-loaded surfaces
- Out:
  - Lock screen and polkit

# Acceptance criteria
- AC1: No nmcli or bluetoothctl process is spawned for state tracking.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: No nmcli or bluetoothctl process is spawned for state tracking.

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
- Rationale: replaces about 19 shell-out processes (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
