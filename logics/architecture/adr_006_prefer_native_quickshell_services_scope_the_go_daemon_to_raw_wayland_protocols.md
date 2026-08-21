## adr_006_prefer_native_quickshell_services_scope_the_go_daemon_to_raw_wayland_protocols - Prefer native Quickshell services; scope the Go daemon to raw Wayland protocols
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The point of Quickshell is one coherent process; external daemons undermine that, but some Wayland protocols are unreachable from QML.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Use native Quickshell/QML APIs for everything with a working native binding and confine archeotech-daemon to protocols QML genuinely cannot reach.

# Context
- MPRIS, notifications, audio, battery, network, Bluetooth, WiFi radio all have working native QML/Quickshell APIs.
- All three reference shells split PipeWire (device listing) from pactl (volume control) the same way.
- wlr-output-management, wlr-gamma-control and wlr-screencopy are not reachable from Quickshell.

# Decision
- Use Quickshell.Services.Mpris and Notifications.NotificationServer instead of playerctl/swaync; Quickshell.Networking.wifiEnabled instead of nmcli radio.
- Use Quickshell.Services.Pipewire for device listing/switching, keep the working pactl subprocess for volume.
- archeotech-daemon (Go, Sprint 26) handles only wlr-output-management, wlr-gamma-control and wlr-screencopy.

# Consequences
- A PwObjectTracker instance on the active sink/source is mandatory boilerplate.
- One extra binary to build and a Go dependency in the project.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
