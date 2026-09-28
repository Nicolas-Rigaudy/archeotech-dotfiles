# Resume here (last updated 2026-09-28)

Short state of play for a fresh session. Details live in logics; this file only
says where to look and what is next. Update it at the end of each session (`/wrap`).

## Where things stand
- **Audit (2026-09-28):** five reports + contact sheets in `.claude/audits/2026-09-28/`;
  audit page https://claude.ai/artifact/DYRRZnpcg856cU9LX2iBup. Decisions recorded in
  `logics/architecture/adr_032_*` (Corvus Dataslate base identity; identity packs are
  add-ons; Angular/HUD retired to test fixtures; Contexts is the 1.0 headline).
- **Program:** `req_005_2026_09_28_audit_upgrade_program`, orchestrated by
  `task_031_…`, sequenced in `logics/roadmap/road_001_archeotech_shell.md`
  (0.30 Safety net → 0.31 Correctness → 0.40 Design v2 → 0.50 Utility → 0.60 Contexts
  → 1.0). Personal items: `road_002`.
- **0.30 Safety net:** item_101 (isolated shot.sh), item_102 (guard hooks, Qt6 lint,
  skills, reviewer agents), item_104 (docs hygiene, GPL-3.0) done. **item_103 In
  progress:** `scripts/archeotech-live.sh` is built and tested; waiting for the owner
  to run `scripts/archeotech-live.sh init` + SUPER+SHIFT+R. Until then the live bar
  follows the dev checkout, so anything landed on `main` hot-reloads onto it.
- **0.31 Correctness:** item_106 (widgets loaded twice), item_107 (fake toggles,
  notification settings, Config.ready race), item_105 (CommandRunner queue, theme
  boot gating) done and landed (shell `1c22858`, `45a3cc7`, `b35817f`).

## Next
1. item_108 toast/OSD/network hardening (per-toast timers — the Repeater over a
   reassigned JS array recreates every toast; toasts/OSD on the focused output;
   nmcli monitor backoff; Wi-Fi password off argv, Network.qml:182).
2. item_109 visual defects from the audit renders (edit-mode pill over clock, panel
   stacking/bleed-through, launcher dead space, media idle state, carousel spill).
3. item_068 golden matrix + CI (start from `.claude/audits/2026-09-28/render-matrix.sh`
   and the shot.sh flags; add image diff + contrast checks).
4. item_049 dashboard data reliability.
Then 0.40 Design system v2 (items 110-117, …).

## How to work
- One item at a time with the `/shell-item` skill (worktree → A/B proof vs unfixed
  main → qml-reviewer → land on main by path → logics closeout). Renders with `/shot`;
  independent visual verdicts with the `visual-verifier` agent.
- Open owner decisions / pending: item_103 activation (above); 27 open post-1.0 items
  still name the Obsolete task_001 as primary task (offer: a holding task + `flow
  repair links`); `~/.claude/RTK.md` describes an rtk hook that is not active.
- Owner WIP in archeotech-shell (do not touch or commit): `Commons/Primitives/SegmentedControl.qml`,
  `Modules/Shell/Builder/EditOverlay.qml`, staged deletion of `Modules/Shell/Builder/WidgetPalette.qml`.
- Nothing is pushed (both repos). Pushing is the owner's step.
