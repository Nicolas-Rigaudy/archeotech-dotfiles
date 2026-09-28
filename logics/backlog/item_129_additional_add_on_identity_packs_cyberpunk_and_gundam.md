## item_129_additional_add_on_identity_packs_cyberpunk_and_gundam - Additional add-on identity packs: cyberpunk and gundam
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Additional add-on identity packs: cyberpunk and gundam. Owner direction: real identity packs (Grimdark/Warhammer, cyberpunk, gundam, ...) ship as add-ons through community pack support, not as built-ins.
- Keywords: additional, add, identity, packs, cyberpunk, gundam
- Use when: Implementing or reviewing the 1.1 Identity packs milestone work on identity packs.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Owner direction: real identity packs (Grimdark/Warhammer, cyberpunk, gundam, ...) ship as add-ons through community pack support, not as built-ins.

# Scope
- In:
  - Cyberpunk and gundam packs built purely on surface recipes, style delegates and pack tokens, installed via the pack install mechanism
- Out:
  - Built-in packs other than Base

# Acceptance criteria
- AC1: Each pack installs from its own repo URL and switches live with no core changes.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC1: Each pack installs from its own repo URL and switches live with no core changes.

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
- Rationale: post-1.0, after community pack support ships (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
