## task_025_coherency_audit_slice_5_one_offs_tokens - Coherency audit Slice 5 - one-offs + tokens
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
> Indicators reviewed: 2026-09-07 17:22:53

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, audit, slice, offs, tokens
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_038_coherency_audit_slice_5_one_offs_tokens`

# Acceptance criteria
- AC5: Each listed one-off is fixed and the recessedTrack token is introduced

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_025_coherency_audit_slice_5_one_offs_tokens.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_025_coherency_audit_slice_5_one_offs_tokens.md` after implementation.

# Validation
- (no validation recorded yet)
- qmllint clean on all edited files (Appearance, SliderRow, SystemStatus, SegmentedControl, MediaPanel, PanelRegistry). Visually verified via MPRIS-mock + HOME=/home/corvus shot.sh: recessedTrack renders in dashboard bars + segmented tracks; 3d knob in Notifications sliders; media panel controls clear the strip dock (before/after); progress bar shows for both length>0 and length=0 players. OSD shadow + album-art lift split to item_095.
- Finish workflow executed on 2026-09-07.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-07.
- Linked backlog item(s): `item_038_coherency_audit_slice_5_one_offs_tokens`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: Slice 5 delivered in archeotech-shell: recessedTrack token+dedup (9fe34bc), 3d slider knob (b939760), media seek off-by-4 (84f7de3), media panel size 220->250 to clear the strip dock, and progress-bar length-less handling. Shot-verified via MPRIS-mock + HOME=/home/corvus shot.sh (before/after captures). OSD shadow + album-art lift split to item_095. Source: `shell:9fe34bc,b939760,84f7de3`
- request-AC5 -> This task. Proof: Slice 5 delivered in archeotech-shell: recessedTrack token+dedup (9fe34bc), 3d slider knob (b939760), media seek off-by-4 (84f7de3), media panel size 220->250 to clear the strip dock, and progress-bar length-less handling. Shot-verified via MPRIS-mock + HOME=/home/corvus shot.sh (before/after captures). OSD shadow + album-art lift split to item_095. Source: `shell:9fe34bc,b939760,84f7de3`
