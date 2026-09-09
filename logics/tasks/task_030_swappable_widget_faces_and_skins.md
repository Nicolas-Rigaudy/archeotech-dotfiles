## task_030_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-09 15:39:11

# AI Context
- Summary: Implement swappable widget faces in the `archeotech-shell` repo across three waves — (1) variant contract on `WidgetRegistry`, (2) face picker in ConfigForm + Builder writing to per-instance config with live hot-swap, (3) two multi-face reference widgets (Clock, system-stat) as proof. Verify headless via `HOME=/home/corvus ./scripts/shot.sh`.
- Keywords: swappable, widget, faces, variant, WidgetRegistry, WidgetLoader, ConfigForm, EditOverlay
- Use when: implementing the variant resolver, the face picker, or the reference faces.
- Skip when: theme-pack restyle (req_001); new widget types; DnD builder mechanics (item_022); motion (req_002).

# Implementation seams (archeotech-shell repo)
- `Services/Shell/WidgetRegistry.qml` — `availableWidgets` catalogue, `widgetFile(id,isStrip)` resolver, `_builtinSchemas`/`configSchemaFor`/`resolveConfig` per-instance config. Extend here for the variant contract.
- `Modules/Shell/Sides/WidgetLoader.qml` — async `setSource` mount; `_applyOptional()` on `onLoaded`/`onConfigChanged` already gives live config hot-update (the AC2 hot-swap seam).
- `Modules/Settings/Widgets/ConfigForm.qml` — schema→row rendering; add a face-picker row. `Modules/Shell/Builder/EditOverlay.qml` — the Builder's per-instance edit surface (secondary picker home).
- `Widgets/Bar/ClockWidget.qml` — the reference widget to split into faces.
- adr_010 (registry contract) · adr_022 (per-instance config). Verify with `HOME=/home/corvus ./scripts/shot.sh` (isolated; never the live session).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_100_swappable_widget_faces_and_skins`

# Acceptance criteria
- AC1: `WidgetRegistry` exposes a variant contract — `variantsFor(id)` returns `{variantId:{file,label,constraints}}`, `defaultVariant(id)` returns the fallback, and `widgetFile(id,isStrip,variantId)` resolves a face's `.qml` — extending the adr_010 filename convention with NO per-plugin registry edit (a dropped face file + declaration is enough). Verify: a widget with ≥2 declared faces resolves each face's file by id, and an unknown/absent variantId falls back to the default without error.
- AC2: The user picks a widget's face per instance from ConfigForm (item_063) and the Builder EditOverlay (item_022); the choice is written to the instance's per-instance config under a reserved key (adr_022), persists across a `shell-config.json` reload, and hot-swaps the live face via `WidgetLoader.onConfigChanged` WITHOUT remounting the holder. Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: changing a face updates the rendered widget and survives reload.
- AC3: At least two multi-face reference widgets ship, each face a self-contained `.qml` declaring its own aspect constraints: (a) Clock — analog / digital / minimal; (b) a system-stat widget — radial gauge vs. horizontal bars. Verify: both appear in the face picker with all faces selectable and each renders correctly headless.

# Plan
- Wave 1 — Variant contract (AC1): extend `WidgetRegistry` with `variantsFor(id)` → `{variantId:{file,label,constraints}}`, `defaultVariant(id)`, and a variant-aware `widgetFile(id,isStrip,variantId)` that resolves a face's `.qml` and falls back to the default on unknown/absent variantId. Decide the face-file convention on the adr_010 seam (e.g. `Widgets/Bar/<Pascal>/<Variant>Face.qml`) so a dropped file + declaration needs no per-plugin registry edit. Unit-check resolution + fallback.
- Wave 2 — Face selection + live swap (AC2): reserve a namespaced face key (e.g. `__face`) in per-instance config (adr_022), excluded from the widget-authored schema; thread the selected variant through `WidgetLoader._resolve()` and make `onConfigChanged` swap the face live without remounting the holder; confirm persistence across a `shell-config.json` reload.
- Wave 3 — Face picker UI (AC2): add a face-picker row to `ConfigForm.qml` (reads `variantsFor`, writes the reserved key) and surface it in the Builder `EditOverlay.qml`; surface which faces fit the current side (advisory constraints).
- Wave 4 — Reference faces (AC3): split `ClockWidget` into analog/digital/minimal faces and add a system-stat widget with radial-gauge vs. horizontal-bars faces; each face self-contained with declared aspect constraints. Verify all faces render + are selectable headless via `HOME=/home/corvus ./scripts/shot.sh`.
- Wave 5 — Docs + closeout: update `docs/WIDGET_API.md` (variant contract) and adr_010; record validation, then `logics-manager flow finish task`.
- [ ] Use `logics-manager flow progress task task_030_swappable_widget_faces_and_skins.md --progress <n>%` during multi-wave work.
- [ ] Run `logics-manager flow finish task task_030_swappable_widget_faces_and_skins.md` after implementation.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_003_swappable_widget_faces_and_skins`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
