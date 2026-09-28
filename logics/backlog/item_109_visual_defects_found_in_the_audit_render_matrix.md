## item_109_visual_defects_found_in_the_audit_render_matrix - Visual defects found in the audit render matrix
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 16:25:17

# AI Context
- Summary: Visual defects found in the audit render matrix. Edit Mode pill covers the bar clock
- Keywords: visual, defects, found, audit, render, matrix
- Use when: Implementing or reviewing the 0.31 Correctness sweep milestone work on polish.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Edit Mode pill covers the bar clock; panels stack over the open dashboard with its content bleeding through; the launcher has dead space below few results; the media panel idle state is a bare 'Nothing playing'; wallpaper carousel edge thumbnails spill outside the panel.
- Evidence: .claude/audits/2026-09-28/contact-sheets and the audit page screenshots.

# Scope
- In:
  - Fix each defect and add it as a golden scenario
- Out:
  - Design system v2 token work

# Acceptance criteria
- AC1: Each listed defect is absent in its golden scenario across dark, light and flat.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Each listed defect is absent in its golden scenario across dark, light and flat.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-09-28 owner decisions: (1) Edit Mode banner over the clock -> needs a proper edit mode design review and audit, split to item_130. (2) Carousel edge tiles past the panel are the intended peek (Carousel.qml clip:false) -> kept, not a defect. (3) Launcher keeps its fixed height; fill the space below short result lists. (4) Media idle -> designed empty state. Panels stacking over the dashboard: not reproducible on main 436dc27 (dashboard open or openAuto, then launcher open, replaces it); the audit render was made while the leaked mango autostart ran a second quickshell in the nested session (two shell instances drawing), so it was a render artifact, not a shell bug.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_041_visual_defects_found_in_the_audit_render_matrix`

# Priority
- Priority: Medium
- Rationale: visible on first use by a stranger (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_041_visual_defects_found_in_the_audit_render_matrix`

# Notes
- Task `task_041_visual_defects_found_in_the_audit_render_matrix` was finished via `logics-manager flow finish task` on 2026-09-28.
