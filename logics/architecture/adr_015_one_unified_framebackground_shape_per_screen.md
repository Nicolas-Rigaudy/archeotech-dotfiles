## adr_015_one_unified_framebackground_shape_per_screen - One unified FrameBackground Shape per screen
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Translucent glass makes overlapping per-side pieces double their alpha and show seams, and different-thickness sides can't share a clean corner.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Draw the whole resting frame as one filled SVG path per ShellSurface instead of separate per-side bodies plus corner pieces.

# Context
- Semi-transparent glass means any two overlapping pieces double alpha and show a visible seam.
- Adjacent sides of different thickness (30px bar vs 10px strip) can't share a clean dynamically-sized corner as separate tiling pieces.
- Replaces 4 CornerBlend Items plus per-side body fills.

# Decision
- Draw everything as one FrameBackground.qml Shape/PathSvg (WindingFill) per screen: horizontal bands + vertical bands between them + concave fillet wedges at active junctions.
- Bar/Strip Items become transparent containers hosting only widgets; outer corners round in pill mode and stay sharp in framed via radius-0 arcs.
- setSideType resets size to the type default (bar 30 / strip 10) on every switch, since FrameBackground sizes bands from sideGap.

# Consequences
- Corner geometry is now JS-computed SVG path strings, rebuilt via an explicit Connections on ShellConfig.onDataChanged (binding-through-function tracking was unreliable).
- Frame corners are decorative and no longer in the input mask (clicks pass through).

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
