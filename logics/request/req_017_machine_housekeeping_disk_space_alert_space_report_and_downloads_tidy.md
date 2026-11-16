## req_017_machine_housekeeping_disk_space_alert_space_report_and_downloads_tidy - Machine housekeeping: disk space alert, space report and Downloads tidy
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Low
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: machine, housekeeping, disk, space, alert, report, downloads, tidy
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Needs
- The Arch partition fills up without warning. The owner wants a notification before it is full, not when a build or an upgrade fails.
- When space is low, the owner wants to see where it went and which cleanups are safe, without hunting through du output.
- ~/Downloads collects everything (images, PDFs, slides, archives) and is never tidied. It should sort itself on a schedule without losing anything.

# Context
- 2026-11-16 state: / and /home share the btrfs partition nvme0n1p4 (216 G, subvolumes @ @home @snapshots @cache @log) at 85 % used, 34 G free. /mnt/games is a separate 260 G btrfs partition (the old Fedora dual-boot, 42 % used).
- Known consumers: /var/cache/pacman/pkg 7.2 G, ~/.cache 8.6 G (paru builds included), ~/Downloads 3.3 G (196 files: 81 images, 35 PDFs, 25 pptx, 14 zips), snapper root config with ~85 snapshots.
- On btrfs, df under-reports what snapshots hold; the alert reads `btrfs filesystem usage` free estimate when available and falls back to df.
- Pattern: scripts in scripts/, user units in config/.config/systemd/user/, linked by install.sh; timers use Persistent=true so a run missed while asleep catches up. Notifications go through notify-send to the shell's notification server.
- Decision: reuse the item_171 notifier (rate limit per kind per day) instead of a second notification helper; it gains generic kinds (disk-warn, disk-critical). If item_171 has not landed when this starts, land it first.
- Backups deferred (owner, 2026-11-16): there is no off-laptop target yet (no external drive, NAS or cloud). A copy to another partition on the same NVMe protects against deletion or a broken filesystem, not against disk loss or theft, and /mnt/games is the only spare space. Only a snapper `root` config exists, so @home has no snapshots today. Revisit when an off-laptop target exists; a snapper config for @home is the cheap local option to weigh then.
- Resizing the partitions (shrinking /mnt/games to grow the Arch partition) is an owner decision with a live-USB step and stays out of this request.

# Acceptance criteria
- AC1: A user timer checks free space on the Arch partition and notifies once a day at a warning level (default under 15 % free) and again at a critical level (default under 8 % free); nothing is sent above the warning level.
- AC2: The alert names the top consumers, and an on-demand `disk-report` command lists them with sizes and the safe cleanup command for each, without deleting anything itself.
- AC3: A Downloads tidy job sorts files into type folders on a schedule, never deletes or overwrites a file, skips files still being downloaded or modified in the last day, and has a dry-run mode.
- AC4: Scripts and units are tracked, installed by install.sh, documented in docs/TOOLS.md, and the backup deferral is recorded with its reasons.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_007_machine_housekeeping`
- Architecture decision(s): (none yet)

# References
- Obsidian vault note 'linux automation' (owner's list of ideas: organise Downloads, scheduled jobs, rsync backups, disk usage monitoring)
- config/.config/systemd/user/battery-alert.service (tracked user unit pattern)
- config/.config/systemd/user/update-dev-tools.{service,timer} (tracked daily timer pattern, Persistent=true)
- logics/backlog/item_171_update_notifier_and_state_file_shared_by_all_update_jobs.md (rate-limited notifier to reuse)
- scripts/setup-snapper.sh (snapper root config, snap-pac, grub-btrfs)
- https://wiki.archlinux.org/title/Btrfs (df vs btrfs filesystem usage on btrfs)

# Backlog
- `item_176_disk_space_alert_on_the_arch_partition`
- `item_177_disk_report_where_the_space_went_and_what_is_safe_to_clean`
- `item_178_downloads_tidy_sort_downloads_into_type_folders_on_a_schedule`
- `item_179_housekeeping_docs_and_the_backup_deferral_note`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

