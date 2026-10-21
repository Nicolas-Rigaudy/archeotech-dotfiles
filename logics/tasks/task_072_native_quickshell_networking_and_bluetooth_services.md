## task_072_native_quickshell_networking_and_bluetooth_services - Native Quickshell Networking and Bluetooth services
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 50%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: Move shell services off spawned nmcli/busctl/gdbus processes onto Quickshell's native modules; Bluetooth and SystemClock done, Network/VPN blocked on missing native data.
- Keywords: native, quickshell, networking, bluetooth, services
- Use when: Working on Services/Networking or clock timers.
- Skip when: Lock screen, polkit (out of scope).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_121_native_quickshell_networking_and_bluetooth_services`

# Acceptance criteria
- AC1: No nmcli or bluetoothctl process is spawned for state tracking.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_072_native_quickshell_networking_and_bluetooth_services.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_072_native_quickshell_networking_and_bluetooth_services.md` after implementation.

# Validation
- command: tests/run.sh 79 pass, tests/py 35 OK, qmllint-ci rc 0, token-lint 0; headless shot.sh renders on night/fallback: popup:bt and setting:connections.bluetooth list the same 3 paired devices, power and trusted stars as the busctl version (same order after sorting by address); dashboard and setting:clock.format with clock.seconds on; a 3-frame burst shows the bar clock ticking (21:36:11/14/16). Renders in cr-0w/local/state/night/shots/fallback-2026-10-21/ | result: passed | date: 2026-10-21. Connect, disconnect, power, trust and forget were not exercised: they would change the owner's real devices.

# Report
- Bluetooth (e845ecd): Services/Networking/Bluetooth.qml reads adapter power, the device list (name, address, connected, paired, trusted, battery) from Quickshell.Bluetooth and does power, connect (trust first), disconnect, trust and forget through the native objects. The gdbus monitor, the per-device busctl loop and the 3 s fallback poll are gone, as is the hci0 hard-wiring (default adapter now). The public contract is unchanged. Discovery and pairing stay on bt-agent.py, which registers the SSP agent Quickshell does not provide.
- SystemClock (cc9b18b): bar clock, dashboard clock/greeting, the Settings clock preview and ColorScheme's day/night switch tick on wall-clock boundaries (seconds only when shown) instead of free-running 1 s / 60 s timers.
- Not done: LazyLoader adoption. It changes when surfaces like the OSD first map (fade timing), which is a visible behaviour change; left for a pass with a burst-capture check.
- Paused, needs a product decision: Network and VPN. Quickshell 0.3.2's Networking module has no Wi-Fi frequency (the bar tooltip and Connections pane show "5 GHz"/"2.4 GHz"), no per-saved-network auto-join (the pane's Auto-join toggle; NMSettings is opaque), no BSSID and no VPN connections at all. Options: (a) keep nmcli for Network and VPN until Quickshell exposes these (AC1 stays open for them); (b) go native for connection state, signal, Wi-Fi power and scan, keep one nmcli read only for band and auto-join, and keep VPN on nmcli; (c) go fully native and drop the band and Auto-join displays. Recommendation: (b), which removes the `nmcli monitor` and most spawns without losing anything the UI shows.
- Owner check: connect and disconnect a headset from the bar popup and Settings, toggle Bluetooth power, and see the spinners clear.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
