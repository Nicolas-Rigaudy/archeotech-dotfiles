# Automatic updates: notifier and state

The update jobs (req_013) share two scripts and one state directory. System
packages (pacman + AUR) go through arch-update, which has its own notices and
state in `~/.local/state/arch-update/`; nothing here touches them.

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
kind still sends. `--dry-run` prints the notice and leaves the state untouched.

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

## Tests

`tests/test-update-scripts.sh` runs both scripts against a temp state dir with a
stub notifier (nothing reaches the desktop).
