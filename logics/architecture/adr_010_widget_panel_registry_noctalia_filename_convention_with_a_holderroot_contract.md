## adr_010_widget_panel_registry_noctalia_filename_convention_with_a_holderroot_contract - Widget/panel registry: Noctalia filename convention with a holderRoot contract
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The v1.0 goal is drop-a-folder-get-a-widget, and bar/strip widgets need one portable context contract.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.
> Indicators reviewed: 2026-09-03 11:12:18

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
- **Reference patterns to consider (k4, 2026-09-03 study — full writeup ANALYSIS §20 pending).** k4's Quickshell dynamic-island plugin SDK (`import K4`; plugins = `<Name>Plugin.qml` + `<Name>View.qml` + qmldir; catalogued in `catalog.json`) adds two capabilities our filename-convention contract lacks:
  - *Priority contention for a SHARED surface:* many plugins can request the same island/panel at once; each declares `priority` + `active` (wants it now), highest wins (k4 ladder: idle 0 · volume 40 · clock 50 · player 55 · toast 59 · panel 60 · launcher 80 · ask 90), plus a `transitorio` (self-dismissing) flag so auto-opened views (a toast, a screenshot confirmation) yield the surface immediately when another plugin claims it — arbitrated in ONE place, not ad-hoc per widget. Worth adopting if/when we have a shared morphing island/panel where volume HUD, media, notifications, launcher compete.
  - *Service/view lifecycle split:* a plugin's `Process`/`Timer`/`IpcHandler` are declared as default children and live as long as the BAR lives; the `view` mounts on demand only while the plugin is active. Cleaner than tying background work to view lifetime; complements the injected holderRoot contract (adr_016).
  - *Plugin-relative assets:* the host fills each plugin's on-disk `carpeta`; a `fichero(rel)` helper builds absolute paths so a plugin can ship + exec its own scripts/binaries (matches the external-plugin dir plan, adr_016/item_063).
  - *Content-driven size, measured-not-summed:* the plugin declares `islandWidth/Height`; the mature version has the VIEW measure its rendered zone widths and bind them back, with summed estimates as a startup floor only.
  - *Meta:* k4 ships a coding-agent skill encoding the plugin contract so agents scaffold + hot-test plugins without a bar restart — worth considering given our Claude Code workflow.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
