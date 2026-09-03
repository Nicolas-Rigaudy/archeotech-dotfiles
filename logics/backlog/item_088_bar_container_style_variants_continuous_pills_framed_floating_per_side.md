## item_088_bar_container_style_variants_continuous_pills_framed_floating_per_side - Bar container style variants continuous pills framed floating per side
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 65
> Confidence: 65
> Progress: 0
> Complexity: Medium
> Theme: Bar
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: A per-side "container style" for the bar/strip surface so the SAME widgets can re-chrome as one continuous bar, individual container-pills (transparent surface, each item/group in its own pill), a framed outline, or a single floating pill/island — selectable per side in shell-config. Makes the bar fully customizable so two setups can look wildly different. User wish 2026-09-03; peer rices widely use per-item container pills.
- Keywords: bar, container, pill, chrome, floating, framed, surface, per-side, holder, strip
- Use when: extending the bar/strip surface rendering and the shell-config per-side schema.
- Skip when: individual WIDGET looks (req_003 faces/skins); zone/widget assignment or the DnD builder (item_022); the theming-pack engine itself (req_001/adr_027).

# Problem
- The bar surface renders as one continuous glass `FrameBackground` behind transparent widgets. Many peer setups use per-item container pills / a single floating pill / a framed outline for radically different identities. Today the bar's chrome style is fixed, which caps how different two Archeotech setups can look.

# Scope
- In:
  - Add a per-side `containerStyle` (a.k.a. `chrome`) field to the shell-config per-side object `{ type, zones, size, outerGap, corners, containerStyle }` (hot-reload).
  - Variants: `continuous` (current — one bar surface); `pills` (transparent bar, each widget/group in its own token-styled `StyledRect`/`BarPill`); `framed` (outline/frame chrome, hollow); `floating` (the whole side as one rounded pill/island).
  - Rendering: the `FrameBackground`/bar surface + `BarPill` wrappers react to the style; configurable pill GROUPING (which adjacent widgets share one pill vs stand alone).
  - Works across all sides/types (bar/strip/holder) and each side can differ from the others (mixed looks in one setup).
  - Style the pill/frame via adr_027 surface-role recipes (token-driven), so theming packs can later drive it.
- Out:
  - Individual widget faces (req_003); zone/widget layout + DnD (item_022); building the theming-pack engine (req_001/adr_027 — this CONSUMES surface roles, it does not build them).

# Decision framing
- Product framing: Not needed
- Architecture framing: STRUCTURAL variant per adr_026's skin/structure boundary — `containerStyle` changes how the surface renders, not just tokens, so it is a config-driven layout option (Layer-C-adjacent), not a pure token overlay. Keep the widget/holder contract stable (adr_010/016); only the container chrome changes. Touches adr_015 (`FrameBackground`) and adr_012 (bar/strip popup masks — the input mask must follow whichever chrome is active).

# Acceptance criteria
- AC1: A per-side `containerStyle` config selects `continuous` / `pills` / `framed` / `floating` and hot-reloads.
- AC2: In `pills` mode the bar surface is transparent and each widget/group renders in its own token-styled pill; grouping is configurable.
- AC3: Styles work on all sides/types and can differ per side (two sides, two distinct looks) without breaking the input mask.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: a new per-side bar-chrome capability (continuous/pills/framed/floating) under req_000 AC2 (new widgets/panels/shell features).

# Links
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_015 (FrameBackground), adr_012 (bar/strip popup input mask), adr_027 (surface-role styling this consumes), adr_026 (skin/structure boundary)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
