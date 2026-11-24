## req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget - Storage module: disk cleanup panel, size map and bar widget
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: High
> Theme: Storage
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:33:21

# AI Context
- Summary: Archeotech panel that scans disk use on demand, frees space through tiered previewed cleanups (polkit, Trash) and maps folders as a squarified treemap; bar widget and notification Open action.
- Keywords: storage, module, disk, cleanup, panel, size, map, bar, widget
- Use when: Working on the Storage panel, its scan helper and cleanup sources, the treemap, the storage bar widget or the disk-alert Open action.
- Skip when: Changing the dotfiles disk-report/disk-alert timers only (req_017) or notification actions themselves (item_119).

# Needs
- When the disk fills up the owner wants to open one place from the notification or the bar, see what takes the space, tick what to remove and free it, without copying commands into a terminal.
- The owner wants a picture of where the space went: boxes drawn to the size of each folder and file, as in the Windows tree viewers (WinDirStat style), with drill-down.
- Cleanup must be safe by default: it says what deleting each item costs, never offers personal folders, shows the real commands before running them and reports what was freed.

# Context
- 2026-11-24 state: / is btrfs at 90 % used with 1 MiB unallocated and 2.6 G metadata free; disk-report.sh found a 28 G uv cache and 21 G of leftover cdx profile folders that the plain du view hid inside one 70 G line.
- The dotfiles already have disk-report.sh (read-only scan, --json, --json --root instant) and disk-alert.sh (hourly timer, notifications through update-notify.sh). The shell module is the UI on top of the same idea.
- archeotech-shell is public, so the module must be generic: cleanup sources are data (detect, size, cleanup command, tier, needs root), shipped for common Linux sources; machine-specific sources (e.g. ~/.cdx leftovers) live in the owner's private config.
- Owner priority (2026-11-24): before the screensaver (task_077). Tabs: Clean up and Explore; Explore must include the size-proportional box view.
- Owner rules that apply: render the options and open them in imv before asking (visual choices); panel lists read top to bottom with one header row (segmented tabs + search), hints in a muted footer; pick-one settings are ButtonGroupRow selectors; Prim.Divider and Prim.Tooltip; no fake toggles; tests in the isolated shot.sh session only.
- Privileged cleanups (pacman cache, journal, snapper, btrfs balance) go through a polkit prompt (pkexec), never a terminal sudo; personal files go to the Trash (gio trash), caches are removed.

# Acceptance criteria
- AC1: A storage service runs a read-only scan on demand in a helper process, caches the last result with its age, and exposes free space, btrfs metadata and unallocated space, and tiered cleanup entries to QML.
- AC2: The Clean up tab lists entries grouped Safe / Review with checkbox, exact size and what deleting costs; personal folders are never offered; a confirm step shows the exact commands, privileged ones run through polkit, personal files go to the Trash, and the panel reports the space freed and rescans.
- AC3: The Explore tab shows a squarified treemap of a folder (boxes sized by bytes, coloured by type or tier) with click to drill down, a breadcrumb back up and a largest-first list beside it, built from the scan without a second full walk.
- AC4: A bar widget shows used space with warn and critical colours from the same thresholds as disk-alert, and opens the panel; an IPC target (storage open/toggle/rescan) opens it, and disk-alert's notification has an Open action once item_119 actions land.
- AC5: Cleanup sources are data-driven: the shell ships generic sources and loads extra ones from user config; the dotfiles add the owner's sources, and the docs describe the source format.
- AC6: The layout was picked by the owner from rendered mockups before building, and the shipped panel renders in shot.sh with realistic data (long lists, a deep tree, a privileged entry) on dark, light and Flat.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_008_storage_module`
- Architecture decision(s): (none yet)

# References
- scripts/disk-report.sh and scripts/disk-alert.sh in archeotech-dotfiles (req_017: the scan, tiers and cleanup commands this module turns into a UI)
- Modules/Shell/Panels/Content/ (panel pattern) and Widgets/Bar/<Id>Widget.qml (filename-convention bar widgets, docs/WIDGET_API.md) in archeotech-shell
- shell.qml IpcHandler targets (launcher/settings/dashboard open/toggle pattern)
- logics/backlog/item_119_notifications_v2_actions_images_grouping_history.md (notification actions, needed for the Open button)
- logics/backlog/item_121 (Quickshell Polkit and other native services not yet adopted)
- GNOME Disk Usage Analyzer (baobab), KDE Filelight, WinDirStat / WizTree treemaps, ncdu, macOS Storage management, Windows Storage Sense (design references only)
- Bruls, Huizing, van Wijk, 'Squarified Treemaps' (2000): the layout algorithm for the size map

# Backlog
- `item_180_storage_panel_mockups_layout_options_for_clean_up_and_explore`
- `item_181_storage_service_and_data_driven_cleanup_sources`
- `item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash`
- `item_183_storage_panel_explore_tab_with_a_squarified_treemap`
- `item_184_storage_bar_widget_ipc_target_and_the_open_action_on_disk_alert`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
