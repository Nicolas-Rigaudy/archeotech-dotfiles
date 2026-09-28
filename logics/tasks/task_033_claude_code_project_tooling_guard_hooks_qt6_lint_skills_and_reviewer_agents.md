## task_033_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents - Claude Code project tooling: guard hooks, Qt6 lint, skills and reviewer agents
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-28 13:41:49

# AI Context
- Summary: Versioned Claude Code project tooling in the dotfiles .claude/: live-session guard hook, Qt6 QML syntax gate and lint, /shot /verify /wrap skills, qml-reviewer and visual-verifier agents, permissions allowlist.
- Keywords: claude, code, project, tooling, guard, hooks, qt6, lint, skills, reviewer, agents
- Use when: Changing how Claude sessions are guarded, linted or verified on this project.
- Skip when: Working on shot.sh itself (item_101) or the live worktree (item_103).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_102_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents`

# Acceptance criteria
- AC1: Each forbidden command is blocked by the hook with an explanatory message.
- AC2: A syntax error in an edited .qml file is reported by the hook from the Qt6 linter.
- AC3: /shot produces a contact sheet across dark, light and at least two packs for a named panel.

# Plan
- [x] 1. Guard hook with regression cases.
- [x] 2. Qt6 syntax gate (pre-save) and filtered lint (post-save).
- [x] 3. /shot, /verify, /wrap skills; qml-reviewer and visual-verifier agents.
- [x] 4. Versioned settings.json (un-ignored) with allowlist and deny list.
- [x] Run `python3 -m logics_manager flow finish task task_033_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents.md` after implementation.

# Validation
- PASSED 2026-09-28 on archeotech-dotfiles 45109bf: python3 .claude/hooks/test_guard_bash.py -> 22 forbidden live-session/git commands blocked (incl. wrapped in sh -c) and 15 legitimate ones allowed (incl. prose in quoted notes); hook proven live in-session (a grim call and a sh -c grim test string were blocked). qml-syntax-gate.py blocks an Edit that unbalances a brace in ClockWidget.qml with the exact syntax line and passes a valid edit; qml-lint.py reports one finding across 40 primitives. shot.sh flags produced a 4-tile launcher contact sheet (macchiato/latte x base/grimdark). jq validation of settings.json hooks OK.
- command: `python3 .claude/hooks/test_guard_bash.py; hook pipe-tests; shot.sh matrix contact sheet` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Added .claude/settings.json (now versioned; settings.local.json stays ignored), .claude/hooks/{guard-bash.py,test_guard_bash.py,qml-syntax-gate.py,qml-lint.py,stop-summary.sh}, .claude/agents/{qml-reviewer,visual-verifier}.md, .claude/skills/{shot,verify,wrap}/SKILL.md. Agents and skills load from the next session start. Commits 91218bc and 45109bf.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_102_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: guard-hook half of AC1 delivered in archeotech-dotfiles 45109bf - every forbidden live-session command is blocked (22 regression cases plus live in-session blocks), with QML syntax gating before saves reach the live bar; the render-isolation half is task_032.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof deferred to slice closeout.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
