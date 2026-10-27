## task_070_edit_mode_design_review_and_audit - Edit mode design review and audit
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
- Keywords: edit, mode, design, review, audit
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_130_edit_mode_design_review_and_audit`

# Acceptance criteria
- AC1: A written review of edit mode with the owner's chosen direction recorded in this item.
- AC2: The Edit Mode banner no longer overlaps any bar content, verified in shot.sh --state editmode renders across dark, light and flat.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_070_edit_mode_design_review_and_audit.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_070_edit_mode_design_review_and_audit.md` after implementation.

# Validation
- command: tests/py (new test_editmode_banner.py), tests/run.sh; shot.sh --state editmode in dark, light and flat before/after, and three banner layouts rendered side by side (cr-0w/local/state/night/shots/130-editmode: banner-options.png, after-dark-light-flat-top.png) | result: AC2 passed in the three looks | date: 2026-10-21

# Report
- AC2 DONE (shell 404734d, branch night/roadmap-next): the banner is now a docked, opaque toolbar across the top, as tall as the real bar, so the clock and right-hand pills no longer poke out. Three layouts were rendered (current floating pill at y=16; a pill moved into the bar row; the docked toolbar). The pill-in-bar-row hides the clock but cannot guarantee that a wider centre zone stays covered, so the dock was built: it works for any bar content and height. Trade-off: the live bar is hidden behind it (it was already dimmed; the mock bar below shows the layout being edited).
- AC1 REVIEW (written; the owner's chosen direction is still needed). Findings from renders of main and the branch at 1280x720:
  1. Banner over the bar: fixed above.
  2. The Widget Library (470 wide, up to height-120 tall, centred) overlaps the mock top bar at 720p: the free band between the top and bottom mocks is about 480px, the library content about 540. Options: (a) scroll the library body (risk: drag-and-drop from inside a Flickable needs care), (b) three columns instead of two to cut its height, (c) collapse the category sections and expand one at a time. Recommendation: (b) then (a) only if a smaller screen still overflows.
  3. Four Bar/Strip/Holder/Off selectors compete with the library for attention, one per edge at equal weight. Options: (a) leave, (b) show a side's selector only while its mock is hovered or selected, (c) fold it into a small popover on the mock. Recommendation: (b).
  4. The frame toggle shows the current state as its label ("Framed" / "Pill frame") so it reads like a status, not a switch. Recommendation: label it "Frame" with the two states as a segmented control.
  5. Hints are split: the banner says drag chips and Esc, the library says drag back to remove. Fine as is.
  Direction recommended: keep the structure (docked toolbar, four edge mocks, library), apply 2(b) and 3(b), 4. Not built: these are layout and hierarchy choices for the owner.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
