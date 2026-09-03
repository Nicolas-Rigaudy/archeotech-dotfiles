## item_084_migrate_hyprland_config_to_lua_window_rules_per_app_opacity_floating_pip - Migrate Hyprland config to Lua (window rules, per-app opacity, floating PiP)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 70
> Confidence: 65
> Progress: 0%
> Complexity: Medium
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Port the Hyprland fallback config to Hyprland's new Lua config so per-window rules (float, per-app opacity, floating PiP) work without the deprecated INI `windowrule`/`windowrulev2` forms.
- Keywords: migrate, hyprland, config, lua, window, rules, per, app, opacity, floating, pip
- Use when: Working on the Hyprland config's window/layer rules or the INI→Lua migration.
- Skip when: Working on the MangoWC config, the CompositorService QML facade (item_070), or the shell itself.

# Problem
- Hyprland 0.56.2 (current in Arch extra) has moved window rules to a new Lua config (`hl.window_rule{...}`). The classic INI `windowrule = float, class:…` form is rejected outright ("invalid field float"), and `windowrulev2 = …` only parses with a deprecation error shown on every login — confirmed deterministically via `ci/verify-compositor-configs.sh`.
- Consequently the Hyprland fallback currently ships with NO per-window rules: floating PiP, float+center for settings dialogs (pavucontrol/blueman/nm-editor/GTK portal), and per-app opacity (kitty/Code) were dropped for a clean session. Only global `decoration` opacity remains (all windows).
- Hyprland is trending fully toward Lua (the upstream wiki now documents only Lua for rules), so an INI-only config is a dead end for anything rule-based.

# Scope
- In:
  - Decide the migration shape: full `hyprland.lua` vs a verified INI-sources-Lua hybrid (the `source = rules.lua` hybrid verifies clean but was NOT proven to actually apply the rules — needs a bootable Hyprland test to confirm).
  - Re-express the dropped rules in Lua: floating PiP (`match={title="Picture-in-Picture"}, float=true`), float+center for the settings dialogs, per-app opacity for kitty/Code, and the shell glass blur (`layerrule` blur on `archeotech-shell`).
  - Extend `ci/` to lint the Lua config (`Hyprland --verify-config` already accepts `.lua`).
- Out:
  - MangoWC config (its rules stay INI).
  - The CompositorService/HyprlandService QML facade (item_070, already delivered).
  - Proving rules render live (needs a real Hyprland login or a bootable in-container Hyprland — see item_068 / ci/README gaps).

# Acceptance criteria
- AC1: The Hyprland config expresses floating PiP, per-app opacity (kitty/Code), and the settings-dialog float+center rules via the Lua config, verifying clean (0 hard errors, 0 deprecation) in `ci/verify-compositor-configs.sh`.
- AC2: The shell glass-surface blur (`archeotech-shell` layer) is restored under Hyprland via the working 0.56 layer-rule form.
- AC3: A single documented config remains the source of truth (no split-brain between INI and Lua that desyncs on edit), and CI lints whichever form is chosen.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
