## task_080_cyberdeck_netrunner_register_matches_its_mockup - Cyberdeck Netrunner register matches its mockup
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
> Indicators reviewed: 2026-11-05 23:26:46

# AI Context
- Summary: Build the Cyberdeck Netrunner register as real chrome through adr_027 Layer C style delegates (packs/cyberdeck/styles) and new host seams (PanelChrome, LaunchTile, GaugeFace, WorkspaceCell, roles and font tokens), then match the four approved mockups side by side.
- Keywords: cyberdeck, netrunner, register, matches, mockup
- Use when: Changing Cyberdeck delegates, the 0.5.0 style seams, or comparing Netrunner renders with the renders2 mockups.
- Skip when: Megacorp or Deck register work, or base-shell changes with no pack involved.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_166_cyberdeck_netrunner_register_matches_its_mockup`

# Acceptance criteria
- AC1: Rendered at 1920x1200 with shot.sh/desk-check (pack cyberdeck, register netrunner), the dashboard, launcher, settings and agents views match cr-0w local/state/shots/cyberdeck-pack/renders2/shell-netrunner-{dash,launch,settings,agents}.png side by side: frame, bar zones and workspaces, panel and card shapes, card titles, gauges, selectors and tabs, launcher rows, strip buttons, fonts, wallpaper and screen effects. A palette or token change alone never meets this AC.
- AC2: Each mismatch found in the side-by-side comparison is listed and either fixed or accepted by the owner; the visual-verifier element checklist passes.
- AC3: The owner approves the side-by-side sheet and then the register on the live bar (after SUPER+SHIFT+R).
- AC4: The shell layout and customisation are unchanged (bar zones, frame, strips, panels, widgets, settings); without the pack every golden is unchanged; contrast-check --strict passes; Reduce motion stills every animation and effect.

# Plan
- [x] Wave 1: engine seams (GaugeFace, WorkspaceCell, PanelChrome, LaunchTile, clock/sectionLabel roles, mono/display font tokens, shellVersion 0.5.0) with base visuals unchanged.
- [x] Wave 2: Netrunner delegates (frame, bar segments, workspaces, panel chrome, cards, headers, gauges, selectors, rows, strip keys, launch housings) and the netrunner wallpaper.
- [x] Wave 3: 1920x1200 renders of dashboard, launcher, settings and agents vs the mockups; list each mismatch; fix or accept.
- [x] Wave 4: qmllint, qml-reviewer, golden.sh, tests/run.sh, contrast-check --strict, visual-verifier; docs STYLE_API.md and THEME_PACK.md.
- [x] Wave 5: owner review of the side-by-side sheet, then the live bar.
- [x] Use `python3 -m logics_manager flow progress task task_080_cyberdeck_netrunner_register_matches_its_mockup.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_080_cyberdeck_netrunner_register_matches_its_mockup.md` after implementation.

# Validation
- 2026-11-05: archeotech-shell 1e0cdea. scripts/golden.sh --root <wt>: 27 ok, wallpaper-flat FAIL 75 px (fails identically on main 231dc0a, pre-existing). Cyberdeck dashboard goldens masked for battery gauge + tip (tests/golden/masks.txt), stable at 0-3 px. tests/run.sh 127 passed 0 failed. qmllint: only singleton false positives. qml-reviewer: no blockers; fixed sectionLabel fallback (follows theme textMuted slot), bullet shear, WorkspaceCell duration via api.animMs. Owner approved the review sheet (mockup vs render, 7 rows).
- 2026-11-05: polish landed as archeotech-shell c240e26 (frame cut under 2*gap, strip spacing, PopupSurface seam + cyberdeck plate, settings search inset). desk-check before/after at 1920x1200; golden.sh: only dashboard-cyberdeck-* changed (regenerated), editmode-light AA flake 0 px on rerun; tests/run.sh 127 passed 0 failed; qmllint clean on changed pack files; qml-reviewer should-fixes applied.
- command: `scripts/golden.sh --root <wt>; tests/run.sh` | result: passed | date: 2026-11-05
- Finish workflow executed on 2026-11-05.
- Linked backlog/request close verification passed.

# Report
- Netrunner chrome landed on main. Open: owner sees it on the live bar (AC3, needs SUPER+SHIFT+R since pack.json is new). Deferred to item_167/item_168: delegates ignore register and use fixed teal fills, so Megacorp/Deck still show Netrunner chrome in their palettes. Agents badge belongs to item_158. Minor: dirty-repo bullet is peach (mockup yellow), project row text smaller than mockup.
- Owner approved the polish on the live bar (2026-11-05, 'all better'): AC3 met. Follow-up: strip spacing values (60/16/12) could become pack-supplied tokens.
- Finished on 2026-11-05.
- Linked backlog item(s): `item_166_cyberdeck_netrunner_register_matches_its_mockup`
- Related request(s): `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`

# AC Traceability
- request-AC1 -> This task. Proof: Netrunner register only; 1920x1200 desk-check renders of dashboard, launcher, settings and agents matched against renders2/shell-netrunner-*.png in the owner-approved review sheet (1e0cdea), polish c240e26 approved live. Megacorp and Deck stay with item_167 and item_168.
- request-AC2 -> This task. Proof: cyberdeck pack styles (FrameStyle, PanelChrome, PopupSurface, LaunchTile, GaugeFace, WorkspaceCell) and the netrunner wallpaper are original work in packs/cyberdeck; no third-party asset added.

# Links
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
