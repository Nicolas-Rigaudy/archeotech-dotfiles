## task_066_live_colour_preview_on_scroll_in_pickers - Live colour preview on scroll in pickers
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
- Keywords: live, colour, preview, scroll, pickers
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_006_live_colour_preview_on_scroll_in_pickers`

# Acceptance criteria
- AC5: Scrolling the wallpaper picker previews the extracted palette without applying

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_066_live_colour_preview_on_scroll_in_pickers.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_066_live_colour_preview_on_scroll_in_pickers.md` after implementation.

# Validation
- command: tests/py (new test_wallpaper_print_color.py: prints a hex, writes no cache, usage error, header documented), tests/run.sh 85 pass, qmllint-ci unchanged, token-lint 0; headless renders of the three UI options and the final pick | result: passed (scrolling itself was not driven live: the preview follows the carousel's currentIndex) | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed fc69883 (script), fa6a2b0 (shot.sh links the checkout's own wallpaper-set.sh so a worktree renders its script, not the installed one), f686663 (UI) on shell branch night/roadmap-next. wallpaper-set.sh --print-color <image> prints the extracted accent, applies nothing and writes no cache (extraction split from the cached wrapper). Wallpapers service: preview(path) debounced 150ms, one lookup at a time, cached per session. Picker shows a colour dot + hex in the filter row for the centred wallpaper (both the quick panel and Settings). Three options were rendered (A dot+hex, B tinted card border, C accent/soft/deep swatches; cr-0w/local/state/night/shots/006-preview/options-abc.png); A built, reason: it states the value and sits with the caption. Note: the preview is the single accent the script extracts (used for the logo overlay), not a full palette; a full palette preview needs a palette extractor that does not exist yet.
- Finished on 2026-10-21.
- Linked backlog item(s): `item_006_live_colour_preview_on_scroll_in_pickers`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
