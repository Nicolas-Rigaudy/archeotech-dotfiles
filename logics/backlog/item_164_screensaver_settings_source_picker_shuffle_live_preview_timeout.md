## item_164_screensaver_settings_source_picker_shuffle_live_preview_timeout - Screensaver settings: source picker, shuffle, live preview, timeout
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Ambient
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: screensaver, settings, source, picker, shuffle, live, preview, timeout
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The owner needs to pick, preview and time the screensaver next to the existing idle settings.

# Scope
- In:
  - Power pane section in the layout picked in the mockup item: source or shuffle (ButtonGroupRow / list per design rules), live preview, timeout before lock, card mode (overlay / take over / off) when a card plugin is installed.
  - Values persisted with the idle settings (~/.cache/swayidle.conf gains SCREENSAVER_* keys) and in settings search.
- Out:
  - The swayidle script change (dotfiles item).

# Acceptance criteria
- AC3: Choosing a source updates the preview live, shuffle rotates sources between runs, and the timeout is written where the idle hook reads it.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: Choosing a source updates the preview live, shuffle rotates sources between runs, and the timeout is written where the idle hook reads it.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)
- Request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Primary task(s): `task_077_orchestrate_the_screensaver_engine`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

