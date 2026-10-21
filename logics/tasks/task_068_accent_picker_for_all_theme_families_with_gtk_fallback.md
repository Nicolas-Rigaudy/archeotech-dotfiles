## task_068_accent_picker_for_all_theme_families_with_gtk_fallback - Accent picker for all theme families with GTK fallback
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
- Keywords: accent, picker, all, theme, families, gtk, fallback
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_091_accent_picker_for_all_theme_families_with_gtk_fallback`

# Acceptance criteria
- AC1: Accent is selectable for non-Catppuccin families across QML/terminal/rofi/mango targets.
- AC2: GTK degrades gracefully (documented fallback, no breakage) when a per-accent package is absent.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_068_accent_picker_for_all_theme_families_with_gtk_fallback.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_068_accent_picker_for_all_theme_families_with_gtk_fallback.md` after implementation.

# Validation
- command: tests/py (new test_accent_families.py: catalog offers the 14 names for 5 families and none for Monochrome, every theme.json carries every name, apply_accent drives accent name/mango/rofi/kitty for all 13 themes, leaves GTK and the VSCode accent alone off Catppuccin, ignores unknown names), tests/run.sh, qmllint-ci unchanged; Settings > Appearance render with the Dracula family (cr-0w/local/state/night/shots/091-accent) | result: passed; theme-switch.py itself was NOT run end to end (it acts on the live session), only apply_accent in a test | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed bd23c91 on shell branch night/roadmap-next. The palette names were already shared by every theme.json and apply_accent already worked for any palette, so the work was the catalogue: Dracula, Tokyo Night, Gruvbox and Nord now list the 14 accents (Monochrome stays empty: no hue by design). GTK fallback is the existing behaviour, now documented and tested: per-accent GTK/cursor/VSCode accent only on Catppuccin (when the package is installed), other families keep the variant's own. Not verified live: picking an accent on a non-Catppuccin family through the real theme-switch, and contrast of every accent on every light theme (reported, not gated).
- Finished on 2026-10-21.
- Linked backlog item(s): `item_091_accent_picker_for_all_theme_families_with_gtk_fallback`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
