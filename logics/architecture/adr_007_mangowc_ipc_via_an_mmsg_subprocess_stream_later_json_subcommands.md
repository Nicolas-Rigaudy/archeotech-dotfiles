## adr_007_mangowc_ipc_via_an_mmsg_subprocess_stream_later_json_subcommands - MangoWC IPC via an mmsg subprocess stream (later JSON subcommands)
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: MangoWC has no QML bindings and the only upstream-safe binding lives in a custom fork.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.
> Indicators reviewed: 2026-09-03 16:43:15

# Overview
- Stream MangoWC events from mmsg over stdout into Quickshell, parsing line-by-line, staying off the non-upstream Quickshell.DWL fork.

```mermaid
flowchart LR
  MM[mmsg -w JSON watch streams]
  PR[Quickshell Process + SplitParser]
  API[Compositor public API]
  QS[Quickshell consumers - workspaces windows]
  MM --> PR --> API --> QS
```

# Context
- Noctalia's MangoWC backend uses Quickshell.DWL, which is not upstream — it lives in a custom fork.
- Later the AUR package was renamed mangowc -> mangowm and updated to 0.15.5 to pull in wlroots 0.20 for a dock-undock output-hotplug freeze.
- The mangowm update rewrote mmsg IPC from old flags to get/watch/dispatch subcommands emitting JSON.

# Decision
- Parse mmsg -w output line-by-line via Quickshell Process + SplitParser instead of depending on the DWL fork.
- On the mangowm migration, port all consumers to the JSON subcommand interface (MangoWC.qml two JSON watch streams, mango-reload.sh, theme-switch.py) keeping the same public API.

# Consequences
- Subprocess overhead, fragile text parsing, and parser re-spec on any mmsg output-format change.
- pkill -x mango kills the real session compositor, so nested-compositor teardown must kill by captured PID.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
