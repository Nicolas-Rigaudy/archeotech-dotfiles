# archeotech-dotfiles — project instructions

> **Repo split (2026-07-09):** the Archeotech Quickshell **shell** (bar/panels/launcher/theme system — the publishable product) lives in a separate repo, **`~/Projects/archeotech-shell`** (public, run via `qs -c archeotech`). **This** repo (`archeotech-dotfiles`) is the private personal machine config. Shell-dev sessions edit code in `archeotech-shell` but the `.claude/` knowledge base here still covers the shell.

> **Starting a session? Read `.claude/handoffs/RESUME.md` first** — current state, next items, open owner decisions. Shell items are implemented with the `/shell-item` skill; renders with `/shot`.

> **Planning lives in `logics/`** (logics-manager), not in this file — see `.claude/PLANNING.md`, `LOGICS.md`, and the root `CLAUDE.md`. The full pre-2026-08-21 knowledge base (shipped log, session-by-session changelog, detailed component tables, how-tos, locked-architecture prose) is archived verbatim in `.claude/PROJECT_HISTORY.md`.

---

## How I want you to work (conventions)

### Durable feedback — read this first (do NOT use the auto-memory system)
**Never write to Claude's file-based auto-memory** (`MEMORY.md` / the `memory/` dir under the Claude profile). The user can't see or control those. **All durable instructions, preferences, and learned gotchas go in these project MD files** (this file, `docs/`, `logics/`) where they're version-controlled and editable by the user. This overrides the default "save to memory" behavior. (Stated 2026-09-04, and before.)

