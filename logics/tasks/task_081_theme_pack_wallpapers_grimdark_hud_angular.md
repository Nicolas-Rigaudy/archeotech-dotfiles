## task_081_theme_pack_wallpapers_grimdark_hud_angular - Theme pack wallpapers (grimdark, hud, angular)
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
> Indicators reviewed: 2026-11-06 16:07:43

# AI Context
- Summary: pack.json names a wallpaper folder; Wallpapers.qml offers the active pack's wallpapers in the pickers (pack first) and drops them on a pack switch. Cyberdeck ships five (42d1e08).
- Keywords: theme, pack, wallpapers, grimdark, hud, angular
- Use when: a pack ships wallpapers, or the picker catalogue changes.
- Skip when: wallpaper tied to a theme or auto-switched on theme change (follow-up item).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_151_theme_pack_wallpapers_grimdark_hud_angular`

# Acceptance criteria
- AC1: Each pack has at least two fitting wallpapers with recorded licences, offered in the picker while the pack is active.

# AC Traceability
- request-AC5 -> This task. Proof: pack.json `wallpapers` (cyberdeck ships 5, archeotech-shell 42d1e08 + 98a630a); isolated render with cyberdeck active lists 31 wallpapers, pack ones first; test_packWallpaperDir.

# Plan
- [x] ManifestLogic: `wallpapers` field + `packWallpaperDir` (relative folder inside the pack only); PackRegistry.wallpaperDirFor.
- [x] Wallpapers.qml: scan + thumbs take the active pack's folder; `pack` field; thumbs keyed `pack-<id>-<file>`; rescan on pack change with a queued pass.
- [x] cyberdeck pack.json `"wallpapers": "walls"`; docs/THEME_PACK.md; manifest test; goldens.
- [x] Use `python3 -m logics_manager flow progress task task_081_theme_pack_wallpapers_grimdark_hud_angular.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_081_theme_pack_wallpapers_grimdark_hud_angular.md` after implementation.

# Validation
- tests/run.sh: 128 passed, 0 failed (incl. test_packWallpaperDir). scripts/golden.sh --root <wt>: 27/30 pass; dashboard-cyberdeck-{netrunner,megacorp,deck} fail on main too (unmasked timestamp, pre-existing); wallpaper-flat + settings-cyberdeck-netrunner regenerated. Isolated renders: cyberdeck active = 31 wallpapers (5 pack first), base = 26; live pack switch both ways updates the picker.
- command: `tests/run.sh; scripts/golden.sh` | result: passed | date: 2026-11-06
- Finish workflow executed on 2026-11-06.
- Linked backlog/request close verification passed.

# Report
- Landed as archeotech-shell 98a630a. pack.json 'wallpapers' names a folder inside the pack (ManifestLogic.packWallpaperDir rejects absolute paths, .. and odd ids); Wallpapers.qml lists the active pack's wallpapers ahead of the user's, thumbs keyed pack-<id>-<file>, rescans on a pack switch. AC1 delivered for cyberdeck (5 wallpapers, CREDITS.md); grimdark is outdated and ships none, hud/angular are test fixtures. Follow-up item_170: wallpapers tied to themes with auto-switch.
- Finished on 2026-11-06.
- Linked backlog item(s): `item_151_theme_pack_wallpapers_grimdark_hud_angular`
- Related request(s): `req_006_wallpaper_modes`
- Follow-up fix archeotech-shell b6594f7: the picker opened on the user's marked wallpaper with the 5 pack ones off-screen, so a pack looked empty. While a pack ships wallpapers for the mode, the pickers now offer only those plus the one on screen, labelled 'For dark mode · Cyberdeck · 6'; Show all adds the user's own (Wallpapers.offered). tests/run.sh 128 passed; goldens updated: settings-cyberdeck-netrunner, wallpaper-dark, wallpaper-light.

# Links
- Request: `req_006_wallpaper_modes`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
