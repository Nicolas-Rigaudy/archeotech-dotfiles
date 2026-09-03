## item_087_settings_deep_dive_search_display_modes_deep_linking - Settings deep-dive search display-modes deep-linking
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 60
> Confidence: 60
> Progress: 0
> Complexity: Medium
> Theme: Settings
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: The "OS-level" settings polish surfaced by the earlier cross-repo research (ANALYSIS §9/§10/§13) that is still uncaptured — cross-settings SEARCH, alternate DISPLAY MODES, complete DEEP-LINKING, and a settings-widget-library audit — layered on the shipped configSchema/ConfigForm (item_063) and CC-into-bar (adr_011). Also the home for the §20.5 "settings deep-dive" candidate; hyprmod is the external reference for "tweak every option, live."
- Keywords: settings, search, display-modes, deep-linking, navrail, hyprmod
- Use when: extending the settings surface beyond configSchema forms.
- Skip when: rebuilding the shipped configSchema/ConfigForm (item_063, Done) or the CC-into-bar architecture (adr_011, decided).

# Problem
- Settings is functional (configSchema forms, CC dissolved into the bar) but lacks the polish the research flagged as "OS-level": no cross-settings search, a single display mode, and incomplete quick-toggle -> pane deep-linking. Peer apps (esp. GTK4 BlueManCZ/hyprmod) set the bar for "tweak every option, see it live."

# Scope
- In:
  - Settings SEARCH: `SettingsSearchService` pattern (JSON index, fuzzy match, <=15 results, subTabName boost 1.5x); each settings card registers keywords.
  - DISPLAY MODES: at least one alternate to the default (Noctalia centered/attached/window — "attached" is what makes settings feel integrated).
  - DEEP-LINKING: `IpcHandler{target:"settings"}` + `openPane(id)` so CC quick-toggles jump straight to the matching pane (and bar icon -> CC card -> Settings pane chain, §13.7).
  - Audit the settings-widget library (ToggleRow/SliderRow/DropdownRow/ButtonGroupRow/ColorPickerRow) for gaps; confirm Config-vs-Persistent state split (adr_009).
- Out:
  - The shipped configSchema/ConfigForm engine (item_063); the CC-into-bar decision (adr_011); a bespoke GTK settings app (hyprmod is reference only, not a port).

# Acceptance criteria
- AC1: Cross-settings search finds any setting by keyword and navigates to it.
- AC2: CC quick-toggles deep-link to the matching settings pane via `openPane`.
- AC3: At least one alternate display mode (attached or window) is available beyond the default.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: delivers new settings/shell surfaces (search, display modes, deep-linking) under req_000 AC2 (new widgets/panels/shell features).

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_011 (CC dissolved into one settings side panel), adr_009 (reactive Config for Config-vs-Persistent split)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
