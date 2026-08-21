## adr_001_mangowc_as_primary_compositor_hyprland_as_fallback - MangoWC as primary compositor, Hyprland as fallback
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Need a Wayland compositor whose base and event model fit the QML shell workflow and portal stack.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Run MangoWC (wlroots-based) as the daily compositor with a retained Hyprland config as a fallback.

# Context
- wlroots base aligns with xdg-desktop-portal-wlr.
- Scrolling layout suits the workflow.
- mmsg -w streams events cleanly into Quickshell Process + SplitParser.

# Decision
- Adopt MangoWC over Hyprland as the primary compositor.
- Keep the Hyprland config as a fallback for the rare day MangoWC breaks.
- Use xdg-desktop-portal-wlr (not -hyprland) since MangoWC is wlroots-based, configured at ~/.config/xdg-desktop-portal/mangowc-portals.conf so it is stow-managed.

# Consequences
- Smaller community than Hyprland.
- No Quickshell.Hyprland native bindings — a custom Services/Compositor/MangoWC.qml IPC layer is required.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
