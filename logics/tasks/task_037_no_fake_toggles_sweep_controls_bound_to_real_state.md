## task_037_no_fake_toggles_sweep_controls_bound_to_real_state - No-fake-toggles sweep: controls bound to real state
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
- Summary: ToggleSwitch made a controlled component; the four Notifications settings wired; Config.ready fixed to wait for config.json; Theme tab, AWS readout and Power pane stop showing controls or values that do nothing.
- Keywords: fake, toggles, sweep, controls, bound, real, state
- Use when: Touching Settings controls, notification toasts, or Config load timing.
- Skip when: Notifications v2 features (item_119) or toast timer/monitor bugs (item_108).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_107_no_fake_toggles_sweep_controls_bound_to_real_state`

# Acceptance criteria
- AC1: Every Settings control reflects external state changes after being clicked.
- AC2: Changing each notification setting changes toast behaviour immediately.
- AC3: No Settings control is visible that has no effect in the current configuration.

# Plan
- [x] 1. ToggleSwitch controlled; audit every caller binding for reactivity.
- [x] 2. Wire toastTimeout, maxToasts, showOnFullscreen, persistDnd.
- [x] 3. Remove no-effect controls/values (Theme tab under packs, AWS readout, Power pane backends).
- [x] 4. A/B renders vs unfixed main, harness for the switch, qml-reviewer, land by path.
- [x] Run `python3 -m logics_manager flow finish task task_037_no_fake_toggles_sweep_controls_bound_to_real_state.md` after implementation.

# Validation
- PASSED 2026-09-28 (isolated shot.sh renders, fix vs unfixed main): (AC1) harness drove old and new ToggleSwitch - after an external state change to off, the old switch stayed on (state=false, switch=true) while the new one followed; every caller binding checked reactive. (AC2) maxToasts=2 with 4 notifications: main shows 4, fix shows the newest 2; toastTimeout=2000 burst: fix toast gone by ~2s, main keeps it ~5s; persistDnd=true + dnd=true: main shows the toast, fix suppresses it. showOnFullscreen implemented against CompositorService.isFullscreen(focusedOutput) (no fullscreen client available headless; reviewed, not rendered). (AC3) Theme tab under Grimdark shows a notice instead of dead Dark/Light/flavor/accent pickers, Base unchanged; AWS row reads 'none' (true for new terminals) instead of the shell's own unset env; Power pane disables idle controls with a reason when the swayidle script is absent. Root cause found on the way: Config.ready flipped on the first empty textChanged, so ColorScheme._bootResolve wrote config before config.json loaded (race vs the 50ms save). Fixed via FileView loaded()/loadFailed(): probe showed 0 early writes after; fresh boot (shot.sh --fresh) fires loadFailed and boots with defaults; normal boot fires loaded with 12 keys; macchiato/latte/grimdark boot renders correct. qml-reviewer: ship; its should-fixes applied (no DND write-back on restore, timeout on the fish call). Landed as archeotech-shell 45a3cc7.
- command: `shot.sh A/B renders (--set/--notify-count/--burst/--fresh), ToggleSwitch harness, Config load probes, qml-reviewer` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Changed in archeotech-shell 45a3cc7: Commons/Primitives/ToggleSwitch.qml, Services/Persistence/Config.qml, Services/System/Notifications.qml, shell.qml, Modules/NotificationCenter/NotifToast.qml, Modules/Settings/Panes/{NotificationsPane,PowerPane}.qml, Widgets/Appearance/ThemeCarousel.qml, Modules/Dashboard/panels/SystemNotes.qml. shot.sh gained --set, --notify-count (25bbd92) and --fresh (ccd5e8e). Audit correction: the Settings Mode row was already hidden under Grimdark; the dead controls were in the panel Theme tab.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_107_no_fake_toggles_sweep_controls_bound_to_real_state`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: audit-verified fake toggles and the fake notification settings fixed in archeotech-shell 45a3cc7, each shown by A/B renders or a harness against unfixed main; the Config.ready race behind the config.json overwrite risk fixed and probed. Other AC2 bugs and the golden matrix are sibling items.
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
