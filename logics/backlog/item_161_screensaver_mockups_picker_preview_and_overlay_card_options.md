## item_161_screensaver_mockups_picker_preview_and_overlay_card_options - Screensaver mockups: picker, preview and overlay card options
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Ambient
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:05:16

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: screensaver, mockups, picker, preview, overlay, card, options
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The picker, preview and overlay card are visual choices; the owner picks from rendered options before any UI build (standing rule).

# Scope
- In:
  - 2-3 options for the Power pane picker (list with thumbnails, gallery, compact selector plus preview), the live preview placement, and the overlay card (corner card, lower band, centred).
  - Rendered at 1920x1200 with shot.sh --qml standalone mocks, on dark and light, combined into one review page.
  - At least two original QML scene ideas sketched beyond the classic terminal animations, from `.claude/SCREENSAVER_RESEARCH.md`: glance board (clock, next event, weather, battery), wallpaper drift, dev radar at rest (OrbitViz on live data), flip clock, theme-aware shader.
- Out:
  - Engine code, plugins and the idle hook.

# Acceptance criteria
- AC6: The owner has picked a picker layout, a preview placement and an overlay card style; the pick is recorded in this item.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC6: The owner has picked a picker layout, a preview placement and an overlay card style; the pick is recorded in this item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)
- Request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Primary task(s): `task_077_orchestrate_the_screensaver_engine`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
