# Resume here (last updated 2026-09-29, evening)

Short state of play for a fresh session. Details live in logics; this file only
says where to look and what is next. Update it at the end of each session (`/wrap`).

## Where things stand
- **Audit (2026-09-28):** reports + contact sheets in `.claude/audits/2026-09-28/`;
  audit page https://claude.ai/artifact/DYRRZnpcg856cU9LX2iBup. Decisions in
  `logics/architecture/adr_032_*`.
- **Program:** `req_005_2026_09_28_audit_upgrade_program`, orchestrated by `task_031_…`
  (30%), sequenced in `logics/roadmap/road_001_archeotech_shell.md`
  (0.30 Safety net → 0.31 Correctness → 0.40 Design v2 → 0.50 Utility → 0.60 Contexts
  → 1.0). Personal items: `road_002`.
- **0.30 Safety net: done** (101-104). The live bar is PINNED to
  `~/Projects/archeotech-shell.live` (owner ran `init` 2026-09-29, at `cef5002`): landed
  commits reach the bar only via `archeotech-live.sh promote`; `preview <wt|branch>` /
  `back` show work in progress. Check `archeotech-live.sh status` before assuming the
  owner sees a change.
- **0.31 Correctness:** 105, 106, 107, **108** (`436dc27`: per-toast timers, per-screen
  toast windows on the focused output, nmcli backoff, Wi-Fi PSK via stdin), **109**
  (`05f202c`: launcher footer, designed media idle state), **049** (`cef5002`: System
  Notes per-stat fetch, missing sources hidden, selectable in Settings → Shell) done.
  **item_068 In progress (60%)**: `8d84bd6` delivered `scripts/golden.sh` + 25 goldens in
  `tests/golden`, `tests/run.sh` (qmltestrunner, 22 pass), `scripts/contrast-check.py`,
  and the CI `qml` job (Arch container: qmllint gate + tests + contrast). Still open:
  render smoke + golden diff + diff artifact **in CI** (needs a cached image with mango
  from AUR; owner chose "staged").
- **task_001 re-home done:** 27 post-1.0 items now hang off holding `task_039` (retire it
  with `sync update-indicators --status Obsolete` once empty, not `flow close`).
- **New:** `item_130` edit mode design review + audit (0.40; banner over the clock,
  3 selectors; owner asked for a proper review first).

## Next
1. item_068 follow-up: CI image with mango (AUR build, cached) → render smoke + golden
   diff in the `qml` job, upload `diff/` on failure. Or move on and leave it staged.
2. 0.31 leftovers: MangoService backoff (item_131, `4a4d6e0`) and Config set churn +
   external-edit reload (item_132, `bd39a70`) done. Left: qmllint duplicate id `section`
   in EditOverlay (fold into item_130); `Config.get(k, ({}))` on a missing key still
   returns a fresh default object per evaluation (small follow-up).
3. Then 0.40 Design system v2 (items 110-117, 039, 130). The contrast report is the
   baseline: 63 token pairs below floor; tokyo-night-day body 2.78:1; nord
   `overlay0 == surface0` (1.00:1).

## How to work
- One item at a time with `/shell-item` (worktree → A/B vs unfixed main → qml-reviewer →
  `golden.sh --root <wt>` + `tests/run.sh` → land by path → closeout). `/verify` has the
  full checklist; judge renders with the `visual-verifier` agent, not by eye.
- shot.sh gained `--outputs N` and `--exec 'CMD'` (`$QSPID` inside → `qs ipc --pid`);
  see the `/shot` skill. Intended visual change → `golden.sh --update --only '<names>'`
  and commit the PNGs with it.
- After `flow repair links` / `repair ac-traceability`: `git status logics` and restore
  closed docs they touched (both bit this session).

## Pending owner actions / decisions
- item_108 real-network check: join a password-protected Wi-Fi from the Wi-Fi panel
  once (nmcli `--ask` with the PSK on stdin was proven only against a fake nmcli).
- Push both repos (nothing pushed; ~80 commits each).
- RTK: fixed 2026-09-29. cdx's `--rtk on` only adds a prompt line; the rewrite hook was
  added to the `corvus` and `rose` profile `settings.json` (backups `*.bak-pre-rtk`).
  A local `rtk init` (2026-09-29 11:29) injected ~134 lines of rtk instructions into the
  root `CLAUDE.md` and created `.rtk/filters.toml` (empty template) — uncommitted,
  redundant with the global hook + `~/.claude/RTK.md`. Owner decides: keep, or
  `git checkout -- CLAUDE.md && rm -r .rtk`. Do not commit it without asking.
- Owner WIP: none in archeotech-shell (the builder work landed as `38b5167`).
  archeotech-dotfiles has theme churn / personal files unstaged
  (`config/.config/fish/fish_variables`, `mango/config.conf`, `fish/completions/copilot.fish`) — not ours.
