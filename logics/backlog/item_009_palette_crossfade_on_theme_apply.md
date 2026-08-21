## item_009_palette_crossfade_on_theme_apply - Palette crossfade on theme apply
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Theming polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: palette, crossfade, theme, apply
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Theme apply snaps rather than transitioning

# Scope
- In:
  - Per-frame lerp palette crossfade (Noctalia pattern), interruption-safe
- Out:
  - Animating external-app color changes

# Acceptance criteria
- AC5: Applying a theme crossfades the palette instead of snapping

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Applying a theme crossfades the palette instead of snapping
- request-AC1 -> This backlog slice. Proof: AC5: Applying a theme crossfades the palette instead of snapping

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
