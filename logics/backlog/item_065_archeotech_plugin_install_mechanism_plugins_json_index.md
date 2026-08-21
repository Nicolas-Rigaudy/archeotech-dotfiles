## item_065_archeotech_plugin_install_mechanism_plugins_json_index - archeotech plugin install mechanism + plugins.json index
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
- Summary: Adds the `archeotech plugin install <name>` git-clone install mechanism and a repo-hosted `plugins.json` index (official + community catalog).
- Keywords: archeotech, plugin, install, mechanism, plugins, json, index
- Use when: Working on the plugin install CLI path or the plugins.json index format/hosting.
- Skip when: Working on the manifest schema fields themselves (see item_066) or the Plugin Manager pane UI (item_063).
- Note (adr_026): the install CLI + plugins.json index also cover THEME PACKS (a plugin kind), including the official Shadow Spears pack (item_082); distribution/tiers detail lives in item_021.

# Problem
- There is no install mechanism for plugins today; the only way to add a module is to manually drop a folder into the modules directory.
- There is no catalog a user can browse or search to discover official or community plugins before installing one.
- The first official plugin (dev-workflow, item_065's sibling milestone 0.27 goal) has nothing to install itself with.

# Scope
- In:
  - `archeotech plugin install <name>` CLI command that git-clones the named plugin into the modules directory
  - A repo-hosted `plugins.json` index listing official and community plugins (name, repo URL, description)
  - Basic install error handling (name not found in index, clone failure, already installed)
- Out:
  - Plugin manifest schema fields themselves (item_066)
  - The Plugin/Widget Manager settings pane UI (item_063, milestone 0.26)
  - Update/uninstall automation beyond what the manager pane already does

# Acceptance criteria
- AC1: `archeotech plugin install dev-workflow` clones the plugin into the modules directory and it becomes visible to ModuleRegistry without manual steps.
- AC2: Installing a name not present in `plugins.json` fails with a clear error instead of a silent no-op.
- AC3: `plugins.json` is fetched from a repo-hosted URL and lists at least the dev-workflow plugin as official.

# AC Traceability
- request-AC3 -> This backlog slice. Proof: the git-clone install mechanism and plugins.json index are the milestone 0.27 delivery that dogfoods the plugin ecosystem.

# Priority
- Priority: High
- Rationale: The install mechanism is the core deliverable of 0.27 and blocks dogfooding the plugin ecosystem end to end.

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
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
