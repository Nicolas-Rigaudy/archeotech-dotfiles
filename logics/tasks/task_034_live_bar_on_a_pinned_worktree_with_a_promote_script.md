## task_034_live_bar_on_a_pinned_worktree_with_a_promote_script - Live bar on a pinned worktree with a promote script
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 13:41:50

# AI Context
- Summary: scripts/archeotech-live.sh pins ~/.config/quickshell/archeotech to a detached worktree (archeotech-shell.live) so only promoted commits reach the live bar.
- Keywords: live, bar, pinned, worktree, promote, script
- Use when: Changing how the live bar tracks the shell checkout.
- Skip when: Rendering for verification (use shot.sh --root).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_103_live_bar_on_a_pinned_worktree_with_a_promote_script`

# Acceptance criteria
- AC1: Editing a file in the main checkout does not change the running bar until promote is run.
- AC2: promote followed by SUPER+SHIFT+R shows the new commit.

# Plan
- [x] 1. archeotech-live.sh status/init/promote/follow with refusal on a dirty live tree or a non-symlink target.
- [x] 2. Test end to end against a throwaway clone and fake home.
- [x] 3. Register in install.sh; document in .claude/claude.md.
- [x] Run `python3 -m logics_manager flow finish task task_034_live_bar_on_a_pinned_worktree_with_a_promote_script.md` after implementation.

# Validation
- PASSED 2026-09-28 in a throwaway clone + fake home (ARCHEOTECH_HOME/ARCHEOTECH_SHELL overrides): status reports FOLLOWING, init creates the detached worktree and relinks, a commit in the dev clone leaves the file seen through the live link unchanged (status: main 1 ahead), promote moves the live link to the new commit and the file shows the change, promote refuses when the live tree is dirty, follow relinks to dev; the real ~/.config/quickshell/archeotech link was untouched throughout. bash -n clean on archeotech-live.sh and install.sh. Commit 2541cd3.
- command: `archeotech-live.sh status/init/promote/follow in a throwaway clone with ARCHEOTECH_HOME/ARCHEOTECH_SHELL overrides` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Added scripts/archeotech-live.sh (dotfiles), registered in install.sh LOCAL_SCRIPTS, workflow documented in .claude/claude.md Durable feedback. Activation on the real machine is the owner's one-time step: scripts/archeotech-live.sh init, then SUPER+SHIFT+R. Commit 2541cd3.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_103_live_bar_on_a_pinned_worktree_with_a_promote_script`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: supports AC1 by keeping worktree edits off the live bar - verified in a throwaway clone in archeotech-dotfiles 2541cd3 (commits reach the pinned link only after promote).
