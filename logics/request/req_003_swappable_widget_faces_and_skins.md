## req_003_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 70
> Confidence: 70
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

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
- AC1: A widget can declare multiple faces/variants (id, file, label, size/aspect constraints) and the registry resolves them, extending the adr_010 filename convention without a per-plugin registry edit.
- AC2: The user picks a widget's face per instance from the builder / ConfigForm; the choice persists via per-instance config (adr_022) and hot-reloads.
- AC3: At least two multi-face reference widgets ship (e.g. clock analog/digital/minimal; a system stat as gauge vs bars).

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_010 (widget registry contract — the seam this extends).

# References
- `.claude/ANALYSIS.md` (§20.1 swappable widget looks; §20.3 rec 2)
- `logics/architecture/adr_010_widget_panel_registry_noctalia_filename_convention_with_a_holderroot_contract.md`

# Backlog
- none
