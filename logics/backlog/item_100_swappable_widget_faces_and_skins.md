## item_100_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-09 17:59:31

# AI Context
- Summary: Deliver swappable faces on the shell's large content surfaces (dashboard cards / panels) — a host-agnostic face contract proven on `DashCard._content`, with SystemStatus (bars/gauges/compact) + MediaPanel (full/compact) as reference targets; bar-widget faces reuse the same contract secondarily. The headline "change a widget's LOOK, not just its presence" feature for roadmap 0.26, value-gated by a gauges spike.
- Keywords: swappable, faces, DashCard, SystemStatus, MediaPanel, gauges, variant, registry
- Use when: extending WidgetRegistry's resolver, wiring a face picker into ConfigForm/EditOverlay, or authoring multi-face reference widgets.
- Skip when: adding a new widget TYPE; theme-pack visual restyle (req_001); the DnD builder mechanics themselves (item_022); motion plumbing (req_002).

# Problem
A widget should have looks, not just presence. Extend the filename-convention contract (adr_010) so a widget declares variants `{id:{file,label,constraints}}`; expose a face picker; variants honor per-instance config (adr_022) and hot-reload.
Scope IN: a variant/face registry extension of adr_010; per-widget face declaration with size/aspect constraints; a face picker in the builder (item_022) / ConfigForm (item_063); at least two reference multi-face widgets.
Scope OUT: new widget types; the DnD spatial builder itself (item_022); theme/pack visual restyle (req_001); motion plumbing (req_002).

# Scope
- In (primary — large content surfaces, where faces earn their keep):
  - A host-agnostic face contract: a face declares `{id,file,label,constraints}`; a host resolves declared faces + renders the selected one via a content `Loader`, with clean default fallback. Proven on the `DashCard._content` slot.
  - Reference target A — **SystemStatus card**: `bars` (labelled % rows, today) / `gauges` (radial arcs) / `compact` (sparkline strip), same cpu/ram/disk/bat data.
  - Reference target B — **MediaPanel**: `full` (art + transport side-by-side) / `compact` (small art + play/pause).
  - Face selection persists + hot-swaps live (swap inner content source only; keep the data-bearing shell mounted).
- In (secondary — reuse the same pattern on the bar):
  - `WidgetRegistry` variant contract (`variantsFor`/`defaultVariant`/variant-aware `widgetFile`, adr_010) + `__face` reserved key in per-instance config (adr_022) + a face-picker row in ConfigForm/EditOverlay.
- Out:
  - Bar-icon faces as the *proof* (a clock's 12/24h+seconds is already config, not a face); new widget TYPES; theme/pack restyle (req_001); DnD builder mechanics (item_022); motion plumbing (req_002)
  - Full holder-aware responsive reflow (item_064) — faces only declare advisory constraints here
  - Building the dashboard customizable-grid config store (item_046) — card-face persistence uses the minimum needed and defers the grid work

# Acceptance criteria
- AC1: A host-agnostic face contract — a face declares `{id,file,label,constraints}`; a host resolves declared faces + renders the selected one via a content `Loader`, falling back to the default on unknown/absent id. Proven first on the `DashCard._content` slot; the same pattern is reusable by the bar `WidgetRegistry` (`variantsFor`/`defaultVariant`/variant-aware `widgetFile`, adr_010). Verify: a card/widget with ≥2 declared faces resolves each by id and falls back cleanly.
- AC2: Face selection persists + hot-swaps live without a full remount (swap only the inner content source; keep the data-bearing shell + props mounted). Cards persist in a minimal dashboard/card settings key (relates item_046); bar widgets persist in per-instance config under a reserved `__face` key (adr_022), surfaced by ConfigForm (item_063) / Builder EditOverlay (item_022). Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: switching a face updates the rendered surface and survives reload.
- AC3: At least two multi-face reference targets ship on large surfaces: (a) **SystemStatus card** — `bars` / `gauges` / `compact` over the same cpu/ram/disk/bat data; (b) **MediaPanel** — `full` / `compact`. Verify each face renders headless via `HOME=/home/corvus ./scripts/shot.sh --state dashboard|media`.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: host-agnostic face contract proven on `DashCard._content`, reusable by the bar `WidgetRegistry`; ≥2 faces resolve by id with clean default fallback.
- request-AC2 -> This backlog slice. Proof: face selection persists + hot-swaps live by swapping only the inner content source (cards → dashboard settings key; bar widgets → `__face` per-instance config), verified headless.
- request-AC3 -> This backlog slice. Proof: SystemStatus (bars/gauges/compact) + MediaPanel (full/compact) ship as multi-face reference targets, each face self-contained, verified via shot.sh state-driving.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `logics/request/req_003_swappable_widget_faces_and_skins.md`
- Primary task(s): (none yet)

# Priority
- Priority: High
- Rationale: Load-bearing for the 0.26 exit signal ("widgets configure + change face from the manager pane") — the configure half is Done (item_063); this is the change-face half. Unblocks the milestone's headline capability.

# Notes
- Hybrid rationale: Derived from request `req_003_swappable_widget_faces_and_skins` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_003_swappable_widget_faces_and_skins.md`.
- Generated locally by logics-manager.

# Tasks
- `task_030_swappable_widget_faces_and_skins`
