## item_109_visual_defects_found_in_the_audit_render_matrix - Visual defects found in the audit render matrix
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

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

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: visible on first use by a stranger (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
