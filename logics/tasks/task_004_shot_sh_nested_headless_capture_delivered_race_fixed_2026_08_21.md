## task_004_shot_sh_nested_headless_capture_delivered_race_fixed_2026_08_21 - shot.sh nested-headless capture (delivered, race-fixed 2026-08-21)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-08-24 15:04:21

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: shot, nested, headless, capture, delivered, race, fixed, 2026
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_067_headless_render_harness_shot_sh_qs_ipc_state_driving`

# Acceptance criteria
- AC1: `shot.sh` renders the shell headless to a real PNG and tears down the nested compositor by captured PID only, never touching the live session.
- AC2: A named shell state (e.g. launcher open, dashboard open) can be driven via `qs ipc` before capture, without synthetic input.
- AC3: A burst capture produces a sequence of frames sufficient to confirm a motion state changed (e.g. a toast appeared and later dismissed).

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_004_shot_sh_nested_headless_capture_delivered_race_fixed_2026_08_21.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_004_shot_sh_nested_headless_capture_delivered_race_fixed_2026_08_21.md` after implementation.

# Validation
- (no validation recorded yet)
- Finish workflow executed on 2026-08-21.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-08-21.
- Linked backlog item(s): `item_067_headless_render_harness_shot_sh_qs_ipc_state_driving`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
