## task_022_flat_glass_aesthetic_settings_toggle_full_rollout - Flat <-> glass aesthetic Settings toggle full rollout
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-09-04 15:31:20

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: flat, glass, aesthetic, settings, toggle, full, rollout
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`

# Acceptance criteria
- AC5: The Settings flat/glass toggle flips every surface consistently

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_022_flat_glass_aesthetic_settings_toggle_full_rollout.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_022_flat_glass_aesthetic_settings_toggle_full_rollout.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint on all changed QML (no syntax errors); isolated-HOME shot.sh dual-mode capture of dashboard/layout/launcher confirming tiles, panels and shadows flip flat<->glass consistently with glass unchanged` | result: passed | date: 2026-09-04
- Finish workflow executed on 2026-09-04.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-04.
- Linked backlog item(s): `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: Added flat-aware surfaceRaised elevation token (af39219); routed neutral tiles/hovers (QuickLaunch/LayoutPicker/WallpaperPicker(Body)/Launcher) through it (40040af); gated toast/notif/launcher/shell shadows + flattened ThemeCarousel swatch (8ebfbe1). Discovery grep confirmed the rest already gate on depthFlat/_metal/glassBg. Verified via isolated-HOME shot.sh: layout chips + launcher panel/shadow + QuickLaunch tiles flip cleanly flat<->glass; glass unchanged; live session untouched. layer.enabled->CurveRenderer left to item_037. Source: `af39219`
- request-AC5 -> This task. Proof: Added flat-aware surfaceRaised elevation token (af39219); routed neutral tiles/hovers (QuickLaunch/LayoutPicker/WallpaperPicker(Body)/Launcher) through it (40040af); gated toast/notif/launcher/shell shadows + flattened ThemeCarousel swatch (8ebfbe1). Discovery grep confirmed the rest already gate on depthFlat/_metal/glassBg. Verified via isolated-HOME shot.sh: layout chips + launcher panel/shadow + QuickLaunch tiles flip cleanly flat<->glass; glass unchanged; live session untouched. layer.enabled->CurveRenderer left to item_037. Source: `af39219`
