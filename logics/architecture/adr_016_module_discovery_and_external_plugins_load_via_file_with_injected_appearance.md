## adr_016_module_discovery_and_external_plugins_load_via_file_with_injected_appearance - Module discovery and external plugins load via file:// with injected appearance
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Third-party modules load from an absolute file:// path outside the config tree, where qs.Commons imports cannot resolve.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Discover modules with a Process+jq scan and inject Commons.Appearance as an appearance property rather than relying on imports.

# Context
- ModuleRegistry scans two roots (repo modules/ and user ~/.local/share/archeotech/modules/) with the standard Process+jq idiom, lowercase modules/ deliberately distinct from PascalCase Modules/.
- Directory-change watching isn't readily available, so discovery re-runs on edit-mode open.
- qs.Commons import and root:/ only resolve for files inside the config tree — external modules loaded via absolute file:// cannot import shell tokens.

# Decision
- Discover community modules via Process+jq scan, rescanning on edit-mode open; built-ins stay in WidgetRegistry/PanelRegistry.
- Inject Commons.Appearance as an appearance property onto plugin: widgets that declare it (guarded by 'x' in item), leaving built-ins that import Commons untouched.
- Resolve plugin-panel metadata in Strip._metaFor (falling back to ModuleRegistry) rather than coupling PanelRegistry to its sibling singleton.

# Consequences
- External authors use appearance.colors.x instead of import; shell services beyond theme tokens are not exposed to external modules.
- Correction: bundled modules also load via absolute file://, so they too must use injected appearance — the earlier claim they could import Commons was wrong.
- Plugin panels carry a contentUrl (absolute file://), so the strip content area splits into two mutually-exclusive Loaders (binding both on one Loader races).

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
