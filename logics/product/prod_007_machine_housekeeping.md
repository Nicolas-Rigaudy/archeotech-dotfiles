## prod_007_machine_housekeeping - Machine housekeeping
> Date: 2026-11-16
> Status: Proposed
> Related request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
> Related backlog: `item_176_disk_space_alert_on_the_arch_partition`, `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`, `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`, `item_179_housekeeping_docs_and_the_backup_deferral_note`
> Related task: `task_083_orchestrate_machine_housekeeping`
> Related architecture: (none yet)
> Reminder: Update status, linked refs, scope, decisions, success signals, and open questions when you edit this doc.

# Overview
Small scheduled jobs that keep the owner's Arch laptop tidy: a disk space alert with a report of where space went, and a Downloads folder that sorts itself.

# Goals
- The owner hears about low disk space days before it breaks an upgrade or a build.
- Freeing space is a matter of reading one report and running the suggested commands.
- ~/Downloads stays browsable without manual sorting, and nothing is ever lost.

# Non-goals
- Backups (deferred until an off-laptop target exists).
- Automatic deletion of caches, snapshots or downloads.
- Repartitioning the disk or shrinking /mnt/games.
- A disk usage widget in archeotech-shell.

# Scope and guardrails
- In: scaffolded request, product, backlog, orchestration task, validation, and handoff context.
- Out: unrelated workflow docs and implementation of generated tasks.

# Key product decisions
- Use structured input as the source of truth for generated docs.
- Keep generated write paths local and repo-bounded.

# Success signals
- Generated docs pass lint and audit without broad manual rewrites.
- Context-pack output can be handed to an implementation agent directly.

# References
- Product back-reference: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Task back-reference: `task_083_orchestrate_machine_housekeeping`
