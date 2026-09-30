## task_050_tonal_selected_pills_on_light_themes - Tonal selected pills on light themes
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 90%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-30 14:15:59

# AI Context
- Summary: Light-theme selected states with text use a tonal, accent-outlined pill with dark text (selectedFill/onSelected tokens); dark unchanged.
- Keywords: tonal, selected, pills, light, themes
- Use when: Styling a selected/active state that carries text on an accent fill.
- Skip when: Icon-only glyphs on accent, or palette/role changes (adr_033).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_142_tonal_selected_pills_light_themes`

# Acceptance criteria
- AC1: Selected pill text meets 4.5:1 on every light theme except a designer-exempt one, and dark themes render unchanged.
- AC2: The selected segment stays clearly distinguishable from the unselected ones on light themes.

# Plan
- [ ] Appearance tokens selectedTint/selectedFill/onSelected/selectedBorder(+Width).
- [ ] Migrate SegmentedControl, CalendarPopup today, PluginsPane Official badge.
- [ ] contrast-check gates selected text per theme; tokyo-night-day exempt (designer fg 4.52 on base).
- [ ] A/B renders on latte/gruvbox-light/tokyo-night-day + macchiato unchanged; goldens; qml-reviewer.
- [ ] Use `python3 -m logics_manager flow progress task task_050_tonal_selected_pills_on_light_themes.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_050_tonal_selected_pills_on_light_themes.md` after implementation.

# Validation
- archeotech-shell 0c52f94. contrast-check --strict 0 failures with the new gated selected-text column: latte 5.30, alucard 11.86, gruvbox-light 8.26 (was 3.33), monochrome-light 10.83, dark 5.6-8.7 unchanged; tokyo-night-day 3.66 exempt (contrastExempt.selectedFill, designer fg 4.52 on base). contrast-check --glass 0; theme-fidelity 0; tests/run.sh 31/31; golden.sh 25/25 after --update of settings-light, wallpaper-light, editmode-light (Done button). A/B: macchiato Appearance 42 px (clock) = unchanged; macchiato Connections diff only in the live Wi-Fi scan list. visual-verifier PASS 4/4 (sampled label contrast latte ~7:1, gruvbox-light ~10:1).

# Report
- Tokens Appearance.colors.selectedTint/selectedFill/onSelected/selectedBorder/selectedBorderWidth: light = base tinted 20% toward the accent + 1.5px accent outline + textPrimary; dark = accent + base, no change. Migrated SegmentedControl, GlassButton active (found by qml-reviewer), 8 ConnectionsPane active labels, CalendarPopup today, PluginsPane Official badge. contrast-check reads selectedTint from Appearance.qml. Deliberately left: icon-only glyphs on accent (Wi-Fi/BT popup tiles, check badges, play button, bar pills) since non-text 3:1 holds, so light themes mix tonal text pills with solid accent icon tiles. Follow-up: PluginsPane Verified badge (base on overlay0) is 1.7-3.4:1 on every theme. Pending owner: approve the look and the tokyo-night-day selectedFill exemption.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
