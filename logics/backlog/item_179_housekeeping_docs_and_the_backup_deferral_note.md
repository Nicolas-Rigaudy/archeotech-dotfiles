## item_179_housekeeping_docs_and_the_backup_deferral_note - Housekeeping docs and the backup deferral note
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:10:46

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: housekeeping, docs, backup, deferral, note
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The housekeeping jobs and the reasons backups are deferred must be written where the owner looks later, so the backup question is picked up again when a target exists.

# Scope
- In:
  - docs/TOOLS.md entries for disk-alert, disk-report and downloads-tidy (thresholds, how to change them, how to undo a Downloads sort).
  - A short backup note in docs/: no off-laptop target yet, why a same-disk partition copy is weak, @home has no snapper config, options to weigh later (external drive with btrfs send or restic, a snapper config for @home).
- Out:
  - Setting up any backup.

# Acceptance criteria
- AC4: docs/TOOLS.md matches the shipped scripts and the backup note exists and is linked from it.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: docs/TOOLS.md matches the shipped scripts and the backup note exists and is linked from it.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)
- Request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Primary task(s): `task_083_orchestrate_machine_housekeeping`

# Priority
- Priority: Low
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Notes
- Task `task_083_orchestrate_machine_housekeeping` was finished via `logics-manager flow finish task` on 2026-11-24.
