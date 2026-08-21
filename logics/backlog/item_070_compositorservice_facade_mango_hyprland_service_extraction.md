## item_070_compositorservice_facade_mango_hyprland_service_extraction - CompositorService facade + Mango/Hyprland service extraction
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Builds a CompositorService facade with a stable API, extracts today's MangoWC code into MangoService, adds HyprlandService, and routes all 11 mmsg call sites through the facade.
- Keywords: compositorservice, facade, mango, hyprland, service, extraction
- Use when: Working on the compositor abstraction layer, MangoService/HyprlandService implementations, or removing direct mmsg calls from widgets.
- Skip when: Working on the actual Hyprland config file port, SDDM session, or reload script (see item_071), or on compositor docs (item_072).

# Problem
- There is a `Services/Compositor/MangoWC.qml` but no facade, so the UI is coupled directly to mango-specific `mmsg` calls in 9 QML files (11 call sites).
- Without an abstraction, adding Hyprland support means duplicating compositor logic across every widget that currently calls `mmsg` directly.
- The vision's "one codebase across compositors" pillar has never been exercised by a second real compositor implementation.

# Scope
- In:
  - `CompositorService.qml` facade: detects the active compositor and exposes a stable API (activeWorkspace/workspaces/focusedWindow/activeWindowTitle, switchWorkspace/focusWindow/moveToWorkspace, workspaceChanged/windowFocusChanged/outputsChanged signals)
  - `MangoService.qml`: extraction of today's `MangoWC.qml` mmsg stream/dispatch behind the facade API, no behavior change
  - `HyprlandService.qml`: built on the built-in `Quickshell.Hyprland` service (workspaces/monitors/toplevels/event stream), falling back to `hyprctl` for dispatch gaps
  - Routing all 11 `mmsg` call sites (shell.qml, Osd.qml, ShellPane/AboutPane, ShellExclusions, MangoWC.qml, TitleWidget/WorkspacesWidget, Carousel.qml) through `CompositorService.*`
- Out:
  - The Hyprland config file itself (keybinds/window rules/monitor/blur) and dual SDDM session (item_071)
  - docs/COMPOSITOR_SUPPORT.md (item_072)
  - Niri/Sway services (post-1.0)

# Acceptance criteria
- AC1: No QML file calls `mmsg` directly outside `MangoService.qml`; all 11 former call sites go through `CompositorService`.
- AC2: `HyprlandService` implements the same facade API as `MangoService` using `Quickshell.Hyprland` where available.
- AC3: Switching the active compositor at startup changes which service backs `CompositorService` with no widget-level code changes.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: the CompositorService facade and Mango/Hyprland service extraction are the core abstraction deliverable of milestone 0.29.

# Priority
- Priority: High
- Rationale: The facade is the architectural prerequisite every other 0.29 deliverable (Hyprland config, docs) depends on.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `logics/request/req_000_archeotech_shell_dotfiles.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
