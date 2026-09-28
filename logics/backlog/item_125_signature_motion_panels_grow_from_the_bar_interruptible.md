## item_125_signature_motion_panels_grow_from_the_bar_interruptible - Signature motion: panels grow from the bar, interruptible
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: High
> Theme: Motion
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Signature motion: panels grow from the bar, interruptible. Panels fade in rather than morph
- Keywords: signature, motion, panels, grow, bar, interruptible
- Use when: Implementing or reviewing the 0.60 Contexts and signature milestone work on motion.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Panels fade in rather than morph; there is no sliding selection highlight, staggered list entrance or list add/remove transition.

# Scope
- In:
  - Interruptible morph from bar anchor to panel
  - Sliding selection highlight and staggered entrances on shared primitives
- Out:
  - Motion personalities and UI sound (post-1.0 req_002 remainder)

# Acceptance criteria
- AC1: Reversing a panel open mid-animation morphs back without a jump (burst capture).

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC1: Reversing a panel open mid-animation morphs back without a jump (burst capture).

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
- Rationale: the core of req_002 trimmed to what reads premium at launch (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
