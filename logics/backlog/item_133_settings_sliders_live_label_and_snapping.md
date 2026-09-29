## item_133_settings_sliders_live_label_and_snapping - Settings sliders: live value label and step snapping
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 95%
> Confidence: 90%
> Progress: 100%
> Complexity: Low
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-29 15:26:15

# AI Context
- Summary: SliderRow's value label is computed from the caller's round trip (Config / ShellConfig), not the slider, so sliders whose round trip is debounced (Settings -> Shell Corner Radius, Outer Gap) freeze their label for the whole drag; the knob glides unsnapped while the value moves in steps.
- Keywords: settings, slider, sliderrow, label, snap, stepSize, valueDisplay
- Use when: Changing Modules/Settings/Widgets/SliderRow.qml or its callers.
- Skip when: Implementing the unread appearance scale keys (separate decision).

# Problem
- Owner report 2026-09-29: dragging the Corner Radius slider does not update its text, so picking a value is hard; the knob moves smoothly although the setting goes in steps of 1.
- `ShellPane.qml` Corner Radius / Outer Gap bind `value` to `ShellConfig.cornerRadius()/outerGap()`, written only after a debounce timer and hot-reload; `valueDisplay` is an expression of that `value`.
- `Slider` uses the default `snapMode` (NoSnap): value rounds to `stepSize` (qmltestrunner: 0.1 steps every ~7 px) while the knob does not.

# Scope
- In:
  - SliderRow label formats the slider's live value (`format: v => ...` replaces `valueDisplay`), all 10 callers.
  - `snapMode: Slider.SnapAlways`.
- Out:
  - Font/Corner/Padding scale sliders in Appearance write keys nothing reads (fake since c91f700): owner decision, separate item.

# Acceptance criteria
- AC1: During a drag the label shows the value under the knob on every step, including the debounced Shell sliders.
- AC2: The knob snaps to step positions.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: live label during drag.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_046_settings_sliders_live_value_label_and_step_snapping`

# Priority
- Priority: High
- Rationale: owner-reported usability defect in every settings slider; small fix (2026-09-29).

# Notes
- Generated locally by logics-manager.
- Task `task_046_settings_sliders_live_value_label_and_step_snapping` was finished via `logics-manager flow finish task` on 2026-09-29.

# Tasks
- `task_046_settings_sliders_live_value_label_and_step_snapping`
