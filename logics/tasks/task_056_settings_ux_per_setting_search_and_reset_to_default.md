## task_056_settings_ux_per_setting_search_and_reset_to_default - Settings UX: per-setting search and reset to default
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
> Indicators reviewed: 2026-10-13 11:25:30

# AI Context
- Summary: Row-level Settings search (sidebar results, jump + pulse) and per-row reset to default (↺ when changed), defaults declared once in ConfigDefaults.js.
- Keywords: settings, per, setting, search, reset, default
- Use when: Adding a Settings row (give it configKey or searchKey and an index entry), changing search, or a config default.
- Skip when: Import/export of the whole config (out of scope).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_138_settings_ux_per_setting_search_and_reset`

# Acceptance criteria
- AC1: Searching a setting's label (e.g. 'toast') lists that row and selecting it scrolls to and highlights it.
- AC2: Every row with a declared default shows reset when changed, and reset restores the default live.

# Plan
- [x] Owner UX picks (2026-10-12): sidebar row-level results with pane > section, jump + accent pulse; reset = muted ↺ after the label only when changed, hover names the default, no confirm.
- [x] SettingsSearchLogic.js index (44 entries) + ranking; PaneRegistry.focusSetting; State.settingsFocusKey/serial; launcher deep-links to the row.
- [x] SearchTarget (scroll + pulse, works for lazy panes) and RowLabel (↺) in all row widgets; configKey wiring.
- [x] ConfigDefaults.js + Config.get fallback/isModified/reset/defaultFor; inline call-site defaults removed.
- [x] Panes wired; non-config rows (frame, idle, max volume, night light, input) reset through their services.
- [x] IPC `settings focus <key>`, shot.sh `--state setting:<key>`; tests (qml + py drift guard).
- [x] Use `python3 -m logics_manager flow progress task task_056_settings_ux_per_setting_search_and_reset_to_default.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_056_settings_ux_per_setting_search_and_reset_to_default.md` after implementation.

# Validation
- tests/run.sh 72/72 (tst_settingssearch: ranking, every-token, entryFor, defaults); python3 -m unittest discover -s tests/py 28 OK incl. test_settings_search (index<->pane keys both ways, defaults declared once; drift injected and caught); token-lint 0; qmllint only known singleton/duck-typing classes; scripts/golden.sh --root <wt> 25/25 ok, settings-* re-run after review fixes 0 px. shot.sh --state setting:<key>: notifications.toastTimeout (8000 set) -> pane opened, row outlined, ↺ shown; clock.date -> Shell pane scrolled to Date; power.sleep -> lazy pane built by the pick, row outlined; nightLight.temperature -> scrolled + outlined, ↺ at 3200 K. PROBE query 'touch' -> 4 rows 'Input › Touchpad', first selected. PROBE reset burst: 8.0s + ↺ -> 5.0s, no ↺, key removed from config.json. qml-reviewer: no blocking; should-fixes applied (stale focus key expires, ListView ancestors skipped, outline target released, attached ToolTip, anim tokens).
- command: `tests/run.sh; python3 -m unittest discover -s tests/py; scripts/golden.sh --root <wt>; shot.sh --state setting:<key>` | result: passed | date: 2026-10-13
- Finish workflow executed on 2026-10-13.
- Linked backlog/request close verification passed.

# Report
- archeotech-shell 1453d16. Search: SettingsSearchLogic.INDEX (44 settings, pane > section, keywords), ranked label > section > keyword; sidebar lists one result per setting (↑/↓, Enter); PaneRegistry.focusSetting + State.settingsFocusKey; SearchTarget in every row widget (searchKey) or section, scrolls + pulses, works for lazy panes; launcher and IPC 'settings focus <key>' use it; shot.sh --state setting:<key>. Reset: ConfigDefaults.js (defaults declared once, Config.get falls back, isModified/reset/defaultFor); RowLabel ↺ in all row widgets via configKey; frame, idle (PowerPane.idleDefaults), max volume, night light, input reset through their services; display layout/keyboard layout/profiles have no default and no ↺. Disabled-with-reason rows kept.
- Finished on 2026-10-13.
- Linked backlog item(s): `item_138_settings_ux_per_setting_search_and_reset`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: archeotech-shell 1453d16; 'toast' lists the row and selecting it scrolls to and pulses it; changed rows show ↺ and reset restores the default live (shot.sh setting:<key> renders, PROBE reset burst, tst_settingssearch, test_settings_search).

# Notes
- 2026-10-13: owner tested on the live bar: search + reset work; the stock Qt tooltip on the ↺ was ugly. Owner picked a shell-styled tooltip, used everywhere: Commons/Primitives/Tooltip.qml (glass card, e2 shadow) now backs the ↺ hint and the Wi-Fi Auto-join hint; tests/py/test_tooltips.py rejects stock ToolTip. Same commit fixes Opacity showing ↺ when an explicit 'glass' equals the default (compare effectiveGlassPreset to glassDefault). archeotech-shell ddc94b7.
