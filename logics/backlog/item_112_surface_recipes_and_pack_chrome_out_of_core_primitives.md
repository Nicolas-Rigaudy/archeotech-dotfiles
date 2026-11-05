## item_112_surface_recipes_and_pack_chrome_out_of_core_primitives - Surface recipes and pack chrome out of core primitives
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: High
> Theme: Theming engine
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:36:24

# AI Context
- Summary: Surface recipes and pack chrome out of core primitives. frameChamfer doubles as the 'is this Grimdark' switch (72 references in 20 files)
- Keywords: surface, recipes, pack, chrome, out, core, primitives
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on theming engine.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- frameChamfer doubles as the 'is this Grimdark' switch (72 references in 20 files); copper/steel/teal branches live inside base primitives; FrameFx.qml:122-176 hardcodes steel so registers never recolour; ConsoleChrome and BarSegment sit in base Commons; only GlassButton uses style delegates.
- Evidence: audit-design.md, audit-architecture.md.

# Scope
- In:
  - Per-role surface recipes (Ambxst StyledRect model endorsed by adr_027) that packs override
  - Move Grimdark chrome into its pack via recipes and style delegates; retire frameChamfer as an identity switch; make pack inherits resolve
- Out:
  - Finishing the Grimdark pack itself (item_082)

# Acceptance criteria
- AC1: grep finds no pack-specific colour or branch in Commons/ or Modules/.
- AC2: Grimdark renders identically to before from pack files only.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: grep finds no pack-specific colour or branch in Commons/ or Modules/.
- request-AC6 -> This backlog slice. Proof: AC2: Grimdark renders identically to before from pack files only.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_059_surface_recipes_and_pack_chrome_out_of_core_primitives`

# Priority
- Priority: High
- Rationale: required before add-on packs are possible (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_059_surface_recipes_and_pack_chrome_out_of_core_primitives`

# Notes
- Task `task_059_surface_recipes_and_pack_chrome_out_of_core_primitives` was finished via `logics-manager flow finish task` on 2026-11-05.
