## task_071_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet - State-driven OSD, generic panel IPC and keybind cheatsheet
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 90%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: Make the OSD follow audio and brightness state, confirm the generic panel IPC and keybind sheet already delivered.
- Keywords: state, driven, osd, generic, panel, ipc, keybind, cheatsheet
- Use when: Working on the OSD triggers, panel IPC or the Super+K keybind sheet.
- Skip when: Changing the OSD's look (Modules/OSD/Osd.qml visuals) or notifications.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_120_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet`

# Acceptance criteria
- AC1: Changing volume from any source shows the OSD.
- AC2: Any panel id can be opened by IPC.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_071_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_071_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet.md` after implementation.

# Validation
- command: tests/run.sh (79 pass, new tst_osdlogic.qml 5 cases), python3 -m unittest discover -s tests/py (35 OK), scripts/qmllint-ci.py rc 0, scripts/token-lint.py 0; headless shot.sh load on night/fallback with no new qs.log errors and no OSD at startup (cr-0w/local/state/night/shots/fallback-2026-10-21/) | result: passed | date: 2026-10-21. A real volume or brightness change was not driven: the nested session has no PipeWire, and changing the real devices would touch the live session.

# Report
- AC1 (shell branch night/fallback, 00d75fa): shell.qml watches Audio.volume/muted and Brightness.percent and raises the OSD on any change, wherever it came from (keys, wpctl, pavucontrol, the bar sliders, the udev-detected brightness keys). Modules/OSD/OsdLogic.js gates it: silent for 2 s after startup (first device reads) and for 750 ms after the default sink changes or (un)binds, so a Bluetooth profile switch or a sink switch does not flash it. Audio exposes sinkBound for that. The keybinds' `ipc call osd …` still works; both paths just restart the hide timer. docs/MANGOWC-SETUP.md says the suffix is now optional.
- AC2: already met before this task: `ipc call panel open|toggle <id>` (plugins included, `plugin:<id>`) in shell.qml, documented in docs/MODULE_API.md.
- Cheatsheet scope: already delivered by item_145 (Super+K keyboard panel parsed from the mango config, KeybindsLogic.js).
- Side fix (31bd037): shell.qml read appearance.coverageBlur with an inline default that tests/py rejects; it now reads the ConfigDefaults value (same "auto").
- Open, needs the owner: a live check of AC1: run the branch, change volume from pavucontrol or the bar slider and see the OSD; switch the default sink and see it stay hidden. Not proven: whether the OSD while dragging the bar's own volume slider feels redundant (the AC asks for any source, so it shows).

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
