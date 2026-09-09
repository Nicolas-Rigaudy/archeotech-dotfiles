## item_100_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-09 15:38:29

# AI Context
- Summary: Deliver the swappable-face capability end to end — extend `WidgetRegistry` with a variant contract (adr_010 seam), add a face picker to ConfigForm + Builder EditOverlay writing to per-instance config (adr_022), and ship two multi-face reference widgets (Clock; a system-stat gauge/bars) as proof. The headline "change a widget's look, not just its presence" feature for roadmap 0.26.
- Keywords: swappable, widget, faces, skins, variant, registry, ConfigForm, face-picker
- Use when: extending WidgetRegistry's resolver, wiring a face picker into ConfigForm/EditOverlay, or authoring multi-face reference widgets.
- Skip when: adding a new widget TYPE; theme-pack visual restyle (req_001); the DnD builder mechanics themselves (item_022); motion plumbing (req_002).

# Problem
A widget should have looks, not just presence. Extend the filename-convention contract (adr_010) so a widget declares variants `{id:{file,label,constraints}}`; expose a face picker; variants honor per-instance config (adr_022) and hot-reload.
Scope IN: a variant/face registry extension of adr_010; per-widget face declaration with size/aspect constraints; a face picker in the builder (item_022) / ConfigForm (item_063); at least two reference multi-face widgets.
Scope OUT: new widget types; the DnD spatial builder itself (item_022); theme/pack visual restyle (req_001); motion plumbing (req_002).

# Scope
- In:
  - Variant contract on `WidgetRegistry` (`variantsFor`/`defaultVariant`/variant-aware `widgetFile`) extending the adr_010 filename convention
  - Reserved namespaced face key in per-instance config (adr_022); live face swap via `WidgetLoader.onConfigChanged`, persisted across `shell-config.json` reload
  - Face picker in ConfigForm (item_063) and Builder EditOverlay (item_022)
  - Two multi-face reference widgets: Clock (analog/digital/minimal) + a system-stat widget (radial gauge vs. horizontal bars), each face a self-contained `.qml` with aspect constraints
- Out:
  - New widget TYPES; theme/pack restyle (req_001); DnD builder mechanics (item_022); motion plumbing (req_002)
  - Full holder-aware responsive reflow (item_064) — faces only declare advisory constraints here

# Acceptance criteria
- AC1: `WidgetRegistry` exposes a variant contract — `variantsFor(id)` returns `{variantId:{file,label,constraints}}`, `defaultVariant(id)` returns the fallback, and `widgetFile(id,isStrip,variantId)` resolves a face's `.qml` — extending the adr_010 filename convention with NO per-plugin registry edit (a dropped face file + declaration is enough). Verify: a widget with ≥2 declared faces resolves each face's file by id, and an unknown/absent variantId falls back to the default without error.
- AC2: The user picks a widget's face per instance from ConfigForm (item_063) and the Builder EditOverlay (item_022); the choice is written to the instance's per-instance config under a reserved key (adr_022), persists across a `shell-config.json` reload, and hot-swaps the live face via `WidgetLoader.onConfigChanged` WITHOUT remounting the holder. Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: changing a face updates the rendered widget and survives reload.
- AC3: At least two multi-face reference widgets ship, each face a self-contained `.qml` declaring its own aspect constraints: (a) Clock — analog / digital / minimal; (b) a system-stat widget — radial gauge vs. horizontal bars. Verify: both appear in the face picker with all faces selectable and each renders correctly headless.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: `WidgetRegistry` exposes a variant contract — `variantsFor(id)` returns `{variantId:{file,label,constraints}}`, `defaultVariant(id)` returns the fallback, and `widgetFile(id,isStrip,variantId)` resolves a face's `.qml` — extending the adr_010 filename convention with NO per-plugin registry edit (a dropped face file + declaration is enough). Verify: a widget with ≥2 declared faces resolves each face's file by id, and an unknown/absent variantId falls back to the default without error.
- request-AC2 -> This backlog slice. Proof: AC2: The user picks a widget's face per instance from ConfigForm (item_063) and the Builder EditOverlay (item_022); the choice is written to the instance's per-instance config under a reserved key (adr_022), persists across a `shell-config.json` reload, and hot-swaps the live face via `WidgetLoader.onConfigChanged` WITHOUT remounting the holder. Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: changing a face updates the rendered widget and survives reload.
- request-AC3 -> This backlog slice. Proof: AC3: At least two multi-face reference widgets ship, each face a self-contained `.qml` declaring its own aspect constraints: (a) Clock — analog / digital / minimal; (b) a system-stat widget — radial gauge vs. horizontal bars. Verify: both appear in the face picker with all faces selectable and each renders correctly headless.

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
