## task_002_shell_wide_design_polish_rollout - Shell-wide design polish rollout
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 40%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-08-21 09:37:33

# AI Context
- Summary: The active, shell-wide "Polish & Liveliness" rollout — migrating every surface onto the 3D/glass/StateLayer treatment round by round. Already underway (several rounds landed).
- Keywords: polish, liquid-glass, StateLayer, CurveRenderer, coherency, rounds, liveliness
- Use when: Working the next design-polish wave, or checking what polish is shipped vs remaining.
- Skip when: Building a net-new feature/plugin or the release plumbing (those are their own backlog items/milestones).

# Context
- This is the shell-wide design-polish rollout (formerly the POLISH_ROLLOUT / "Design Polish Pass" tracker), not just the Settings pane.
- Feel-gated, rolling effort: pilot a surface, live-test, then commit — round by round.
- Several rounds have already landed (Slice 1, most of Rounds 1-3); Round 4 (strip/bar), remaining popups/media, the coherency audit slices, and the shared GlassSheen extraction remain.

# Plan
- [x] Round 1 (partial): floating overlays onto glass/StateLayer.
- [ ] Round 1 leftovers: CalendarPopup / WifiPopup / BtPopup + MediaPanel/MediaWidget.
- [ ] Round 3: EditOverlay/WidgetPalette builder buttons onto GlassButton/StateLayer, then a full design pass over all of Settings.
- [ ] Flat<->glass aesthetic toggle: full rollout to un-migrated popups/media/edit-mode/openers (item_012).
- [ ] Coherency audit Slices 2-5 (item_035-038): selector unification, flat-mode sweep, dedup+inputs, one-offs+tokens.
- [ ] Round 4: opener/BarPill/chip hover-press states + SAFE bar/strip tweaks (item_015, item_017).
- [ ] Launcher keyboard-first master search (item_016).
- [ ] Extract a shared GlassSheen helper; misc stragglers (item_039, item_043, item_044, item_045, item_050).
- [ ] GATE: feel-check each wave; leave the repo commit-ready; do not close until it looks/behaves right in the live shell.

# Backlog
- Covers polish-cluster items: item_002, item_004, item_006, item_007, item_008, item_009, item_010, item_012, item_015, item_016, item_017, item_035, item_036, item_037, item_038, item_039, item_043, item_044, item_045, item_050.

# Definition of Done (DoD)
- [ ] Code is implemented and reviewed.
- [ ] Validation passes.
- [ ] Linked docs are synchronized.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> This task. Proof: implementation delivers the bounded request need.
- request-AC2 -> This task. Proof: implementation scope is limited to the linked delivery slice.
- request-AC3 -> This task. Proof: implementation is executable from the promoted backlog item.
- backlog-AC1 -> This task. Proof: task remains bounded to the linked backlog scope.
- backlog-AC2 -> This task. Proof: task provides the executable implementation surface.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
