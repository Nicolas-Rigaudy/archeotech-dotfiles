## task_064_async_fade_in_on_wallpaper_thumbnails - Async fade-in on wallpaper thumbnails
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: async, fade, wallpaper, thumbnails
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_007_async_fade_in_on_wallpaper_thumbnails`

# Acceptance criteria
- AC5: Thumbnails fade in smoothly instead of popping

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_064_async_fade_in_on_wallpaper_thumbnails.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_064_async_fade_in_on_wallpaper_thumbnails.md` after implementation.

# Validation
- command: tests/run.sh (77 pass), qmllint-ci unchanged, headless render of the wallpaper picker (cr-0w/local/state/night/shots/007-thumbs) | result: passed (the fade itself is motion and was not watched live: owner to eyeball) | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed 44dc4d2 on shell branch night/roadmap-next: the wallpaper picker carousel and the per-mode wallpaper slots fade their thumbnail in over Appearance.anim.base through Commons.Tween when it first loads. The flag is sticky, so the thumbnail-to-full-image swap does not fade twice. Honours animation scale and reduced motion.
- Finished on 2026-10-21.
- Linked backlog item(s): `item_007_async_fade_in_on_wallpaper_thumbnails`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
