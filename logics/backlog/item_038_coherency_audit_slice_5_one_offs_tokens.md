## item_038_coherency_audit_slice_5_one_offs_tokens - Coherency audit Slice 5 - one-offs + tokens
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Coherency audit
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-07 17:22:54

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
- Delivered (2026-09-07, task_025, archeotech-shell): recessedTrack token promoted + deduped across 3 call sites (9fe34bc); raised 3d slider knob (b939760); media seek off-by-4 fix (84f7de3); AND two user-reported media-panel one-offs surfaced during the work — panel size 220->250 so playback controls clear the strip dock (verified via MPRIS-mock repro), and progress bar now shows for length-less players (elapsed only, no total/seek) instead of hiding entirely. All shot-verified via a reusable MPRIS-mock + `HOME=/home/corvus ./scripts/shot.sh` harness.
- Deferred to [[item_095_coherency_slice_5_tail_osd_popup_shadow_album_art_lift]] (2026-09-07): OSD popup shadow + album-art lift — visual one-offs needing a runtime state (volume event / artUrl) not cheaply producible in isolation; split out so this slice closes on what's delivered rather than being done blind.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_025_coherency_audit_slice_5_one_offs_tokens`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Tasks
- `task_025_coherency_audit_slice_5_one_offs_tokens`

# Notes
- Task `task_025_coherency_audit_slice_5_one_offs_tokens` was finished via `logics-manager flow finish task` on 2026-09-07.
