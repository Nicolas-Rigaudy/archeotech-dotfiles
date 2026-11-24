# Backups (deferred)

**Status (2026-11-24):** no backup is set up. The owner deferred it on
2026-11-16 (req_017) until there is somewhere off the laptop to put one.
This note keeps the reasoning so the question can be picked up again.

## What protects data today

- **snapper on `/` only** (`root` config): timeline snapshots plus snap-pac
  pre/post pairs around every pacman transaction. These undo a bad update
  (rollback steps in [UPDATES.md](UPDATES.md)); they are not backups. They live
  on the same disk and the same btrfs filesystem as the data.
- **`@home` has no snapper config.** A deleted or overwritten file in `$HOME`
  cannot be brought back from a snapshot.
- Code is safe where it is pushed (git remotes); everything else in `$HOME`
  (Documents, unpushed work, `~/.config` outside this repo) has one copy.

## Why not a copy on the same disk

A copy to another partition of the same NVMe (for example `/mnt/games`)
guards against an accidental `rm`, but a dead SSD, theft, loss or a
filesystem-wide failure takes both copies at once. It also eats the space
that `/` is already short of (see `disk-report.sh`).

## Options to weigh when a target exists

| Option | Covers | Cost |
|--------|--------|------|
| snapper config for `@home` (timeline, e.g. hourly 24 / daily 7) | accidental delete or edit in `$HOME`, instant restore | no hardware; uses disk space as files change. Cheapest first step, still same-disk. |
| External drive + `btrfs send/receive` of `@home` snapshots (e.g. `btrbk`) | dead disk, bad filesystem | a drive formatted btrfs; incremental, fast, needs the drive plugged in. |
| External drive or remote + `restic` (or `borg`) | dead disk, theft (if remote), encrypted | any filesystem or an S3 bucket; file-level, dedup, works off-site. |

Whatever is picked: back up `@home` (and `/etc` if not tracked here), keep at
least one copy off the laptop, and test a restore once.

## Related

- `disk-alert.sh` / `disk-report.sh`: [TOOLS.md](TOOLS.md#housekeeping-disk-alert-disk-report-downloads-tidy)
- Snapshots and rollback: [UPDATES.md](UPDATES.md)
