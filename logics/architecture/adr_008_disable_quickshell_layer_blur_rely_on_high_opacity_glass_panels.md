## adr_008_disable_quickshell_layer_blur_rely_on_high_opacity_glass_panels - Disable Quickshell layer blur; rely on high-opacity glass panels
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: SceneFX layer blur produces a white-fringe halo on rounded layer surfaces on this Intel Xe GPU.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Turn off layer blur globally and fake the glass feel with high-opacity translucent panels.

# Context
- blur_layer=1 causes a white-fringe halo around rounded-corner layer surfaces on Intel Xe, landscape outputs only.
- Per-surface layerrule = noblur did not reliably suppress it.
- Window-content blur (blur=1) is unaffected.

# Decision
- Set blur_layer=0 globally.
- Use high-opacity translucent panels (glassBg 0.96, glassBgLight 0.93) for the glass feel.

# Consequences
- Loses true layer blur but avoids the halo artifact.
- Window-content blur still works normally.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
