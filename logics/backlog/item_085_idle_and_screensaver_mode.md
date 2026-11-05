## item_085_idle_and_screensaver_mode - Idle and screensaver mode
> From version: 1.0.0
> Schema version: 1.0
> Status: Obsolete
> Understanding: 55
> Confidence: 55
> Progress: 0
> Complexity: Medium
> Theme: Idle
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:02:35

# AI Context
- Summary: An idle / screensaver mode — after inactivity, dim the shell and show a gentle ambient animation, restoring on cursor/key. Candidate from ANALYSIS.md §20.5 (user-endorsed 2026-09-03); an ambient-motion slice of the motion system (req_002).
- Keywords: idle, screensaver, ambient, dim, burn-in, motion
- Use when: implementing idle detection + a screensaver/ambient overlay.
- Skip when: the lock screen (item_018, separate); DPMS / suspend / power policy.

# Problem
- The shell has no idle/screensaver behaviour. A gentle ambient idle state adds liveliness, reduces burn-in on OLED/long-idle, and is a nice demo beat (cf. hyprdvd's screensaver mode — one flavour of many).

# Scope
- In:
  - Idle detection (reuse the existing idle service / Wayland idle protocol), an ambient screensaver overlay (dim + a gentle animation — e.g. a clock, orbiting/particle motion reusing the Canvas hero-viz from req_004), restore on any input.
  - Config: enable + timeout + style, via configSchema.
- Out:
  - Lock screen (item_018); DPMS/suspend/power-management policy; the specific window-bounce gimmick (hyprdvd is just one option).

# Acceptance criteria
- AC1: After a configurable idle timeout a screensaver/ambient overlay appears and dismisses cleanly on any input.
- AC2: Enable, timeout, and style are configurable and respect the theme tokens.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: delivers "optional ambient idle motion" from req_002 AC4 as a concrete idle/screensaver surface.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- 2026-11-05 (owner): absorbed by req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook (items 161-165, road_001 0.60). Retired Obsolete; the engine, sources, settings and idle hook live there.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_002_motion_and_fluidity_system`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
