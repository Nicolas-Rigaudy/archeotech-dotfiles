## task_017_fix_dashboard_auto_close_right_after_boot - Fix dashboard auto-close right after boot
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
> Indicators reviewed: 2026-09-04 01:48:01

# AI Context
- Summary: Fix the boot-window dashboard bug — `openAuto` shows the dashboard ~4s on login with a re-arming auto-dismiss timer; opening it manually in that window collided with the timer and snapped it shut. Fix lives in the `archeotech-shell` repo (QML): manual open/toggle now clears `dashboardAutoOpen`, and the timer stops the instant that flag clears.
- Keywords: fix, dashboard, auto, close, right, after, boot
- Use when: The login dashboard auto-hide interferes with manual interaction, or touching `openAuto`/`autoDismiss`.
- Skip when: Reworking `openAuto` itself (out of scope) or unrelated dashboard content/layout.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_043_fix_dashboard_auto_close_right_after_boot`

# Acceptance criteria
- AC2: Manually opening the dashboard during the boot window keeps it open

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_017_fix_dashboard_auto_close_right_after_boot.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_017_fix_dashboard_auto_close_right_after_boot.md` after implementation.

# Validation
- `qmllint` clean on both edited files (`shell.qml`, `Modules/Shell/Panels/Content/Dashboard.qml`).
- Logic traced across all paths: (A) manual toggle during window — flag clears, timer stops, reopen stays open; (B) manual `open()` while already auto-showing — flag clears and the new `onDashboardAutoOpenChanged` stops the timer even with no `panelOpen` transition; (C) no interaction — 4s auto-dismiss still fires (no regression).
- Behavioural repro is a login-time scenario (`openAuto` runs from mango autostart on login); deterministic fix, applies on next shell reload/login. User-confirm: on next boot, open the dashboard within ~4s — it stays open.
- Finish workflow executed on 2026-09-04.
- Linked backlog/request close verification passed.

# Report
- Shell repo (`archeotech-shell`), commit `7107bca` `fix[QML]: keep dashboard open when opened manually during boot auto-show`:
  - `shell.qml` — dashboard IPC `toggle()`/`open()` now clear `Commons.State.dashboardAutoOpen` (manual open cancels the boot auto-open intent).
  - `Dashboard.qml` — added a `Connections` on `Commons.State` that stops `autoDismiss` the instant `dashboardAutoOpen` goes false, closing the `open()`-while-open gap (no `panelOpenChanged` there).
- Scope honoured: did not rewrite `openAuto` (out of scope); minimal, no new chrome.
- Follow-up (2026-09-04, commit `0e4ebd6`): per user, the dashboard is a bottom-edge bar panel used to launch apps on login, so the 4s auto-dismiss was itself unwanted. Removed the auto-dismiss entirely (dropped the `autoDismiss` Timer + both `Connections`, `openAuto` now just opens, `dashboardAutoOpen` state deleted). Login still auto-shows; it stays until Esc/click-out. This supersedes `7107bca` and satisfies AC2 more completely (the dashboard always stays open, not just during the boot window).
- Finished on 2026-09-04.
- Linked backlog item(s): `item_043_fix_dashboard_auto_close_right_after_boot`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof: manual open/toggle clears `dashboardAutoOpen` (shell.qml) and `autoDismiss` stops when that flag clears (Dashboard.qml, commit 7107bca); qmllint clean; all interaction paths traced — manually opening during the boot window keeps it open.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
