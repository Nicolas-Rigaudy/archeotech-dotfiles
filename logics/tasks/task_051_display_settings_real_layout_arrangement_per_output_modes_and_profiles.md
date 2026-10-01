## task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles - Display settings: real layout, arrangement, per-output modes and profiles
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 50%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-01 16:42:23

# AI Context
- Summary: Settings > Display monitor-layout editor bound to real wlr-randr state (arrange, mode, rotation, scale, apply with 15 s auto-revert), then saved per-monitor profiles that auto-apply on hotplug.
- Keywords: display, settings, real, layout, arrangement, per, output, modes, profiles
- Use when: Changing how outputs are read, arranged, applied or profiled.
- Skip when: Night light or per-output shell bar config.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_135_display_settings_real_layout_arrangement_profiles`

# Acceptance criteria
- AC1: After a restart the pane shows the real current layout of every output.
- AC2: The work setup (eDP-1 + HDMI-A-1 + portrait DP-3) can be arranged without overlap and saved as a profile that re-applies on dock.

# Plan
- [x] Wave 1: Hardware.Displays (wlr-randr --json read on start/hotplug/2 s while visible, one-call apply, 15 s keep/revert), DisplaysLogic.js (parse, logicalSize, argv, normalize, snap, hasOverlap; tests), DisplayArrangement canvas, DisplayPane editor replacing the Layout guesses + wdisplays row.
- [ ] Wave 2: profiles in ~/.config/archeotech/displays.json keyed by make/model/serial (connector fallback), Save as profile, silent auto-apply on hotplug with a toast, retire monitor-apply.sh hard-coded layouts (seed Work/Home/Laptop), shared apply script usable by the hotplug daemon.
- [ ] Use `python3 -m logics_manager flow progress task task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_051_display_settings_real_layout_arrangement_per_output_modes_and_profiles.md` after implementation.

# Validation
- Wave 1 (archeotech-shell 68631af): tests/run.sh 44/44 (13 DisplaysLogic tests: parse current/native fallback, logical size, argv incl. 0 Hz and no-mode outputs, overlap, snap flush/never-overlap/edge-align/lone, normalize); token-lint 0; golden.sh 25/25 unchanged. Isolated 3-output session: pane mirrors real wlr-randr state incl. a 270 portrait output (2 s re-read); end-to-end: DisplaysLogic snapped portrait to the far left, the generated argv ran in the nested session (rc 0) and wlr-randr read back exactly 0,100 / 720,0 / 2000,0, shell and canvas followed. qml-reviewer blockers fixed: unchanged reads keep the same array (no rebuild mid-drag), apply/revert only name connected outputs, failed apply cancels the countdown, no second apply during countdown. Pending owner: try on the real desk (dock/undock, rotate, Apply then Revert).

# Report
- Not started.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner 2026-10-01: profiles match monitors by make/model/serial (connector fallback; eDP has no serial); matching profile applies silently with a toast; wave 1 first. The editor lives in Settings (no external wdisplays); Mirror dropped (it only stacked outputs at 0,0; mango has no true mirroring). Owner pain point: after unplugging, the second screen sometimes still shows and had to be disabled by hand in wdisplays; wave 1 gives an in-pane Enabled toggle, wave 2's Laptop profile should make it automatic.
