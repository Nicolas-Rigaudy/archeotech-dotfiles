## item_137_clock_format_bar_widget_options_scan_roots_settings - Clock format, bar widget options and dashboard scan roots in Settings
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85%
> Confidence: 80%
> Progress: 0%
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Expose settings that today need a config.json hand-edit or are hardcoded.
- Keywords: settings, clock, format, bar, widget, options, scan, roots, settings
- Use when: Implementing this Settings addition picked from the item_134 audit.
- Skip when: Working on other Settings panes; see item_134 for the full comparison.

# Problem
- Clock/date format is not configurable (stale unread key bar.clockFormat in config.json).
- bar.modules.{battery,bluetooth,music,wifi} widget options and dashboard.scanRoots are read by the shell but only settable by hand-editing config.json.
- All four reference shells expose clock/date format.

# Scope
- In:
  - Clock: 24h/12h, seconds, date format
  - Bar widget options (via the widgets' configSchema / ConfigForm where possible)
  - Dashboard Active Projects scan folders
  - Drop the stale bar.clockFormat / bar.height keys
- Out:
  - New bar widgets

# Acceptance criteria
- AC1: Clock format, widget options and scan roots are editable in Settings, apply live, and nothing needs a hand-edit.
- AC2: No stale unread keys remain in the default config.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Clock format, widget options and scan roots are editable in Settings, apply live, and nothing needs a hand-edit.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: owner picked it from the item_134 settings audit (2026-09-29).

# Notes
- Generated locally by logics-manager.
