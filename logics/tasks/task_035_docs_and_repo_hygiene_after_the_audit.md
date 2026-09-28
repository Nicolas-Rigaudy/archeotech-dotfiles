## task_035_docs_and_repo_hygiene_after_the_audit - Docs and repo hygiene after the audit
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 80%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 13:44:22

# AI Context
- Summary: Post-audit docs hygiene: SHELL_VISUAL_DEV.md rewritten around isolated shot.sh, internal handoff docs moved out of the public shell repo, stale facts fixed, LICENSE added.
- Keywords: docs, repo, hygiene, after, audit
- Use when: Checking which docs were corrected after the 2026-09-28 audit.
- Skip when: Writing the 1.0 API/INSTALL/CONTRIBUTING docs (item_076).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_104_docs_and_repo_hygiene_after_the_audit`

# Acceptance criteria
- AC1: No doc in either repo instructs a live grim or a live qs ipc call.
- AC2: The public shell repo contains no internal handoff docs and has a LICENSE file.

# Plan
- [x] 1. Rewrite docs/SHELL_VISUAL_DEV.md around the isolated shot.sh (shell fbe0c6c) and fix packs/shadow-spears paths.
- [x] 2. Move FLAGSHIP_HANDOFF.md and FRAME_CORNER_HANDOFF.md to dotfiles .claude/handoffs/ (owner's uncommitted Session 4 notes preserved).
- [x] 3. Fix stale facts in .claude/claude.md (Quickshell 0.3.1, Pipewire adopted, Qt6 qmllint, commit-by-path rule).
- [ ] 4. Add a LICENSE to archeotech-shell (owner to choose the license).
- [ ] Run `python3 -m logics_manager flow finish task task_035_docs_and_repo_hygiene_after_the_audit.md` after implementation.

# Validation
- 2026-09-28: grep of every .md in archeotech-shell and the dotfiles docs/.claude found no instruction to grim the live screen or call qs ipc against the live bar for verification (remaining hits are user-facing package lists, screenshot keybinds and the documented ipc keybinds). The public shell repo no longer contains FLAGSHIP_HANDOFF.md or FRAME_CORNER_HANDOFF.md (shell fbe0c6c; copies in dotfiles 0388150, with the owner's uncommitted Session 4 notes byte-identical). LICENSE still missing: awaiting the owner's license choice.

# Report
- Not started.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
