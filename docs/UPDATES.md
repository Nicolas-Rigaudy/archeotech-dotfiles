# Automatic updates: policy, jobs and rollback

How this laptop stays up to date (req_013). The decision and its reasons are in
`logics/architecture/adr_036_two_tier_machine_updates_unattended_user_tools_owner_run_arch_update.md`.

## Policy

| Tier | What | Who applies it | When |
| --- | --- | --- | --- |
| User tools | Claude Code, npm globals (logics-manager, Codex), cdx, pipx venvs, uv tools, rtk, codebase-memory-mcp | `update-dev-tools.timer`, unattended | Daily, `Persistent=true` |
| System | pacman + AUR (paru) | The owner, by running arch-update | When the owner chooses; `arch-update.timer` only checks (login + every 6 h) |

- Nothing runs `pacman -Syu` unattended.
- Nothing reboots the machine on its own; arch-update asks after a kernel upgrade.
- Every pacman transaction gets a snap-pac pre/post snapshot; the GRUB menu lists
  them (grub-btrfs). That is the rollback path (see Rollback runbook below).
- Notifications only when something needs the owner: system updates available
  (arch-update, with a run action) or a tool update failed (`tool-failed`, critical,
  at most once a day). A clean day is silent.
- No fallback kernel is installed (`linux` only). Adding `linux-lts` is an open
  owner decision: see Missing modules and a kernel that does not boot.

## Daily flow

1. Once a day the user-tool job runs on its own. Nothing to do unless a red
   "Updates" notice says a tool failed: read `journalctl --user -u update-dev-tools`,
   fix or roll back that tool (see update-dev-tools.sh below), then
   `systemctl --user start update-dev-tools`.
2. arch-update checks at login and every 6 h. When updates are pending the tray
   icon in the bar changes and one notification arrives.
3. When it suits you (not right before a meeting: a kernel upgrade wants a
   reboot), click the tray icon or the notification's action, or run `arch-update`
   in kitty. Then follow "An arch-update run".

## An arch-update run

1. The pending pacman and AUR packages are listed. `arch-update -l` shows the
   same list without starting a run.
2. Arch news published since the last run are offered first. Read any that
   name a package in the list: a news item can require a manual step before
   the upgrade. Do that step, then go on. `arch-update -n 5` shows the last 5
   news at any time.
3. Confirm the upgrade. paru runs pacman (sudo password) and then the AUR
   builds. snap-pac takes a `pre` snapshot before and a `post` snapshot after
   each pacman transaction (`snapper -c root list | tail`).
4. After the upgrade it offers, one by one, each with a yes/no:
   - orphan and unused packages to remove (read the list; say no if unsure),
   - cleaning the package cache down to 2 versions (`KeepOldPackages=2`: the
     current one and one to roll back to),
   - `.pacnew` / `.pacsave` files to merge (merge the ones for files you
     changed; a tracked file in this repo goes through git as usual),
   - services that run old binaries and need a restart,
   - a reboot when the kernel was upgraded. Say yes when you can; until then
     see Missing modules.
5. The tray icon goes back to "up to date".

Config: `config/.config/arch-update/arch-update.conf` (paru, keep 2, no
flatpak); `arch-update --show-config` prints what is in use.

### arch-update state (`~/.local/state/arch-update/`)

| File | Content |
| --- | --- |
| `last_updates_check_packages` | Pending pacman updates from the last check, one per line (empty = none) |
| `last_updates_check_aur` | Pending AUR updates from the last check |
| `last_updates_check_time` | When the last check ran |
| `last_update_run` | When the last run finished (epoch seconds) |
| `last_news_check` | Title and date of the newest news already shown |
| `tray_icon` | Current tray icon name (`arch-update-blue` = up to date) |

Logs of the check: `journalctl --user -u arch-update`. Next check:
`systemctl --user list-timers arch-update.timer`.

## Rollback runbook (bad system upgrade)

Disk layout this relies on: root is subvolume `@`, mounted by path
(`subvol=/@` in fstab, `rootflags=subvol=@` on the kernel line); snapshots
live in `@snapshots` (mounted at `/.snapshots`); `/var/cache` and `/var/log`
are their own subvolumes, so the package cache and logs survive a rollback.
`/boot` is a separate ext4 partition and is **not** in any snapshot.

Because root is mounted by path, `snapper rollback` alone does nothing useful
here (it changes the btrfs default subvolume, which the `subvol=` options
override). Roll back by replacing `@` with a copy of the snapshot:

1. **Find the snapshot.** In a terminal, or from the snapshot boot below:
   `snapper -c root list | grep -E 'pre|post' | tail`. Pick the `pre` snapshot of
   the bad transaction (its description is the pacman command).
