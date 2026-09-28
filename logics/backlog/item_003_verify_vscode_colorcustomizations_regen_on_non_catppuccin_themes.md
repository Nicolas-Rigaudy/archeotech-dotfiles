## item_003_verify_vscode_colorcustomizations_regen_on_non_catppuccin_themes - Verify VSCode colorCustomizations regen on non-Catppuccin themes
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 10%
> Complexity: Low
> Theme: Theming appliers
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: verify, vscode, colorcustomizations, regen, non, catppuccin, themes
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- apply_vscode now regenerates bg for every theme; may clash on Gruvbox/Tokyo/Nord VSCode themes

# Scope
- In:
  - Verify no clash on non-Catppuccin VSCode themes; gate to Catppuccin if it does
- Out:
  - Rewriting the VSCode applier wholesale

# Acceptance criteria
- AC1: VSCode backgrounds track the palette without clashing on any family

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: VSCode backgrounds track the palette without clashing on any family

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-09-28: verify alongside item_127 opt-in theme-switch targets. Scheduled 1.0.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Low
- Rationale: Verification chore tied to item_127 opt-in targets (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
