## adr_011_dissolve_control_center_into_bar_one_unified_settings_side_panel - Dissolve Control Center into bar + one unified Settings side panel
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Control Center was a catch-all with duplicated functionality (WiFi list in three places) that fought the one-ShellSurface model.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Remove Control Center, make the bar the quick-action surface and Settings a right-strip panel, and unify all appearance controls into one Appearance home.

# Context
- The WiFi network list was implemented in three places (bar WifiPopup, CC, ConnectionsPane).
- Settings was a FloatingWindow; theme, wallpaper and logo were split across surfaces and couldn't reach each other.
- Panels are global — open on every screen or none (opening via bar gear / IPC was already global, so per-screen open/close was asymmetric).

# Decision
- Remove Control Center; bar = quick actions, Settings = deep config as a PanelRegistry panel on the right strip sharing the single-open model.
- Unify theme + wallpaper + logo + typography + geometry into one Settings -> Appearance pane, with the Super+W bottom panel as a compact quick-switcher sharing extracted ThemeGridBody/WallpaperPickerBody bodies.
- Panels open/close across all screens (toggleGlobal / isOpenAnywhere / closeAllAcross).

# Consequences
- Settings is now a large right-edge drawer rather than a movable/resizable window.
- A panel cannot be shown on only one screen — accepted for a single-user multi-monitor desktop.
- Supersedes the prior Settings-standalone-window, CC-quick-access-only and wallpaper-picker-first-class-panel decisions.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
