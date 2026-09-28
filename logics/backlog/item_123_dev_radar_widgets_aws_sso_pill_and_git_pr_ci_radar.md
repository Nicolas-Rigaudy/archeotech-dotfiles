## item_123_dev_radar_widgets_aws_sso_pill_and_git_pr_ci_radar - Dev radar widgets: AWS SSO pill and git/PR/CI radar
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Dev workflow
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Dev radar widgets: AWS SSO pill and git/PR/CI radar. No visibility of SSO token expiry, open PRs, review requests or CI status without leaving the desktop.
- Keywords: dev, radar, widgets, aws, sso, pill, git
- Use when: Implementing or reviewing the 0.60 Contexts and signature milestone work on dev workflow.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- No visibility of SSO token expiry, open PRs, review requests or CI status without leaving the desktop.

# Scope
- In:
  - AWS SSO pill with expiry countdown and re-login action
  - git/PR/CI radar via gh for pinned repos
- Out:
  - Terraform/Docker providers (post-1.0)

# Acceptance criteria
- AC1: The pill shows remaining SSO time and warns before expiry.
- AC2: The radar lists review requests and failing checks.

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC1: The pill shows remaining SSO time and warns before expiry.

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
- Rationale: high daily value for this owner (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
