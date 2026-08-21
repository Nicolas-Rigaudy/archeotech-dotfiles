## item_062_desktop_widget_layer_sprint_21_chunk_3_deferred - Desktop widget layer (Sprint 21 Chunk 3, deferred)
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
- Summary: A desktop-level widget layer (clock/stats/media) on WlrLayer.Bottom with intra-window drag, grid snap, and persisted positions — Sprint 21 Chunk 3, deferred after the lock-screen work.
- Keywords: desktop, widget, layer, wlrlayer, draggable, peek-desktop, deferred
- Use when: Picking up the parked Chunk 3 desktop-widget work, or scoping desktop widgets against the module/builder system.
- Skip when: Working on bar/strip/panel widgets (those are the existing holder system, not this bottom desktop layer).

# Problem
- Sprint 21 Chunks 0-2 shipped the module builder + community extension system, but Chunk 3 (the desktop widget layer) was deferred and never built.
- There is no way to place widgets directly on the desktop background (clock, system stats, media player) independent of the bar/strip/panel holders.
- Deferred originally because it was scheduled after the lock screen, and the lock-screen sprint (S23) was cancelled — leaving this parked.

# Scope
- In:
  - `Modules/DesktopWidgets/WidgetLayer.qml` on `WlrLayer.Bottom` (separate PanelWindow, independent of ShellSurface) + a "peek desktop" access (mango corner action / keybind).
  - `Modules/DesktopWidgets/DraggableWidget.qml` — intra-window drag (Wayland-safe), grid snap, boundary clamp, persist x/y to config (Noctalia pattern).
  - At least 3 desktop widgets: `DesktopClock`, `DesktopSystemStats`, `DesktopMediaPlayer`.
  - `panel-content` via `PanelRegistry` proper + a `desktop-widget` `canLiveIn` target wired through the builder palette.
- Out:
  - Bar/strip/panel holder widgets (existing system).
  - The broader plugin manager / per-instance config work (separate backlog items).

# Acceptance criteria
- AC1: A desktop widget layer renders on `WlrLayer.Bottom` as its own PanelWindow, with a "peek desktop" corner action / keybind.
- AC2: Widgets are draggable within the layer (grid snap + boundary clamp) and their x/y positions persist to config across restarts.
- AC3: At least three desktop widgets ship: `DesktopClock`, `DesktopSystemStats`, `DesktopMediaPlayer`.
- AC4: Desktop widgets are assignable through the builder palette via a `desktop-widget` `canLiveIn` target and `PanelRegistry`.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: delivers the desktop-widgets feature named in request-AC2 (new widgets/panels/shell features).

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
- Priority: Low
- Rationale: Deferred since Sprint 21; parked after the S23 lock-screen sprint was cancelled. A nice-to-have desktop surface, not on the critical path to v1.0.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
