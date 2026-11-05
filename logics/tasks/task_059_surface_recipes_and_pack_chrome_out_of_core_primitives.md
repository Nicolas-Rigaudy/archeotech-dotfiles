## task_059_surface_recipes_and_pack_chrome_out_of_core_primitives - Surface recipes and pack chrome out of core primitives
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:36:23

# AI Context
- Summary: Pack chrome (Grimdark steel/copper/rivets) leaves core: per-role surface recipes in a pack's tokens.json `surfaces` plus pack style delegates for MetalSurface, ConsoleChrome, BarSegment and BarDivider.
- Keywords: surface, recipes, pack, chrome, out, core, primitives
- Use when: adding a pack look (e.g. Cyberdeck) or touching panel/selector/button surfaces, bar segments or frame rails.
- Skip when: the change is base-look only and needs no pack variation.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`

# Acceptance criteria
- AC1: grep finds no pack-specific colour or branch in Commons/ or Modules/.
- AC2: Grimdark renders identically to before from pack files only.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_059_surface_recipes_and_pack_chrome_out_of_core_primitives.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_059_surface_recipes_and_pack_chrome_out_of_core_primitives.md` after implementation.

# Validation
- Wave 1-2 (shell branch night/roadmap-next): tests/run.sh 72 pass, token-lint 0, qmllint unchanged. Renders (shot.sh, mocha, grimdark + base) before/after: 4 bar popups x2 packs pixel-identical; dashboard/settings/launcher/editmode/strip identical bar live data (stats, wifi scan order). Renders in cr-0w/local/state/night/shots/112-base and 112-plated.
- Wave 3 (archeotech-shell cd43af7): A/B shot.sh matrix, 14 states x {grimdark, base}, mocha, --fresh, fixture wallpaper: pixel-identical outside the clock band and live data (dashboard stats, wifi/bt scan order); grimdark editmode re-render 0 px. scripts/golden.sh 25/25 ok (settings-dark/flat flaky, 0 px on re-render). tests/run.sh 127 passed. token-lint 0. qmllint no new real warnings (singleton missing-property false positives only). grep: platedChrome gone from Commons/ and Modules/.
- command: `golden.sh 25/25; tests/run.sh 127; shot.sh A/B grimdark+base` | result: passed | date: 2026-11-05
- Finish workflow executed on 2026-11-05.
- Linked backlog/request close verification passed.

# Report
- Wave 1 (39e40fc): hover/wifi/bt/calendar popups share Commons/Primitives/PopupSurface, drawn from Appearance.popupSurface (pack `surfaces.popup` recipe in grimdark tokens.json); -190 lines of duplicated shape/branches.
- Wave 2 (f7095a4): `frameChamfer` now only cuts corner geometry (FrameBackground fillet, FrameFx bezel path); plated chrome is `Appearance.platedChrome`, declared by the pack as `surfaces.plated`. Remaining for AC1/AC2: convert the ~40 platedChrome branches (BarPanel, BarPill, SegmentedControl, MetalSurface, Tooltip, GlassButton, ColorSchemeBody, Media/Title/Clock/Workspaces widgets, Strip, FrameFx) into per-role recipes, then move ConsoleChrome/BarSegment into the pack.
- Wave 3 (cd43af7): platedChrome removed. Recipes panelSurface, selectorSurface, choiceSurface, keySurface, buttonSurface and segmentPad read the pack's tokens.json surfaces (colour strings accept +n lighter, -n darker, /a alpha). Steel/copper chrome moved to packs/grimdark/styles (MetalSurface, ConsoleChrome, BarSegment, BarDivider); core gates layout on Appearance.hasStyle(). Frame corner plates are fx.rails.cornerPlates. Docs: THEME_PACK surfaces section, STYLE_API delegate tables. Note: PackRegistry scans styles at startup, so new style files need a full reload (SUPER+SHIFT+R).
- Finished on 2026-11-05.
- Linked backlog item(s): `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC3 -> This task. Proof: pack chrome (steel, copper, rivets, segment housings) lives in packs/grimdark/styles and tokens.json surfaces; platedChrome gone from core; A/B renders pixel-identical, scripts/golden.sh 25/25 (archeotech-shell cd43af7).
- request-AC6 -> This task. Proof: item AC2, Grimdark renders from pack files only: shot.sh A/B matrix (14 states x grimdark/base) pixel-identical to the pre-change main, apart from live data.
