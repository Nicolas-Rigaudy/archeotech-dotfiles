## task_057_per_mode_wallpapers_light_wallpaper_for_light_themes - Per-mode wallpapers: light wallpaper for light themes
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 80%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-14 16:02:43

# AI Context
- Summary: Optional per-mode wallpapers (wallpaper.perMode + wallpaper.light/dark): the Wallpapers service applies the slot for the theme's mode whenever Appearance.isLight flips; Settings > Appearance > Wallpaper gets a One for both | Per mode selector and Light/Dark slot cards that pick which slot the carousel sets.
- Keywords: per, mode, wallpapers, light, wallpaper, themes
- Use when: Changing wallpaper apply, the wallpaper picker, or light/dark mode switching.
- Skip when: Palette or wallpaper-derived colour work.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_140_per_mode_wallpapers_light_and_dark`

# Acceptance criteria
- AC1: Switching between a light and a dark theme also switches to that mode's wallpaper.
- AC2: With no per-mode wallpaper set, behaviour is unchanged.

# Plan
- [x] Owner decisions (2026-10-14): slot cards (Light / Dark, selected card = carousel target, current mode marked); Super+W sets the current mode's slot; also source light + dark wallpapers for the catalogue (promo use: record licenses).
- [ ] Wallpapers service: currentPath + apply() (moved out of WallpaperPickerBody), per-mode follow on Appearance.isLight.
- [ ] Settings > Appearance > Wallpaper: mode selector + slot cards; picker writes the target slot.
- [ ] Config defaults, search index, tests; renders light/dark; goldens.
- [ ] Use `python3 -m logics_manager flow progress task task_057_per_mode_wallpapers_light_wallpaper_for_light_themes.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_057_per_mode_wallpapers_light_wallpaper_for_light_themes.md` after implementation.

# Validation
- tests/run.sh 72/72; python unittest 29 OK; token-lint 0; qmllint Qt6 only singleton/delegate-id false positives; scripts/golden.sh --root <wt> 25/25 ok. shot.sh renders: latte+perMode -> light slot applied, macchiato -> dark slot, perMode off -> wallpaper untouched (AC2). In-session burst (drive.sh fills slots with catalogue paths, then flips theme.json latte->macchiato + theme reload): snowy (light slot) applied, then after the flip the starfield (dark slot) follows one frame after the palette; selected card + Now marker follow the mode. qml-reviewer: blocking items fixed (queued apply, re-read last-wallpaper after an apply and before each follow, failed path not retried, follow waits for theme.json/pack resolve).

# Report
- archeotech-shell 521cf9d: wallpaper.perMode/light/dark; Wallpapers service owns applied path + apply queue and follows Appearance.isLight; Settings > Appearance > Wallpaper: One for both | Per mode + Light/Dark slot cards (selected card = carousel target); Super+W fills the current mode's slot. Pending: owner check on the live bar; wallpaper catalogue picks (sourcing agent running).

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
