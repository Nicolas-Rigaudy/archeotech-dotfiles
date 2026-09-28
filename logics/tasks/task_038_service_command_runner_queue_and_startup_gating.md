## task_038_service_command_runner_queue_and_startup_gating - Service command runner queue and startup gating
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 15:15:34

# AI Context
- Summary: Commons/CommandRunner queues (or coalesces) service commands so none is dropped; ColorScheme boot waits for config + pack dir and skips a steady-state theme-switch re-run.
- Keywords: service, command, runner, queue, startup, gating
- Use when: Adding any service action that runs an external command, or touching theme boot.
- Skip when: Native Networking/Bluetooth migration (item_121).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_105_service_command_runner_queue_and_startup_gating`

# Acceptance criteria
- AC1: Two theme changes issued 100ms apart both apply in order and the final UI state matches the system.
- AC2: A cold boot with a pack active runs theme-switch at most once and never rewrites config.json before it has loaded.

# Plan
- [x] 1. Shared CommandRunner (FIFO / coalesce) proven by harness against the old reused-Process pattern.
- [x] 2. Port MangoService, ColorScheme, Brightness, Bluetooth, VPN and the Display/Power/Media/About pane runners.
- [x] 3. Gate theme boot on Config.ready + pack dir; persist theme.appliedKey.
- [x] 4. A/B renders (stubbed theme-switch call counts), qml-reviewer, land by path.
- [x] Run `python3 -m logics_manager flow finish task task_038_service_command_runner_queue_and_startup_gating.md` after implementation.

# Validation
- PASSED 2026-09-28: harness fired 3 slow jobs back to back - the old reused-Process pattern ran jobs 1 and 3 (job 2 silently dropped), CommandRunner queue mode ran all 3 in order, coalesce mode ran first + newest (AC1 mechanism). A/B boot renders counting stubbed theme-switch calls (shot.sh stubs.log): Grimdark boot main 1 run, fix 0; Base boot 0/0; a genuine resolved change (flavorDark=mocha vs applied macchiato) runs exactly once on both and the fix stores theme.appliedKey; a configured-but-missing pack boots to the base look after the 5 s fallback with no spurious run (AC2). Config writes before load: 0 (Config.ready root cause fixed in task_037, 45a3cc7). qml-reviewer: ship; its should-fixes applied (dead imports, qualified root._load, comments). Landed as archeotech-shell b35817f.
- command: `CommandRunner harness vs old Process; shot.sh A/B boot renders with stubs.log counts; qml-reviewer` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- New Commons/CommandRunner.qml; ported Services/Compositor/MangoService.qml, Services/Theming/ColorScheme.qml, Services/Hardware/Brightness.qml (argv), Services/Networking/Bluetooth.qml, Services/Networking/VPN.qml (argv, no shell quoting), Modules/Settings/Panes/{Display,Power,About}Pane.qml, Modules/Shell/Panels/Content/MediaPanel.qml (archeotech-shell b35817f). Found on the way and fixed in shot.sh (f34fbb2): the nested shell's theme-switch sent SIGUSR1 to the owner's live kitty processes by name; renders now stub live-session scripts. Follow-up (not in scope): Bluetooth's _disconnCmd/_removeCmd/_pairCmd/_scanCmd and Network.qml still use raw Processes guarded by busy flags; item_121 (native modules) replaces them.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_105_service_command_runner_queue_and_startup_gating`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: the audit-verified dropped-command bug fixed in archeotech-shell b35817f (harness: old pattern dropped 1 of 3 jobs, CommandRunner none) and the every-boot theme-switch re-run removed (A/B stub counts 1 -> 0). Other AC2 bugs and the golden matrix are sibling items.
