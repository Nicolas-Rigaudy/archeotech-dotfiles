## adr_021_roadmap_extensibility_plugins_before_portability_hyprland_pulled_pre_v1_0 - Roadmap: extensibility/plugins before portability, Hyprland pulled pre-v1.0
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The product differentiator is customizability plus a plugin ecosystem, but a shell that only runs on MangoWC has near-zero addressable market.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Re-sequence to plugins-first before multi-compositor, then pull Hyprland forward to a pre-v1.0 co-equal target.

# Context
- Per-instance widget config (configSchema declared but unconsumed) was the last thing forcing users to hand-edit shell-config.json.
- Multi-compositor benefits other people's machines, so it was deemed later; Hyprland was already the tested backup.
- Later: Quickshell is compositor-agnostic and almost nobody runs MangoWC, dogfooding on both is the only forcing function for the facade, and a MangoWC dock-undock freeze made Hyprland a needed stability fallback.

# Decision
- Reorder to 26 Widget Extensibility & Plugin Manager -> 27 Dev Workflow Official Plugin -> 28 Distribution/v1.0, pushing multi-compositor + Go daemon behind v1.0.
- Make dev-workflow tooling the first official plugin (Obsidian model), not core.
- Pull Hyprland support + the CompositorService facade forward to pre-v1.0 (Sprint 29), Hyprland only — Niri/Sway stay post-v1.0; mango remains daily-driver primary.

# Consequences
- One more sprint before the v1.0 tag in exchange for a shell people can actually run.
- Cost is bounded — coupling is shallow (11 mmsg sites across 9 files) and built-in Quickshell.Hyprland does much of the workspace/window/event work.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
