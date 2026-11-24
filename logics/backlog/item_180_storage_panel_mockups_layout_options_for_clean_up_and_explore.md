## item_180_storage_panel_mockups_layout_options_for_clean_up_and_explore - Storage panel mockups: layout options for Clean up and Explore
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Storage
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 12:18:59

# AI Context
- Summary: Rendered layout options for the Storage panel's Clean up and Explore tabs, picked by the owner before any engine work.
- Keywords: storage, panel, mockups, layout, options, clean, explore
- Use when: Choosing the Storage panel layout or treemap colouring.
- Skip when: Building the service or cleanup execution.

# Problem
- The panel has two dense views (a tiered cleanup list and a treemap) and the owner picks layouts from renders, not descriptions.

# Scope
- In:
  - Standalone QML mockups rendered through shot.sh --qml at 1920x1200 with the real disk-report numbers: 2-3 layout options for Clean up (list density, where the confirm step sits) and for Explore (treemap and list side by side vs stacked, treemap colouring by type vs tier).
  - One combined contact sheet opened in imv, then AskUserQuestion for the pick.
- Out:
  - Engine work and real cleanup.

# Acceptance criteria
- AC6: The owner picked a Clean up layout and an Explore layout from rendered options; the pick is recorded in this item.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC6: The owner picked a Clean up layout and an Explore layout from rendered options; the pick is recorded in this item.

# Owner pick (2026-11-24)
- Mockups (standalone QML, real disk-report numbers, 1920x1200 via `shot.sh --qml`) and sheets are in `.claude/mockups/storage/`: `options.png` (the six options) and `picks.png` (the confirmed picks).
- Clean up: hybrid `CleanC.qml`. Option B's layout (list on the left, "Selected" side card on the right with the commands and the Free button) plus option A's two-line rows (size, then what deleting costs).
- Explore: option B (`ExploreB.qml`). Treemap across the top, largest-first list and details card below, breadcrumb above the map.
- Treemap colouring: by tier (Safe / Review / personal / system), legend under the map.
- Bar widget: drive icon + used-space ring (`Wid.qml` variant `dring`); the free space text appears only at warn or critical. Monochrome theme: warn = bright, critical = inverted chip; colour themes use peach / red.
- Review items (leftover profiles, old backups) go to the Trash (gio trash). The result screen then offers "Empty Trash now" as its own confirmed step, because on the same btrfs volume the Trash frees nothing until it is emptied.
- Note for item_181: `paru -Sc` is interactive, so the paru source cleans with `rm -rf ~/.cache/paru/clone`.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_008_storage_module`
- Architecture decision(s): (none yet)
- Request: `req_018_storage_module_disk_cleanup_panel_size_map_and_bar_widget`
- Primary task(s): `task_085_orchestrate_the_storage_module`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
