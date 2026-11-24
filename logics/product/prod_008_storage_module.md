## prod_008_storage_module - Storage module
> Date: 2026-11-24
> Status: Proposed
> Related request: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
> Related backlog: `item_180_storage_panel_mockups_layout_options_for_clean_up_and_explore`, `item_181_storage_service_and_data_driven_cleanup_sources`, `item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash`, `item_183_storage_panel_explore_tab_with_a_squarified_treemap`, `item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert`
> Related task: `task_085_orchestrate_the_storage_module`
> Related architecture: (none yet)
> Reminder: Update status, linked refs, scope, decisions, success signals, and open questions when you edit this doc.

# Overview
A disk utility inside Archeotech: a panel that scans on demand, shows where the space went as a size map and a list, and frees space through tiered, previewed, reversible-where-possible cleanups; plus a bar widget and an Open action on the low-space notice.

# Goals
- Going from a low-space notice to freed space takes one click to open and one confirm to clean.
- The size map makes the biggest folders obvious at a glance.
- No cleanup surprises: every action says what it costs, shows its command, and personal files are recoverable from the Trash.

# Non-goals
- Duplicate-file finding and file previews.
- Scheduled or automatic deletion (the dotfiles timers only notify and sort Downloads).
- Partition management, resizing or formatting (GNOME Disks territory).
- Per-snapshot sizes (they need btrfs quotas).

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
- Product back-reference: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
- Task back-reference: `task_085_orchestrate_the_storage_module`
