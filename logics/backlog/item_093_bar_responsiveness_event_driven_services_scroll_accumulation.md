## item_093_bar_responsiveness_event_driven_services_scroll_accumulation - Bar responsiveness: event-driven services + scroll accumulation
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Bar responsiveness
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-04 09:58:58

# AI Context
- Summary: Make the system bar react instantly instead of on slow polls, and fix scroll adjustment. Battery was a 30s sysfs poll; brightness never observed external (XF86-key) changes; the shared scroll handler misread trackpad wheel events. Audit found volume/mic (pactl subscribe) and network (nmcli monitor) already event-driven; Bluetooth (3s poll) is the remaining poller.
- Keywords: bar, responsiveness, event, driven, services, scroll, accumulation, battery, brightness, upower, udev
- Use when: Touching bar-widget backing services (battery/brightness/volume/network/bluetooth) or the BarPill scroll handler.
- Skip when: Non-bar periodic timers (dashboard CPU/RAM 5s, day/night theme 60s) — those are inherently periodic and fine.

# Problem
- Battery bar lagged up to 30s on plug/unplug (30s sysfs poll). Brightness widget went stale because XF86 keys drive `brightnessctl` directly with no observer, so scroll-adjust computed from a wrong base. The shared BarPill scroll mapped every wheel event (incl. trackpad zero-delta terminator events) to a full ±step, so brightness/volume drifted the wrong way at the end of a gesture and were hyper-sensitive. Battery hover popup was a static snapshot taken on hover-enter.

# Scope
- In:
  - Battery → native UPower (event-driven). Brightness → udev backlight monitor + optimistic authoritative set. BarPill scroll → ignore zero-delta, accumulate to a 120-unit notch (fixes brightness + volume). Battery hover popup → live update while hovered.
- Out:
  - Bluetooth 3s poll → event-driven (deferred follow-up). Non-bar periodic timers.

# Acceptance criteria
- AC1: Battery and brightness reflect changes effectively instantly (no multi-second poll lag).
- AC2: Bar scroll adjustment lands on the intended value with no phantom reverse steps.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: battery UPower-driven + brightness udev-driven; instant updates.
- request-AC2 -> This backlog slice. Proof: BarPill accumulates wheel delta + ignores zero-delta, fixing the scroll-to-100→90 jump.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_019_bar_responsiveness_event_driven_services_scroll_accumulation`

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
- Task `task_019_bar_responsiveness_event_driven_services_scroll_accumulation` was finished via `logics-manager flow finish task` on 2026-09-04.

# Tasks
- `task_019_bar_responsiveness_event_driven_services_scroll_accumulation`
