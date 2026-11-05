## item_158_crow_agents_module_and_screensaver_in_the_cyberdeck_pack - crow agents module and screensaver in the cyberdeck pack
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
- Keywords: crow, agents, module, screensaver, cyberdeck, pack
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- crow surfaces on the desk (agents pill and panel, the planned screensaver) must look native in the pack without pack-specific code.

# Scope
- In:
  - crow-agents module: check it reads Appearance tokens only (accent, display font, surfaces); slot gauge as a segmented HUD bar (FiraCode-safe glyphs), attention badge in the register's warning colour.
  - Screensaver (item_085 engine, cr-0w req_015): terminal sources (ascii-magic MIT pieces, cmatrix-style rain) run in kitty and take the register's ANSI colours; the CR-0W working card overlay uses the pack panel style; optional scanline layer.
  - Render each register with the module panel open and a screensaver mock.
- Out:
  - Building the screensaver engine (item_085) or the crow plugin itself (cr-0w).

# Acceptance criteria
- AC1: Renders of the agents pill, panel and screensaver card in each register read as one identity with the shell.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: Renders of the agents pill, panel and screensaver card in each register read as one identity with the shell.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Primary task(s): `task_076_orchestrate_the_cyberdeck_theme_pack`

# Priority
- Priority: Low
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

