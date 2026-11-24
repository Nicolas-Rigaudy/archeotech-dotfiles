## item_183_storage_panel_explore_tab_with_a_squarified_treemap - Storage panel: Explore tab with a squarified treemap
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Storage
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:33:39

# AI Context
- Summary: Explore tab: squarified treemap of the scan tree with drill-down, breadcrumb and a synced largest-first list.
- Keywords: storage, panel, explore, tab, squarified, treemap
- Use when: Working on the treemap layout, its colours or Explore navigation.
- Skip when: Deleting files (Clean up owns deletion).

# Problem
- A list of sizes does not show at a glance where 70 G went; the owner wants size-proportional boxes as in the Windows tree viewers.

# Scope
- In:
  - Squarified treemap (JS layout, tested) drawn from the scan tree: nested boxes sized by bytes, labels where they fit, colour by type or tier per the mockup pick, hover with Prim.Tooltip (path, size).
  - Click a box to drill into it, breadcrumb to go back up; largest-first list beside or below synced with the map; open a folder in the file manager.
  - Deeper levels loaded lazily by a scoped helper call on the clicked folder, not a second full walk.
- Out:
  - Deleting from the Explore tab (Clean up owns deletion); duplicate finding.

# Acceptance criteria
- AC3: The treemap areas are proportional to bytes (logic test), drill-down and breadcrumb work, and the list matches the map.
- AC6: Renders with a deep, wide probe tree on dark, light and Flat pass the visual check.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: The treemap areas are proportional to bytes (logic test), drill-down and breadcrumb work, and the list matches the map.
- request-AC6 -> This backlog slice. Proof: AC6: Renders with a deep, wide probe tree on dark, light and Flat pass the visual check.

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
