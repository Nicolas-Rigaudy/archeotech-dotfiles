## item_173_daily_system_update_check_with_arch_news_gate - Daily system update check with Arch news gate
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:34:22

# AI Context
- Summary: No-root daily check: checkupdates, paru -Qua and Arch news since the last upgrade, written to pending.json, with an upgrade-due notice past a 7-day threshold.
- Keywords: daily, system, update, check, arch, news, gate
- Use when: changing what counts as pending, the news gate or the nudge threshold.
- Skip when: applying updates (item_174 sysup).

# Problem
- Nothing tells the owner when system updates are pending or when Arch news needs reading before an upgrade, so the owner checks by hand.

# Scope
- In:
  - scripts/update-check.sh (no root): checkupdates and paru -Qua counts and package lists, kernel/systemd/mesa/glibc flagged as notable, Arch news RSS items newer than the last system upgrade.
  - Writes pending.json in the state dir; unread news ids kept until `sysup --ack-news`.
  - Daily user timer (Persistent=true). Notifies upgrade-due when updates are older than the threshold (default 7 days) or news is unread.
  - Evaluate `checkupdates -d` to pre-download packages without touching the sync db.
- Out:
  - Applying any update.
  - Running pacman -Sy outside sysup (partial-upgrade risk).

# Acceptance criteria
- AC2: The check runs as the user, leaves /var/lib/pacman/sync untouched, and pending.json matches checkupdates output.
- AC2: A news item newer than the last upgrade is listed as unread until acknowledged.
- AC4: No notification when nothing is pending; one upgrade-due notification once the threshold passes.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: The check runs as the user, leaves /var/lib/pacman/sync untouched, and pending.json matches checkupdates output.
- request-AC4 -> This backlog slice. Proof: AC2: A news item newer than the last upgrade is listed as unread until acknowledged.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

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
