## item_142_tonal_selected_pills_light_themes - Tonal selected pills on light themes
> From version: 1.0.0
> Schema version: 1.0
> Status: Obsolete
> Understanding: 90%
> Confidence: 85%
> Progress: 90%
> Complexity: Medium
> Theme: Design
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-30 14:15:59

# AI Context
- Summary: On light themes, text on selected accent pills uses a tonal fill (light, accent-tinted) with dark text instead of base text on the accent.
- Keywords: tonal, selected, pill, accent, light, contrast, onSelected
- Use when: Styling a selected/active state that carries TEXT on an accent fill.
- Skip when: Icon-only glyphs on accent (3:1 non-text, already pass) or palette/role changes (adr_033).

# Problem
- contrast-check reports textOnAccent (base on the accent) below 4.5 on gruvbox-light (3.33) and tokyo-night-day (3.11); no official slot reaches AA on those accents, so a role remap cannot fix it.
- Owner direction (2026-09-30 resume note): restyle selected pills (tinted fill + dark text) rather than recolour accents.

# Scope
- In:
  - Appearance tokens colors.selectedFill / colors.onSelected: light = base tinted toward the accent + textPrimary; dark = accent + base (unchanged).
  - Text on accent fills: SegmentedControl selected label/glyph, CalendarPopup today, PluginsPane Official badge.
  - contrast-check gates onSelected on selectedFill (textOnAccent stays reported).
- Out:
  - Icon-only glyphs on accent (wifi/bt toggles, play button, check badges, bar pill icons): non-text 3:1 already met.
  - Accent recolouring.

# Acceptance criteria
- AC1: Selected pill text meets 4.5:1 on every light theme except a designer-exempt one, and dark themes render unchanged.
- AC2: The selected segment stays clearly distinguishable from the unselected ones on light themes.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: Selected pill text meets 4.5:1 on every light theme except a designer-exempt one, and dark themes render unchanged.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Owner decision 2026-09-30: keep solid accent pills on light themes; tonal pills reverted (c380d33). Accepted: selected-pill text below AA on gruvbox-light (3.33) and tokyo-night-day (3.11), reported not gated. Do not re-propose tonal pills.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): `adr_033`
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: fixes the two sub-AA light themes item_111 surfaced; every settings pane shows a SegmentedControl.

# Notes
- Generated locally by logics-manager.

# Tasks
- `task_050_tonal_selected_pills_on_light_themes`
