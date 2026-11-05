## task_077_orchestrate_the_screensaver_engine - Orchestrate the screensaver engine
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: orchestrate, screensaver, engine
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. Render picker, preview and overlay card options; owner picks (mockup item).
- [ ] 2. Decide the terminal-source host (kitty window + rule vs embedded) as an ADR, then build the engine core with the IPC target and card layer.
- [ ] 3. Source plugins: QML first, then terminal, then web.
- [ ] 4. Settings section in the picked layout.
- [ ] 5. Dotfiles swayidle hook and window rules; owner checks on the live desk.
- [ ] 6. Retire item_085 as absorbed; hand item_158 and the crow card the card-layer contract.
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_161_screensaver_mockups_picker_preview_and_overlay_card_options`
- `item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal`
- `item_163_screensaver_source_plugins_qml_terminal_and_web_examples`
- `item_164_screensaver_settings_source_picker_shuffle_live_preview_timeout`
- `item_165_dotfiles_idle_hook_swayidle_starts_the_shell_screensaver_before_the_lock`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC6 -> `item_161_screensaver_mockups_picker_preview_and_overlay_card_options`. Proof deferred to slice closeout.
- request-AC1 -> `item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal`. Proof deferred to slice closeout.
- request-AC5 -> `item_162_screensaver_engine_core_ipc_target_fullscreen_host_and_dismissal`. Proof deferred to slice closeout.
- request-AC2 -> `item_163_screensaver_source_plugins_qml_terminal_and_web_examples`. Proof deferred to slice closeout.
- request-AC3 -> `item_164_screensaver_settings_source_picker_shuffle_live_preview_timeout`. Proof deferred to slice closeout.
- request-AC4 -> `item_165_dotfiles_idle_hook_swayidle_starts_the_shell_screensaver_before_the_lock`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

