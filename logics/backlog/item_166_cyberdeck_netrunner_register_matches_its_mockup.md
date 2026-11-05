## item_166_cyberdeck_netrunner_register_matches_its_mockup - Cyberdeck Netrunner register matches its mockup
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 80%
> Progress: 90%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 17:31:25

# AI Context
- Summary: The Netrunner register of the cyberdeck pack, built until the shell matches the round 3 Netrunner mockups side by side. One deliverable: palette, fonts, frame, bar, cards, gauges, selectors, rows, strip, wallpaper and effects together.
- Keywords: cyberdeck, netrunner, register, mockup, delegates, frame, bar, gauges, fonts, wallpaper
- Use when: Building or reviewing the Netrunner look, or any cyberdeck delegate it introduces.
- Skip when: Megacorp (item_167) or Deck (item_168) specifics; crow deck ANSI (item_157); screensaver (item_158).

# Problem
- The first cyberdeck slice (item_154) recoloured the stock shell and was rejected by the owner on 2026-11-05 as "exactly what I did not want, just a color filter". The roadmap had cut the identity into layers (palette, fonts, chrome, gauges, wallpaper) and no item said what Netrunner must look like, so the first layer could only ever be a colour filter.

# Target
- Mockups: cr-0w local/state/shots/cyberdeck-pack/renders2/shell-netrunner-{dash,launch,settings,agents}.png; QML source cr-0w local/state/shots/cyberdeck-pack/mock/shell/ (Style.qml register netrunner). Spec: .claude/CYBERDECK_RESEARCH.md round 3.
- Frame: cyan rule with cut corners, red crosshairs on the side edges, red accent rule under the clock.
- Bar: slanted translucent pills per zone; slanted workspace dots (active filled cyan); clock in yellow Rajdhani with the date and weather in Share Tech Mono; crow agents pill with slot gauge and yellow attention badge in the right zone.
- Panels and cards: cut-corner panels with a notch, hairline cyan border, faint scanlines; card titles in cyan Rajdhani caps, tracked.
- Gauges: slanted segment bars (cyan, red past the limit, green battery) with a big numeric readout, replacing the ring gauges.
- Selectors and tabs: sheared cyan fill for the selected key; panel tab strip as slanted keys.
- Launcher rows: numbered, outlined cut card for the selection, READY/LOCKED chips.
- Strip buttons: cut-corner sockets, active filled cyan.
- Type: Rajdhani Bold (display, headers, numbers), Share Tech Mono (data, hints); OFL, shipped in the pack.
- Wallpaper: original procedural rain city shipped with the pack.
- Screen effects: pack setting Off | Subtle | Full (scanlines), gated by Reduce motion.

# Scope
- In (steps of this one deliverable, in order):
  - Palette, roles and registers chassis (was item_154; built in worktree feat/item_154, not landed).
  - Engine: the active register reaches every style delegate.
  - Fonts and type scale (was item_155).
  - Delegates: FrameStyle, BarSegment, MetalSurface (cards), CardHeader, SegmentedControl, RowSelection, StripButton, ScreenEffects (was item_156 wave 2).
  - New seams where the mockup needs one: workspace indicator, gauge face (was item_159).
  - Pack wallpaper (the cyberdeck part of item_151).
- Out:
  - Layout or behaviour changes (adr_026); kill mode, scanner launcher behaviour and layout profiles (item_160); crow deck ANSI (item_157); screensaver (item_158).

# Acceptance criteria
- AC1: Rendered at 1920x1200 with shot.sh/desk-check (pack cyberdeck, register netrunner), the dashboard, launcher, settings and agents views match cr-0w local/state/shots/cyberdeck-pack/renders2/shell-netrunner-{dash,launch,settings,agents}.png side by side: frame, bar zones and workspaces, panel and card shapes, card titles, gauges, selectors and tabs, launcher rows, strip buttons, fonts, wallpaper and screen effects. A palette or token change alone never meets this AC.
- AC2: Each mismatch found in the side-by-side comparison is listed and either fixed or accepted by the owner; the visual-verifier element checklist passes.
- AC3: The owner approves the side-by-side sheet and then the register on the live bar (after SUPER+SHIFT+R).
- AC4: The shell layout and customisation are unchanged (bar zones, frame, strips, panels, widgets, settings); without the pack every golden is unchanged; contrast-check --strict passes; Reduce motion stills every animation and effect.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1 side-by-side match of the netrunner register.
- request-AC2 -> This backlog slice. Proof: AC1/AC4 fonts, ornaments and styles are original and OFL.

# Decision framing
- Product framing: Not needed
- Architecture framing: New delegate seams follow docs/STYLE_API.md (add api fields, never remove).

# Links
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Primary task(s): (none yet)

# Priority
- Priority: High
- Rationale: Owner's next pick (2026-11-05): Netrunner first, then Megacorp and Deck reuse its delegates.

# Notes
- 2026-11-05: created when the owner had the cyberdeck docs rewritten after the item_154 colour-filter rejection; each register is now one deliverable judged against its mockup.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Tasks
- `task_080_cyberdeck_netrunner_register_matches_its_mockup`
