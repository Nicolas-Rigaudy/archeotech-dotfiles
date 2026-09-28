## item_102_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents - Claude Code project tooling: guard hooks, Qt6 lint, skills and reviewer agents
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Tooling
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Claude Code project tooling: guard hooks, Qt6 lint, skills and reviewer agents. No hooks, agents, skills or permission allowlist exist in either repo
- Keywords: claude, code, project, tooling, guard, hooks, qt6, lint, skills, reviewer, agents
- Use when: Implementing or reviewing the 0.30 Safety net milestone work on tooling.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- No hooks, agents, skills or permission allowlist exist in either repo; transcripts show 114 live grim calls and 84 live qs ipc calls between 2026-08-26 and 09-04.
- Sessions ran /usr/bin/qmllint (Qt5, silent on these files) instead of /usr/lib/qt6/bin/qmllint; the 27 singletons lack a qmldir so Qt6 lint is noisy.
- Evidence: audit-tooling.md (contains ready hook JSON, agent frontmatter and skill outlines).

# Scope
- In:
  - PreToolUse guard hook blocking pkill of qs/quickshell/mango, qs ipc without --pid, bare grim, mango outside shot.sh, git add -A, git push, logics-manager bootstrap, theme-switch without a fake home
  - PostToolUse Qt6 qmllint on .qml edits (filtered) and a qmldir for the singletons
  - Skills: /shot (safe render + matrix + contact sheet), /verify (verify-before-done checklist), /wrap (end-of-session)
  - Agents: qml-reviewer, visual-verifier; permissions allowlist/deny list
- Out:
  - CI (separate item)

# Acceptance criteria
- AC1: Each forbidden command is blocked by the hook with an explanatory message.
- AC2: A syntax error in an edited .qml file is reported by the hook from the Qt6 linter.
- AC3: /shot produces a contact sheet across dark, light and at least two packs for a named panel.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Each forbidden command is blocked by the hook with an explanatory message.

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
- Rationale: the safety rules exist only as prose and have been violated in practice (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
