## task_020_bluetooth_service_event_driven_drop_3s_poll - Bluetooth service event-driven (drop 3s poll)
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
> Indicators reviewed: 2026-09-04 10:10:12

# AI Context
- Summary: Made the Bluetooth service truly event-driven. Root cause: the existing `busctl monitor org.bluez` needs BecomeMonitor/eavesdrop privilege → "Access denied" as a normal user, so it died instantly and the 3s poll fallback was what actually ran. Swapped to `gdbus monitor --system --dest org.bluez` (ordinary signal subscription, no privilege), filtered to Device1/Adapter1/Battery1 + Interfaces{Added,Removed} and debounced 300ms to skip chatty MediaPlayer position ticks.
- Keywords: bluetooth, service, event, driven, gdbus, busctl, dbus, org.bluez
- Use when: Touching Bluetooth.qml's update mechanism.
- Skip when: Bluetooth command/agent flows (connect/pair/scan) — unchanged here.

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_094_bluetooth_service_event_driven_drop_3s_poll`

# Acceptance criteria
- AC1: Bluetooth device/connection/battery state updates instantly (event-driven), not on a 3s poll.
- AC2: The change adds no privilege requirement and coalesces noisy signals.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_020_bluetooth_service_event_driven_drop_3s_poll.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_020_bluetooth_service_event_driven_drop_3s_poll.md` after implementation.

# Validation
- Root cause confirmed live: `busctl monitor --json=short org.bluez` → "Call to org.freedesktop.DBus.Monitoring.BecomeMonitor failed: Access denied" (exit 1) as the normal user → old monitor never ran → 3s poll was active.
- `gdbus monitor --system --dest org.bluez` runs non-root (streams "Monitoring signals from all objects owned by org.bluez").
- Post-change, confirmed the LIVE hot-reloaded shell spawned `gdbus monitor --system --dest org.bluez` (pid observed via pgrep) and no `busctl monitor` remains.
- qmllint passed on 2026-09-04: 0 errors on Bluetooth.qml. Behavioural confirm (connect/disconnect reflects instantly) left to user device toggle.
- Finish workflow executed on 2026-09-04.
- Linked backlog/request close verification passed.

# Report
- archeotech-shell commit `55eda96`: `Services/Networking/Bluetooth.qml` — replaced `busctl monitor` with `stdbuf -oL gdbus monitor --system --dest org.bluez`; filter to Device1/Adapter1/Battery1 + InterfacesAdded/Removed; 300ms debounce (`_refreshDebounce`) to coalesce bursts and skip MediaPlayer1/MediaTransport1 position/volume spam; 1s auto-restart (`_monRestart`) on exit. 3s `_pollTimer` kept as an inert safety fallback (only fires if the monitor is ever down).
- Completes the bar event-driven sweep from item_093 — no bar poller remains.
- Finished on 2026-09-04.
- Linked backlog item(s): `item_094_bluetooth_service_event_driven_drop_3s_poll`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: `gdbus monitor` replaces the access-denied `busctl monitor`; live shell confirmed running it (commit 55eda96) → event-driven, 3s poll no longer the active path.
- request-AC2 -> This task. Proof: gdbus signal subscription needs no privilege (verified non-root); 300ms debounce + interface filter coalesce/skip noisy MediaPlayer signals.
- request-AC3 -> This task. Proof: delivery chain complete — item_094 promoted to this task, implemented (commit 55eda96), validated, and closed out.
- request-AC4 -> Not in this slice's scope.
- request-AC5 -> Not in this slice's scope.
- request-AC6 -> Not in this slice's scope.
