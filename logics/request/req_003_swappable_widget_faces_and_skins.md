## req_003_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85
> Confidence: 80
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-09-09 15:37:33

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
- AC1: `WidgetRegistry` exposes a variant contract — `variantsFor(id)` returns `{variantId:{file,label,constraints}}`, `defaultVariant(id)` returns the fallback, and `widgetFile(id,isStrip,variantId)` resolves a face's `.qml` — extending the adr_010 filename convention with NO per-plugin registry edit (a dropped face file + declaration is enough). Verify: a widget with ≥2 declared faces resolves each face's file by id, and an unknown/absent variantId falls back to the default without error.
- AC2: The user picks a widget's face per instance from ConfigForm (item_063) and the Builder EditOverlay (item_022); the choice is written to the instance's per-instance config under a reserved key (adr_022), persists across a `shell-config.json` reload, and hot-swaps the live face via `WidgetLoader.onConfigChanged` WITHOUT remounting the holder. Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: changing a face updates the rendered widget and survives reload.
- AC3: At least two multi-face reference widgets ship, each face a self-contained `.qml` declaring its own aspect constraints: (a) Clock — analog / digital / minimal; (b) a system-stat widget — radial gauge vs. horizontal bars. Verify: both appear in the face picker with all faces selectable and each renders correctly headless.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Dependencies & Risks
- Depends on: adr_010 (filename-convention registry — the seam extended), adr_022 (per-instance `{id,config}` — where face selection persists), item_063 (Done — ConfigForm/plugin-manager pane, the picker's primary home), item_022 (Builder EditOverlay — secondary picker home). Relates item_064 (holder-aware panels — faces must honour vertical/horizontal orientation + aspect constraints).
- Risk: reserved face key could collide with a widget's own config field — namespace it (e.g. `__face`) and exclude it from the widget-authored schema surfaced in ConfigForm.
- Risk: async `setSource` remount on face change would flicker/reset widget state — mitigate by treating face as config-driven where possible, or by scoping the remount to the loaded item so the holder/layout slot is preserved (WidgetLoader already re-applies config live via `onConfigChanged`).
- Risk: faces with incompatible aspect constraints on a narrow vertical bar could clip — constraints must be advisory to the holder (item_064), and the picker should surface which faces fit the current side.
- Risk (scope creep): "skins" can bleed into theme-pack restyle (req_001) — keep faces = structural layout variants, not palette/ornament; those stay in the theming engine.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_010 (widget registry contract — the seam this extends).

# References
- `.claude/ANALYSIS.md` (§20.1 swappable widget looks; §20.3 rec 2)
- `logics/architecture/adr_010_widget_panel_registry_noctalia_filename_convention_with_a_holderroot_contract.md`

# Backlog
- `item_100_swappable_widget_faces_and_skins`
