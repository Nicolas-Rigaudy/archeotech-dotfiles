## adr_025_system_tray_via_quickshell_systemtray_qt6ct_platform_theme - System tray via Quickshell SystemTray + qt6ct platform theme
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The shell had no SNI host, and on bare wlroots Qt has no platform theme so themed tray IconNames resolve to a magenta placeholder.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Add a Quickshell SystemTray host under QApplication mode and install qt6ct so SNI icons resolve on bare wlroots.

# Context
- The old bar tray was hand-built widgets — no StatusNotifierItem app could appear.
- Platform context menus via QsMenuAnchor require QApplication mode.
- SNI apps send themed IconNames; gsettings/kdeglobals alone did not work — Qt6 needs the platform-theme plugin to read an icon theme.

# Decision
- Add Widgets/Bar/TrayWidget.qml over Quickshell.Services.SystemTray and give shell.qml //@ pragma UseQApplication; left-click opens the menu.
- Install qt6ct with QT_QPA_PLATFORMTHEME=qt6ct (environment.d + explicit in mango-reload.sh), icon_theme Papirus (base, has user-* status icons), darker color scheme.
- Also add config/.config/environment.d/path.conf (PATH=$HOME/.local/bin:$PATH) so autostarted apps find ~/.local/bin binaries.

# Consequences
- TrayWidget is deliberately NOT in the default shell-config.json — without qt6ct a stranger gets a magenta placeholder, so it's a palette widget users place themselves.
- QtWidgets is a superset of QGuiApplication, no downside seen.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
