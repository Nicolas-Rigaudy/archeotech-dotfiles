## item_167_cyberdeck_megacorp_register_matches_its_mockup - Cyberdeck Megacorp register matches its mockup
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 80%
> Progress: 0%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: The Megacorp register of the cyberdeck pack, built until the shell matches the round 3 Megacorp mockups side by side. Reuses the delegates and seams item_166 introduces.
- Keywords: cyberdeck, megacorp, register, mockup, delegates
- Use when: Building or reviewing the Megacorp look.
- Skip when: Netrunner (item_166) or the other register.

# Problem
- See item_166: palette-only registers were rejected; each register is judged against its own mockup.

# Target
- Mockups: cr-0w local/state/shots/cyberdeck-pack/renders2/shell-megacorp-{dash,launch,settings,agents}.png; QML source cr-0w local/state/shots/cyberdeck-pack/mock/shell/ (Style.qml register megacorp). Spec: .claude/CYBERDECK_RESEARCH.md round 3.
- Frame: black band, red hairline on the top inner edge, red L ticks in the bottom corners.
- Bar: hairline boxes, numbered workspace cells, house crest.
- Panels and cards: hairline frame with a red code tab (SYS, GIT, RUN, LOG).
- Gauges: 40-cell segmented bars, red past the limit.
- Selectors: rectangular red fill. Launcher rows: numbered table rows, selection inverted white.
- Type: Barlow Condensed Bold caps tracked wide; Share Tech Mono. Palette black, warm white, blood red only.

# Scope
- In:
  - The Megacorp branch of every cyberdeck delegate, its fonts, wallpaper and effects level.
- Out:
  - Layout or behaviour changes; item_157, item_158, item_160.

# Acceptance criteria
- AC1: Rendered at 1920x1200 with shot.sh/desk-check (pack cyberdeck, register megacorp), the dashboard, launcher, settings and agents views match cr-0w local/state/shots/cyberdeck-pack/renders2/shell-megacorp-{dash,launch,settings,agents}.png side by side: frame, bar zones and workspaces, panel and card shapes, card titles, gauges, selectors and tabs, launcher rows, strip buttons, fonts, wallpaper and screen effects. A palette or token change alone never meets this AC.
- AC2: Each mismatch found in the side-by-side comparison is listed and either fixed or accepted by the owner; the visual-verifier element checklist passes.
- AC3: The owner approves the side-by-side sheet and then the register on the live bar (after SUPER+SHIFT+R).
- AC4: The shell layout and customisation are unchanged (bar zones, frame, strips, panels, widgets, settings); without the pack every golden is unchanged; contrast-check --strict passes; Reduce motion stills every animation and effect.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1 side-by-side match of the megacorp register.
- request-AC2 -> This backlog slice. Proof: AC1/AC4 fonts, ornaments and styles are original and OFL.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: After item_166 (Netrunner first, owner 2026-11-05).

# Notes
- 2026-11-05: created in the cyberdeck docs rewrite after the item_154 rejection.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
