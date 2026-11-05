## task_080_cyberdeck_netrunner_register_matches_its_mockup - Cyberdeck Netrunner register matches its mockup
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
> Indicators reviewed: 2026-11-05 17:31:25

# AI Context
- Summary: Build the Cyberdeck Netrunner register as real chrome through adr_027 Layer C style delegates (packs/cyberdeck/styles) and new host seams (PanelChrome, LaunchTile, GaugeFace, WorkspaceCell, roles and font tokens), then match the four approved mockups side by side.
- Keywords: cyberdeck, netrunner, register, matches, mockup
- Use when: Changing Cyberdeck delegates, the 0.5.0 style seams, or comparing Netrunner renders with the renders2 mockups.
- Skip when: Megacorp or Deck register work, or base-shell changes with no pack involved.

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_166_cyberdeck_netrunner_register_matches_its_mockup`

# Acceptance criteria
- AC1: Rendered at 1920x1200 with shot.sh/desk-check (pack cyberdeck, register netrunner), the dashboard, launcher, settings and agents views match cr-0w local/state/shots/cyberdeck-pack/renders2/shell-netrunner-{dash,launch,settings,agents}.png side by side: frame, bar zones and workspaces, panel and card shapes, card titles, gauges, selectors and tabs, launcher rows, strip buttons, fonts, wallpaper and screen effects. A palette or token change alone never meets this AC.
- AC2: Each mismatch found in the side-by-side comparison is listed and either fixed or accepted by the owner; the visual-verifier element checklist passes.
- AC3: The owner approves the side-by-side sheet and then the register on the live bar (after SUPER+SHIFT+R).
- AC4: The shell layout and customisation are unchanged (bar zones, frame, strips, panels, widgets, settings); without the pack every golden is unchanged; contrast-check --strict passes; Reduce motion stills every animation and effect.

# Plan
- [ ] Wave 1: engine seams (GaugeFace, WorkspaceCell, PanelChrome, LaunchTile, clock/sectionLabel roles, mono/display font tokens, shellVersion 0.5.0) with base visuals unchanged.
- [ ] Wave 2: Netrunner delegates (frame, bar segments, workspaces, panel chrome, cards, headers, gauges, selectors, rows, strip keys, launch housings) and the netrunner wallpaper.
- [ ] Wave 3: 1920x1200 renders of dashboard, launcher, settings and agents vs the mockups; list each mismatch; fix or accept.
- [ ] Wave 4: qmllint, qml-reviewer, golden.sh, tests/run.sh, contrast-check --strict, visual-verifier; docs STYLE_API.md and THEME_PACK.md.
- [ ] Wave 5: owner review of the side-by-side sheet, then the live bar.
- [ ] Use `python3 -m logics_manager flow progress task task_080_cyberdeck_netrunner_register_matches_its_mockup.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_080_cyberdeck_netrunner_register_matches_its_mockup.md` after implementation.

# Validation
- 2026-11-05: archeotech-shell 1e0cdea. scripts/golden.sh --root <wt>: 27 ok, wallpaper-flat FAIL 75 px (fails identically on main 231dc0a, pre-existing). Cyberdeck dashboard goldens masked for battery gauge + tip (tests/golden/masks.txt), stable at 0-3 px. tests/run.sh 127 passed 0 failed. qmllint: only singleton false positives. qml-reviewer: no blockers; fixed sectionLabel fallback (follows theme textMuted slot), bullet shear, WorkspaceCell duration via api.animMs. Owner approved the review sheet (mockup vs render, 7 rows).

# Report
- Netrunner chrome landed on main. Open: owner sees it on the live bar (AC3, needs SUPER+SHIFT+R since pack.json is new). Deferred to item_167/item_168: delegates ignore register and use fixed teal fills, so Megacorp/Deck still show Netrunner chrome in their palettes. Agents badge belongs to item_158. Minor: dirty-repo bullet is peach (mockup yellow), project row text smaller than mockup.

# Links
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
