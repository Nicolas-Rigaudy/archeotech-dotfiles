## req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook - Screensaver engine: pluggable sources, Settings picker and idle hook
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: High
> Theme: Ambient
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 15:05:16

# AI Context
- Summary: Idle screensaver in the shell, decided by the owner in the crow hub (req_015, 2026-11-03): plugin sources (terminal, QML, web), Power pane picker with preview and shuffle, a screensaver IPC target that swayidle calls before the lock, and a card layer for crow. Absorbs item_085; road_001 0.60.
- Keywords: screensaver, engine, pluggable, sources, settings, picker, idle, hook
- Use when: Building or reviewing the screensaver, its sources, its settings, the idle hook or a card plugin such as crow's.
- Skip when: Lock screen (item_018), DPMS and suspend policy, or the Cyberdeck look of the screensaver (item_158).

# Needs
- Owner decision (crow hub req_015 track 1, 2026-11-03): a full-screen screensaver when the machine idles, with the engine in archeotech-shell. Settings picker near the Power pane idle settings, live preview, shuffle, and screensaver sources as plugins so new ones are easy to add.
- Source kinds: terminal animation (cmatrix/unimatrix, pipes.sh, asciiquarium, cbonsai, tty-clock, ASCII Star Wars asciimation from a local copy, ascii-magic's 734 MIT animated pieces via `npx ascii-magic-art`), QML scenes (including original ones), and a web page.
- Research 2026-11-05 (`.claude/SCREENSAVER_RESEARCH.md`) adds two kinds: `shader` (Qt ShaderEffect, Shadertoy-style GLSL, theme-aware through token uniforms; hyprsaver is the nearest prior art and no Quickshell screensaver exists) and `program` (any fullscreen program: gource on the active repo, mpv videos, xscreensaver hacks via Xwayland as best effort). Terminal pool gains termflix (about 60 animations, screensaver flag), astroterm and rotating globes.
- crow ships a screensaver plugin later (like integrations/archeotech/crow-agents): a 'CR-0W is working' card with run bars, modes overlay / take over / off, default overlay on top of the active source. The engine must allow a plugin card drawn above the active source.
- Owner wants original ideas too, beyond the classic Linux animations. Placed in road_001 0.60 First impression (owner, 2026-11-05).

# Context
- Idle today: swayidle is started by config/.config/swayidle/config.sh (dotfiles) with dim / lock / sleep timeouts read from ~/.cache/swayidle.conf; PowerPane.qml edits those values and re-runs the script. The shell has no idle behaviour of its own.
- A layer-shell overlay cannot host a terminal, so terminal sources need a fullscreen kitty window with a compositor rule (MangoWC windowrule and Hyprland windowrule), or a terminal emulator embedded in QML; check before designing.
- Plugins: modules/<id>/module.json + entry QML per docs/MODULE_API.md, with configSchema for per-instance settings. A screensaver source can be a new canLiveIn target or its own manifest kind.
- IPC: shell.qml exposes IpcHandler targets (theme, launcher, settings, panel, osd, ...). The swayidle hook will call a new `screensaver` target before the lock; the dotfiles change is its own item.
- Absorbs item_085 (idle and screensaver mode). item_158 (Cyberdeck crow agents and screensaver look) builds on this engine.
- Safety: testing stays isolated (shot.sh / desk-check.py); never trigger the live session's idle or screensaver.

# Acceptance criteria
- AC1: A `screensaver` IPC target starts, stops and previews the screensaver; any input dismisses it and returns focus to the previous window.
- AC2: Sources are plugins discovered from a manifest; QML, shader, terminal, program and web sources each have at least one working example, and adding a source needs no core edit.
- AC3: Settings (Power pane, next to the idle timeouts) picks a source or shuffle, shows a live preview, and sets the screensaver timeout before the lock.
- AC4: swayidle starts the screensaver through the IPC target before the lock timeout, on MangoWC and Hyprland.
- AC5: A plugin card layer (overlay / take over / off) can draw above the active source; a demo card proves the contract that crow will use.
- AC6: Mockup options for the picker, preview and overlay card are rendered and the owner picks one before the UI is built.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)

# References
- cr-0w logics/request/req_015_wishlist_ambient_mobile_voice_colleague_ideas.md (track 1, decided 2026-11-03)
- cr-0w local/state/handoffs/2026-11-03-1322-archeotech-shell.md
- cr-0w integrations/archeotech/crow-agents
- logics/backlog/item_085_idle_and_screensaver_mode.md
- logics/backlog/item_158_crow_agents_module_and_screensaver_in_the_cyberdeck_pack.md
- archeotech-shell Modules/Settings/Panes/PowerPane.qml
- archeotech-shell docs/MODULE_API.md
- archeotech-shell shell.qml (IpcHandler targets)
- config/.config/swayidle/config.sh
- logics/roadmap/road_001_archeotech_shell.md (0.60 First impression)

# Backlog
- `item_161_screensaver_mockups_picker_preview_and_overlay_card_options`
- `item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal`
- `item_163_screensaver_source_plugins_qml_terminal_and_web_examples`
- `item_164_screensaver_settings_source_picker_shuffle_live_preview_timeout`
- `item_165_dotfiles_idle_hook_swayidle_starts_the_shell_screensaver_before_the_lock`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
