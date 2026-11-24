## item_182_storage_panel_clean_up_tab_with_confirm_polkit_and_trash - Storage panel: Clean up tab with confirm, polkit and Trash
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: High
> Theme: Storage
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 13:28:37
> Owner: claude

# AI Context
- Summary: Clean up tab: Safe/Review checkbox rows, confirm step with exact commands, polkit for privileged ones, Trash for personal files, freed-space report.
- Keywords: storage, panel, clean, tab, confirm, polkit, trash
- Use when: Working on cleanup execution, polkit prompts or the Clean up tab UI.
- Skip when: The treemap or the bar widget.

# Problem
- Freeing space today means reading a report and copying commands into a terminal with sudo.

# Scope
- In:
  - Panel content with the owner-picked layout: header row (segmented Clean up | Explore, search), free-space bar with btrfs metadata warning, Safe and Review groups, checkbox rows with size and cost text, footer with scan age, Rescan and Free X.
  - Confirm step listing the exact commands; privileged ones run through pkexec (one prompt per run where possible); personal files via gio trash; caches removed.
  - Result: freed space reported, automatic rescan; after a large cleanup with no unallocated space, offer the btrfs balance as a separate confirmed step.
  - Renders with realistic probe data (long list, privileged rows, running and done states).
- Out:
  - Explore tab (next item).

# Acceptance criteria
- AC2: Ticking Safe entries and confirming runs exactly the commands shown, privileged ones behind a polkit prompt, and reports the freed bytes; personal folders never appear as entries.
- AC6: Renders on dark, light and Flat with probe data pass the visual check.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Ticking Safe entries and confirming runs exactly the commands shown, privileged ones behind a polkit prompt, and reports the freed bytes; personal folders never appear as entries.
- request-AC6 -> This backlog slice. Proof: AC6: Renders on dark, light and Flat with probe data pass the visual check.

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
