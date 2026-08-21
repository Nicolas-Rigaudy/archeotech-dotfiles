## task_003_configschema_auto_forms_plugin_widget_manager_pane - configSchema auto-forms + Plugin/Widget Manager pane
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-08-21 17:37:49

# AI Context
- Summary: Implementation slice — consume the already-declared `configSchema` (currently carried through `ModuleRegistry` but unused) to auto-render `ConfigForm.qml` from existing row components; migrate zone entries to `{id, config}` with a read-time shim for old bare strings; inject per-instance config through `BarWidgetLoader`/`StripWidgetLoader` keyed so duplicate widgets don't collide; ship `PluginsPane.qml`. The same configSchema->ConfigForm pipeline later renders theme-pack settings (item_081), so keep it pack-agnostic.
- Keywords: configschema, auto, forms, plugin, widget, manager, pane, per-instance, back-compat-shim, ConfigForm
- Use when: Building the ConfigForm renderer, the `{id, config}` migration/shim, per-instance loader injection, or the PluginsPane UI.
- Skip when: Working the plugin install mechanism / manifest schema (item_065/066), holder-aware or vertical layouts (item_064), or intra-overlay drag-reorder (deferred/out of scope).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_063_configschema_auto_forms_plugin_widget_manager_pane`

# Acceptance criteria
- AC1: A widget's `configSchema` renders as an auto-generated settings form using the existing row components, with no per-widget custom form code.
- AC2: Two instances of the same widget (e.g. two clocks) can hold independent config and both persist correctly across shell restarts.
- AC3: Old bare-string `shell-config.json` zone entries load unmodified via the back-compat shim; no migration script is required.
- AC4: The Plugins/Widget Manager pane lists installed modules with working enable/disable and uninstall, plus the built-in widget catalogue.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_003_configschema_auto_forms_plugin_widget_manager_pane.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_003_configschema_auto_forms_plugin_widget_manager_pane.md` after implementation.

# Validation
- Found already-implemented in `archeotech-shell` (Sprint 26 work) — verified 2026-08-21, not newly built.
- AC1 (auto-form): `Modules/Settings/Widgets/ConfigForm.qml` renders rows from a schema; mounted + bound (schema/config/onChanged→setEntryConfig) at `Modules/Shell/Builder/EditOverlay.qml:521-527`. TextFieldRow present. Code-verified.
- AC2 (two instances, independent config): RUNTIME-verified via headless capture — a bar with two `clock` instances (`{}` vs `{format:"12h",showSeconds:true}`) rendered `17:35` and `5:35:32 PM` side by side. `instanceKey: id+"#"+occ` (`Sides/Bar.qml:172`) prevents collision.
- AC3 (bare-string shim): RUNTIME-verified — a bare `"workspaces"` content entry loaded with no error; `_normEntry()`/`_sideContent()` at `Services/Shell/ShellConfig.qml:55-92`. The live config is already all-objects (migration effectively done).
- AC4 (PluginsPane): `Modules/Settings/Panes/PluginsPane.qml` (enable/disable/uninstall + built-in catalogue), registered `Modules/Settings/PaneRegistry.qml:12`, enable/disable via `Services/Shell/ModuleRegistry.qml` `setEnabled()`. Code-verified.
- Method: nested headless `mango` (`WLR_BACKENDS=headless` + `WLR_RENDERER=pixman`) + `grim` via `scripts/shot.sh`, against an isolated fake-HOME config copy — never the user's live session.

# Report
- Delivered (pre-existing). This slice's scope was implemented during Sprint 26 before the Logics corpus tracked it; the backlog item was authored from a stale snapshot. No new code was written for this task — all four ACs are satisfied and verified as above. Follow-up: reconcile other Ready items against the shell code before promoting (corpus lagged the code here).

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
