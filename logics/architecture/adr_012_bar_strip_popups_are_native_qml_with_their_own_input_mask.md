## adr_012_bar_strip_popups_are_native_qml_with_their_own_input_mask - Bar/strip popups are native QML with their own input mask
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: External apps for WiFi/BT broke visual cohesion, and popups floating outside the surface rect passed clicks through.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Replace external tray apps with native Shape popups and extend the ShellSurface input mask to cover popup bounds on all sides.

# Context
- Bar WiFi/BT icons used to launch nm-connection-editor / blueman-manager.
- Bar popups float outside the SideLoader rect the input mask covers, so clicks passed through to windows behind.
- A layered (layer.enabled) Shape card swallowed/mis-mapped its own hover in size-dependent ways, causing an open/close oscillation.

# Decision
- Replace external apps with native Shape popups (top-5 networks + inline toggle), deep-linking full management to Settings -> Connections.
- Bar.qml exposes _anyPopupOpen + _popupBounds; ShellSurface mirrors it into a Region input mask, generalised from top-only to all four sides.
- Antialias interactive Shapes with preferredRendererType Shape.CurveRenderer, never layer.enabled.

# Consequences
- Bar popup capped at 5 entries; power users go to Settings.
- Any future bar/popup restructure must preserve the popup mask or popups become click-through.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
