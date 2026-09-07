## task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift - Coherency Slice 5 tail: OSD popup shadow + album-art lift
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-09-07 17:38:24

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, slice, tail, osd, popup, shadow, album, art, lift
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_095_coherency_slice_5_tail_osd_popup_shadow_album_art_lift`

# Acceptance criteria
- AC1: The backlog slice stays bounded for coherency slice 5 tail: osd popup shadow + album-art lift.
- AC2: The backlog slice is reviewable and promotable into a task.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_026_coherency_slice_5_tail_osd_popup_shadow_album_art_lift.md` after implementation.

# Validation
- (no validation recorded yet)
- qmllint clean on MediaPanel.qml + Osd.qml. Shot-verified via HOME=/home/corvus shot.sh: album art now has a drop-shadow lift + rounded corners (OpacityMask, tested with an opaque cover — no square poke); OSD pill has a depth-gated drop shadow, triggered through its 'osd' IPC handler.
- Finish workflow executed on 2026-09-07.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-07.
- Linked backlog item(s): `item_095_coherency_slice_5_tail_osd_popup_shadow_album_art_lift`
- Related request(s): (none)

# Links
- Request: (none yet)
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
