## item_083_theming_engine_ornament_asset_overlay_fx_pack_font_hook_flagship_gap - Theming engine: ornament asset-overlay FX + pack font hook (flagship gap)
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 85
> Confidence: 80
> Progress: 0%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Engine gap surfaced by the Shadow Spears flagship (item_082): the Layer-B decorator/FX vocabulary was geometric primitives only (colored brackets, edge glow, tiled texture) + a single shell-wide font — which can reskin colour/shape/motion but CANNOT express WH40K's identity (iconography, ornament, gothic type). Adds: (1) an ornament asset-overlay FX (`fx.ornaments` — pack SVG/PNG at frame anchors, "corners" auto-rotated); (2) a pack display-font hook (`font.displayFile`/`displayFamily` → `Appearance.font.display`, body stays mono); and confirms packs may carry their own full `colors` palette. Non-IP/open assets only (no GW-owned icons).
- Keywords: theming, engine, ornament, asset, overlay, pack, font, hook, flagship, gap, filigree, sigil, palette
- Use when: Extending the theming engine's decorator/FX or font surface, or when a pack needs iconography/ornament/display-type beyond tokens.
- Skip when: Authoring a concrete pack that the existing surface already covers.

# Problem
- The flagship stress test (item_082) proved the engine reskins colour/shape/motion well but has no way to place real ornament/iconography or a display font — so a strongly-themed identity (WH40K) reads as "recolor + brackets", not the theme. Filed back from item_082 per its "any engine gap feeds back" clause.

# Scope
- In:
  - Ornament asset-overlay FX (`fx.ornaments`) — SVG/PNG at frame anchors, tint TBD.
  - Pack display-font hook (shipped `.ttf`/`.otf` via FontLoader, or installed family) with body/display split.
  - Per-pack full palette override (already supported via Layer A `colors`; documented).
- Out:
  - Shipping actual GW-owned iconography (IP) — packs supply open/non-IP or hand-sourced art.
  - Pack-supplied wallpapers + set-active-on-switch (follow-up; same opt-in/reversible caution as window decor).

# Acceptance criteria
- AC1: The backlog slice stays bounded for theming engine: ornament asset-overlay fx + pack font hook (flagship gap).
- AC2: The backlog slice is reviewable and promotable into a task.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: (to be linked)
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
