## item_106_bar_and_strip_widget_instantiation_fixes - Bar and strip widget instantiation fixes
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Shell
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 14:08:14

# AI Context
- Summary: Bar and strip widget instantiation fixes. Bar.qml horizontal (l.286/317/341) and vertical (l.421/439/459) Repeaters share the same zone models and are only hidden with visible, so tray, marquee, clock timers and plugins are instantiated twice (verified).
- Keywords: bar, strip, widget, instantiation, fixes
- Use when: Implementing or reviewing the 0.31 Correctness sweep milestone work on shell.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Bar.qml horizontal (l.286/317/341) and vertical (l.421/439/459) Repeaters share the same zone models and are only hidden with visible, so tray, marquee, clock timers and plugins are instantiated twice (verified).
- WIDGET_API says strip holders provide no-op popup functions but Strip.qml has none; a bar widget placed on a strip that calls them likely throws.
- Plugin widgets are probably blank after a cold start because WidgetLoader never retries after the module scan finishes.

# Scope
- In:
  - Give the inactive orientation no model
  - Add strip no-op popup API
  - WidgetLoader retry on registry ready
- Out:
  - Holder-aware vertical widgets (item_064)

# Acceptance criteria
- AC1: Each configured bar widget has exactly one live instance per bar.
- AC2: A plugin widget renders after a cold start and a bar widget on a strip can call popup functions without error.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Each configured bar widget has exactly one live instance per bar.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_036_bar_and_strip_widget_instantiation_fixes`

# Priority
- Priority: High
- Rationale: every bar widget currently runs twice per bar per screen (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_036_bar_and_strip_widget_instantiation_fixes`

# Notes
- Task `task_036_bar_and_strip_widget_instantiation_fixes` was finished via `logics-manager flow finish task` on 2026-09-28.
