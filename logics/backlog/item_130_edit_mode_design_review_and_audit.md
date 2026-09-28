## item_130_edit_mode_design_review_and_audit - Edit mode design review and audit
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Owner-requested design review + audit of the builder edit mode (EditOverlay) after the 38b5167 rework; the Edit Mode banner still overlaps the bar clock (split out of item_109 on 2026-09-28).
- Keywords: edit, mode, design, review, audit
- Use when: Redesigning edit mode layout (banner, zone editors, widget library, selectors) or auditing its UX.
- Skip when: Fixing unrelated panel visuals (item_109 covers launcher/media).

# Problem
- The Edit Mode banner (EditOverlay.qml, top:16, 40px) sits over the bottom of the dimmed real bar so the clock pokes out around it; the gap between the real bar and the mock top bar is ~27px.
- The audit also called edit mode the busiest screen: three competing Bar/Strip/Holder/Off selectors plus the library, over the scrimmed shell.
- Evidence: .claude/audits/2026-09-28 audit page (Edit mode figure) and a fresh render of main 436dc27 (shot.sh --state editmode).

# Scope
- In:
  - A design review (layout, hierarchy, what the banner/selectors/library should be) and a UX audit of the current EditOverlay, then the resulting fixes, including the banner-over-clock overlap.
- Out:
  - Widget API / zone model changes; design system v2 tokens.

# Acceptance criteria
- AC1: A written review of edit mode with the owner's chosen direction recorded in this item.
- AC2: The Edit Mode banner no longer overlaps any bar content, verified in shot.sh --state editmode renders across dark, light and flat.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: the Edit Mode banner no longer overlaps bar content in the golden editmode scenario.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: visible first-use defect, but needs an owner design decision first (2026-09-28).

# Notes
- Generated locally by logics-manager.
