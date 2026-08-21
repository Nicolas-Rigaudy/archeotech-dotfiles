## adr_023_wallpaper_picker_gotchas_file_paths_restart_not_reload_async_decode - Wallpaper picker gotchas: file:// paths, restart-not-reload, async decode
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Three subtle facts cost real debugging on the wallpaper picker redesign.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Strip the file:// prefix for Image.source, force a full shell restart for singleton rescans, and keep image decode async.

# Context
- StandardPaths.writableLocation returns a file:// URL, so 'file://' + Paths.cache produces file://file///... and the image silently fails.
- QML hot-reload does not reliably re-run singletons / Component.onCompleted one-time scans.
- asynchronous: false on an Image moves decode onto the open animation, making the open janky.

# Decision
- For a filesystem Image.source, strip with Paths.cache.replace(/^file:\/\//,'') then re-prefix once; find/Process stdout paths are already plain.
- mango-reload.sh (Super+Shift+R) must fully restart Quickshell (kill then relaunch last, after wlr-randr re-applies monitors), not reload-config-only.
- Keep Image async and make thumbnails tiny with a persistent model/view; set currentIndex (PathView has no positionViewAtIndex).

# Consequences
- The thumbnail file:// bug was masked by a fallback to decoding the full 4K/6K original, which looked like slow thumbnails for several iterations.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
