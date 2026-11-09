## item_175_update_policy_adr_rollback_runbook_and_docs - Update policy ADR, rollback runbook and docs
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:34:22

# AI Context
- Summary: Writes the two-tier policy as an ADR, the rollback runbook (grub-btrfs boot entry, snapper rollback, missing-modules recovery) and the TOOLS/PACKAGES docs.
- Keywords: update, policy, adr, rollback, runbook, docs
- Use when: recovering from a bad upgrade or explaining the update policy.
- Skip when: script changes (items 171 to 174).

# Problem
- The two-tier policy and the rollback path exist only in this request; the owner needs them written where they will look during a bad upgrade.

# Scope
- In:
  - ADR in logics/architecture/: two tiers (user tools unattended, system guarded), timer cadence, no unattended reboot, no unattended -Syu.
  - Runbook in docs/: daily flow, sysup, reading pending.json, rollback from a snapper snapshot via grub-btrfs boot entry then snapper rollback, recovering from a missing-modules state.
  - docs/TOOLS.md and docs/PACKAGES.md entries; note on a fallback kernel (linux-lts) as an owner decision.
  - Point cr-0w req_045 at versions.json.
- Out:
  - Installing linux-lts (owner decision first).

# Acceptance criteria
- AC5: The ADR, the runbook and both docs exist and match the shipped scripts.
- AC5: The rollback steps were tried once on a non-destructive snapshot listing (snapper list, grub-btrfs menu entries present).

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: The ADR, the runbook and both docs exist and match the shipped scripts.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
