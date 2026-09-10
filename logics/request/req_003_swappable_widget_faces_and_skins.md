## req_003_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 85
> Confidence: 80
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-09-10 16:16:54

# AI Context
- Summary: Give every widget interchangeable "faces"/skins (visual variants) selectable per instance via a data-driven variant registry — the user picks a widget's LOOK, not just whether it is present. Candidate work from ANALYSIS.md §20 (three shells converged on this independently).
- Keywords: swappable, widget, faces, skins, variants, registry
- Use when: extending the widget contract/registry, adding widget visual variants, or wiring a face picker into the builder/ConfigForm.
- Skip when: adding a brand-new widget TYPE (that is the widget itself); theme-wide restyle (req_001); the DnD builder mechanics (item_022).

# Needs
- A widget should have looks, not just presence. Extend the filename-convention contract (adr_010) so a widget declares variants `{id:{file,label,constraints}}`; expose a face picker; variants honor per-instance config (adr_022) and hot-reload.
- Scope IN: a variant/face registry extension of adr_010; per-widget face declaration with size/aspect constraints; a face picker in the builder (item_022) / ConfigForm (item_063); at least two reference multi-face widgets.
- Scope OUT: new widget types; the DnD spatial builder itself (item_022); theme/pack visual restyle (req_001); motion plumbing (req_002).

# Context
- Reference sources (ANALYSIS §20.1 "swappable widget looks"): Serpantinum faces (Clock Analog/Digital/Minimal, Weather Compact/Full/Round) + a data-driven `WidgetRegistry` (`type->{defaultVariant, variants:{id:{file,icon,label}}}`); Ambxst variants; dhrruvsharma `workspacedisc` skins. Each face is a self-contained `.qml` declaring its own min/max aspect constraints.
- Relates: adr_010 (filename-convention registry — the seam to extend), item_022 (builder registry + face picker home), item_063 (Done — ConfigForm/plugin manager), holder_aware_panels (responsive faces), adr_022 (per-instance config).

# Acceptance criteria
- AC1: A **host-agnostic face contract** — a face declares `{id, file, label, constraints}`, and a host resolves the declared faces + renders the selected one via a `Loader` slot, falling back to the default on an unknown/absent face id. Proven first on the **DashCard content slot** (the primary, high-value surface — `DashCard._content`), and the same pattern is reusable by the bar `WidgetRegistry` (`variantsFor`/`defaultVariant`/variant-aware `widgetFile`) as a secondary application. Verify: a card/widget with ≥2 declared faces resolves each by id and falls back cleanly.
- AC2: The user picks a face and the choice **persists + hot-swaps live** without a full remount. For cards, face selection persists in a dashboard/card config store (relates item_046 customizable grid / item_049); for bar widgets, in per-instance config under a reserved key (adr_022) surfaced by ConfigForm (item_063) / Builder EditOverlay (item_022). Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: switching a face updates the rendered surface and survives a reload.
- AC3: At least two multi-face reference targets ship on **large content surfaces** (dashboard cards / panels — where layout genuinely varies and config can't express the difference), each face a self-contained `.qml`: (a) the **SystemStatus** dashboard card — labelled `bars` vs. radial `gauges` vs. `compact` sparkline over the same cpu/ram/disk/bat data; (b) the **MediaPanel** — `full` (art + transport side-by-side) vs. `compact` (small art + play/pause). Verify: each face is selectable and renders correctly headless via `HOME=/home/corvus ./scripts/shot.sh --state dashboard|media`. NOTE: bar-icon faces are explicitly de-scoped as the proof — a bar clock's 12/24h+seconds is already config, not a face; faces earn their keep only where the variants are structurally different render trees.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Dependencies & Risks
- Primary surface = **dashboard cards / panels** (`DashCard._content`, `Modules/Shell/Panels/Content/*`) — where the alternatives are structurally different render trees (SystemStatus bars/gauges/compact; MediaPanel full/compact) and config genuinely can't express them. Bar-icon faces are the secondary, lower-value application.
- Depends on: `DashCard` (the content-slot seam), adr_010 (bar registry convention — the secondary seam), adr_022 (per-instance `{id,config}` — bar-widget face persistence). Relates item_046 (dashboard customizable grid — likely home for card-face persistence), item_049 (system-notes/data), item_063 (Done — ConfigForm), item_022 (Builder EditOverlay), item_064 (holder-aware panels — advisory face constraints).
- OPEN QUESTION: cards are singletons composed directly in `Dashboard.qml` (no per-instance config today) — decide where a card's face persists (a small dashboard/card settings key vs. riding item_046's grid config). The bar path already has per-instance config; the card path does not yet.
- Risk: reserved face key could collide with a widget's own config field — namespace it (e.g. `__face`) and exclude it from the widget-authored schema.
- Risk: remounting the face on change flickers/resets state — swap only the inner content `Loader.source`, keeping the card/holder shell + data props mounted (the data-bearing component owns cpu/ram/etc.; faces are pure presentation bound to it).
- Risk (scope creep): "skins" can bleed into theme-pack restyle (req_001) — keep faces = structural layout variants, not palette/ornament; those stay in the theming engine.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_010 (widget registry contract — the seam this extends).

# References
- `.claude/ANALYSIS.md` (§20.1 swappable widget looks; §20.3 rec 2)
- `logics/architecture/adr_010_widget_panel_registry_noctalia_filename_convention_with_a_holderroot_contract.md`

# Backlog
- `item_100_swappable_widget_faces_and_skins`
