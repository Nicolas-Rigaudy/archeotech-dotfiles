## item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales - Semantic token layer with contrast floor and spacing/type scales
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Design system
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Semantic token layer with contrast floor and spacing/type scales. Appearance.qml is one flat bag
- Keywords: semantic, token, layer, contrast, floor, spacing, type, scales
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on design system.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Appearance.qml is one flat bag; components pick raw palette steps (overlay0 is the second most used text colour, 1.8-2.7:1 on cards).
- Spacing tokens used 28 times vs 226 pixel literals; 82 literal font sizes (9-40px); no opacity, elevation, weight or letter-spacing scales; 5 of 12 duration tokens unused.
- Evidence: audit-design.md.

# Scope
- In:
  - Mode-aware semantic roles (text primary/secondary/muted, surface levels, border, state, elevation) resolved from the palette with a minimum-contrast rule
  - 4pt spacing grid, type scale, opacity and elevation tiers; bulk-migrate literals
  - CI grep invariant: no hex colour or raw font size outside tokens
- Out:
  - Surface recipes and pack chrome (separate item)

# Acceptance criteria
- AC1: No hex literal or raw font size outside Commons token files.
- AC2: Automated contrast check passes AA for text roles on every theme.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: No hex literal or raw font size outside Commons token files.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: foundation for light themes, packs and accessibility (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
