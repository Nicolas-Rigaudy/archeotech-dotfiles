## task_024_coherency_audit_slice_4_dedup_inputs - Coherency audit Slice 4 - dedup + inputs
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
> Indicators reviewed: 2026-09-07 14:57:00

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: coherency, audit, slice, dedup, inputs
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_037_coherency_audit_slice_4_dedup_inputs`

# Acceptance criteria
- AC5: Duplicated labels removed, inputs unified/styled, and popups use CurveRenderer

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_024_coherency_audit_slice_4_dedup_inputs.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_024_coherency_audit_slice_4_dedup_inputs.md` after implementation.

# Validation
- (no validation recorded yet)
- qmllint passed on 2026-09-07 on all edited files (5 panes + DropdownRow) with no errors and SectionLabel/Popup/ItemDelegate resolving; brace-balance verified. Isolated shot.sh visual capture could not render in the headless background-job sandbox (blank frame incl. bar), so live visual confirmation is deferred to the user post hot-reload.
- Finish workflow executed on 2026-09-07.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-07.
- Linked backlog item(s): `item_037_coherency_audit_slice_4_dedup_inputs`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC5 -> This task. Proof: Slice 4 delivered in archeotech-shell: 08fac40 (dedup inline SectionLabel across 5 panes onto shared Widgets/SectionLabel) + 4d664ac (themed Dropdown popup+delegate; unified inline TextField placeholder/focus-anim). qmllint clean on all edited files; no layer.enabled remains in Settings so popups already use CurveRenderer. Source: `shell:08fac40,4d664ac`
