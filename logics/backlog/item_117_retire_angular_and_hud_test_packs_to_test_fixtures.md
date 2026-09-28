## item_117_retire_angular_and_hud_test_packs_to_test_fixtures - Retire Angular and HUD test packs to test fixtures
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Theming engine
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Retire Angular and HUD test packs to test fixtures. Angular renders almost identical to Base and HUD only recolours the accent
- Keywords: retire, angular, hud, test, packs, fixtures
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on theming engine.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Angular renders almost identical to Base and HUD only recolours the accent; the owner confirmed both were testing only.

# Scope
- In:
  - Move both to tests/fixtures/packs for engine tests; remove from the Settings pack picker
  - Keep any engine capability they exercised (corner shape setting, HUD kit hooks)
- Out:

# Acceptance criteria
- AC1: The pack picker lists only installed real packs; engine tests still load the fixtures.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC1: The pack picker lists only installed real packs; engine tests still load the fixtures.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Low
- Rationale: they were test-only; real packs ship as add-ons (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
