## task_062_primitive_library_completion_with_focus_and_disabled_states - Primitive library completion with focus and disabled states
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 50%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: primitive, library, completion, focus, disabled, states
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_113_primitive_library_completion_with_focus_and_disabled_states`

# Acceptance criteria
- AC1: The four popups share one PopupCard.
- AC2: Every interactive primitive shows a visible keyboard focus state.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_062_primitive_library_completion_with_focus_and_disabled_states.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_062_primitive_library_completion_with_focus_and_disabled_states.md` after implementation.

# Validation
- command: `tests/run.sh` (77 pass), `python3 -m unittest discover tests/py` (40 pass, new test_primitive_states.py), token-lint 0, qmllint-ci unchanged; isolated renders of GlassButton/ToggleSwitch/SegmentedControl focused and disabled, Settings > Appearance and Connections full-shell renders | result: passed | date: 2026-10-21

# Report
- Wave 1 (shell 8f86cf4 + this branch): FocusRing primitive (Appearance.focusRing tokens, option A of three rendered options: 2px accent outline, 2px gap; options PNG in cr-0w/local/state/night/shots/113-focus/focus-options-dark.png and -light.png) plus keyboard activation (Tab/Space/Enter, arrows for segmented) and a disabled dim (Appearance.disabledOpacity) on GlassButton, ToggleSwitch, SegmentedControl. AC1 was met by 39e40fc (four popups share PopupSurface).
- Wave 2: Spinner primitive replaces five glyph-spinner copies (Wi-Fi/Bluetooth popups, Connections pane).
- Remaining: IconButton, ListRow, TextField, ComboBox, Scrollbar primitives; focus ring on StateLayer-based rows; extend INTERACTIVE in test_primitive_states.py as each lands.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
