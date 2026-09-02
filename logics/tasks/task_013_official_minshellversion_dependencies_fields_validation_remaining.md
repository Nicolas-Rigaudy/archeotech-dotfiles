## task_013_official_minshellversion_dependencies_fields_validation_remaining - official + minShellVersion + dependencies fields + validation (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-02 14:27:44
> Owner: corvus

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: official, minshellversion, dependencies, fields, validation, remaining
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_066_plugin_manifest_schema_official_verified_minshellversion_deps`

# Acceptance criteria
- AC1: A plugin manifest with `official: true` or `verified: true` renders the corresponding badge in the Plugin Manager pane.
- AC2: Installing or loading a plugin whose `minShellVersion` exceeds the running shell version produces a clear warning/block instead of a silent failure.
- AC3: A plugin's declared `dependencies` are shown to the user at install time.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_013_official_minshellversion_dependencies_fields_validation_remaining.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_013_official_minshellversion_dependencies_fields_validation_remaining.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint ModuleRegistry.qml PluginsPane.qml shell.qml; shot.sh --state settings:plugins headless render (official badges + throwaway minShellVersion=9.9.9/deps module → warning+disabled+deps)` | result: passed | date: 2026-09-02
- Finish workflow executed on 2026-09-02.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-02.
- Linked backlog item(s): `item_066_plugin_manifest_schema_official_verified_minshellversion_deps`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof: module.json gained official/minShellVersion/dependencies (parsed in ModuleRegistry; shellVersion bound from shell.qml). Plugins pane: AC1 Official badge (accent) + Verified badge (muted) render distinctly; AC2 incompatible module shows red 'Requires shell >= X' warning + disabled toggle, and is blocked from placement/enable in ModuleRegistry; AC3 dependencies shown as a 'Requires:' row. Validated qmllint-clean and by headless render of the Plugins pane (shot.sh --state settings:plugins): official badges on hello/notes, and a throwaway minShellVersion=9.9.9 + deps module showed the warning/disabled-toggle/deps-row; live session survived. Implemented in archeotech-shell a512c26. Source: `a512c26`
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
