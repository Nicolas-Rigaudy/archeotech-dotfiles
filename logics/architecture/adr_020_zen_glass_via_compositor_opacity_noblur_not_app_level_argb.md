## adr_020_zen_glass_via_compositor_opacity_noblur_not_app_level_argb - Zen glass via compositor opacity + noblur, not app-level ARGB
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Zen's clean ARGB glass needs the WebRender native compositor, which is blocklisted on this Intel Xe / Mesa GPU.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Let MangoWC dim the whole Zen window (rendered opaque internally) instead of using app-level premultiplied ARGB.

# Context
- Force-enabling WebRender throws diamond/star artifacts on this GPU.
- kitty/VSCode get clean app-level ARGB glass, but Zen cannot.

# Decision
- Apply focused_opacity 0.88/0.75 and noblur:1 for appid:zen in MangoWC, Zen rendered opaque internally; Super+SHIFT+O toggles opaque for screen-share.

# Consequences
- Slightly more washed than app-level apps (compositor-vs-premultiplied-alpha gap, not config-fixable) but artifact-free.
- Revisit trigger is Mesa lifting the blocklist (full diagnosis in TROUBLESHOOTING.md).

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
