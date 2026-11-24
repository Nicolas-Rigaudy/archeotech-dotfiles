## task_085_orchestrate_the_storage_module - Orchestrate the storage module
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-11-24 12:19:08

# AI Context
- Summary: Orchestrates the Storage module: mockups first, then service, Clean up, Explore, bar widget and IPC, goldens.
- Keywords: orchestrate, storage, module
- Use when: Delivering the Storage module waves in order.
- Skip when: Screensaver work (task_077) or the dotfiles timers (task_083).

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. 1. Mockups: render Clean up and Explore layout options with real numbers, one contact sheet in imv, owner picks (AskUserQuestion).
- [ ] 2. 2. Service + sources + scan helper with logic tests.
- [ ] 3. 3. Clean up tab to the picked layout; polkit and Trash paths; probe-data renders.
- [ ] 4. 4. Explore tab with the treemap; layout tests; probe-data renders.
- [ ] 5. 5. Bar widget + IPC; disk-alert Open action once item_119 actions exist; docs.
- [ ] 6. 6. Golden scenarios for the panel, golden.sh + tests/run.sh, qml-reviewer, owner review on the live bar via preview when they ask.
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_180_storage_panel_mockups_layout_options_for_clean_up_and_explore`
- `item_181_storage_service_and_data_driven_cleanup_sources`
- `item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash`
- `item_183_storage_panel_explore_tab_with_a_squarified_treemap`
- `item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC6 -> `item_180_storage_panel_mockups_layout_options_for_clean_up_and_explore`. Proof deferred to slice closeout.
- request-AC1 -> `item_181_storage_service_and_data_driven_cleanup_sources`. Proof deferred to slice closeout.
- request-AC5 -> `item_181_storage_service_and_data_driven_cleanup_sources`. Proof deferred to slice closeout.
- request-AC2 -> `item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash`. Proof deferred to slice closeout.
- request-AC6 -> `item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash`. Proof deferred to slice closeout.
- request-AC3 -> `item_183_storage_panel_explore_tab_with_a_squarified_treemap`. Proof deferred to slice closeout.
- request-AC6 -> `item_183_storage_panel_explore_tab_with_a_squarified_treemap`. Proof deferred to slice closeout.
- request-AC4 -> `item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert`. Proof deferred to slice closeout.
- request-AC5 -> `item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
- Product brief(s): `prod_008_storage_module`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
