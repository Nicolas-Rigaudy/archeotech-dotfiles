## task_074_launcher_command_palette_with_providers - Launcher command palette with providers
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 25%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: Launcher command palette; windows provider and a pre-fill IPC done, prefix modes and the remaining providers wait on product choices.
- Keywords: launcher, command, palette, providers
- Use when: Adding launcher providers or prefix modes (Modules/Shell/Panels/Content/Launcher.qml).
- Skip when: The AI provider (item_124 Claude Ask).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_118_launcher_command_palette_with_providers`

# Acceptance criteria
- AC1: Each provider is reachable by prefix and by blended search.
- AC2: Four rofi scripts are retired.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_074_launcher_command_palette_with_providers.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_074_launcher_command_palette_with_providers.md` after implementation.

# Validation
- command: tests/run.sh 86 pass, tests/py 35 OK, qmllint-ci rc 0, token-lint 0; headless shot.sh on night/fallback: a kitty window titled 'probe window alpha' in the nested session, `qs ipc call launcher search probe` opens the launcher pre-filled and lists the window first (Window › kitty) above settings matches (launcher-window-provider.png in cr-0w/local/state/night/shots/fallback-2026-10-21/) | result: passed | date: 2026-10-21. Picking the window (Enter) could not be driven headless: no synthetic input.

# Report
- Windows provider (shell night/fallback, 3a963c5): open windows from Wayland foreign-toplevel (Quickshell ToplevelManager, so not mango-specific), matched on title and app id, weighted at 0.65 so an app's launcher entry stays above its windows; picking one calls activate().
- `ipc call launcher search <text>` (196ceb6): opens the launcher with the box pre-filled (also while open). This is the hook prefix-mode keybinds would use.
- Paused, product choices:
  - Prefix characters per mode (AC1). Options: (a) single characters like `>` commands, `:` emoji, `=` calc, `@` windows, `!` clipboard; (b) words like `win `, `clip `; (c) no prefixes, only blended search plus per-mode keybinds through `launcher search`. Recommendation: (a), the convention most launchers use, with (c)'s keybinds on top.
  - Clipboard (cliphist is installed): blended results would show copied secrets while typing an app name, so it should be prefix-only. That depends on the prefix decision.
  - Projects: which app opens a project (terminal, editor, file manager)?
  - Script commands and quicklinks: need a config format.
  - SSH hosts: no ~/.ssh/config on this machine, so it was not built.
  - qalc: not installed; the JS calculator stays.
- AC2 (four rofi scripts retired): the rofi scripts and their binds live in the dotfiles repo, outside this job.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
