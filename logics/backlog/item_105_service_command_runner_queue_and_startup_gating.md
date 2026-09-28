## item_105_service_command_runner_queue_and_startup_gating - Service command runner queue and startup gating
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
- Summary: Service command runner queue and startup gating. MangoService._cmd (MangoService.qml:278), ColorScheme.qml:71-88 and Brightness.qml:67-75 reuse one Process
- Keywords: service, command, runner, queue, startup, gating
- Use when: Implementing or reviewing the 0.31 Correctness sweep milestone work on services.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- MangoService._cmd (MangoService.qml:278), ColorScheme.qml:71-88 and Brightness.qml:67-75 reuse one Process; setting running=true while busy is a no-op, so tag clicks during a decoration script are lost and a quick second theme click shows theme B while A stays applied (verified).
- Config and packs load asynchronously; boot applies base window decoration then re-applies when the pack loads (second call likely dropped), theme-switch.py re-runs on every boot with a pack active, and an early Config.set can overwrite config.json.

# Scope
- In:
  - A shared command helper that queues or detaches (execDetached) and reports failures
  - Gate startup side-effects on config + pack registry ready; skip redundant boot theme-switch
- Out:
  - Native Networking/Bluetooth migration

# Acceptance criteria
- AC1: Two theme changes issued 100ms apart both apply in order and the final UI state matches the system.
- AC2: A cold boot with a pack active runs theme-switch at most once and never rewrites config.json before it has loaded.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Two theme changes issued 100ms apart both apply in order and the final UI state matches the system.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-09-28 (task_037, archeotech-shell 45a3cc7): the config-overwrite race is fixed at its root - Config.ready now waits for FileView loaded()/loadFailed(); ColorScheme._bootResolve (the early writer, via ColorScheme.qml:110/126) already gated on ready, so 0 writes before load after the fix. Remaining scope here: the queued/detached command runner (MangoService, ColorScheme, Brightness, PowerPane cmdRunner) and theme-switch re-running on every boot with a pack active.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: silently dropped commands make the UI lie about system state (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
