## item_076_api_install_contributing_docs - API + INSTALL + CONTRIBUTING docs
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Writes docs/INSTALL.md, docs/PLUGIN_API.md, and CONTRIBUTING.md, and finalizes the MODULE/WIDGET/THEME/PANEL API docs for v1.0.
- Keywords: api, install, contributing, docs
- Use when: Writing or finalizing installer, plugin-authoring, or contribution documentation.
- Skip when: Working on the README/screenshots/demo GIF/tag (item_077) or on the install script implementation itself (item_074).

# Problem
- There is no docs/INSTALL.md walking a stranger through fresh-Arch install (MangoWC and Hyprland), so the rewritten install.sh (item_074) has no companion doc.
- There is no docs/PLUGIN_API.md or CONTRIBUTING.md, so a community author has no documented path to submit a plugin or theme.
- Existing MODULE_API/WIDGET_API/THEME_SPEC/PANEL_API docs were written incrementally per sprint and have not been finalized/reconciled for the v1.0 surface.

# Scope
- In:
  - `docs/INSTALL.md`: fresh Arch install walkthrough for both MangoWC and Hyprland
  - `docs/PLUGIN_API.md` and `CONTRIBUTING.md`: how to submit a plugin or theme
  - Finalize `MODULE_API.md`/`WIDGET_API.md`/`THEME_SPEC.md`/`PANEL_API.md` against the current shipped API surface
- Out:
  - README screenshots/demo GIF and the v1.0.0 tag itself (item_077)
  - Implementing the install script or plugin install mechanism (item_074, item_065)

# Acceptance criteria
- AC1: docs/INSTALL.md takes a stranger from fresh Arch to a running shell on both MangoWC and Hyprland.
- AC2: docs/PLUGIN_API.md and CONTRIBUTING.md together document the full path to submit a plugin or theme.
- AC3: MODULE_API/WIDGET_API/THEME_SPEC/PANEL_API docs match the actual current API surface with no known-stale sections.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: INSTALL/PLUGIN_API/CONTRIBUTING and finalized API docs are the documentation half of milestone 1.0's distribution readiness.

# Priority
- Priority: Medium
- Rationale: Necessary for community contribution but depends on the install script (item_074) and plugin mechanism (item_065) being final first.

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
