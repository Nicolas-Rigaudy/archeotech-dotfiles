## item_116_glass_material_decision_real_blur_or_satin - Glass material decision: real blur or satin
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Design system
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Glass material decision: real blur or satin. Quickshell layer blur is off (adr_008) and panels are 96% opaque, so the documented glass aesthetic is not what renders.
- Keywords: glass, material, decision, real, blur, satin
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on design system.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Quickshell layer blur is off (adr_008) and panels are 96% opaque, so the documented glass aesthetic is not what renders.

# Scope
- In:
  - Spike compositor blur for layers on MangoWC and Hyprland, measure cost, record an ADR
  - Either enable blur or rename and design the material as satin
- Out:

# Acceptance criteria
- AC1: An ADR records the decision and the goldens reflect it.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: An ADR records the decision and the goldens reflect it.

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
- Rationale: the 'glass' aesthetic currently renders as a 96% opaque slab (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
