## item_181_storage_service_and_data_driven_cleanup_sources - Storage service and data-driven cleanup sources
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Storage
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:33:38

# AI Context
- Summary: Scan helper, data-driven cleanup source format and Services/System/Storage.qml exposing free space, btrfs state, entries and a folder tree.
- Keywords: storage, service, data, driven, cleanup, sources
- Use when: Changing the scan, the source JSON format or the storage service bindings.
- Skip when: Panel visuals or running cleanups.

# Problem
- The scan and cleanup knowledge lives in a private dotfiles script; the public shell needs a generic, data-driven backend that QML can bind to.

# Scope
- In:
  - A scan helper shipped with the shell (port of disk-report.sh): free space, btrfs metadata/unallocated, sized entries per source, and a folder tree (bytes per dir, a few levels deep, top-N children) for Explore, as JSON; timeout and partial flag kept.
  - Source format (JSON): id, label, detect (path or command), size path, cleanup command, tier Safe/Review, cost text, needs_root, trash vs remove; shipped generic sources (pacman cache, paru, yay, journal, ~/.cache dirs, Trash, uv, pip, npm, flatpak unused, docker, snapper count); extra sources from user config.
  - Services/System/Storage.qml: runs the helper via Process, caches the last result and its time, exposes models; rescan(); no scan at startup beyond the instant free-space read.
  - Owner's sources (cdx leftovers, ~/.cdx uv cache) added in the dotfiles config; logic tests for parsing and tiering.
- Out:
  - Running cleanups (next item).
  - Per-snapshot sizes.

# Acceptance criteria
- AC1: Storage.qml exposes free, metadata, unallocated, entries and the tree after rescan(); the result and its age survive a panel close.
- AC5: A source added in user config appears after rescan without a shell code change; tests cover the source format.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Storage.qml exposes free, metadata, unallocated, entries and the tree after rescan(); the result and its age survive a panel close.
- request-AC5 -> This backlog slice. Proof: AC5: A source added in user config appears after rescan without a shell code change; tests cover the source format.

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
