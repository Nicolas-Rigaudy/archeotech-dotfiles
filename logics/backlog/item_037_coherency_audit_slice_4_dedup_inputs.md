## item_037_coherency_audit_slice_4_dedup_inputs - Coherency audit Slice 4 - dedup + inputs
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Coherency audit
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, audit, slice, dedup, inputs
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Inline SectionLabel re-declared in 5 panes; unstyled text fields and Dropdown/TimePick popups; inconsistent close buttons and app-tiles; popups use layer.enabled instead of CurveRenderer

# Scope
- In:
  - Use shared SectionLabel; unify text fields + style Dropdown/TimePick popup; close buttons -> StateLayer/GlassButton; popups -> Shape.CurveRenderer
- Out:
  - Redesigning the panes

# Acceptance criteria
- AC5: Duplicated labels removed, inputs unified/styled, and popups use CurveRenderer

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Duplicated labels removed, inputs unified/styled, and popups use CurveRenderer

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — SettingsCard unified + dedup on several panes (delivered); remaining: full dedup + input styling. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
