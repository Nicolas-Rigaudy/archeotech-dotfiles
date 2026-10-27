## task_060_retire_angular_and_hud_test_packs_to_test_fixtures - Retire Angular and HUD test packs to test fixtures
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: retire, angular, hud, test, packs, fixtures
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_117_retire_angular_and_hud_test_packs_to_test_fixtures`

# Acceptance criteria
- AC1: The pack picker lists only installed real packs; engine tests still load the fixtures.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_060_retire_angular_and_hud_test_packs_to_test_fixtures.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_060_retire_angular_and_hud_test_packs_to_test_fixtures.md` after implementation.

# Validation
- command: `python3 -m unittest discover tests/py` (39 pass, incl. new test_pack_fixtures.py), `tests/run.sh` (72 pass) | result: passed | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed 725511a on shell branch night/roadmap-next: packs/angular and packs/hud moved to tests/fixtures/packs/; bundled packs/ now lists only grimdark (PackRegistry scans packs/, so the picker follows); test_pack_fixtures.py asserts bundled vs fixture lists, that every pack manifest and tokens.json load, and that the HUD configSchema hooks (glow, texture, brackets, window corner radius) stay. Docs note in THEME_PACK.md. Not branch-merged to main.
- Finished on 2026-10-21.
- Linked backlog item(s): `item_117_retire_angular_and_hud_test_packs_to_test_fixtures`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
