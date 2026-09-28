## item_111_designed_light_themes_with_their_own_surface_recipe - Designed light themes with their own surface recipe
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Design system
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Designed light themes with their own surface recipe. Light themes are recoloured dark themes: cards render darker and greyer than their panel, shadows sink toward black, secondary text is about 2:1 (Tokyo Night Day worst)
- Keywords: designed, light, themes, own, surface, recipe
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on design system.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Light themes are recoloured dark themes: cards render darker and greyer than their panel, shadows sink toward black, secondary text is about 2:1 (Tokyo Night Day worst); flat mode already looks better than glass in light (render matrix).

# Scope
- In:
  - Light surface recipe (lighter cards, tinted soft shadows, lit edges)
  - Per-theme review across all 7 light variants
- Out:
  - New theme families

# Acceptance criteria
- AC1: All light-theme goldens pass AA and cards read lighter than or equal to their panel.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: All light-theme goldens pass AA and cards read lighter than or equal to their panel.

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
- Rationale: every light theme currently fails hierarchy and contrast (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
