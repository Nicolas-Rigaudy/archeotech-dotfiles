## item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean - disk-report: where the space went and what is safe to clean
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 85%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-24 11:10:46

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: disk, report, space, went, safe, clean
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- When space runs low the owner has to guess between the pacman cache, paru builds, ~/.cache, snapshots and Downloads, and remember the safe command for each.

# Scope
- In:
  - scripts/disk-report.sh (no root needed for the base report): free space, then sizes of /var/cache/pacman/pkg, paru clone/build cache, ~/.cache, ~/Downloads, the largest dirs under $HOME (top 10, one level deep, timed out on slow dirs), snapper snapshot count.
  - Each line carries its safe cleanup command (paccache -rk2 / paccache -ruk0, paru -Sc, snapper cleanup number, clearing a named cache dir) and never runs it.
  - Machine-readable output (--json) that disk-alert uses for its top consumers.
- Out:
  - Running any cleanup.
  - Per-snapshot exclusive sizes (needs btrfs quotas; note it as an option).

# Acceptance criteria
- AC2: The report runs as the user in under 30 s, lists the known consumers with sizes, and each line has a cleanup command.
- AC2: --json output is valid and lists the same entries.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: The report runs as the user in under 30 s, lists the known consumers with sizes, and each line has a cleanup command.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)
- Request: `req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy`
- Primary task(s): `task_083_orchestrate_machine_housekeeping`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
