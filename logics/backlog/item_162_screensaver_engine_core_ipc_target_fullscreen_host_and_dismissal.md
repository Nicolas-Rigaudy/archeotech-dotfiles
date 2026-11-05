## item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal - Screensaver engine core: IPC target, fullscreen host and dismissal
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Ambient
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: screensaver, engine, core, ipc, target, fullscreen, host, dismissal
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- The shell has no screensaver surface, no IPC entry to start one and no layer where a plugin card can draw over it.

# Scope
- In:
  - `screensaver` IpcHandler target: start, stop, preview <source>, status.
  - Fullscreen host per screen (all outputs) with dismissal on any key, pointer move or click, restoring focus.
  - Card layer above the source with modes overlay / take over / off and a demo card.
  - Terminal-source host decision recorded as an ADR: kitty fullscreen window + compositor rule versus an embedded terminal.
  - Reduce motion and the 114 animation scale respected by the engine's own fades.
- Out:
  - Individual sources (own item), Settings UI, swayidle changes.

# Acceptance criteria
- AC1: `qs ipc call screensaver start` in an isolated session shows the active source on every output and any input dismisses it.
- AC5: A demo card draws over the source in overlay mode and replaces it in take-over mode.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: `qs ipc call screensaver start` in an isolated session shows the active source on every output and any input dismisses it.
- request-AC5 -> This backlog slice. Proof: AC5: A demo card draws over the source in overlay mode and replaces it in take-over mode.

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

