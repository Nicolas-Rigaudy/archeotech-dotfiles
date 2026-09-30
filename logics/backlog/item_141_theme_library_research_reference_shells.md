## item_141_theme_library_research_reference_shells - Theme library research: how the reference shells source light and dark themes
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 70%
> Confidence: 70%
> Progress: 0%
> Complexity: Low
> Theme: Theme
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Study which themes DMS, caelestia, end-4 ii and noctalia ship (official ports vs custom vs wallpaper-generated Material You), how they pair light and dark variants, and how they keep them consistent, to improve the Archeotech theme library.
- Keywords: themes, library, light, dark, catppuccin, material you, matugen, research
- Use when: Planning which theme families/flavors to add or drop.
- Skip when: Palette fidelity or role changes (adr_033 rules stand).

# Problem
- Owner (2026-09-30): look at the themes the inspiration repos commonly use, whether they use pre-existing palettes (like Archeotech) or custom ones, and how they handle dark and light, to make the theme library better.
- Known so far: DMS has stock DARK/LIGHT tables + matugen wallpaper themes + a theme registry browser; caelestia and end-4 generate Material You schemes per mode; noctalia ships built-in palettes + community palettes (item_134 comparison; refs cloned under the session scratchpad).

# Scope
- In:
  - Per shell: shipped theme list, source (official port / custom / generated), light-dark pairing, how light variants are designed.
  - Recommendation: families/flavors to add (official light variants that exist upstream), and whether wallpaper-generated themes fit the official-palettes rule.
- Out:
  - Implementing new themes (separate items).

# Acceptance criteria
- AC1: A written comparison with a recommended list of theme additions/removals, each with its upstream source.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: comparison and recommendations.

# Decision framing
- Product framing: Needed (which themes belong in 1.0)
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): `adr_033_official_palettes_only_semantic_text_roles_with_a_contrast_floor`
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: Low
- Rationale: owner asked for it "later, not necessarily now" (2026-09-30).

# Notes
- Generated locally by logics-manager.
