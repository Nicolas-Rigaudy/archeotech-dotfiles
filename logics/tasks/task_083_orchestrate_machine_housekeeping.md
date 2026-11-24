## task_083_orchestrate_machine_housekeeping - Orchestrate machine housekeeping
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:10:46

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: orchestrate, machine, housekeeping
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [x] 1. Check item_171 (update notifier) has landed; land it first if not, with generic kinds.
- [x] 2. disk-report (disk-alert reads its --json output).
- [x] 3. disk-alert script, unit and timer; dry-run against lowered thresholds, then enable. (enabled 2026-11-24; first run sent disk-warn, / 9 % free)
- [x] 4. downloads-tidy with a dry run on the real ~/Downloads shown to the owner before the first real run and before enabling the timer. (owner approved the 199-move plan 2026-11-24, extensionless files -> Documents; timer enabled, first run 2026-11-25 00:49)
- [x] 5. Docs and the backup deferral note.
- [x] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [x] Keep commit creation under operator control; do not force one commit per micro-step.
- [x] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_176_disk_space_alert_on_the_arch_partition`
- `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`
- `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`
- `item_179_housekeeping_docs_and_the_backup_deferral_note`

# Definition of Done (DoD)
- [x] Generated request, product, backlog, and task docs are present.
- [x] Context-pack handoff is available when requested.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> This task. Proof: tests/test-disk-alert.sh (levels, once a day, silent above warn); disk-alert.timer enabled 2026-11-24, first run sent disk-warn.
- request-AC2 -> This task. Proof: tests/test-disk-alert.sh (message names top 3; report JSON with a cleanup command per entry, under 30 s); disk-report.sh only prints commands.
- request-AC3 -> This task. Proof: tests/test-downloads-tidy.sh 26/26 (dry run, no delete/overwrite, partial/fresh skipped); owner-approved real dry run, 199 moves.
- request-AC4 -> This task. Proof: scripts + units in git, install.sh links/enables them, docs/TOOLS.md Housekeeping section, docs/BACKUPS.md deferral note.
- request-AC1 -> `item_176_disk_space_alert_on_the_arch_partition`. Proof deferred to slice closeout.
- request-AC4 -> `item_176_disk_space_alert_on_the_arch_partition`. Proof deferred to slice closeout.
- request-AC2 -> `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`. Proof deferred to slice closeout.
- request-AC3 -> `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`. Proof deferred to slice closeout.
- request-AC4 -> `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`. Proof deferred to slice closeout.
- request-AC4 -> `item_179_housekeeping_docs_and_the_backup_deferral_note`. Proof deferred to slice closeout.

# Validation
- 2026-11-24: `tests/test-disk-alert.sh` 23/23 ok (AC1 once-a-day, levels, metadata, thresholds; AC2 report JSON, <30 s, cleanup per entry); `tests/test-downloads-tidy.sh` 26/26 ok (AC3 dry run changes nothing, count equal, partial/fresh/hidden stay, no overwrite, logged undo); `tests/test-update-scripts.sh` still green; shellcheck clean; `systemd-analyze --user verify` on the four units.
- Real machine: `disk-report.sh` 4-20 s; `disk-alert.sh --dry-run` -> disk-warn (/ 10 % free, 21.7G); `downloads-tidy.sh --dry-run` -> 199 moves, nothing changed.
- Finish workflow executed on 2026-11-24.
- Linked backlog/request close verification passed.

# Report
- 2026-11-24 built (scripts/disk-report.sh, disk-alert.sh, downloads-tidy.sh; 4 user units; install.sh links + enables; update-notify.sh kinds disk-warn / disk-critical, app "System"; docs/TOOLS.md section + docs/BACKUPS.md). Owner picked the Downloads folders: Images, Documents, Slides, Archives, Media, Installers, 3D, Data, Other. disk-report has `--json --root` (instant) so the hourly alert only scans when it will notify. Added a critical level for btrfs metadata < 1 GiB with no unallocated space: on 2026-11-24 the disk is fully allocated (1 MiB unallocated, 2.6G metadata free). Owner approved the Downloads plan (extensionless files -> Documents) and had both timers enabled the same day; the first disk-alert run sent the warning at 11:22.
- 2026-11-16 scoped only, nothing built. Open owner picks: order (proposed item_171 notifier, then 177, 176, then rest of task_082) and the Downloads folder names (Images/Documents/Slides/Archives/Media/Installers/Other).
- Finished on 2026-11-24.
- Linked backlog item(s): `item_176_disk_space_alert_on_the_arch_partition`, `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`, `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`, `item_179_housekeeping_docs_and_the_backup_deferral_note`
- Related request(s): `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`

# Links
- Request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |


# Notes
- Backups deferred (owner, 2026-11-16): no off-laptop target; a /mnt/games copy shares the disk. Revisit with a target; snapper config for @home is the cheap local option.