2. **If the system still boots:** see what changed first:
   `snapper -c root status <pre>..<post>`. Often downgrading the one bad package
   from the cache is enough: `sudo pacman -U /var/cache/pacman/pkg/<pkg>-<oldver>-*.pkg.tar.zst`.
   Stop here if it is.
3. **If it does not boot (or you want the whole system back):** in GRUB pick
   *Arch Linux snapshots*, then the `pre` snapshot, then `vmlinuz-linux &
   initramfs-linux.img`. The snapshot boots read-only: the desktop may not
   start; switch to a TTY (Ctrl+Alt+F3) and log in.
   The menu lists the 50 newest snapshots (grub-btrfs default; hourly timeline
   snapshots fill it in about two days). If the `pre` snapshot is no longer
   there, do step 4 from a live USB instead.
4. **Swap the root subvolume** (from the snapshot boot, or a live USB):
   ```
   sudo mount -o subvolid=5 /dev/disk/by-uuid/0c172033-161d-41b4-aad4-3a0636d3e8c7 /mnt
   sudo mv /mnt/@ /mnt/@.broken-$(date +%F)
   sudo btrfs subvolume snapshot /mnt/@snapshots/<N>/snapshot /mnt/@
   sudo umount /mnt
   ```
   The new `@` is a writable copy of snapshot N. Nothing in `@home` changes.
5. **Reboot** into the normal GRUB entry (the first one). It now boots the
   restored `@`.
6. **Match the kernel to the restored root.** `/boot` still holds the kernel
   from the bad upgrade. If that upgrade included `linux` (`uname -r` differs
   from `pacman -Q linux`; Wi-Fi or sound may be missing), reinstall the version
   the restored root expects, from the cache (no network needed), then reboot:
   ```
   pacman -Q linux
   sudo pacman -U /var/cache/pacman/pkg/linux-<that version>-x86_64.pkg.tar.zst
   ```
   This rewrites `/boot/vmlinuz-linux` and rebuilds the initramfs. Skip this
   step if `linux` was not in the bad transaction.
7. **Clean up** once the system is good for a few days:
   `sudo mount -o subvolid=5 /dev/disk/by-uuid/0c172033-161d-41b4-aad4-3a0636d3e8c7 /mnt && sudo btrfs subvolume delete /mnt/@.broken-<date>`.
   Then hold the bad package back until it is fixed upstream (`IgnorePkg` in
   `/etc/pacman.conf`, removed again after).

## Missing modules and a kernel that does not boot

**After a kernel upgrade, before the reboot**, the running kernel's modules are
gone from `/usr/lib/modules`. Anything that needs a module not yet loaded fails:
a USB stick, a new Bluetooth or audio device, a VPN (wireguard), a docker
network. That is expected, not damage. Reboot (arch-update offers it). If you
cannot reboot now, avoid plugging new hardware until you do.

**After the reboot, if the new kernel does not boot:** the snapshot entries in
GRUB do not help, because they all boot the same new kernel from `/boot`. With
no fallback kernel the fix is a live USB:

1. Boot the Arch ISO, then
   `mount -o subvol=@ /dev/disk/by-uuid/0c172033-161d-41b4-aad4-3a0636d3e8c7 /mnt`,
   `mount /dev/nvme0n1p3 /mnt/boot`, `mount /dev/nvme0n1p1 /mnt/boot/efi` (partition
   names as of 2026-11; check with `lsblk -f`), `mount -o subvol=@cache <same uuid> /mnt/var/cache`.
2. `arch-chroot /mnt`, then `pacman -U /var/cache/pacman/pkg/linux-<previous>-x86_64.pkg.tar.zst`.
3. Exit, reboot, add `IgnorePkg = linux` to `/etc/pacman.conf` until a fixed
   kernel ships.

A fallback kernel (`linux-lts`, about 45 MB on `/boot`) would replace the live
USB with a second GRUB entry. Installing it is the owner's call (req_013, ADR 036).

**Booting a snapshot after a kernel upgrade** loads the new kernel against the
snapshot's older `/usr/lib/modules`: root mounts (its drivers are in the
initramfs) but Wi-Fi, sound or graphics modules may be missing. That is enough
to do the rollback from a TTY; step 6 above fixes the mismatch.

## State directory

`~/.local/state/archeotech-updates/` (`$XDG_STATE_HOME/archeotech-updates`).
Scripts and tests can point elsewhere with `UPDATE_STATE_DIR`.

| File | Written by | Purpose |
| --- | --- | --- |
| `notified.json` | `update-notify.sh` | Last notification per kind (rate limit) |
| `versions.json` | `update-state.sh` | Installed version of every followed tool |

## update-notify.sh

```
update-notify.sh [--dry-run] <kind> <message...>
```

Sends one desktop notification (`notify-send`, app name "Updates") and records
it. A second call with the same kind on the same day sends nothing; a different
kind still sends. Kinds ending in `-failed` go out with critical urgency: the
shell draws them with a red border and keeps them until dismissed. Other kinds
are normal. `--dry-run` prints the notice and leaves the state untouched.

