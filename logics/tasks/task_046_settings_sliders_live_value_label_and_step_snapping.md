## task_046_settings_sliders_live_value_label_and_step_snapping - Settings sliders: live value label and step snapping
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-29 15:26:14

# AI Context
- Summary: SliderRow formats its label from the live slider value via a `format` function (replacing `valueDisplay` at all 10 callers) and snaps the knob to steps.
- Keywords: settings, sliders, live, value, label, step, snapping
- Use when: Touching SliderRow or settings slider rows.
- Skip when: Wiring the unread appearance scale keys.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_133_settings_sliders_live_label_and_snapping`

# Acceptance criteria
- AC1: During a drag the label shows the value under the knob on every step, including the debounced Shell sliders.
- AC2: The knob snaps to step positions.

# Plan
- [x] Worktree `fix/item_133`; SliderRow `format` + `snapMode: Slider.SnapAlways`; convert 10 callers.
- [x] A/B: qmltestrunner drag of SliderRow-shaped row with a debounced round trip (label per mouse step, knob position), main shape vs fix.
- [x] qmllint, qml-reviewer, golden.sh (settings scenarios) + tests/run.sh; land by path.
- [x] Use `python3 -m logics_manager flow progress task task_046_settings_sliders_live_value_label_and_step_snapping.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_046_settings_sliders_live_value_label_and_step_snapping.md` after implementation.

# Validation
- qmltestrunner drag of the real SliderRow with a 300 ms debounced store (ShellPane Corner Radius shape), 6 px mouse steps: main label stuck at 8px while value went 8->12 and the knob glided 7.77..11.56; fix label 8,9,10,11,12px with the knob exactly on steps. golden.sh --root wt 25/25 ok (labels unchanged at rest); tests/run.sh 31 passed; qmllint counts equal to main per file (AppearancePane 26->19). Appearance pane scrolled-to-bottom render main vs fix judged by visual-verifier: TYPOGRAPHY/GEOMETRY gone, LOGO->BEHAVIOR spacing normal, nothing clipped (PASS; first attempt had a broken scroll probe and was correctly failed).
- command: `qmltestrunner SliderRow drag A/B; scripts/golden.sh --root wt; tests/run.sh; visual-verifier` | result: passed | date: 2026-09-29
- Finish workflow executed on 2026-09-29.
- Linked backlog/request close verification passed.

# Report
- 62c4edd: SliderRow format(v) over the live slider value replaces valueDisplay at all 10 callers; snapMode SnapAlways; ConfigForm label decimals follow spec.step (qml-reviewer nit). 3376354: owner chose to remove Font Size Scale / Corner Rounding / Padding Scale (Appearance) - they wrote keys nothing read since c91f700; an appearance settings audit comes later. Out-of-tree callers setting valueDisplay would lose their label (none in tree).
- Finished on 2026-09-29.
- Linked backlog item(s): `item_133_settings_sliders_live_label_and_snapping`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: slider label follows every step during a drag, including the debounced Shell sliders; knob snaps (62c4edd).
