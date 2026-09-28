## item_104_docs_and_repo_hygiene_after_the_audit - Docs and repo hygiene after the audit
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 40%
> Complexity: Low
> Theme: Documentation
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 13:44:22

# AI Context
- Summary: Docs and repo hygiene after the audit. docs/SHELL_VISUAL_DEV.md tells sessions to grim the live screen and drive the live bar via IPC.
- Keywords: docs, repo, hygiene, after, audit
- Use when: Implementing or reviewing the 0.30 Safety net milestone work on documentation.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- docs/SHELL_VISUAL_DEV.md tells sessions to grim the live screen and drive the live bar via IPC.
- FLAGSHIP_HANDOFF.md and FRAME_CORNER_HANDOFF.md are stale internal notes in the public shell repo; three docs point at packs/shadow-spears (now packs/grimdark).
- Stale facts: .claude/claude.md says Quickshell 0.3.0 and native Pipewire not adopted (0.3.1, adopted); RTK.md promises an inactive hook; three different commit policies across docs; README license TBD.

# Scope
- In:
  - Rewrite SHELL_VISUAL_DEV.md around the isolated shot.sh
  - Move handoff docs into the dotfiles .claude/ or the owning logics items
  - Fix stale facts and unify the commit policy; choose and add a LICENSE
- Out:
  - API docs for 1.0 (item_076)

# Acceptance criteria
- AC1: No doc in either repo instructs a live grim or a live qs ipc call.
- AC2: The public shell repo contains no internal handoff docs and has a LICENSE file.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: No doc in either repo instructs a live grim or a live qs ipc call.

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
- Rationale: stale docs actively teach forbidden patterns to new sessions (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_035_docs_and_repo_hygiene_after_the_audit`
