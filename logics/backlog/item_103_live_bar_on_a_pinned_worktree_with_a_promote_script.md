## item_103_live_bar_on_a_pinned_worktree_with_a_promote_script - Live bar on a pinned worktree with a promote script
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 60%
> Complexity: Low
> Theme: Tooling
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Live bar on a pinned worktree with a promote script. ~/.config/quickshell/archeotech symlinks to the dev checkout, so every save hot-reloads onto the live bar
- Keywords: live, bar, pinned, worktree, promote, script
- Use when: Implementing or reviewing the 0.30 Safety net milestone work on tooling.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- ~/.config/quickshell/archeotech symlinks to the dev checkout, so every save hot-reloads onto the live bar; worktrees and parallel agents cannot be used safely.

# Scope
- In:
  - A .live worktree the symlink points to, plus a promote script (fast-forward .live to a chosen commit) and a follow mode for when the owner wants hot-reload
  - Document the flow in docs and .claude/claude.md
- Out:
  - Changing the shell's config path resolution

# Acceptance criteria
- AC1: Editing a file in the main checkout does not change the running bar until promote is run.
- AC2: promote followed by SUPER+SHIFT+R shows the new commit.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Editing a file in the main checkout does not change the running bar until promote is run.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-09-28: mechanism delivered and verified in isolation (task_034); item stays In progress until the owner runs archeotech-live.sh init + SUPER+SHIFT+R on the real bar (AC2). After that, the Commons qmldir deferred from item_102 can land safely.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_034_live_bar_on_a_pinned_worktree_with_a_promote_script`

# Priority
- Priority: High
- Rationale: stops half-finished edits hot-reloading onto the owner's desktop (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_034_live_bar_on_a_pinned_worktree_with_a_promote_script`

# Notes
- Task `task_034_live_bar_on_a_pinned_worktree_with_a_promote_script` was finished via `logics-manager flow finish task` on 2026-09-28.
