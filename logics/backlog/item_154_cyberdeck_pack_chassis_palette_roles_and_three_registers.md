## item_154_cyberdeck_pack_chassis_palette_roles_and_three_registers - Cyberdeck pack chassis: palette, roles and three registers
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 14:47:14

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: cyberdeck, pack, chassis, palette, roles, three, registers
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- No second identity pack exists; Grimdark is the only proof that the pack system carries a full identity.

# Scope
- In:
  - packs/cyberdeck: pack.json, tokens.json with own colours and roles, defaultRegister and registers (Protocol, Netrunner, Phosphor; names final after the owner's pick).
  - Square geometry: radius 1-4, chamfered frame corners, window cornerRadius 0, 2px focus border.
  - Motion: short, snappy durations (fast enter, crisp exit); reduce motion honoured.
  - Pack setting `register` (enum) as in Grimdark.
  - contrast-check --strict passes per register; golden renders across registers x dark.
- Out:
  - Fonts, ornaments, textures and style delegates (own slices).
  - Light mode variant (later, if wanted).

# Decisions
- Owner decisions 2026-11-05 (compare page cr-0w local/state/shots/cyberdeck-pack/compare.html): keep all three registers (Protocol, Netrunner, Phosphor). Default register: none of the drafts picked; open, ask again with revised renders before building.

# Acceptance criteria
- AC1: Selecting the pack and each register repaints the whole shell live; contrast-check --strict passes for all three.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Selecting the pack and each register repaints the whole shell live; contrast-check --strict passes for all three.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Superseded 2026-11-05: the three token-only registers and their decisions were rejected; the chassis waits on the direction pick (Megacorp, Netrunner or Deck). Netrunner needs a no-bar HUD layout, Deck a bezel frame delegate; see .claude/CYBERDECK_RESEARCH.md.
- Owner 2026-11-05: Megacorp, Netrunner and Deck all ship as registers of the cyberdeck pack; the shell keeps its layout (bar zones, frame, strips, panels, widgets, settings), only chrome changes. Grimdark is outdated: reuse its pack mechanics, not its look. Mockups renders2/shell-*.png, spec .claude/CYBERDECK_RESEARCH.md round 3.
- Owner 2026-11-05: defaultRegister = netrunner; registers megacorp, netrunner, deck.

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
