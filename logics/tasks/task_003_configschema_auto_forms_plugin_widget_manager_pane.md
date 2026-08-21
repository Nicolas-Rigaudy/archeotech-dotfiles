## task_003_configschema_auto_forms_plugin_widget_manager_pane - configSchema auto-forms + Plugin/Widget Manager pane
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: Implementation slice — consume the already-declared `configSchema` (currently carried through `ModuleRegistry` but unused) to auto-render `ConfigForm.qml` from existing row components; migrate zone entries to `{id, config}` with a read-time shim for old bare strings; inject per-instance config through `BarWidgetLoader`/`StripWidgetLoader` keyed so duplicate widgets don't collide; ship `PluginsPane.qml`. The same configSchema->ConfigForm pipeline later renders theme-pack settings (item_081), so keep it pack-agnostic.
- Keywords: configschema, auto, forms, plugin, widget, manager, pane, per-instance, back-compat-shim, ConfigForm
- Use when: Building the ConfigForm renderer, the `{id, config}` migration/shim, per-instance loader injection, or the PluginsPane UI.
- Skip when: Working the plugin install mechanism / manifest schema (item_065/066), holder-aware or vertical layouts (item_064), or intra-overlay drag-reorder (deferred/out of scope).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_063_configschema_auto_forms_plugin_widget_manager_pane`

# Acceptance criteria
- AC1: A widget's `configSchema` renders as an auto-generated settings form using the existing row components, with no per-widget custom form code.
- AC2: Two instances of the same widget (e.g. two clocks) can hold independent config and both persist correctly across shell restarts.
- AC3: Old bare-string `shell-config.json` zone entries load unmodified via the back-compat shim; no migration script is required.
- AC4: The Plugins/Widget Manager pane lists installed modules with working enable/disable and uninstall, plus the built-in widget catalogue.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_003_configschema_auto_forms_plugin_widget_manager_pane.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_003_configschema_auto_forms_plugin_widget_manager_pane.md` after implementation.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
