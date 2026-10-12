## task_055_clock_format_bar_widget_options_and_dashboard_scan_roots_in_settings - Clock format, bar widget options and dashboard scan roots in Settings
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
> Indicators reviewed: 2026-10-12 17:22:22

# AI Context
- Summary: One global clock format (clock.format/seconds/date) in Settings > Shell > Clock read by the bar clock, dashboard and notification times; drop the bar.modules show/hide keys (Edit Layout decides presence); project folders (dashboard.scanRoots) editable in Settings; Config drops obsolete keys on load.
- Keywords: clock, format, bar, widget, options, dashboard, scan, roots, settings
- Use when: Changing clock formatting, Settings > Shell, the dashboard Active Projects scan, or config.json key cleanup.
- Skip when: Per-setting search/reset (item_138) or new bar widgets.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_137_clock_format_bar_widget_options_scan_roots_settings`

# Acceptance criteria
- AC1: Clock format, widget options and scan roots are editable in Settings, apply live, and nothing needs a hand-edit.
- AC2: No stale unread keys remain in the default config.

# Plan
- [x] Owner decisions (2026-10-12): one global clock setting (per-widget clock schema dropped); drop bar.modules.* rather than expose them.
- [x] Services/System/ClockLogic.js + tests; ClockWidget, Dashboard, Notifications read clock.*.
- [x] Settings > Shell: CLOCK card (time format, seconds, date + preview) and DASHBOARD - PROJECT FOLDERS card (list, remove, add).
- [x] ActiveProjects: roots passed as bash args, rescan on change.
- [x] ConfigLogic.OBSOLETE_KEYS + dropKeys; Config drops them once loaded.
- [x] Use `python3 -m logics_manager flow progress task task_055_clock_format_bar_widget_options_and_dashboard_scan_roots_in_settings.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_055_clock_format_bar_widget_options_and_dashboard_scan_roots_in_settings.md` after implementation.

# Validation
- tests/run.sh 64/64 pass (new tst_clocklogic, ConfigLogic dropKeys); token-lint 0; qmllint Qt6 only known singleton/import false positives; scripts/golden.sh --root <wt> all 25 ok, then bar-*/dashboard-*/settings-* re-run after review fixes, 0 px. shot.sh renders: Settings > Shell clock + project folder cards (PROBE scroll, removed); --set clock.format=12h clock.seconds=true clock.date=iso -> bar 5:14:10 PM . 2026-10-12, dashboard 5:14 PM; clock.date=numeric -> 12/10; scanRoots [~/Projects] scans after Config.ready; fake-HOME config.json lost bar.* and audio.rememberVolume, siblings kept. qml-reviewer: no blocking; should-fixes applied (date options no longer rebuilt per second, bound clock text, scan waits for Config.ready, no stale flash).
- command: `tests/run.sh; scripts/golden.sh --root <wt>; shot.sh renders` | result: passed | date: 2026-10-12
- Finish workflow executed on 2026-10-12.
- Linked backlog/request close verification passed.

# Report
- archeotech-shell aec377e: global clock.format/seconds/date (Settings > Shell > Clock) read by bar clock, dashboard, notification times; clock per-instance schema removed (a per-instance format in shell-config.json is now ignored). bar.modules.* show/hide reads removed (Edit Layout decides). Settings > Shell > Dashboard . Project folders edits dashboard.scanRoots; ActiveProjects passes roots as bash args (no injection), rescans live. Config drops OBSOLETE_KEYS (bar.clockFormat, bar.height, bar.modules, audio.rememberVolume) once loaded. WIDGET_API.md updated.
- Finished on 2026-10-12.
- Linked backlog item(s): `item_137_clock_format_bar_widget_options_scan_roots_settings`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: archeotech-shell aec377e; clock format, project folders editable in Settings and applied live (shot.sh renders), stale config keys dropped on load (tst_configlogic dropKeys).

# Notes
- 2026-10-12: owner confirmed on the live bar (clock format, date, project folders all work).
