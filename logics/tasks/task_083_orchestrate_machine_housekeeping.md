## task_083_orchestrate_machine_housekeeping - Orchestrate machine housekeeping
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: orchestrate, machine, housekeeping
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. Check item_171 (update notifier) has landed; land it first if not, with generic kinds.
- [ ] 2. disk-report (disk-alert reads its --json output).
- [ ] 3. disk-alert script, unit and timer; dry-run against lowered thresholds, then enable.
- [ ] 4. downloads-tidy with a dry run on the real ~/Downloads shown to the owner before the first real run and before enabling the timer.
- [ ] 5. Docs and the backup deferral note.
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_176_disk_space_alert_on_the_arch_partition`
- `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`
- `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`
- `item_179_housekeeping_docs_and_the_backup_deferral_note`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> `item_176_disk_space_alert_on_the_arch_partition`. Proof deferred to slice closeout.
- request-AC4 -> `item_176_disk_space_alert_on_the_arch_partition`. Proof deferred to slice closeout.
- request-AC2 -> `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`. Proof deferred to slice closeout.
- request-AC3 -> `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`. Proof deferred to slice closeout.
- request-AC4 -> `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`. Proof deferred to slice closeout.
- request-AC4 -> `item_179_housekeeping_docs_and_the_backup_deferral_note`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

