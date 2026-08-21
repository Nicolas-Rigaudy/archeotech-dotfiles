## item_038_coherency_audit_slice_5_one_offs_tokens - Coherency audit Slice 5 - one-offs + tokens
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
- Keywords: coherency, audit, slice, offs, tokens
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Assorted one-offs: AboutPane centering, OSD missing shadow, MediaPanel progress rubber-band/seek off-by-4, launcher selection glyph, LogoCarousel label collision, sidebar wheel-scroll desync, dim off-buttons/icons, off-scale fonts + recessedTrack token, fullscreen auto-hide broken

# Scope
- In:
  - Fix each listed one-off; promote recessed-track literal to a colors.recessedTrack token; trace fullscreen auto-hide signal path
- Out:
  - Broader redesign

# Acceptance criteria
- AC5: Each listed one-off is fixed and the recessedTrack token is introduced

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Each listed one-off is fixed and the recessedTrack token is introduced
- request-AC2 -> This backlog slice. Proof: AC5: Each listed one-off is fixed and the recessedTrack token is introduced

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — partial token coverage (delivered); remaining: one-offs (popup shadow, album-art lift, 3D knob) + token completion. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
