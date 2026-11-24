## item_176_disk_space_alert_on_the_arch_partition - Disk space alert on the Arch partition
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
- Keywords: disk, space, alert, arch, partition
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The Arch partition is at 85 % and nothing warns the owner before it fills; a full btrfs root breaks pacman, builds and snapper.

# Scope
- In:
  - scripts/disk-alert.sh: reads free space for / (btrfs free estimate, df fallback), compares with warning and critical thresholds (defaults 15 % and 8 % free, overridable by env or a small config file).
  - Calls the item_171 notifier with kinds disk-warn / disk-critical (rate limit once a day per kind); the message gives free space and the top three consumers from disk-report.
  - config/.config/systemd/user/disk-alert.{service,timer}: every hour, Persistent=true; install.sh links and enables them.
  - Dry-run flag that prints instead of notifying.
- Out:
  - /mnt/games and other partitions.
  - Cleaning anything up.

# Acceptance criteria
- AC1: With thresholds set above the current usage (dry run), the warning fires once and a second run the same day stays silent; below the threshold nothing is sent.
- AC1: The timer is active after a fresh install.sh run.
- AC4: The unit and script are tracked and listed in docs/TOOLS.md.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: With thresholds set above the current usage (dry run), the warning fires once and a second run the same day stays silent; below the threshold nothing is sent.
- request-AC4 -> This backlog slice. Proof: AC1: The timer is active after a fresh install.sh run.

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
