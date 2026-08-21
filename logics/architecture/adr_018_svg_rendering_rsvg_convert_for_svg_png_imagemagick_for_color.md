## adr_018_svg_rendering_rsvg_convert_for_svg_png_imagemagick_for_color - SVG rendering: rsvg-convert for SVG->PNG, ImageMagick for color
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: ImageMagick's SVG renderer fills transparency with white, breaking alpha in composited wallpapers/logos.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Use rsvg-convert for SVG->PNG conversion and keep ImageMagick only for color extraction and final compositing.

# Context
- ImageMagick's SVG renderer fills transparency with white.
- rsvg-convert (librsvg) preserves alpha correctly.

# Decision
- Use rsvg-convert for any SVG->PNG conversion.
- Keep ImageMagick for histogram color extraction and final compositing.
- For QML preview tiles, do LOGO_COLOR/LOGO_OPACITY substitution in-memory via FileView + a data: URI, so there are no committed preview duplicates.

# Consequences
- Single source of truth for logo previews with negligible per-mount substitution cost.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
