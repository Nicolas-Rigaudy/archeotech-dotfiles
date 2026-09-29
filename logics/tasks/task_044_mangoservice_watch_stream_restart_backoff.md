## task_044_mangoservice_watch_stream_restart_backoff - MangoService watch-stream restart backoff
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
> Indicators reviewed: 2026-09-29 14:09:06

# AI Context
- Summary: Give MangoService's three mmsg watch streams a real exponential backoff (500 ms doubling to 8 s), resetting only after a stream stayed up 10 s, mirroring Network.qml's nmcli monitor.
- Keywords: mangoservice, watch, stream, restart, backoff
- Use when: Touching mmsg watch restart logic in Services/Compositor/MangoService.qml.
- Skip when: Adding a generic compositor backend (out of scope).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_131_mangoservice_watch_stream_restart_backoff`

# Acceptance criteria
- AC1: With `mmsg` failing immediately, successive restarts of each watch stream wait increasing intervals up to the cap instead of ~1 s each.
- AC2: A stream that stayed up (10 s+) and then exits restarts after the short interval again.

# Plan
- [x] Worktree `fix/item_131`; one shared restart helper keyed on per-Process start time; drop the `interval = 500` resets from the Timers.
- [x] A/B: shot.sh with a stub `mmsg` that exits at once, count spawns per stream over a fixed window on main vs worktree.
- [x] qmllint, qml-reviewer, golden.sh + tests/run.sh; land by path.
- [x] Use `python3 -m logics_manager flow progress task task_044_mangoservice_watch_stream_restart_backoff.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_044_mangoservice_watch_stream_restart_backoff.md` after implementation.

# Validation
- A/B with a fake mmsg (exits 1 at once) via PATH prepend, shot.sh -w 30: main respawns each of the 3 watch streams every 1.0 s (n=31-32 in 30 s); fix gaps 0.5,1,2,4,8,8 s (n=7). Fake mmsg staying up 11 s: constant 11.5 s restarts (reset after healthy uptime). Missing binary: Quickshell 0.3.1 logs 'Process failed to start' and emits no exited, so no loop on main or fix. golden.sh --root wt: all 25 ok; tests/run.sh 22 passed; qmllint warning count unchanged (3, ExitStatus false positives).
- command: `fake-mmsg A/B via shot.sh; scripts/golden.sh --root wt; tests/run.sh` | result: passed | date: 2026-09-29
- Finish workflow executed on 2026-09-29.
- Linked backlog/request close verification passed.

# Report
- Landed 4a4d6e0 (archeotech-shell main): per-Process _startedAt, _scheduleRestart(timer, startedAt) doubles 500 ms to 8 s cap, resets to 500 ms after 10 s+ uptime; trigger zeroes _startedAt (qml-reviewer should-fix). Live bar pinned at cef5002: reaches the bar on promote.
- Finished on 2026-09-29.
- Linked backlog item(s): `item_131_mangoservice_watch_stream_restart_backoff`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: mmsg watch streams back off 0.5 s to 8 s cap (was 1 s forever), measured A/B with a failing fake mmsg (4a4d6e0).
