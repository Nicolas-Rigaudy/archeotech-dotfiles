## item_013_layout_loadouts_presets - Layout loadouts / presets
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 10%
> Complexity: Medium
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: layout, loadouts, presets
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- No way to save named snapshots of the whole bar/strip layout and switch in one click

# Scope
- In:
  - ShellConfig.saveLoadout/applyLoadout snapshotting sides/corners/outerGap; loadouts UI row in Shell pane / edit-mode banner
- Out:
  - Per-monitor loadouts

# Acceptance criteria
- AC3: Users can save, apply, rename, and delete named layout loadouts that hot-reload live

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: Users can save, apply, rename, and delete named layout loadouts that hot-reload live

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-09-28: kept as the bar-layout facet that a Context (item_122) can apply. Scheduled 0.60.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: Bar-layout facet that Contexts applies (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
