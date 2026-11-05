## item_157_pack_controlled_kitty_ansi_slots_so_crow_deck_matches_the_register - Pack-controlled kitty ANSI slots so crow deck matches the register
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: pack, controlled, kitty, ansi, slots, crow, deck, matches, register
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- kitty-colors.conf.tmpl maps fixed palette names to ANSI slots and copies normals into brights. crow deck frames use slot 4 (blue), so a magenta-accent register shows blue frames in the terminal.

# Scope
- In:
  - Optional tokens.json `ansi` block: palette name or hex for color0-15, cursor, selection and tab colours; registers may override it; template falls back to today's map.
  - Distinct brights per register (brighter neon for 9-14).
  - theme-switch.py applies it; a test renders crow deck through ansi-shot for each register.
  - Grimdark keeps its current output (no ansi block).
- Out:
  - crow deck code changes (it stays on ANSI slots only).

# Acceptance criteria
- AC1: With the pack active, kitty's 16 colours come from the register's ansi map and the crow deck ansi-shot shows the register accent on frames.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: With the pack active, kitty's 16 colours come from the register's ansi map and the crow deck ansi-shot shows the register accent on frames.

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

