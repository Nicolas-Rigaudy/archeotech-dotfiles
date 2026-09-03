## adr_028_visual_builder_dnd_intra_surface_mock_drag_with_click_to_assign_fallback - Visual Builder DnD intra-surface mock drag with click-to-assign fallback
> Date: 2026-09-03
> Status: Proposed
> Related request: `req_000_archeotech_shell_dotfiles`
> Related backlog: `item_022_visual_builder_drag_and_drop_spatial_zone_representation`
> Related task: (none yet)
> Drivers: User prefers drag-and-drop over click-to-assign for the Module Builder; ANALYSIS §14.4 had rejected only cross-window drag and deferred intra-window DnD to backlog (item_022). Caffyne (Fabric/GTK) research 2026-09-03 supplied a proven, portable mechanism.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Adopt pointer drag-and-drop for the Visual Builder by dragging widget chips on a to-scale mock rendered inside the single EditOverlay surface (intra-surface, so Qt DnD is reliable); keep click-to-assign as the keyboard-accessible fallback. Supersedes only the DnD-half of ANALYSIS §14.4.

# Context
- ANALYSIS §14.4 chose click-to-assign because *cross-window* drag on Wayland is unreliable (QML Drag/DropArea are single-window; documented cross-surface MIME/state-leak bugs). The DECISIONS note (2026-06-03) explicitly deferred *intra-window* DnD to backlog.
- item_022 already scopes this: intra/cross-zone drag of chips on a to-scale mock, persisting via ShellConfig; cross-window drag is out of scope.
- Locked architecture (ADR 015 / §15): one full-screen PanelWindow per monitor; EditOverlay is a single surface. So a drag that targets the mock — not the live bars — never crosses a surface boundary, which is exactly the reliable case for Qt DropArea.
- Caffyne research (2026-09-03, ANALYSIS §20 pending) demonstrated the full pattern shipping in a GTK shell: global drag-state instead of the DnD payload, a drop placeholder, a grabbed-image drag icon, and applet grouping guarded by an incompatibility set.

# Decision
- Drag target is the to-scale mock inside EditOverlay, never the live bars. All drag stays intra-surface; cross-monitor placement remains out of scope (unchanged from §14.4).
- Global drag-state singleton: reuse Commons.State.editMode; add draggedKey/draggedSource. Drag.mimeData carries only a small locator ("zone:index"); the widget key lives in the singleton (Caffyne "globals-not-payload" trick) to avoid Wayland MIME flakiness.
- Each mock zone is a DropArea; each chip a draggable Item. On drag-hover, insert a styled placeholder gap at the computed insertion index (animate reflow via Behavior). Drag icon via Item.grabToImage() -> Drag.imageSource.
- On drop, rewrite the ShellConfig zones order; existing write -> hot-reload -> re-sync applies it (AC3).
- Applet grouping (stretch): a chip reserves a group-zone; dropping chip B onto chip A's group-zone merges them into a combined pill, guarded by an incompatibleGroups set with valid/invalid affordance.
- Click-to-assign is retained as the keyboard path (Tab/Enter); both paths write the same config. DnD is additive, not a replacement.
- Antialias any interactive Shape with preferredRendererType Shape.CurveRenderer; never wrap interactive drag content in layer.enabled (hit-testing rule).

# Consequences
- First time we animate DnD (and possibly an input mask) in-surface. Qt DropArea within one window is reliable, but requires a real-device smoke test on MangoWC + Hyprland (grim/manual, not the headless fake-HOME) before closeout.
- Cross-monitor widget placement still needs click-to-assign; the mock could later add a per-monitor switcher rather than cross-surface drag.
- Grouping adds an incompatibleGroups contract that widget authors must be aware of (relates to the plugin/registry contract, ADR 010/016).
- §14.4's click-only stance remains valid for the cross-window case; this ADR narrows it, it does not fully replace it.

# References
- Related request: `req_000_archeotech_shell_dotfiles`
- Related backlog: `item_022_visual_builder_drag_and_drop_spatial_zone_representation`
- Related task: (none yet)
