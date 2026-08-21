## item_071_hyprland_config_port_dual_sddm_session_reload_parity - Hyprland config port + dual SDDM session + reload parity
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
- Summary: Ports the compositor config (keybinds/window rules/monitor/blur) to Hyprland, adds a dual SDDM session, and gives reload parity with the MangoWC workflow.
- Keywords: hyprland, config, port, dual, sddm, session, reload, parity
- Use when: Working on the actual hyprland.conf file, the SDDM session entry, or the shell-reload script for Hyprland.
- Skip when: Working on the CompositorService/HyprlandService QML abstraction (item_070) or compositor documentation (item_072).

# Problem
- There is no Hyprland compositor config in this repo; keybinds, window rules, monitor layout, and blur rules only exist for MangoWC.
- A user cannot select Hyprland at login; there is no second SDDM session pointing at `qs -c archeotech` under Hyprland.
- There is no Hyprland equivalent of `mango-reload.sh`, so config changes under Hyprland have no reload workflow.

# Scope
- In:
  - `hyprland.conf`: keybinds ported from mango's `config.conf`, `windowrulev2` equivalents of mango `windowrule=monitor:...`, monitor rules, and blur (`decoration:blur` + `layerrule = blur, <shell namespace>` mirroring `blur_layer`)
  - A second SDDM session that autostarts `qs -c archeotech` + awww + portals under Hyprland (mirroring `mango/autostart.sh`)
  - Reload parity: a Hyprland equivalent of `mango-reload.sh` (`hyprctl reload` + shell restart), or a compositor-agnostic `shell-reload.sh`
- Out:
  - The CompositorService/HyprlandService QML facade code (item_070, must land first)
  - docs/COMPOSITOR_SUPPORT.md (item_072)

# Acceptance criteria
- AC1: Logging into the Hyprland SDDM session renders the shell with tracking workspaces and working panels/OSD/blur.
- AC2: Every keybind present in the mango config has a working Hyprland equivalent in `hyprland.conf`.
- AC3: A single reload command applies a config change under Hyprland without a full logout/login, matching the mango workflow.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: the Hyprland config port, dual SDDM session, and reload parity are the dogfooding deliverable of milestone 0.29.

# Priority
- Priority: Medium
- Rationale: Depends on the CompositorService facade (item_070) landing first; not the architectural blocker itself.

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
