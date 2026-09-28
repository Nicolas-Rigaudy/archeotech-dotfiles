## task_036_bar_and_strip_widget_instantiation_fixes - Bar and strip widget instantiation fixes
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
> Indicators reviewed: 2026-09-28 14:08:13

# AI Context
- Summary: Bar zone Repeaters get a model only for the active orientation (no double instantiation); Strip gains the no-op hover-card API; WidgetLoader retries plugin widgets after the module scan.
- Keywords: bar, strip, widget, instantiation, fixes
- Use when: Touching bar/strip widget mounting or plugin widget loading.
- Skip when: Holder-aware vertical widgets (item_064).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_106_bar_and_strip_widget_instantiation_fixes`

# Acceptance criteria
- AC1: Each configured bar widget has exactly one live instance per bar.
- AC2: A plugin widget renders after a cold start and a bar widget on a strip can call popup functions without error.

# Plan
- [x] 1. Measure instances with a worktree-only probe (baseline).
- [x] 2. Gate Repeater models by orientation; add Strip no-op popup API; plugin retry on registry ready.
- [x] 3. Re-measure, render a plugin fixture on main vs fix, qml-reviewer, land on main by path.
- [x] Run `python3 -m logics_manager flow finish task task_036_bar_and_strip_widget_instantiation_fixes.md` after implementation.

# Validation
- PASSED 2026-09-28: worktree-only console.log probe in WidgetLoader, rendered with shot.sh --root: baseline 34 widget loads with every top-bar widget loaded twice (13 x 2); after the fix 21 loads, each widget exactly once, no QML errors in qs.log (AC1). Fixture shell-config with plugin:hello on the top bar (shot.sh --shell-config): unfixed main renders an empty slot after cold start, the fix renders the hello widget (AC2, re-checked after coalescing the retry with Qt.callLater). Strip now exposes showPopup/hidePopup/hideCalendar/keepPopupsAlive no-ops (AC2). qml-reviewer agent: verdict ship; its should-fix (double setSource on cold start) and nit (comment) applied. Qt6 qmllint: no new findings beyond the known singleton/qmldir false positives. Landed on archeotech-shell main as 1c22858 (probe never committed).
- command: `worktree probe instance count via shot.sh --root; plugin fixture render via shot.sh --shell-config; qml-reviewer; qmllint` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Modules/Shell/Sides/Bar.qml, Strip.qml, WidgetLoader.qml changed in archeotech-shell 1c22858. Also added shot.sh --shell-config (8181ac0) to render fixed layouts; reusable for item_068 goldens.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_106_bar_and_strip_widget_instantiation_fixes`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: one of the audit-verified bugs (double-instantiated bar widgets) fixed in archeotech-shell 1c22858, measured 34 -> 21 loads with every widget once; plugin cold-start blank fixed and shown by render. The rest of AC2 (other bugs, golden matrix) is covered by sibling items.
