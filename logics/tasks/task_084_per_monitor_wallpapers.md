## task_084_per_monitor_wallpapers - Per-monitor wallpapers
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-11-19 17:26:05

# AI Context
- Summary: Deliver item_148 in three waves: (1) per-output fit modes in wallpaper-set.sh with a Fit selector applied to all outputs, Fill by default; (2) per-screen images and the arrangement editor; (3) Span.
- Keywords: per, monitor, wallpapers
- Use when: Changing how wallpaper-set fits or routes images per output.
- Skip when: Per-workspace wallpapers (item_033) or wallpaper sources (item_146).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_148_per_monitor_wallpapers`

# Acceptance criteria
- AC1: Each connected output can show its own wallpaper set from the picker, and it survives a restart.
- AC2: Each output has a Fit selector (Fill, Fill + anchor, Fit + blur, Fit + edges); a landscape image on the portrait output fills it by default, and the logo overlay follows the chosen fit.
- AC3: Span shows one image across all outputs, each output showing its part of the arrangement.
- AC4: An output that is not configured shows the "all" wallpaper and fit; light/dark follow and pack wallpapers keep working in every layout mode.

# Plan
- [ ] Wave 1: wallpaper-set.sh reads `wallpaper.fit` / `wallpaper.anchor` from shell-config.json (fill | fill-anchor | blur | edges; left | centre | right), one fit function used by the plain and logo paths, logo cache keyed by fit/anchor/size; Fit selector (+ Anchor) in Settings > Appearance > Wallpaper re-applies the current wallpaper. A/B renders at 1080x1920.
- [ ] Wave 2: per-output images and slots, arrangement editor.
- [ ] Wave 3: Span.
- [ ] Use `python3 -m logics_manager flow progress task task_084_per_monitor_wallpapers.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_084_per_monitor_wallpapers.md` after implementation.

# Validation
- Wave 1 (archeotech-shell e701891): python3 -m unittest discover tests/py -> 72 OK (tests/py/test_wallpaper_fit.py: 7 tests, fake awww + temp HOME; fit crops, logo cache per fit/anchor/size, --warm-all, failure fallback to raw image). tests/run.sh -> 128 passed, 0 failed. scripts/golden.sh --root <wt>: settings-cyberdeck-netrunner changed by intent (new Fit card) and regenerated; wallpaper-dark/light/flat FLAKY (colour chip timing, 0 px on re-render); dashboard-cyberdeck-* fail on main too (pre-existing). qml-reviewer should-fixes applied.

# Report
- Wave 1 landed: wallpaper-set.sh renders each output with awww --outputs; fit modes fill (centre crop, Keep left/centre/right), blur (previous look), edges (image edge rows stretched into the bars); config keys wallpaper.fit (default fill) and wallpaper.anchor (default centre), passed by env so a click applies before the debounced config write; Settings > Appearance > Wallpaper gets a Fit selector + Keep row; logo composites cached as <hash>-<logo>-<fit>-<anchor>-<WxH>.png and built in a private scratch dir. The fit applies only when screen and image orientation differ; same-orientation screens always crop from the centre. Old *-l.png/*-p.png/plain-portrait.png caches in ~/.cache/wallpaper are orphaned. Pending: owner check on the live bar; wave 2 (per-screen images + arrangement editor) and wave 3 (Span).

# Links
- Request: `req_006_wallpaper_modes`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
