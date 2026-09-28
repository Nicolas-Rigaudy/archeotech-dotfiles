## item_113_primitive_library_completion_with_focus_and_disabled_states - Primitive library completion with focus and disabled states
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: Medium
> Theme: Design system
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Primitive library completion with focus and disabled states. WifiPopup, BtPopup, CalendarPopup and HoverCard copy the same ~75 lines of chrome
- Keywords: primitive, library, completion, focus, disabled, states
- Use when: Implementing or reviewing the 0.40 Design system v2 milestone work on design system.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- WifiPopup, BtPopup, CalendarPopup and HoverCard copy the same ~75 lines of chrome; no shared icon button, list row, text field; 7 spinner copies; combo box, tooltip and scrollbar are unstyled Qt.
- No focus rings and no disabled state anywhere.

# Scope
- In:
  - PopupCard, IconButton, ListRow, TextField, Spinner, ComboBox, Tooltip, Scrollbar
  - Focus-visible and disabled states in StateLayer
- Out:
  - Motion presets

# Acceptance criteria
- AC1: The four popups share one PopupCard.
- AC2: Every interactive primitive shows a visible keyboard focus state.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: The four popups share one PopupCard.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: Medium
- Rationale: removes the largest source of duplication and hand-rolled Qt defaults (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
