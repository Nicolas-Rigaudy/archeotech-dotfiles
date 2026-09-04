## task_018_auto_hide_sides_in_fullscreen - Auto-hide sides in fullscreen
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
> Indicators reviewed: 2026-09-04 02:09:39

# AI Context
- Summary: Auto-hide the shell sides (bar/strips) when a screen has a fullscreen window, plus a manual force-hide gate. Single signal `ShellState.sidesHidden(screenName)` = `sidesForceHidden || CompositorService.isFullscreen(screenName)`, respected by ShellExclusions (zone→0), Strip (collapses to holder: hidden body + hover-reveal), and Bar (hides + zero size). Reuses holder-mode; no new collapsed chrome.
- Keywords: auto, hide, sides, fullscreen
- Use when: Touching the sides' visibility/exclusion, fullscreen detection, or the force-hide gate.
- Skip when: Designing new chrome for the collapsed state (explicitly out of scope).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_015_auto_hide_sides_in_fullscreen`

# Acceptance criteria
- AC2: Sides auto-hide on fullscreen and can be force-hidden manually, reappearing correctly

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_018_auto_hide_sides_in_fullscreen.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_018_auto_hide_sides_in_fullscreen.md` after implementation.

# Validation
- `qmllint` clean on all 7 changed shell files.
- Data source confirmed live: `mmsg get focusing-client` emits `is_fullscreen` (and a separate `is_fakefullscreen`, correctly ignored). MangoService already parses `is_fullscreen` per-output.
- Reactivity: bindings call `ShellState.sidesHidden()` → `CompositorService.isFullscreen()` → reads QObject props (`_outputs[name].fullscreen`), which QML's dynamic dependency capture tracks through the call (same pattern as the existing reactive `titleFor()`/`clientsFor()`), so `exclusiveZone`/`visible` re-evaluate on fullscreen enter/exit and force-hide toggle.
- Behavioural repro (fullscreen enter/exit visibly hides+restores sides; Super+Shift+H force-hide) requires a shell reload — deferred to user next reload/login; not forced in this background session.
- Known limitation: MangoService updates fullscreen from `watch focusing-client`, so on multi-monitor a de-focused monitor's fullscreen flag can lag until its next client event. Fine for the common single-fullscreen case; noted for a future refinement.
- qmllint passed on 2026-09-04: 0 errors across 7 changed shell files; is_fullscreen IPC data source confirmed live
- Finish workflow executed on 2026-09-04.
- Linked backlog/request close verification passed.

# Report
- Shell repo (`archeotech-shell`), commit `2eca5ea`:
  - `CompositorService.qml` — expose `isFullscreen(name)` (delegates to backend); `HyprlandService.qml` — safe `isFullscreen` stub (inert until the Hyprland milestone).
  - `ShellState.qml` — `sidesForceHidden` + `toggleSidesHidden()` + `sidesHidden(screenName)` (the single gate).
  - `ShellExclusions.qml` — `_zone` returns 0 when hidden (reclaim the edge).
  - `Strip.qml` — `_effectiveHolder = holderMode || sidesHidden` drives `visible`/`_edgeInset`/`_perpExtent` (collapses to holder + hover-reveal).
  - `Bar.qml` — hides + zero implicit size when hidden.
  - `shell.qml` — `sides` IPC handler (`toggleHidden`/`hide`/`show`).
- Dotfiles: `config.conf` keybind `Super+Shift+H` → `ipc call sides toggleHidden`; `docs/KEYBINDS-MANGO.md` updated.
- Scope honoured: reused holder-mode reveal, no new collapsed chrome.
- Follow-up fix (2026-09-04, commit `f5fd6c8`): the first pass only hid `Bar`/`Strip`, but the visible bar is largely the `FrameBackground` glass (a z:0 sibling in `ShellSurface`) + `FrameFx` — those stayed on screen in fullscreen. Gated both on `sidesHidden(screen)`. User-confirmed working (bar now clears in fullscreen). Lesson: the initial "validation" was code-reasoning only; the missed sibling was caught by actually exercising it.
- Finished on 2026-09-04.
- Linked backlog item(s): `item_015_auto_hide_sides_in_fullscreen`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof: `sidesHidden(screen)` = `sidesForceHidden || CompositorService.isFullscreen(screen)` gates ShellExclusions (zone→0), Strip (collapse to holder), and Bar (hide+zero-size); force-hide via `sides` IPC + Super+Shift+H; reverts on fullscreen exit / toggle. Shell commit 2eca5ea; qmllint clean; `is_fullscreen` data source confirmed live.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof: auto-hide reacts to the compositor's per-output fullscreen (MangoService `is_fullscreen`), surfaced via the CompositorService facade — same multi-monitor/compositor-utility surface as item_026.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
