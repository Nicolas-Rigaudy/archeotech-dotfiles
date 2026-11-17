## item_175_update_policy_adr_rollback_runbook_and_docs - Update policy ADR, rollback runbook and docs
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-17 10:45:54
> Owner: corvus

# AI Context
- Summary: Writes the two-tier policy as an ADR, the rollback runbook (grub-btrfs boot entry, snapper rollback, missing-modules recovery) and the TOOLS/PACKAGES docs.
- Keywords: update, policy, adr, rollback, runbook, docs
- Use when: recovering from a bad upgrade or explaining the update policy.
- Skip when: script or config changes (items 171 to 173).

# Problem
- The two-tier policy and the rollback path exist only in this request; the owner needs them written where they will look during a bad upgrade.

# Scope
- In:
  - ADR in logics/architecture/: two tiers (user tools unattended, system via arch-update run by the owner), why arch-update over a custom script, timer cadence, no unattended reboot, no unattended -Syu.
  - Runbook in docs/: daily flow, an arch-update run step by step, reading ~/.local/state/arch-update, rollback from a snapper snapshot via grub-btrfs boot entry then snapper rollback, recovering from a missing-modules state.
  - docs/TOOLS.md and docs/PACKAGES.md entries; note on a fallback kernel (linux-lts) as an owner decision.
  - Point cr-0w req_045 at versions.json.
- Out:
  - Installing linux-lts (owner decision first).

# Acceptance criteria
- AC5: The ADR, the runbook and both docs exist and match the shipped scripts and arch-update config.
- AC5: The rollback steps were tried once on a non-destructive snapshot listing (snapper list, grub-btrfs menu entries present).

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: The ADR, the runbook and both docs exist and match the shipped scripts and arch-update config.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): `adr_036_two_tier_machine_updates_unattended_user_tools_owner_run_arch_update`
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Notes
- 2026-11-17: delivered. ADR `adr_036` (two tiers, why arch-update, cadence, no unattended -Syu or reboot, linux-lts as owner decision). `docs/UPDATES.md` is now the runbook: policy table, daily flow, an arch-update run step by step, its state files, rollback, missing modules / a kernel that does not boot. `docs/TOOLS.md` gets an Updates section, `docs/PACKAGES.md` the linux-lts note and update-dev-tools.timer. cr-0w req_045 now names `~/.local/state/archeotech-updates/versions.json` as its version source. Layout facts found while writing: root is `subvol=/@` mounted by path, so `snapper rollback` alone does nothing; the runbook swaps `@` for a snapshot copy from subvolid=5. `/boot` is separate ext4 (not snapshotted), so a rollback across a kernel upgrade reinstalls the matching `linux` from the cache (2 versions kept). Snapshot entries boot read-only (systemd initramfs, no overlayfs hook). Non-destructive proof: `snapper -c root list` shows the snap-pac pre/post pairs, `snapper -c root status 2932..2933` lists the changed files, `/boot/grub/grub-btrfs.cfg` holds 50 snapshot submenus (pre 2930 and 2932 among them, each with `vmlinuz-linux & initramfs-linux.img`), `arch-update -l`, both timers listed, versions.json schema 1 with 10 tools. The subvolume swap itself was not run.
- Task `task_082_orchestrate_automatic_updates` was finished via `logics-manager flow finish task` on 2026-11-17.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Tasks
- `task_082_orchestrate_automatic_updates`
