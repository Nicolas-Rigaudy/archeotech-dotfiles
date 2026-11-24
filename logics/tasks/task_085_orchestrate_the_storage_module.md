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
> Indicators reviewed: 2026-11-24 12:46:53

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
- item_181 (archeotech-shell d0a5906): tests/run.sh 146 passed; python3 -m unittest discover -s tests/py OK (21 storage-scan tests: guard incl. ~/.ssh/<file>, /home/<other>, children base $HOME refused, {path} commands guarded, detail_command quoting, nested dedup, bad --mount); qmllint only the known Config.get false positive; qml-reviewer findings fixed (guard holes, quoting, folder-scan queue, clock expiry); golden.sh --root wt: 27/30 pass, the 3 dashboard-cyberdeck-* fail identically on unchanged main 718ea42 (pre-existing, not this item). Real read-only scan with the owner's sources: 17 rows, 0 rejected, 0 errors, 4.8 s, not partial.
- item_182 landed as archeotech-shell f306187: tests/run.sh 147 passed; scripts/golden.sh 22/25 (only dashboard-cyberdeck-{netrunner,megacorp,deck} fail, same as on main); Qt6 qmllint clean apart from known singleton missing-property false positives; owner approved the review sheet.
- 2026-11-24 item_183 + item_184 (widget, ipc): landed archeotech-shell f4d79d6. tests/run.sh 154 passed (tst_storagelogic: test_treemap_areas_proportional, test_treemap_squarish); Qt6 qmllint clean apart from the known singleton noise; qml-reviewer no blockers (applied: no folder scan during a full scan, 'first 50' search cap, key hints in the footer). shot.sh: qs ipc --pid call panel open storage renders the panel. Owner checked the Explore tab on the live bar (preview of the worktree) and approved.

# Report
- item_181 done: scripts/storage-scan.py (read-only statvfs/du/btrfs scan, JSON), scripts/storage-sources.json (14 shipped sources), Services/System/Storage.qml + StorageLogic.js (free-space level every 5 min, rescan, scanFolder graft), storage.warnPct/critPct config keys, docs/STORAGE.md. Owner sources in dotfiles config/.config/archeotech/storage-sources.json (cdx uv cache 27.8G safe; 2 old cdx profiles 21.3G and arch-backup 3.3G as review/trash); install.sh mkdir guard so stow never folds ~/.config/archeotech. Owner step: stow -R config to link the file. Next: item_182 Clean up tab.
- item_182 done: Clean up tab (CleanC), confirm with exact commands, pkexec run via the helper, review items to the Trash, Empty Trash offered on the result screen, run survives closing the panel, rescan queued while a scan runs.
- 2026-11-24: items 183 + 184 core built and previewing on the live bar, awaiting owner approval. Polkit: mango had no agent, polkit-kde-agent added via exec_once (owner verified the prompt); shell-styled agent logged as item_185. uv (cdx) cleanup times out while uvx MCP servers hold the cache lock (owner reruns later).
- 2026-11-24: item_183 Explore tab (two-level squarified treemap by cleanup tier, drill-down, breadcrumb, synced largest-first list, hovered-box card, lazy scoped folder scans, search, keyboard) and item_184 bar Storage widget + 'storage' IPC target (open/toggle) landed in f4d79d6. Left: item_184 disk-alert Open action waits on item_119 notification actions. Follow-up: panel depth is not clamped to short screens (storage 1000 px, also 940/900 px panels; overflows at 720 and 1080 tall).

# Links
- Request: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
- Product brief(s): `prod_008_storage_module`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
