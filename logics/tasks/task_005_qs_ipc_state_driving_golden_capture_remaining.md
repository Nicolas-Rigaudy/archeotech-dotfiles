## task_005_qs_ipc_state_driving_golden_capture_remaining - qs-ipc state-driving + golden capture (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-08-24 15:04:21

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: ipc, state, driving, golden, capture, remaining
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_067_headless_render_harness_shot_sh_qs_ipc_state_driving`

# Acceptance criteria
- AC1: `shot.sh` renders the shell headless to a real PNG and tears down the nested compositor by captured PID only, never touching the live session.
- AC2: A named shell state (e.g. launcher open, dashboard open) can be driven via `qs ipc` before capture, without synthetic input.
- AC3: A burst capture produces a sequence of frames sufficient to confirm a motion state changed (e.g. a toast appeared and later dismissed).

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_005_qs_ipc_state_driving_golden_capture_remaining.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_005_qs_ipc_state_driving_golden_capture_remaining.md` after implementation.

# Validation
- (no validation recorded yet)

# Report
- Not started.

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
