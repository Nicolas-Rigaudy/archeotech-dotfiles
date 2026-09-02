## item_066_plugin_manifest_schema_official_verified_minshellversion_deps - Plugin manifest schema (official/verified/minShellVersion/deps)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-02 14:27:44

# AI Context
- Summary: Extends the plugin manifest with `official`/`verified`/`minShellVersion`/`dependencies` fields so the manager and install mechanism can trust and gate plugins.
- Keywords: plugin, manifest, schema, official, verified, minshellversion, deps
- Use when: Working on manifest field validation, compatibility gating, or the official/verified/badge logic.
- Skip when: Working on the install CLI or plugins.json hosting (item_065) or the manager pane UI itself (item_063).
- Note (adr_026): theme packs are a KIND of plugin — this same manifest (official/verified/minShellVersion/deps) gates packs too; minShellVersion also versions the theming style contract (item_081).

# Problem
- `module.json` has no way to mark a plugin as official or community-verified, so the manager pane cannot show a trust badge.
- There is no `minShellVersion` field, so an incompatible plugin can be installed and silently break instead of being blocked with a clear message.
- There is no `dependencies` field, so a plugin that needs another plugin or a system binary has no declared way to state that.

# Scope
- In:
  - `official` and `verified` boolean/enum fields in the manifest schema, consumed by the Plugin Manager pane badge
  - `minShellVersion` field with a compare-and-warn/block check at install and load time
  - `dependencies` field (other plugin ids and/or system binaries) surfaced to the user before install
- Out:
  - The install mechanism and plugins.json index itself (item_065)
  - Automatic dependency installation (declare only, not auto-resolve)

# Acceptance criteria
- AC1: A plugin manifest with `official: true` or `verified: true` renders the corresponding badge in the Plugin Manager pane.
- AC2: Installing or loading a plugin whose `minShellVersion` exceeds the running shell version produces a clear warning/block instead of a silent failure.
- AC3: A plugin's declared `dependencies` are shown to the user at install time.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: manifest schema fields (official/verified/minShellVersion/dependencies) are part of the milestone 0.27 plugin ecosystem deliverable.

# Priority
- Priority: Medium
- Rationale: Needed for trust/compatibility signals but the install mechanism (item_065) is the harder blocking dependency.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_013_official_minshellversion_dependencies_fields_validation_remaining`

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
- Task `task_012_manifest_verified_description_fields_delivered` was finished via `logics-manager flow finish task` on 2026-08-21.
- Task `task_013_official_minshellversion_dependencies_fields_validation_remaining` was finished via `logics-manager flow finish task` on 2026-09-02.

# Tasks
- `task_012_manifest_verified_description_fields_delivered`
- `task_013_official_minshellversion_dependencies_fields_validation_remaining`
