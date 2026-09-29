## task_045_config_set_churn_structural_sharing_and_write_echo_suppression - Config set churn: structural sharing and write-echo suppression
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
> Indicators reviewed: 2026-09-29 14:29:57

# AI Context
- Summary: Move Config get/set path logic into a tested ConfigLogic.js with structural sharing and no-op detection; suppress the watchChanges echo of our own write.
- Keywords: config, set, churn, structural, sharing, write, echo, suppression
- Use when: Changing Services/Persistence/Config.qml.
- Skip when: Working on ShellConfig (shell-config.json).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_132_config_set_churn_structural_sharing`

# Acceptance criteria
- AC1: Setting one key does not emit a change on bindings of other object-valued keys (probe count A/B vs main).
- AC2: Our own write is not re-parsed; an external edit to config.json still applies.
- AC3: `set(k, current)` writes nothing.

# Plan
- [x] Worktree `fix/item_132`; `Services/Persistence/ConfigLogic.js` (getPath/setPath) + `tests/qml/tst_configlogic.qml`.
- [x] Config.qml: use it; skip no-op sets; remember the last written text and skip `_parse` on that echo.
- [x] A/B: PROBE IpcHandler doing 20 fontScale sets + a probe binding on an unrelated object key; count its changes and `_parse` calls, main vs worktree. External-edit check via --exec.
- [x] qmllint, qml-reviewer, golden.sh + tests/run.sh; land by path.
- [x] Use `python3 -m logics_manager flow progress task task_045_config_set_churn_structural_sharing_and_write_echo_suppression.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_045_config_set_churn_structural_sharing_and_write_echo_suppression.md` after implementation.

# Validation
- Isolated shell A/B (PROBE IpcHandler, 20 appearance.fontScale sets; change counters on packs.grimdark / audio.aliases / launcher.pinned bindings): main 21 changes each (20 sets + 1 echo re-parse), fix 0. Same-value set: main 1 change + write, fix none. External edit to config.json: never applied on main (FileView watchChanges only emits fileChanged, no reload), applies on fix with 1 change. Truncated invalid file: config kept, next set persists the full config. 10 sets 60 ms apart: memory and disk both end at 1.10. QtTest probe: QML emits a var change for a new object, none for the same reference. tests/run.sh 31 passed (9 new ConfigLogic); golden.sh --root wt 25/25 ok; qmllint clean.
- command: `isolated shell A/B probes; scripts/golden.sh --root wt; tests/run.sh` | result: passed | date: 2026-09-29
- Finish workflow executed on 2026-09-29.
- Linked backlog/request close verification passed.

# Report
- ConfigLogic.js getPath/setPath: structural sharing (copy only the changed path, arrays stay arrays), no-op on equal value (a same-reference object is always written), undefined deletes the key, value stored as a JSON copy. Config.qml: onFileChanged reload() (external edits now apply); _parse keeps current data on invalid text, skips our last 4 writes, unchanged content, and (once ready) anything while a save is pending. qml-reviewer: 2 blocking races found in round 1 (parse failure wiping config, stale echo rollback), fixed; round 2 ship; its boot-order note fixed with the ready guard. Remaining by design: an external edit inside the 50 ms pending-save window is lost (shell write wins, as before). Follow-up: get(k, ({})) with a missing key still returns a new default object per evaluation.
- Finished on 2026-09-29.
- Linked backlog item(s): `item_132_config_set_churn_structural_sharing`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: a 20-tick slider drag fires 0 changes on unrelated object-valued Config bindings (main: 21); external config.json edits now apply (bd39a70).
