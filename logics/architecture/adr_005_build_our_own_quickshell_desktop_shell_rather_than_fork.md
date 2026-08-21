## adr_005_build_our_own_quickshell_desktop_shell_rather_than_fork - Build our own Quickshell desktop shell rather than fork
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Need a desktop shell matching the curated Archeotech aesthetic that runs on MangoWC.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Build the shell in-house, mining reference projects for patterns rather than forking Noctalia or AMBXST.

# Context
- Noctalia has MangoWC support and polish; AMBXST is feature-rich but Hyprland-only.
- Material You aesthetic is incompatible with Archeotech's theme identity.
- The existing foundation (Appearance singleton, MangoWC IPC layer) is sound.

# Decision
- Build-own the shell; use reference projects for patterns, not aesthetics.
- Adopt a source-checking rule: before implementing any workaround, check how reference projects (MangoWC->Noctalia; QML->end-4; components->Caelestia; lock screen->Qylock; install->HyDE/JaKooLit) solve it.

# Consequences
- AMBXST's Hyprland-only IPC would have needed a rewrite anyway.
- A curated steal-from list documents which pattern comes from which project (full catalog in .claude/ANALYSIS.md 2).

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
