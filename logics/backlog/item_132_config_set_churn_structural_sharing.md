## item_132_config_set_churn_structural_sharing - Config set churn: structural sharing and write-echo suppression
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Services
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-29 14:29:58

# AI Context
- Summary: `Persistence.Config.set()` deep-clones the whole config, so every set (each settings-slider tick) gives every object-valued `Config.get()` binding a new identity and fires its downstream; the debounced write is then re-read via `watchChanges` and replaces `_data` again.
- Keywords: config, persistence, set, churn, binding, structural sharing, filewatch, echo
- Use when: Touching `Services/Persistence/Config.qml` get/set or its file round-trip.
- Skip when: Migrating shell-config.json (ShellConfig) or pack manifests.

# Problem
- `Services/Persistence/Config.qml` `set()` does `JSON.parse(JSON.stringify(_data))`: all 63 `Config.get()` call sites re-evaluate and object-valued ones (e.g. `packs.<id>` in shell.qml, `audio.aliases`) emit changed even though their key did not change. A QtTest probe confirmed QML emits a `var` change for a new object and none for the same reference.
- Sliders in Appearance/Notifications/Shell panes call `set()` on every `onMoved`; each debounced write is echoed back by `watchChanges`, `_parse()` replaces `_data` with fresh objects and churns everything a second time.
- A `set()` to the current value still clones, notifies and writes.

# Scope
- In:
  - Pure `ConfigLogic.js` (get/set path helpers) with qmltestrunner tests.
  - Path-copy (structural sharing) in `set()`; untouched subtrees keep identity.
  - No-op `set()` (value unchanged) does nothing.
  - Ignore the file-watch echo of our own write; external edits still reload.
- Out:
  - A per-key signal API or changing the 63 call sites.

# Acceptance criteria
- AC1: Setting one key does not emit a change on bindings of other object-valued keys (probe count A/B vs main).
- AC2: Our own write is not re-parsed; an external edit to config.json still applies.
- AC3: `set(k, current)` writes nothing.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: unrelated object-valued bindings stay quiet on set.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_045_config_set_churn_structural_sharing_and_write_echo_suppression`

# Priority
- Priority: Medium
- Rationale: 0.31 leftover; binding churn on every slider tick across the whole shell, small contained fix (2026-09-29).

# Notes
- Generated locally by logics-manager.
- Task `task_045_config_set_churn_structural_sharing_and_write_echo_suppression` was finished via `logics-manager flow finish task` on 2026-09-29.

# Tasks
- `task_045_config_set_churn_structural_sharing_and_write_echo_suppression`
