## item_131_mangoservice_watch_stream_restart_backoff - MangoService watch-stream restart backoff
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 95%
> Confidence: 90%
> Progress: 100%
> Complexity: Low
> Theme: Services
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-29 14:09:07

# AI Context
- Summary: MangoService's three `mmsg watch` restart timers reset their interval to 500 ms on every trigger, so the "exponential backoff" always waits 1 s; on a non-Mango compositor (or with mmsg missing) the streams respawn every second forever.
- Keywords: mangoservice, mmsg, watch, stream, restart, backoff, compositor
- Use when: Implementing or reviewing the 0.31 Correctness sweep leftover on the compositor service.
- Skip when: Working on the generic compositor backend (separate, post-0.31); see road_001 for sequencing.

# Problem
- `Services/Compositor/MangoService.qml` `_scheduleRestart` doubles `timer.interval`, but each restart Timer's `onTriggered` sets `interval = 500` right after restarting the process, so every retry waits ~1 s (found while fixing item_108; logged in `.claude/TROUBLESHOOTING.md`).

# Scope
- In:
  - Real exponential backoff for `watch all-monitors`, `watch focusing-client`, `watch all-clients` (500 ms doubling to a cap).
  - Reset to the short interval only after a stream stayed up (the `Network.qml` nmcli monitor pattern from `436dc27`).
- Out:
  - A generic compositor backend for non-Mango/non-Hyprland sessions.

# Acceptance criteria
- AC1: With `mmsg` failing immediately, successive restarts of each watch stream wait increasing intervals up to the cap instead of ~1 s each.
- AC2: A stream that stayed up (10 s+) and then exits restarts after the short interval again.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: successive restarts back off to the cap.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_044_mangoservice_watch_stream_restart_backoff`

# Priority
- Priority: Medium
- Rationale: small correctness fix; a respawn loop only bites off-Mango, but it is a known 0.31 leftover (2026-09-29).

# Notes
- Generated locally by logics-manager.
- Task `task_044_mangoservice_watch_stream_restart_backoff` was finished via `logics-manager flow finish task` on 2026-09-29.

# Tasks
- `task_044_mangoservice_watch_stream_restart_backoff`
