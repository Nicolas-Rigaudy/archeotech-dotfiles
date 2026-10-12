# Resume here (last updated 2026-10-12, end of session)

Short state of play for a fresh session. Details live in logics; this file only
says where to look and what is next. Update it at the end of each session (`/wrap`).

## Where things stand
- **Program:** `req_005_2026_09_28_audit_upgrade_program` (orchestrator `task_031`),
  sequenced in `logics/roadmap/road_001_archeotech_shell.md`: 0.30 Safety net (done) →
  0.31 Correctness (done) → **0.40 Design v2 (current)** → 0.50 Utility → 0.60 Contexts →
  1.0. Personal items: `road_002`. 2026-09-28 audit: `.claude/audits/2026-09-28/`.
- **Live bar (2026-10-12):** FOLLOWING the dev checkout (`archeotech-live.sh status`):
  every commit/save on archeotech-shell main hot-reloads onto the owner's bar, so only
  land verified work on main. (The `.live` worktree still exists for `back`/`promote`;
  the owner switches modes, never us.) When pinned, landed commits reach the bar only via
  `archeotech-live.sh promote` (owner runs it). `promote` only hot-reloads QML: process
  state (PipeWire nodes) needs SUPER+SHIFT+R. `theme-switch.py` in `~/.local/bin` points
  at the shell repo's MAIN checkout, so theme/kitty file changes apply on the next
  theme switch even while the bar is pinned.
- **Done 2026-09-29/30 (all on archeotech-shell main, by path):**
  - 0.31 leftovers: mango watch backoff (`4a4d6e0`, item_131); Config set churn +
    external-edit reload (`bd39a70`, item_132); slider live labels + snapping
    (`62c4edd`, item_133); fake Appearance scale sliders removed (`3376354`).
  - item_068 closed: goldens stay local by owner decision (mango needs a GPU/DRM device;
    hosted CI runners have none). CI runs qmllint, logic tests, theme fidelity and strict
    role contrast.
  - **item_110 wave 1** (`5e38db3`, `de16daf`; adr_033): official palettes only
    (`themes/_official/*.json` + `scripts/theme-fidelity.py`, which checks every colour in
    theme.json), per-theme text roles (`Appearance.colors.textPrimary/...`) gated by
    `scripts/contrast-check.py --strict`, 253 call sites migrated, nord-light removed.
  - **item_111 light themes** (`1bfef30`, `1677793`, `9f20bf8`): designer surface roles,
    paper cards on light glass (`Appearance.isLight`), official kitty light themes +
    light readability settings, shot.sh renders with the owner's real mango look.
  - Audio: Bluetooth volume freeze fixed (`31e9e7e`, separate PipeWire trackers) and OSD
    binding loop (`7541d31`); owner confirmed on hardware after a reconnect.
  - Settings audit vs DMS / caelestia / end-4 / noctalia: item_134 (open fixes noted).

- **Landed 2026-09-30 (main):**
  - item_139 / task_049 DONE (owner-confirmed 2026-10-01): Settings → Appearance → Style
    → Opacity **Solid / Glass** (`f8384d9`, `3a1f875`). One table
    `themes/glass-presets.json` feeds Appearance, kitty (`theme-switch --glass`, live via
    kitty socket-only remote control) and mango window opacity, plus
    `contrast-check --glass` in CI. kitty is exempt from mango opacity (windowrule
    `appid:kitty`; mango fixes per-window opacity at map time, see TROUBLESHOOTING).
    Light Glass panels are 0.96 (was 0.92) to keep gruvbox-light text AA.
  - item_142 tonal pills: built, then REVERTED on owner preference (`c380d33`); solid
    accent pills stay, sub-AA pill text on gruvbox-light/tokyo-night-day accepted.
    Chain retired Obsolete; do not re-propose. Follow-up: Verified badge contrast.

