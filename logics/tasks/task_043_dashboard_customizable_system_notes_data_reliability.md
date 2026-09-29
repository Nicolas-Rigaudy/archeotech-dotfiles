## task_043_dashboard_customizable_system_notes_data_reliability - Dashboard customizable System Notes + data reliability
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
> Indicators reviewed: 2026-09-29 11:00:50

# AI Context
- Summary: System Notes becomes a stat registry: one process per stat (system-notes.sh <id>), stats with no source on the machine hidden, updates cached 30 min, snapper via CSV, VPN by connection TYPE, AWS profile validated; stats selectable in Settings > Shell > Dashboard (dashboard.notes).
- Keywords: dashboard, customizable, system, notes, data, reliability
- Use when: Adding/changing a System Notes stat or its fetch/parse, or the dashboard.notes setting.
- Skip when: The AWS SSO pill / Contexts work (0.60), or ActiveProjects.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_049_dashboard_customizable_system_notes_data_reliability`

# Acceptance criteria
- AC4: System Notes stats are user-selectable and only resolvable sources surface reliably

# Plan
- [x] 1. A/B on main: one sequential script; Snapshot N/A, six stats stuck at the placeholder behind checkupdates/paru.
- [x] 2. SystemNotesLogic.js registry + parsers; system-notes.sh per-stat fetch with __NA__/__ERR__; SystemNotes.qml per-stat Processes.
- [x] 3. Settings > Shell > DASHBOARD toggles bound to dashboard.notes.
- [x] 4. Tests (tst_systemnoteslogic), renders dark/light/flat + subset + settings; golden gate (with one-retry FLAKY).
- [x] 5. qml-reviewer, land on main by path, closeout.
- [x] Use `python3 -m logics_manager flow progress task task_043_dashboard_customizable_system_notes_data_reliability.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_043_dashboard_customizable_system_notes_data_reliability.md` after implementation.

# Validation
- A/B isolated renders (shot.sh --state dashboard -w 10): main shows Snapshot N/A (snapper has 2288 snapshots) and Uptime/Kernel/Host/VPN/AWS/IP still '…' after 10s (one sequential script blocked behind checkupdates/paru); fix resolves every stat, hides AWS where ~/.aws/config is absent (fake HOME), snapshot 'today 10:24'. dark/light/flat, a 2-stat --set dashboard.notes selection, and Settings > Shell > DASHBOARD toggles (temporary scroll probe) rendered. system-notes.sh run per stat on this machine: updates 1.8s uncached, 10ms cached; VPN ignores docker bridges. tests/run.sh 22 pass (tst_systemnoteslogic: selection, toggle, snapper, shortStamp, VPN type, updates). Probe: unrelated Config.set x3 -> _selected changed 5 extra times before memoizing (fetchers not recreated), 0 after. golden.sh 25/25 twice; qml-reviewer: blocking (selection churn) + should-fixes (ComponentBehavior Bound, decodeURIComponent, atomic cache) applied.
- command: `shot.sh A/B dashboard renders (dark/light/flat, subset, settings); tests/run.sh 22; golden.sh 25/25; config-churn probe; qml-reviewer` | result: passed | date: 2026-09-29
- Finish workflow executed on 2026-09-29.
- Linked backlog/request close verification passed.

# Report
- Landed on archeotech-shell main as cef5002 (+ f521d96 golden.sh one-retry FLAKY). System Notes = registry (SystemNotesLogic.js) + per-stat fetch (system-notes.sh <id>: __NA__ hides the row, __ERR__ shows 'check failed'); updates cached 30 min and invalidated by a pacman transaction; snapper via --csvout; VPN by TYPE vpn|wireguard; AWS profile checked against ~/.aws/config. Selectable in Settings > Shell > DASHBOARD - SYSTEM NOTES (dashboard.notes, unset = all). Follow-up noted: Persistence.Config has no per-key change signal, so every Config.get() binding re-evaluates on any Config.set() (memoized here by value).
- Finished on 2026-09-29.
- Linked backlog item(s): `item_049_dashboard_customizable_system_notes_data_reliability`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: the audit-verified System Notes bugs (placeholder/wrong readouts: stats stuck behind slow checks, Snapshot N/A, name-matched VPN, unvalidated AWS profile) fixed in archeotech-shell cef5002, with A/B renders and SystemNotesLogic tests; stats user-selectable in Settings (item AC4).
- request-AC4 -> This task. Proof deferred to slice closeout.
