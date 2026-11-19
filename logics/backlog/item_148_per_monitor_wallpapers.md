## item_148_per_monitor_wallpapers - Per-monitor wallpapers
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 95%
> Confidence: 85%
> Progress: 35%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-19 17:26:05

# AI Context
- Summary: Per-screen wallpapers: a fit mode per output (fill, fill + anchor, fit + blur, fit + stretched edges), a different image per output, and a Span mode, edited from a monitor arrangement in Settings > Appearance > Wallpaper; wallpaper-set routes each image to its output.
- Keywords: per, monitor, wallpapers, fit, fill, portrait, span, anchor
- Use when: Multi-monitor wallpaper setups, portrait outputs, how an image is fitted to a screen.
- Skip when: Per-workspace wallpapers (item_033).

# Problem
- All outputs show the same wallpaper, and a portrait output (DP-3 at work, 1080x1920) gets a landscape image shrunk to fit with a blurred, darkened copy filling the rest. That fit is hard-coded in `scripts/wallpaper-set.sh` (`_compose_at_size`, `_prepare_plain_portrait`) with no setting; the owner wants it to fill (2026-11-19).

# Scope
- In:
  - Fit mode per output, a pick-one selector: Fill (centre crop), Fill + anchor (Left / Centre / Right), Fit + blur (today's look), Fit + edges (the image fitted, the bars filled by stretching its outermost rows or columns outward, softened; owner picked "edges stretched" over gradient, mirror and solid colour from renders, 2026-11-19).
  - Default fit for every output: Fill, centre crop (replaces today's automatic blur on portrait outputs).
  - Wallpaper layout mode: Same on all | Per screen | Span. Per screen gives each output its own image; Span crops one image across all outputs as one canvas using their logical positions and sizes.
  - Per-output slots combined with per-mode (item_140): in Per screen, each output keeps a light and a dark image; pack wallpapers (item_151) stay offered as today.
  - Editor in Settings > Appearance > Wallpaper: the outputs drawn as in the Display pane (reuse `Modules/Settings/Widgets/DisplayArrangement.qml`, read-only: no dragging), each showing its wallpaper; click an output, then its Fit selector (and Anchor when Fill + anchor) below it, and the existing picker carousel targets that output. The layout-mode switch sits in the section header.
  - wallpaper-set: apply an image to one output with a fit and anchor; a span pass that cuts per-output crops. The logo overlay follows the same fit: composite cache keys include fit, anchor and output size (today only l/p).
  - Outputs not in the config (dock/undock, wildcard monitor rules) use the "all" settings.
- Out:
  - Per-workspace wallpapers (item_033).
  - Moving monitors from the wallpaper editor (that stays in the Display pane).

# Acceptance criteria
- AC1: Each connected output can show its own wallpaper set from the picker, and it survives a restart.
- AC2: Each output has a Fit selector (Fill, Fill + anchor, Fit + blur, Fit + edges); a landscape image on the portrait output fills it by default, and the logo overlay follows the chosen fit.
- AC3: Span shows one image across all outputs, each output showing its part of the arrangement.
- AC4: An output that is not configured shows the "all" wallpaper and fit; light/dark follow and pack wallpapers keep working in every layout mode.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC1: Each connected output can show its own wallpaper set from the picker, and it survives a restart.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `logics/request/req_006_wallpaper_modes.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Owner runs three outputs at work, one portrait; the current blur fit on it is the trigger (2026-11-19).

# Notes
- Owner decisions 2026-11-19 (from renders of the fit options on the current wallpaper at 1080x1920): fill by default; offer fill + anchor, keep fit + blur as an option, bars filled by stretched image edges; per-screen images and Span in scope; editor = arrangement + picker (ASCII preview chosen over a list of screens).
- Delivery waves: (1) fit modes in wallpaper-set + config + Fit selector, applied to all outputs (fixes the portrait screen alone); (2) per-screen images, slots and the arrangement editor; (3) Span.
- Depends on item_146 only for who calls wallpaper-set; wave 1 can land before it.
- Hybrid rationale: Derived from request `req_006_wallpaper_modes` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_006_wallpaper_modes.md`.
- Generated locally by logics-manager.

# Tasks
- `task_084_per_monitor_wallpapers`
