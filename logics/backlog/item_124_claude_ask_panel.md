## item_124_claude_ask_panel - Claude Ask panel
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Dev workflow
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Claude Ask panel. No quick way to ask an AI about the current selection, git diff, last terminal error or a screenshot, or to hand off to Claude Code in the right repo.
- Keywords: claude, ask, panel
- Use when: Implementing or reviewing the 0.60 Contexts and signature milestone work on dev workflow.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- No quick way to ask an AI about the current selection, git diff, last terminal error or a screenshot, or to hand off to Claude Code in the right repo.

# Scope
- In:
  - Panel using the Claude API with attachable context sources
  - Send to Claude Code in the active context's repo
- Out:
  - Local models

# Acceptance criteria
- AC1: A question with the current selection attached returns an answer in the panel.

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC1: A question with the current selection attached returns an answer in the panel.

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
- Rationale: AI assistance with desktop context (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