## Next (pick one; the owner chooses)
1. Settings items from the audit (below). item_110 is DONE (2026-10-01; waves 2-4:
   `668d60e` type scale + Text size, `3517847` 4pt spacing grid, `fd13057` elevation e1-e5 +
   opacity tiers + hex invariant). `scripts/token-lint.py` (CI) now rejects raw font sizes,
   weights, tracking, off-grid spacing and hex colours outside Commons.
   item_136 input DONE 2026-10-12 (per-keyboard layouts, repeat, touchpad; owner-confirmed). Follow-up: when mango > 0.17.5 ships (upstream reapply_keyboard re-applies device rules on reload), remove the 'replug / next login' status in InputPane._status().
   item_145 + item_144 DONE 2026-10-12 (owner approved, copy confirmed; adr_034): one core Keyboard panel (shell cfdf2b0 → 2af2dcf header → d4ebbc6 modifier keys; id `keybinds`, `Modules/Shell/Panels/Content/KeybindsPanel.qml` + `Keyboard/`): Super+K = Shortcuts tab (mango binds, keys labelled for the picked keyboard), Super+Shift+K = Characters tab (AltGr/dead-key combos, one line per é | É), keyboard dropdown on the diagram, which lights the hovered combo incl. modifiers; data `scripts/keymap-data.py` (xkbcli + Compose). Generic: `ipc call panel toggle <id>`, plugin manifest `panel.side`, `shot.sh --state panel:<id>`. Owner UI rules for panels now in `.claude/claude.md`.
   item_135 display DONE 2026-10-07 (layout editor, confirm dialog, live night light, per-monitor
   profiles auto-applied on dock/undock; owner-confirmed). Other Settings items: item_136
   input, item_137 clock/bar/scan roots, item_138 search + reset; item_134 leftover: remove
   the fake Audio "Remember volume" toggle.
2. item_140 per-mode wallpapers; item_141 theme library research (later, low); item_143 Zen theming retry (low; the userChrome applier and the fake Restart Zen toggle were removed 2026-10-01).
3. Remaining 0.40: 112-117, 039, 130 (edit mode review), 045, 017, 091, 006/007/009.

## How to work
- One item at a time with `/shell-item`; `/verify` for the checklist; `visual-verifier`
  judges renders. Regenerate goldens with the WORKTREE's `scripts/golden.sh --update`
  (the script writes into its own checkout).
- Renders: `scripts/shot.sh --theme <t> --wallpaper <path>`. Light themes look very
  different on light vs dark wallpapers; test both. Candidate light wallpapers used in the
  item_111 review came from github.com/iQuickDev/catppuccin-wallpapers (not in the catalogue).
- Owner reviews: end the reply with a "Your input needed" block (what, why, how, then
  what); one combined image; offer to open it in imv (see `.claude/claude.md`).
- RTK rewrites `git diff`, `head`, `curl`, `docker ps`: use `rtk proxy <cmd>` when exact
  output matters (e.g. `rtk proxy git diff --binary ... | git apply`).
- After `flow repair ac-traceability`: `git status logics` and restore closed tasks it touched.

## Pending owner actions / decisions
- item_108 real-network check: join a password-protected Wi-Fi once from the panel.
- Owner WIP / theme churn, not ours (leave unstaged): `config/.config/fish/fish_variables`,
  `config/.config/kitty/current-theme.conf`, `config/.config/fish/completions/copilot.fish`,
  and 3 recolour lines in `config/.config/mango/config.conf` (jump_label / group_bar colours):
  commit our own hunks in that file via `git update-index --cacheinfo` + a plain
  `git commit` (NOT `git commit -- <path>`, which commits the working tree).
- Unpushed (owner pushes): archeotech-shell and archeotech-dotfiles main are ahead of
  origin (2026-10-12 session).
- (2026-09-30: both repos pushed, bar promoted with the audio fixes, `rtk init`
  leftovers removed; RTK runs from the global hook + `~/.claude/RTK.md`.)
