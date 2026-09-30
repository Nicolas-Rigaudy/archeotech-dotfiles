# Resume here (last updated 2026-09-30)

Short state of play for a fresh session. Details live in logics; this file only
says where to look and what is next. Update it at the end of each session (`/wrap`).

## Where things stand
- **Program:** `req_005_2026_09_28_audit_upgrade_program` (orchestrator `task_031`),
  sequenced in `logics/roadmap/road_001_archeotech_shell.md`: 0.30 Safety net (done) →
  0.31 Correctness (done) → **0.40 Design v2 (current)** → 0.50 Utility → 0.60 Contexts →
  1.0. Personal items: `road_002`. 2026-09-28 audit: `.claude/audits/2026-09-28/`.
- **Live bar:** pinned to `~/Projects/archeotech-shell.live` (promoted by the owner to
  current main on 2026-09-30, audio fixes included). Landed commits reach the bar only via
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

## Next (pick one; the owner chooses)
1. **item_139** glass/opacity setting (solid / soft / glass) in Settings → Appearance.
2. **Tonal selected pills on light themes**: text on accent-coloured pills is below AA on
   gruvbox-light (3.33) and tokyo-night-day (3.11); restyle selected pills (tinted fill +
   dark text) rather than recolouring accents (reported, not gated, in contrast-check).
3. **item_110 wave 2**: type scale (display/headline tiers, weights, tracking, UI/font
   scale setting), migrate 82 literal font sizes. Then waves 3-4 (4pt spacing, elevation +
   CI grep invariant).
4. Settings items from the audit: item_135 display (arrangement + profiles), item_136
   input, item_137 clock/bar/scan roots, item_138 search + reset; item_134 leftover: remove
   the fake Audio "Remember volume" toggle.
5. item_140 per-mode wallpapers; item_141 theme library research (later, low).
6. Remaining 0.40: 112-117, 039, 130 (edit mode review), 045, 017, 091, 006/007/009.

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
- Owner WIP / theme churn, not ours: `config/.config/fish/fish_variables`,
  `config/.config/mango/config.conf`, `config/.config/fish/completions/copilot.fish`.
- (2026-09-30: both repos pushed, bar promoted with the audio fixes, `rtk init`
  leftovers removed; RTK runs from the global hook + `~/.claude/RTK.md`.)
