## adr_010_widget_panel_registry_noctalia_filename_convention_with_a_holderroot_contract - Widget/panel registry: Noctalia filename convention with a holderRoot contract
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The v1.0 goal is drop-a-folder-get-a-widget, and bar/strip widgets need one portable context contract.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Resolve widget id to filename (Noctalia style) and give every widget one holderRoot context so it runs on any side.

# Context
- Caelestia's DelegateChooser maps id->component but requires a registry edit per plugin.
- Noctalia resolves id to Widgets/Bar/<Pascal>Widget.qml via setSource, so a dropped file plus a shell-config.json zone entry is enough.
- Originally split barRoot/stripRoot contexts, later unified.

# Decision
- Use the Noctalia filename convention; the S20 plugin namespace (plugin:<id>) is a single conditional in WidgetRegistry.
- Inject a required barRoot/stripRoot (later one holderRoot superset) via setSource(path, props); document the API in docs/WIDGET_API.md.
- Fold StripIconBase into BarPill, merge Bar/Strip widget loaders into one WidgetLoader, and have each holder implement its half of the contract and stub the other's.

# Consequences
- Async first-mount; setSource(path, props) is the only reliable way to satisfy required properties on a dynamically-loaded widget.
- A few underscore-prefixed properties remain on the holder for sibling-coordination state; deleted all 6 strip wrapper files and the Widgets/Strip/ dir on unification.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
