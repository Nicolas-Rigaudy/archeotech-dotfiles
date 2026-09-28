## item_122_contexts_one_switch_for_project_cloud_and_workspace_state - Contexts: one switch for project, cloud and workspace state
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: High
> Theme: Contexts
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Contexts: one switch for project, cloud and workspace state. The owner switches between projects, AWS accounts, kube clusters, git identities and monitor setups many times a day with no single control
- Keywords: contexts, switch, project, cloud, workspace, state
- Use when: Implementing or reviewing the 0.60 Contexts and signature milestone work on contexts.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- The owner switches between projects, AWS accounts, kube clusters, git identities and monitor setups many times a day with no single control; layout loadouts (item_013) cover only a slice.
- Evidence: audit-features.md ideas section.

# Scope
- In:
  - Context definitions (project dir, AWS profile/SSO, kube context, git identity, monitor layout, accent, focus mode, workspace apps)
  - Switcher in launcher and bar, prod contexts force a red accent, apply/rollback with status
- Out:
  - Team sharing of contexts

# Acceptance criteria
- AC1: Switching context applies every configured facet and the bar shows the active context.
- AC2: A prod context changes the accent to the danger colour.

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC1: Switching context applies every configured facet and the bar shows the active context.

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
- Rationale: owner decision: the 1.0 headline feature no peer shell has (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
