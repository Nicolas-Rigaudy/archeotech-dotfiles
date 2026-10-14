## task_057_per_mode_wallpapers_light_wallpaper_for_light_themes - Per-mode wallpapers: light wallpaper for light themes
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-14 17:20:50

# AI Context
- Summary: Optional per-mode wallpapers (wallpaper.perMode + wallpaper.light/dark): the Wallpapers service applies the slot for the theme's mode whenever Appearance.isLight flips; Settings > Appearance > Wallpaper gets a One for both | Per mode selector and Light/Dark slot cards that pick which slot the carousel sets.
- Keywords: per, mode, wallpapers, light, wallpaper, themes
- Use when: Changing wallpaper apply, the wallpaper picker, or light/dark mode switching.
- Skip when: Palette or wallpaper-derived colour work.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_140_per_mode_wallpapers_light_and_dark`

# Acceptance criteria
- AC1: Switching between a light and a dark theme also switches to that mode's wallpaper.
- AC2: With no per-mode wallpaper set, behaviour is unchanged.

# Plan
- [x] Owner decisions (2026-10-14): slot cards (Light / Dark, selected card = carousel target, current mode marked); Super+W sets the current mode's slot; also source light + dark wallpapers for the catalogue (promo use: record licenses).
- [x] Wallpapers service: currentPath + apply() (moved out of WallpaperPickerBody), per-mode follow on Appearance.isLight.
- [x] Settings > Appearance > Wallpaper: mode selector + slot cards; picker writes the target slot.
- [x] Config defaults, search index, tests; renders light/dark; goldens.
- [x] Use `python3 -m logics_manager flow progress task task_057_per_mode_wallpapers_light_wallpaper_for_light_themes.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_057_per_mode_wallpapers_light_wallpaper_for_light_themes.md` after implementation.

# Validation
- tests/run.sh 72/72; python unittest 29 OK; token-lint 0; qmllint Qt6 only singleton/delegate-id false positives; scripts/golden.sh --root <wt> 25/25 ok. shot.sh renders: latte+perMode -> light slot applied, macchiato -> dark slot, perMode off -> wallpaper untouched (AC2). In-session burst (drive.sh fills slots with catalogue paths, then flips theme.json latte->macchiato + theme reload): snowy (light slot) applied, then after the flip the starfield (dark slot) follows one frame after the palette; selected card + Now marker follow the mode. qml-reviewer: blocking items fixed (queued apply, re-read last-wallpaper after an apply and before each follow, failed path not retried, follow waits for theme.json/pack resolve).
- 4002f6d: tests/run.sh 72/72, python 29 OK, token-lint 0; brightness command run standalone in a scratch HOME (measures, caches .lum, second run reuses); burst through choose() (temporary probe, removed): latte pick camels -> applied; flip to macchiato -> kept (dark slot empty); pick dark mountain -> applied; flip to latte -> camels back. Filter renders: light 27 / dark 26 of 46. golden.sh: wallpaper-dark/light/flat changed by the new filter row (regenerated, intended), rest ok. qml-reviewer: no blocking; carousel no longer rebuilds on a pick (kept path latched on mode change).
- command: `tests/run.sh; scripts/golden.sh --root <wt>; shot.sh bursts; owner live check` | result: passed | date: 2026-10-14
- Finish workflow executed on 2026-10-14.
- Linked backlog/request close verification passed.

# Report
- archeotech-shell 521cf9d: wallpaper.perMode/light/dark; Wallpapers service owns applied path + apply queue and follows Appearance.isLight; Settings > Appearance > Wallpaper: One for both | Per mode + Light/Dark slot cards (selected card = carousel target); Super+W fills the current mode's slot. Pending: owner check on the live bar; wallpaper catalogue picks (sourcing agent running).
- Finished on 2026-10-14.
- Linked backlog item(s): `item_140_per_mode_wallpapers_light_and_dark`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- 2026-10-14: owner picked all 16 light candidates (86a2e2c) and 13 dark (f13a650: #17-23, 25-28, 30, 31) from the sourced set; wallpapers/CREDITS.md carries author/licence/source, 4 marked personal use only (unknown licence). Grimdark/hud/angular wallpapers: owner wants custom ones found later (not this item). Pending: owner check of per-mode switching on the live bar.
- 2026-10-14: owner reported switching did nothing; config.json had no wallpaper key: the One for both | Per mode switch lived only in Settings and was never turned on (Super+W has none). Owner chose: each mode remembers its own wallpaper automatically (switch removed; empty slot keeps the screen), pickers offer wallpapers by brightness (dark <0.35 dark mode, light >0.60 light mode, medium both) with a session Show all chip.
- 2026-10-14: owner confirmed on the live bar: light/dark picks are remembered per mode, switching theme swaps the wallpaper, Super+W offers wallpapers by mode.

# AC Traceability
- request-AC2 -> This task. Proof: archeotech-shell 521cf9d + 4002f6d; each mode keeps its own wallpaper and switching theme swaps it (shot.sh burst through choose(): camels in light, mountain in dark, swap back), an empty slot leaves the wallpaper unchanged; owner confirmed on the live bar 2026-10-14.
