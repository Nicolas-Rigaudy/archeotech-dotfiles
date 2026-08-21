## item_017_panel_keybinds_dismissal_consistency - Panel keybinds / dismissal consistency
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Panels
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: panel, keybinds, dismissal, consistency
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- No global close-any-panel bind; not all holders grab keyboard focus so Esc is inconsistent

# Scope
- In:
  - Global close-any-open-panel bind; audit bar+strip panels for keyboard-focus grab; optional per-panel open binds
- Out:
  - Per-panel custom keybind UI

# Acceptance criteria
- AC2: Esc and a global close bind dismiss any open panel consistently across all holders

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Esc and a global close bind dismiss any open panel consistently across all holders

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
