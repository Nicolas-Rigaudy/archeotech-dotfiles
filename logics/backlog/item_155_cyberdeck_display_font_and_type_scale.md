## item_155_cyberdeck_display_font_and_type_scale - Cyberdeck display font and type scale
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 14:06:14

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: cyberdeck, display, font, type, scale
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The identity needs a techno display face; body text must stay the mono base for legibility.

# Scope
- In:
  - Pick one OFL display face per register or one for the pack: candidates Oxanium, Chakra Petch, Share Tech Mono, VT323 (downloaded to cr-0w local/state/shots/cyberdeck-pack/fonts with their OFL texts).
  - Ship the .ttf and OFL.txt under packs/cyberdeck/fonts; font.displayFile per register if the register merge supports font keys (check the deep merge).
  - Uppercase tracked micro-labels for headers (HUD readout feel).
- Out:
  - Body font changes.

# Decisions
- Owner decision 2026-11-05: Oxanium (OFL) for every register; body stays FiraCode.

# Acceptance criteria
- AC1: Headers render in the chosen OFL face in every register; the licence text ships with the font.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Headers render in the chosen OFL face in every register; the licence text ships with the font.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Primary task(s): `task_076_orchestrate_the_cyberdeck_theme_pack`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
