## item_174_sysup_guarded_system_upgrade_command - sysup: guarded system upgrade command
> From version: 1.0.0
> Schema version: 1.0
> Status: Obsolete
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:44:36

# AI Context
- Summary: Owner-run upgrade command: news acknowledgement, snapshot check, paru -Syu, pacnew and failed-unit report, reboot-needed notice, cache trim. No timer runs it and it never reboots.
- Keywords: sysup, guarded, system, upgrade, command
- Use when: changing the system upgrade steps or the reboot check.
- Skip when: user tools in ~/.local (item_172).

# Problem
- A system upgrade needs the same safety steps every time (news, snapshot, pacnew, reboot check) and the owner does them by memory or skips them.

# Scope
- In:
  - scripts/sysup.sh: shows unread news and refuses to continue until acknowledged; checks snap-pac is installed and snapper root config works; paru -Syu (owner enters the sudo password); after the upgrade, lists pacnew/pacsave (pacdiff -o), failed units, and AUR packages that need a rebuild.
  - Reboot check: running kernel modules dir missing or linux/systemd/glibc upgraded sets reboot-needed and calls update-notify.sh reboot. Never reboots.
  - paccache -rk2 after a successful upgrade; records last upgrade time in the state dir.
  - Records the snapper pre/post numbers for the rollback runbook.
- Out:
  - Unattended runs (no timer runs sysup).
  - Automatic pacnew merging.

# Acceptance criteria
- AC3: With an unread news item, sysup stops before paru and continues after acknowledgement.
- AC3: After an upgrade, a snapper pre/post pair exists and the summary lists pacnew files and failed units.
- AC3: A kernel upgrade ends with a reboot-needed notice and no reboot.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: With an unread news item, sysup stops before paru and continues after acknowledgement.
- request-AC4 -> This backlog slice. Proof: AC3: After an upgrade, a snapper pre/post pair exists and the summary lists pacnew files and failed units.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Obsolete 2026-11-09: the owner chose arch-update (AUR) over a custom sysup script. Its news, paru upgrade, pacnew, services and reboot steps moved to item_173.

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
