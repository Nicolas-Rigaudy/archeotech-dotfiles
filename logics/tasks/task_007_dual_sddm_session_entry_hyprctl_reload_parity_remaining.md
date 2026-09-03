## task_007_dual_sddm_session_entry_hyprctl_reload_parity_remaining - dual SDDM session entry + hyprctl reload parity (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-03 10:19:51
> Owner: corvus

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: dual, sddm, session, entry, hyprctl, reload, parity, remaining
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_071_hyprland_config_port_dual_sddm_session_reload_parity`

# Acceptance criteria
- AC1: Logging into the Hyprland SDDM session renders the shell with tracking workspaces and working panels/OSD/blur.
- AC2: Every keybind present in the mango config has a working Hyprland equivalent in `hyprland.conf`.
- AC3: A single reload command applies a config change under Hyprland without a full logout/login, matching the mango workflow.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_007_dual_sddm_session_entry_hyprctl_reload_parity_remaining.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_007_dual_sddm_session_entry_hyprctl_reload_parity_remaining.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `ci/verify-compositor-configs.sh (isolated Arch/Hyprland 0.56.2 container, 0 hard errors); live hyprctl on real session — configerrors empty, shell layers render on all monitors, workspace dots track/switch; shell-reload.sh both paths; keybind parity` | result: passed | date: 2026-09-03
- Finish workflow executed on 2026-09-03.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-03.
- Linked backlog item(s): `item_071_hyprland_config_port_dual_sddm_session_reload_parity`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof: hyprland.conf ported (all mango keybinds incl. qs-ipc panels, autostart launching qs -c archeotech + awww + portals, monitor/workspace rules) + shell-reload.sh (hyprctl reload | mango-reload delegation) + install.sh wiring. Validated: config loads clean on real Hyprland 0.56.2 (hyprctl configerrors empty), verified deterministically in isolated Arch container (ci/verify-compositor-configs.sh, 0 hard errors); AC1 confirmed LIVE — shell renders on all monitors (archeotech-shell + exclusion layers via hyprctl layers) and the bar's workspace dots track/switch Hyprland workspaces (HyprlandService/CompositorService facade, item_070/task_016); AC2 keybind parity table; AC3 shell-reload.sh both paths tested. Classic window rules dropped (0.56.2 deprecates INI; full Lua migration scoped as item_084). Implemented in 96b95c4 + 37cf400 + 5a9c23c + d345cd0 (+ facade 074235e). Source: `5a9c23c`
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
