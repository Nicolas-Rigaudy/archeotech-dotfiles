## item_138_settings_ux_per_setting_search_and_reset - Settings UX: per-setting search and reset to default
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 85%
> Confidence: 80%
> Progress: 100%
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-10-13 11:25:30

# AI Context
- Summary: Settings infrastructure: search that finds individual rows, and a reset-to-default control per row.
- Keywords: settings, settings, ux, per, setting, search, and, reset
- Use when: Implementing this Settings addition picked from the item_134 audit.
- Skip when: Working on other Settings panes; see item_134 for the full comparison.

# Problem
- Settings search matches panes by keyword (PaneRegistry.search), not individual settings.
- No way to return a setting to its default except editing config.json.
- Reference: DMS SettingsSearchService (jump + highlight) and per-row reset when value != default; Noctalia reset + confirm, reset page, UI overrides kept separate from user config.

# Scope
- In:
  - Rows register label/description/keywords for search; results jump to and highlight the row
  - Per-row reset when the value differs from its default (defaults declared once)
  - Keep disabled-with-reason rows for missing backends (better than hiding)
- Out:
  - Import/export of the whole config

# Acceptance criteria
- AC1: Searching a setting's label (e.g. 'toast') lists that row and selecting it scrolls to and highlights it.
- AC2: Every row with a declared default shows reset when changed, and reset restores the default live.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Searching a setting's label (e.g. 'toast') lists that row and selecting it scrolls to and highlights it.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_056_settings_ux_per_setting_search_and_reset_to_default`

# Priority
- Priority: Medium
- Rationale: owner picked it from the item_134 settings audit (2026-09-29).

# Notes
- Generated locally by logics-manager.
- Task `task_056_settings_ux_per_setting_search_and_reset_to_default` was finished via `logics-manager flow finish task` on 2026-10-13.

# Tasks
- `task_056_settings_ux_per_setting_search_and_reset_to_default`
