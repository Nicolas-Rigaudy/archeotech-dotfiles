## task_048_designed_light_themes_with_their_own_surface_recipe - Designed light themes with their own surface recipe
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
> Indicators reviewed: 2026-09-30 11:06:17

# AI Context
- Summary: Light themes follow each designer's surface roles (panel = side-pane colour as light glass, cards = main background as lighter paper), soft shadows and light-aware grooves; official kitty themes with light readability settings; renders use the owner's real mango look.
- Keywords: designed, light, themes, own, surface, recipe
- Use when: Changing light-theme surfaces, kitty light themes or shot.sh mango config.
- Skip when: Dark-theme surfaces (unchanged) or real blur (item_116).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_111_designed_light_themes_with_their_own_surface_recipe`

# Acceptance criteria
- AC1: All light-theme goldens pass AA and cards read lighter than or equal to their panel.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_048_designed_light_themes_with_their_own_surface_recipe.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_048_designed_light_themes_with_their_own_surface_recipe.md` after implementation.

# Validation
- Research: official guides (Catppuccin style guide, tokyonight.nvim day groups, gruvbox.vim, Dracula spec.mdx) and 4 reference shells (light surfaces opaque/near-opaque, hairline outline_variant borders, black shadows, tonal selection). Renders: 5 light themes x dashboard/settings/launcher/kitty before/after; glass vs opaque x 3 wallpapers (60 renders) with the real mango config; visual-verifier PASS on shell surfaces, kitty readability fixed with dim_opacity 0.75 + text_fg_override_threshold 3 ratio (kitty 0.49.1). Gates: golden 17/17 dark/flat/grimdark unchanged, 8 light goldens regenerated (worktree golden.sh) and 25/25 ok; tests 31 pass; theme-fidelity 0 (now every colour in theme.json); contrast --strict 0 gated; qml-reviewer: no blocking, shot.sh filter hardened (more keywords, -i, comment strip, post-filter guard proven on axisbind/spawn).
- command: `golden.sh (17 dark unchanged, 8 light regenerated), tests/run.sh, theme-fidelity.py, contrast-check.py --strict, visual-verifier` | result: passed | date: 2026-09-30
- Finish workflow executed on 2026-09-30.
- Linked backlog/request close verification passed.

# Report
- Landed 1bfef30 (themes: designer surface slots, official kitty for tokyo-night-day/gruvbox-light, alucard from spec, monochrome color7/15, invented rofi/mango hexes removed, Latte roles subtext1/overlay2, tokyo contrastExempt, Dracula spec in _official, theme-switch kitty light settings, fidelity + contrast updates), 1677793 (Appearance isLight recipe, ToggleSwitch groove, 8 light goldens), 9f20bf8 (shot.sh real mango look + theme borders + wallpaper via startup). Open, not in scope: tonal selected pills / AA text-on-accent on gruvbox-light and tokyo-night-day (reported, not gated); theme-switch.py is symlinked from ~/.local/bin to main, so the next theme switch uses the new files.
- Finished on 2026-09-30.
- Linked backlog item(s): `item_111_designed_light_themes_with_their_own_surface_recipe`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner decisions 2026-09-29/30: lighter paper cards (designer main background) on the side-pane colour; follow Tokyo Night's designer (fg on bg_dark 3.99:1 exempt for panel chrome); keep glass on light themes (panels 0.92, cards 0.88, kitty 0.9) after a glass-vs-opaque comparison on three wallpapers; follow-ups item_139 (solid/soft/glass setting) and item_140 (per-mode wallpapers); item_141 theme library research later.

# AC Traceability
- request-AC3 -> This task. Proof: light goldens regenerated with paper cards lighter than the panel; contrast-check --strict passes AA on base/mantle for every light theme (1677793).
