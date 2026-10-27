## task_059_surface_recipes_and_pack_chrome_out_of_core_primitives - Surface recipes and pack chrome out of core primitives
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: surface, recipes, pack, chrome, out, core, primitives
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`

# Acceptance criteria
- AC1: grep finds no pack-specific colour or branch in Commons/ or Modules/.
- AC2: Grimdark renders identically to before from pack files only.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_059_surface_recipes_and_pack_chrome_out_of_core_primitives.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_059_surface_recipes_and_pack_chrome_out_of_core_primitives.md` after implementation.

# Validation
- Wave 1-2 (shell branch night/roadmap-next): tests/run.sh 72 pass, token-lint 0, qmllint unchanged. Renders (shot.sh, mocha, grimdark + base) before/after: 4 bar popups x2 packs pixel-identical; dashboard/settings/launcher/editmode/strip identical bar live data (stats, wifi scan order). Renders in cr-0w/local/state/night/shots/112-base and 112-plated.

# Report
- Wave 1 (39e40fc): hover/wifi/bt/calendar popups share Commons/Primitives/PopupSurface, drawn from Appearance.popupSurface (pack `surfaces.popup` recipe in grimdark tokens.json); -190 lines of duplicated shape/branches.
- Wave 2 (f7095a4): `frameChamfer` now only cuts corner geometry (FrameBackground fillet, FrameFx bezel path); plated chrome is `Appearance.platedChrome`, declared by the pack as `surfaces.plated`. Remaining for AC1/AC2: convert the ~40 platedChrome branches (BarPanel, BarPill, SegmentedControl, MetalSurface, Tooltip, GlassButton, ColorSchemeBody, Media/Title/Clock/Workspaces widgets, Strip, FrameFx) into per-role recipes, then move ConsoleChrome/BarSegment into the pack.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