Kinds in use: `tool-failed` (user-tool job). Any `a-z0-9-` slug works, so later
jobs (for example the disk space alert, item_176) reuse it with their own kind.

`notified.json`:

```json
{ "tool-failed": { "date": "2026-11-16", "at": "2026-11-16T11:01:00+01:00", "message": "rtk: exit 1" } }
```

## versions.json (read surface for crow)

crow (cr-0w req_045) reads this file to know what is installed; it never needs
to run an updater. The user-tool job (item_172) writes one entry per followed
tool after each run with `update-state.sh record <tool> <version> <method> <ok|failed>`.

```json
{
  "schema": 1,
  "updated_at": "2026-11-16T11:01:00+01:00",
  "tools": {
    "cdx": {
      "version": "1.4.0",
      "method": "pipx",
      "last_update": "2026-11-12T09:30:02+01:00",
      "last_run": "2026-11-16T11:01:00+01:00",
      "last_result": "ok"
    }
  }
}
```

| Field | Meaning |
| --- | --- |
| `schema` | Format version; bumped on any breaking change |
| `updated_at` | Last write to the file |
| `tools.<name>` | One entry per followed tool, keyed by its command name |
| `version` | Installed version as the tool reports it; `null` if never read |
| `method` | How it is installed: `npm`, `pipx`, `uv`, `binary`, `native`, ... |
| `last_update` | When the installed version last changed |
| `last_run` | When the job last tried to update it |
| `last_result` | `ok` or `failed` for that last run |

A failed run that cannot read the version records `unknown`, which keeps the
last known version. Writes are atomic (temp file + rename, under a lock), so a
reader never sees a half-written file. A tool that is no longer followed is
dropped with `update-state.sh forget <tool>`.

## update-dev-tools.sh (user tools)

The daily job for everything installed outside pacman. `update-dev-tools.timer`
(daily, `Persistent=true`, up to 30 min random delay) starts
`update-dev-tools.service`, which runs `scripts/update-dev-tools.sh`.

```
update-dev-tools.sh [--dry-run] [--only tool[,tool...]] [--no-wait]
```

| Tool (versions.json key) | Method | How it updates |
| --- | --- | --- |
| `claude` | `native` | `claude update` (its own auto-updater stays on too) |
| `logics-manager`, `codex` | `npm` | `npm install -g <pkg>@<latest>` when behind; codex is installed when missing |
| `cdx` | `cdx` | `cdx update --yes` (self-update inside its pipx venv), then `cdx update all --yes` |
| every other pipx venv | `pipx` | `pipx upgrade <venv>` |
| every uv tool | `uv` | `uv tool upgrade <tool>` |
| `rtk` | `binary` | GitHub release `rtk-oss-x86_64-unknown-linux-musl.tar.gz`, sha256 checked against `checksums.txt`; the old binary is kept as `~/.local/bin/rtk.prev` |
| `codebase-memory-mcp` | `cbm` | the installed `install.sh` (checksum-verified download) into `~/.local/share/codebase-memory-mcp/v<tag>/`, then the `~/.local/bin` link moves; the newest two version dirs are kept |

Each tool runs in its own process under a 10 min timeout (`STEP_TIMEOUT`), up
to 3 attempts (`RETRIES`, `RETRY_DELAY`), so one failing or hanging tool never
blocks the others. After each tool its version and `ok`/`failed` go to
`versions.json`. If any tool failed, one `tool-failed` notice lists them all
(`rtk: exit 1; codex: timed out after 600s`) and the run exits 1, so the
service shows as failed in `systemctl --user status update-dev-tools`.

Before the first step the script waits up to 30 min for github.com,
registry.npmjs.org and pypi.org to resolve: the timer catches up right after a
resume, before Wi-Fi is back.

Logs: `journalctl --user -u update-dev-tools`. Check without changing anything:
`update-dev-tools.sh --dry-run --no-wait`. Run now:
`systemctl --user start update-dev-tools`.

Rollback: rtk `mv ~/.local/bin/rtk.prev ~/.local/bin/rtk`; codebase-memory-mcp
`ln -sfn ~/.local/share/codebase-memory-mcp/<old>/codebase-memory-mcp ~/.local/bin/`;
npm `npm install -g <pkg>@<version>`; pipx/uv reinstall with a pinned version.

Adding a tool: an npm package goes in `NPM_TOOLS`; a pipx venv or uv tool is
picked up on its own; anything else needs an `update_<method>` function, a
`version_of` case and a `run_tool` line.

## Tests

`tests/test-update-scripts.sh` runs both scripts against a temp state dir with a
stub notifier (nothing reaches the desktop). `tests/test-update-dev-tools.sh`
runs the updater with every tool, npm, pipx, uv and curl stubbed in a temp HOME.
