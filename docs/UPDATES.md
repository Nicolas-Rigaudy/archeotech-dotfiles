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
