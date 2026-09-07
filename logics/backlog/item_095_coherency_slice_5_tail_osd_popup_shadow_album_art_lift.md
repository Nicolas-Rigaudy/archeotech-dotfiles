## item_095_coherency_slice_5_tail_osd_popup_shadow_album_art_lift - Coherency Slice 5 tail: OSD popup shadow + album-art lift
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 80
> Confidence: 75
> Progress: 100%
> Complexity: Low
> Theme: Coherency audit
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-07 17:38:44

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, slice, tail, osd, popup, shadow, album, art, lift
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Split from item_038 (2026-09-07): two Slice-5 visual one-offs still open — the OSD volume/brightness pill has no drop shadow (doesn't lift off the wallpaper), and the MediaPanel album art has no elevation ("lift"). Both need a runtime state the isolated shot harness can only partly produce (OSD needs a volume/brightness event; album-art lift needs a track with artUrl), so they were deferred rather than done blind.

# Scope
- In:
  - Add a depth-gated (shadowStrength) drop shadow to the OSD pill.
  - Add elevation/lift to the MediaPanel album art.
  - Verify via shot.sh (HOME=/home/corvus) with the MPRIS mock (give it an artUrl for the album-art case).
- Out:
  - The already-delivered Slice-5 items (recessedTrack token, 3d knob, seek off-by-4, media panel sizing, progress-bar length-less handling) — see item_038.

# Acceptance criteria
- AC1: The backlog slice stays bounded for coherency slice 5 tail: osd popup shadow + album-art lift.
- AC2: The backlog slice is reviewable and promotable into a task.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: (to be linked)
- Primary task(s): `task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift`

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
- Task `task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift` was finished via `logics-manager flow finish task` on 2026-09-07.

# Tasks
- `task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift`
