## task_023_launcher_keyboard_first_master_search - Launcher keyboard-first master search
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-09-07 11:46:09

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: launcher, keyboard, first, master, search
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_016_launcher_keyboard_first_master_search`

# Acceptance criteria
- AC2: Launcher auto-focuses on open and searches apps + actions via pluggable providers, Enter runs the top result

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_023_launcher_keyboard_first_master_search.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_023_launcher_keyboard_first_master_search.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint clean; node unit-tests of provider ranking + calc; isolated shot.sh load/render check (no QML errors); user live-confirmed master search + multi-monitor focus/open routing on all three monitors` | result: passed | date: 2026-09-07
- Finish workflow executed on 2026-09-07.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-07.
- Linked backlog item(s): `item_016_launcher_keyboard_first_master_search`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: Master search: pluggable provider list (settings/power/calc) + action dispatch on top of the app search, Enter runs the top result (shell e0beb6a); auto-focus was already delivered. Multi-monitor keyboard-first correctness: exclusive keyboard focus + panel-open + focusedOutput all routed to the focused OUTPUT (shell 1144dba, 6694df0, 6517209) — fixes typing/opening on the wrong screen incl. empty portrait. Verified: provider logic unit-tested (suspend/wallpaper/theme/2+2*3), clean load/render, and user confirmed live on laptop + horizontal + portrait monitors. Source: `e0beb6a`
- request-AC3 -> This task. Proof: Master search: pluggable provider list (settings/power/calc) + action dispatch on top of the app search, Enter runs the top result (shell e0beb6a); auto-focus was already delivered. Multi-monitor keyboard-first correctness: exclusive keyboard focus + panel-open + focusedOutput all routed to the focused OUTPUT (shell 1144dba, 6694df0, 6517209) — fixes typing/opening on the wrong screen incl. empty portrait. Verified: provider logic unit-tested (suspend/wallpaper/theme/2+2*3), clean load/render, and user confirmed live on laptop + horizontal + portrait monitors. Source: `e0beb6a`
