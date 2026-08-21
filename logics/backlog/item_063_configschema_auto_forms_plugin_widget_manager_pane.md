## item_063_configschema_auto_forms_plugin_widget_manager_pane - configSchema auto-forms + Plugin/Widget Manager pane
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:15:50

# AI Context
- Summary: Adds a configSchema-driven auto-generated settings form, `{id, config}` zone entries with a back-compat shim, per-instance config injection through the widget loaders, and a Plugins/Widget Manager settings pane.
- Keywords: configschema, auto, forms, plugin, widget, manager, pane
- Use when: Wiring per-instance widget configuration or building/extending the Plugin/Widget Manager pane.
- Skip when: Working on holder-aware panel layout or vertical-orientation widget rendering (see item_064).
- Note (adr_026): the same configSchema -> ConfigForm pipeline renders THEME-PACK-scoped settings (item_081); the Manager pane also lists/enables/configures theme packs, not just widget plugins.

# Problem
- `configSchema` is declared in `module.json` and carried through `ModuleRegistry` but nothing consumes it, so users still hand-edit `shell-config.json` for per-widget settings.
- Zone entries are bare-string widget ids, so two instances of the same widget (e.g. two clocks) cannot hold different config.
- There is no GUI surface to enable/disable/configure installed plugins or browse the built-in widget catalogue.

# Scope
- In:
  - configSchema spec documented in WIDGET_API.md / MODULE_API.md and an auto-generated `ConfigForm.qml` (TextFieldRow + existing Toggle/Slider/Dropdown/ButtonGroupRow)
  - Migrate `shell-config.json` zone entries to `{id, config}` objects with a read-time back-compat shim for old bare-string entries
  - Per-instance config injection through `BarWidgetLoader`/`StripWidgetLoader`, keyed so two instances of one widget coexist without reload collisions
  - A Plugins/Widget Manager settings pane (`PluginsPane.qml`): installed modules with enable/disable, verified badge, uninstall (user-dir only, confirm), and the built-in widget catalogue
- Out:
  - Intra-overlay drag-and-drop reorder and the spatial side-mock preview (left optional/deferred)
  - Plugin install mechanism and manifest schema (item_065, item_066)
  - Vertical-orientation widget layouts and holder-aware panels (item_064)

# Acceptance criteria
- AC1: A widget's `configSchema` renders as an auto-generated settings form using the existing row components, with no per-widget custom form code.
- AC2: Two instances of the same widget (e.g. two clocks) can hold independent config and both persist correctly across shell restarts.
- AC3: Old bare-string `shell-config.json` zone entries load unmodified via the back-compat shim; no migration script is required.
- AC4: The Plugins/Widget Manager pane lists installed modules with working enable/disable and uninstall, plus the built-in widget catalogue.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: configSchema-driven auto-generated settings forms, `{id, config}` zone entries with back-compat shim, per-instance config injection, and the Plugins/Widget Manager pane ship together for milestone 0.26.

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
- Request: `logics/request/req_000_archeotech_shell_dotfiles.md`
- Primary task(s): (none yet)

# Priority
- Priority: High
- Rationale: Closes the biggest S26 gap (per-instance config) and is the prerequisite for the plugin ecosystem in 0.27.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
