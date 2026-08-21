## adr_019_composite_cache_keyed_per_wallpaper_logo_orientation - Composite cache keyed per (wallpaper, logo, orientation)
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The single-slot cache invalidated on any switch, forcing a 2-4s re-render every time.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Cache each composite as its own file keyed by sha1 of the wallpaper path plus logo and orientation, with background warming.

# Context
- The original cache was single-slot (one file + a flag storing <logo>:<wallpaper>).
- Switching anything invalidated it and forced a 2-4s re-render.

# Decision
- Store $CACHE_DIR/composed/<sha1>-<logo>-{l,p}.png files so cache hits are O(1) existence checks.
- Background-warm the other logos for the current wallpaper after every apply; --warm-all pre-renders every combination.

# Consequences
- Disk grows with usage (~167 MB for 16 wallpapers x 3 logos x 2 orientations); no automatic cleanup yet.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
