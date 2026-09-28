## item_114_unified_motion_presets_with_reduced_motion_and_animation_scale - Unified motion presets with reduced motion and animation scale
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Motion
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Unified motion presets with reduced motion and animation scale. 46 hand-set OutCubic easings vs 35 uses of the shared Anim wrappers plus 29 literal durations
- Keywords: unified, motion, presets, reduced, animation, scale
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on motion.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- 46 hand-set OutCubic easings vs 35 uses of the shared Anim wrappers plus 29 literal durations; pack motion overrides have no effect; no reduced-motion setting.

# Scope
- In:
  - Route all animation through named presets
  - Animation-scale and reduced-motion setting
  - Pack-overridable motion tokens that actually apply
- Out:
  - Signature morph motion (separate item)

# Acceptance criteria
- AC1: No literal easing or duration outside Commons.
- AC2: Reduced motion disables non-essential animation shell-wide.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: No literal easing or duration outside Commons.

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
- Rationale: five different open/close feels today (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