Standing feedback the user has given (keep/extend here, not in memory):
- **Testing the shell = isolated, never the live session.** Use `~/Projects/archeotech-shell/scripts/shot.sh` (or the `/shot` skill) for any visual check. Since 2026-09-28 it is fully isolated: fake HOME seeded with copies of the real config, private `XDG_RUNTIME_DIR`, own D-Bus, generated `mango -c` config (the user's autostart never runs), `env -i` — so **no `HOME=` prefix is needed**, and `--root <worktree>` renders any checkout; `--theme/--pack/--flat` pick the look. (The old `HOME=/home/corvus ./scripts/shot.sh` recipe ran the user's full mango autostart inside the nested session, including a name-selected `qs ipc` that could reach the live bar — never use it.) **Never** `grim` the user's real output, **never** drive the live shell's IPC state (`qs ... ipc call ...` without `--pid` toggles their real bar), **never** `pkill`/restart their running shell, **never** boot a compositor yourself. The `.claude/hooks/guard-bash.py` PreToolUse hook enforces these. If shot.sh can't reproduce a case, ask before touching the live screen. **No debug/scratch visuals in shell files** while the live bar follows the dev checkout (a neon-green z-order marker once flashed on their real bar).
- **Live bar vs dev checkout.** `scripts/archeotech-live.sh` (dotfiles) pins the live bar to a separate worktree (`~/Projects/archeotech-shell.live`): `status`, `init` (one-time, then SUPER+SHIFT+R), `promote [ref]` (moves the bar to a commit; hot-reloads, no restart), `follow` (back to hot-reloading every save), `preview <worktree|branch>` (bar runs that worktree, uncommitted work included; the owner's way to watch in-progress work on their real setup) and `back` (end the preview, return to the pinned `.live`). init/follow/preview/back each need one SUPER+SHIFT+R. **Never run `preview`/`back`/`follow`/`promote` yourself** — they move the owner's live bar; suggest the command. `status` flags a preview whose worktree was deleted (bar BROKEN → `back`). Once pinned, edits in the dev checkout and in agent worktrees never reach the bar until promoted, and only committed code does. Check `archeotech-live.sh status` before assuming an edit is visible to the user.
- **Commit named paths only: `git commit -m "…" -- <paths>`.** The owner sometimes has work already staged in archeotech-shell (e.g. a staged file deletion); a plain `git add X && git commit` sweeps that in (happened 2026-09-28, undone with `reset --soft`). `git commit -- <paths>` commits only those paths and leaves other staged work staged (new files still need `git add <paths>` first).
- **Theme-switch churn is not committed.** `theme-switch.py` rewrites tracked configs (gtk settings.ini, kitty/current-theme.conf, rofi/colors.rasi, mango/config.conf, environment.d/cursor.conf) on every family/flavor/accent change — the working tree is routinely dirty with recolors. Never `git add -A` here; stage specific paths and leave theme recolors unstaged unless the user says the palette is the intended default.
- **Full reload vs hot-reload.** Plain `.qml`/token/gradient edits hot-reload live. Changes that don't (notably `pack.json` manifest edits — `PackRegistry` only scans at startup) need a full reload: tell the user to hit **SUPER+SHIFT+R** (`mango-reload.sh`) — don't hand them raw `pkill quickshell; qs &`.
- **logics gotchas:** `logics-manager bootstrap` **deletes the project `.claude/` dir** (back up untracked `settings*.json` first). `flow close task` **cascades** — it auto-Dones every backlog item whose tasks are all done; to retire an umbrella/orchestration task use `sync update-indicators <ref> --status Obsolete` instead. `flow repair links` and `flow repair ac-traceability` also edit docs outside the chain (a product brief's header, placeholder AC lines in closed tasks): check `git status logics` after them and restore what they touched. `flow progress task <orchestrator>` cascades its percentage onto EVERY linked backlog item (it lowered item_103 80%→65%): only use it on single-item tasks, or restore `logics/backlog` afterwards.
- **Regression gate before landing shell code:** `scripts/golden.sh --root <wt>` (25 goldens in `tests/golden`, masks for dynamic regions) + `tests/run.sh`; an intended visual change ships with `golden.sh --update --only '<scenarios>'` PNGs in the same commit. CI (`qml` job) runs qmllint + logic tests; renders stay local until a CI image has mango.
- **Research one-at-a-time repo studies inline** (Read/Grep yourself); only spawn agents for genuine parallel fan-out, not a single agent I then block on.
- **Sandbox `$HOME`** is not `/home/corvus` (see below); also `paru -S` in a background shell can't read the sudo password — have the user run installs via `!`.

### Principles
1. **Build from scratch** — reference projects for inspiration only, never wholesale.
2. **Understand everything** — every config line should be comprehensible.
3. **Reproducible** — everything in git, deployable via scripts.
4. **Incremental** — one feature at a time, tested thoroughly.
5. **Documented** — comment configs, log decisions.
6. **Work-first** — productivity > aesthetics (but both are goals).

### Design rules (the shell)
1. **One palette per theme** — token-driven, switchable family/flavor/accent.
2. **One rasi base** — all rofi menus import a shared base for colors/radius/font.
3. **Glass aesthetic** — blur + transparency, consistent.
4. **Icons everywhere** (Papirus) — no text-only menu entries.
5. **Max 2 keystrokes** to reach any setting.
6. **No fake toggles** — bind to real state (QML property writes), never fire-and-forget shell commands that desync.
7. **Nothing hardcoded** — colors in one place.

### Git commits (hard rules)
Format: `type[SCOPE]: description` — **subject line only, no body**.
- Types: `new` (additions) / `chg` (changes) / `fix` (bug fixes).
- **ALWAYS a `[SCOPE]`** by file-type/area — never a bare `fix:`/`chg:`. In use: `[QML]`, `[MD]`, `[CONF]`, `[SH]`, `[PY]`, `[ASSET]`; combine with `/` (`[SH/CONF]`, `[QML/MD]`).
- Lowercase after the colon; no trailing period. **Keep subjects short and to the point** — state the essence, don't enumerate every change; ~50–72 chars. Use `;` only to pack genuinely-related changes, not as a changelog.
- **Check `git log` first and match the existing vocabulary — do not invent scopes** (scope-by-file-type, not `[MANGOWC]`/`[DOTFILES]`).
- **Commit as the user** — you may create commits. **Never** add `Co-Authored-By: Claude` or any trailer/line that marks Claude as an author or contributor.
- **Never `git push`** — leave pushing to the user.

```
chg[QML]: dashboard cards 16px uniform padding; wider row highlight
fix[SH]: port mango-reload.sh to mangowm 0.15 mmsg IPC
chg[SH/CONF]: launch + IPC via qs -c archeotech (shell moved to its own repo)
```

### Working on the system
- Backup before major config changes (`.bak`); test incrementally; check syntax (`bash -n`, shellcheck in CI; QML with the **Qt6** linter `/usr/lib/qt6/bin/qmllint` — `/usr/bin/qmllint` is the Qt5 one and checks nothing here; the hooks run it automatically); scripts `chmod +x` (755).
- Reload after changes is the **user's** step: SUPER+SHIFT+R (`mango-reload.sh`). Do not `pkill`/restart the user's running shell yourself to "test" — verify in isolation via `shot.sh` (see Durable feedback above).
- **Catppuccin:** always fetch official themes from github.com/catppuccin — never hand-roll color schemes.
- **`$HOME` gotcha:** in this sandboxed CC env `$HOME` is **not** `/home/corvus` — run HOME-sensitive read-only tools with `HOME=/home/corvus`. **Never run `theme-switch` yourself**: whatever `$HOME` is, it signals every live kitty (`pkill -USR1 -x kitty`) and, with the real HOME, rewrites tracked configs and reloads the live compositor/shell. Theme changes are the user's action; renders use `shot.sh --theme/--pack` (theme-switch is stubbed there). The guard hook blocks executing it.
- **Never wrap interactive QML content in a `layer.enabled` item** (it swallows hover hit-testing) — use `preferredRendererType: Shape.CurveRenderer` for AA. [DECISIONS 2026-07-02]
- Before solving QML/compositor problems, check reference sources (source-inspected 2026-05-04): MangoWC IPC = `mmsg -w` (**not** `Quickshell.DWL` — that's a custom fork); MPRIS = `Quickshell.Services.Mpris`; Notifications = `Quickshell.Services.Notifications.NotificationServer`; Lock = `WlSessionLock`+`PamContext`. Full per-project findings in `.claude/ANALYSIS.md §2`.
- When `rtk` is available, prefer it for noisy commands (raw command or `rtk proxy` when exact output matters).

### End-of-session checklist
After significant work, before committing:
1. Update the relevant **logics** docs in the wave via `logics-manager` (status/progress/closeout) — **never hand-edit indicators/lineage/done status**; see `LOGICS.md`.
2. `docs/PACKAGES.md` (new packages), `docs/KEYBINDS-MANGO.md` / `docs/KEYBINDS.md` (keybinds), `docs/TOOLS.md` (tool configs), `docs/MANGOWC-SETUP.md` (setup changes).
3. Log technical choices as ADRs in `logics/architecture/`; add issues + fixes to `.claude/TROUBLESHOOTING.md`.
4. Commit with a message in the format above (as the user, no Claude attribution). **Do not push** — leave that to the user.

---

## Current facts

### Machine
- HP EliteBook 860 G10 — i7-1355U, 32GB, Intel Iris Xe, 512GB NVMe, 1920×1200 16". AZERTY built-in keyboard; QWERTY external at work (Alt+Shift switch, layout-aware binds).
- **Arch Linux only** — btrfs (`@ @home @snapshots @cache @log`), snapper + snap-pac + grub-btrfs, GRUB, paru, systemd, SDDM.
- Displays: **work** = eDP-1 + HDMI-A-1 + DP-3 (portrait); **home** = laptop / 27" 2K / ultrawide / TV. MangoWC monitor rules with `HDMI.*` / `DP-.*` wildcards for unknown displays.

### Stack
- Compositor: **MangoWC** primary (scrolling layouts), **Hyprland** fallback (selectable at SDDM).
- Shell: **Quickshell** (QML), `qs -c archeotech` — `Commons/ + Services/<Domain>/ + Modules/ + Widgets/` layout. (Code in the `archeotech-shell` repo.)
- kitty + fish + starship; zen-browser; VSCode; rofi-wayland; PipeWire; blueman; awww wallpapers + `wallpaper-set.sh` (Arch/Rebel/Imperial logo overlay).
- Theme: token-driven **family → flavor → accent** (default Catppuccin Macchiato + mauve), applied by `scripts/theme-switch.py` across ~11 targets. Spec: `docs/THEME_SPEC.md`.

### User
- Backend developer + Cloud architect (Python, Terraform, AWS). Multi-monitor, frequent project/context switching, dock/undock work↔home.

### Repo layout & GNU Stow (important)
- All config lives **only** in `config/.config/`; GNU Stow symlinks `~/.config/*` → the repo, so editing `~/.config/...` edits the repo file directly (git tracks it).
- Scripts in `scripts/`, symlinked to `~/.local/bin/` by `install.sh`.
- Add a config dir: create under `config/.config/`, add it to the `install.sh` CONFIGS array, then `stow -R config`.
- Shell QML now lives in the separate `archeotech-shell` repo (no longer under `config/.config/quickshell/`).

---

## Pointers
- **Planning / workflow:** `logics/` corpus — start with `.claude/PLANNING.md`, `LOGICS.md`, `logics-manager status`.
- **Architecture decisions:** `logics/architecture/` (ADRs) + archived `logics/external/DECISIONS.archived.md`.
- **Roadmap / milestones:** `logics/roadmap/road_001_archeotech_shell.md` + archived `logics/external/ROADMAP.archived.md`.
- **Research / confirmed APIs:** `.claude/ANALYSIS.md` (+ `TESTING-PIPELINE-RESEARCH.md`, `TILING-PICKER-RESEARCH.md`, `CAELESTIA_BLOB_RESEARCH.md`).
- **Aesthetic direction:** `.claude/STYLE_GUIDE.md` (Corvus persona).
- **Known issues:** `.claude/TROUBLESHOOTING.md`.
- **Human docs:** `docs/` — INSTALLATION, KEYBINDS(-MANGO), PACKAGES, TOOLS, MANGOWC-SETUP.
- **Full pre-restructure knowledge base + session changelog + detailed shell-architecture prose:** `.claude/PROJECT_HISTORY.md`.
- **Session handoffs (internal, moved out of the public shell repo 2026-09-28):** `.claude/handoffs/` (FLAGSHIP_HANDOFF.md, FRAME_CORNER_HANDOFF.md — Grimdark pack history; paths there still say `packs/shadow-spears`, now `packs/grimdark`).
- **2026-09-28 audit (reports, contact sheets, render matrix):** `.claude/audits/2026-09-28/`; resulting program is `req_005` / `task_031`.

### Locked shell-architecture constraints (don't deviate without re-reading `ANALYSIS.md §15` + the ADRs)
- One full-screen PanelWindow per monitor; a single `FrameBackground` (glass + corners) + transparent bar/strip + panels as sibling Items in one coord space; 4× thin PanelWindows reserve `exclusiveZone = sideSize + outerGap`.
- Input passthrough = `QsWindow.mask` + `Intersection.Xor`. Per-screen state = `stateMap` keyed by `screen.name`.
- Widget mounting = **filename convention** (`Widgets/Bar/<Id>Widget.qml`); stable `ListModel` per zone survives `shell-config.json` hot-reload; widget contract in `docs/WIDGET_API.md`.
- Config = `shell-config.json`, per-side `{ type, zones, size, outerGap, corners }` (hot-reload); per-instance `{id, config}` via `configSchema` → `ConfigForm`.
- MangoWC: `scroller_structs=0` + `gappoh/gappov=0` (ShellExclusions owns the side gap). Quickshell **0.3.1** — use `Quickshell.execDetached()` for launches; native `Pipewire` adopted (audio service); `Networking/Bluetooth/UPower/Pam/Greetd/Polkit/IdleMonitor` available but not yet adopted (item_121). Module Builder = **click-to-assign** (Wayland cross-window drag is unreliable).
