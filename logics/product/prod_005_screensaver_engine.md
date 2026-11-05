## prod_005_screensaver_engine - Screensaver engine
> Date: 2026-11-05
> Status: Proposed
> Related request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
> Related backlog: `item_161_screensaver_mockups_picker_preview_and_overlay_card_options`, `item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal`, `item_163_screensaver_source_plugins_qml_terminal_and_web_examples`, `item_164_screensaver_settings_source_picker_shuffle_live_preview_timeout`, `item_165_dotfiles_idle_hook_swayidle_starts_the_shell_screensaver_before_the_lock`
> Related task: `task_077_orchestrate_the_screensaver_engine`
> Related architecture: (none yet)
> Reminder: Update status, linked refs, scope, decisions, success signals, and open questions when you edit this doc.

# Overview
An idle screensaver for the Archeotech shell with pluggable sources (terminal, QML, web), a Settings picker with live preview and shuffle, and an overlay card layer for plugins such as crow.

# Goals
- The machine shows something alive when idle, picked from Settings in two keystrokes.
- New screensavers are a plugin drop-in, not a core change.
- crow and identity packs can show their own card or look on top.

# Non-goals
- The lock screen itself (item_018) and DPMS / suspend policy.
- Shipping crow's own card (it lives in the crow repo).
- Bundling third-party animations whose licence forbids it.

# Scope and guardrails
- In: scaffolded request, product, backlog, orchestration task, validation, and handoff context.
- Out: unrelated workflow docs and implementation of generated tasks.

# Key product decisions
- Use structured input as the source of truth for generated docs.
- Keep generated write paths local and repo-bounded.

# Success signals
- Generated docs pass lint and audit without broad manual rewrites.
- Context-pack output can be handed to an implementation agent directly.

# References
- Product back-reference: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Task back-reference: `task_077_orchestrate_the_screensaver_engine`
