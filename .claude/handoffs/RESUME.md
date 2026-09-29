# Resume here (last updated 2026-09-29)

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
- **0.30 Safety net:** 101, 102, 104 done. **item_103 In progress (80%)**:
  `scripts/archeotech-live.sh` now also has `preview <worktree|branch>` / `back`;
  waiting for the owner to run `init` + SUPER+SHIFT+R (AC2/AC3 are live-bar checks).
  Until then the live bar FOLLOWS the dev checkout: everything landed on shell `main`
  is already on the owner's bar.
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
2. 0.31 leftovers found on the way (not yet items): MangoService backoff never backs
   off (TROUBLESHOOTING); `Persistence.Config` has no per-key change signal (every
   `Config.get()` binding churns on any `set`); qmllint duplicate id `section` in
   EditOverlay (legal, fold into item_130).
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
- item_103: `~/Projects/archeotech-dotfiles/scripts/archeotech-live.sh init`, then
  SUPER+SHIFT+R (or keep following; `preview`/`back` are there when pinned).
- item_108 real-network check: join a password-protected Wi-Fi from the Wi-Fi panel
  once (nmcli `--ask` with the PSK on stdin was proven only against a fake nmcli).
- Push both repos (nothing pushed; ~80 commits each).
- RTK: `~/.claude/RTK.md` describes a hook not active in this profile — enable or drop
  `@RTK.md` from `~/.claude/CLAUDE.md`.
- Owner WIP: none in archeotech-shell (the builder work landed as `38b5167`).
  archeotech-dotfiles has theme churn / personal files unstaged
  (`config/.config/fish/fish_variables`, `mango/config.conf`, `fish/completions/copilot.fish`) — not ours.
