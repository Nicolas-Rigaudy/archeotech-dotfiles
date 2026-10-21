## task_067_panel_keybinds_dismissal_consistency - Panel keybinds / dismissal consistency
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 60%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: panel, keybinds, dismissal, consistency
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_017_panel_keybinds_dismissal_consistency`

# Acceptance criteria
- AC2: Esc and a global close bind dismiss any open panel consistently across all holders

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_067_panel_keybinds_dismissal_consistency.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_067_panel_keybinds_dismissal_consistency.md` after implementation.

# Validation
- command: tests/py (new test_dismissal.py), tests/run.sh 85 pass, qmllint-ci unchanged; headless render of popup:wifi with `qs ipc --pid $QSPID call panel close` before/after (cr-0w/local/state/night/shots/017-dismiss) | result: passed | date: 2026-10-21. Esc itself cannot be driven headless (no synthetic input).

# Report
- Audit: both holder types (Strip, BarPanel) claim focus on open and close on Esc, with child handlers bubbling up, so every panel dismisses with Esc; the global close was `ipc call panel close` but it left a bar's wifi/bluetooth/calendar/hover popups open. Fixed on shell branch night/roadmap-next (1baa78b): ShellState emits dismissed() from closeAllAcross(), Bar drops its popups on it. Documented in docs/PANEL_API.md.
- Still open, needs the owner: (1) a keybind for `qs -c archeotech ipc call panel close` lives in the owner's mango config (dotfiles), not this repo; (2) Esc cannot dismiss bar popups because they take no keyboard focus, and giving them exclusive focus would steal typing from windows underneath: options are leave as is (click away or the global bind), or an on-demand focus grab only for the wifi/bluetooth popups; (3) optional per-panel open binds are not started.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
