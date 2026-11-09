## task_082_orchestrate_automatic_updates - Orchestrate automatic updates
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:44:31

# AI Context
- Summary: Delivers req_013 in four waves: notifier, user-tool updater, arch-update setup, docs. item_174 (sysup) is obsolete. The first real arch-update run is the owner's.
- Keywords: orchestrate, automatic, updates
- Use when: picking the next automatic-updates wave or checking its order.
- Skip when: crow's changelog watch (cr-0w req_045).

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. Notifier and state file (everything else calls it).
- [ ] 2. Tracked user-tool updater (replaces the untracked daily job; quick win, no root).
- [ ] 3. arch-update setup (owner installs it with paru; tracked config, check timer, tray via mango exec_once, kitty via xdg-terminal-exec).
- [x] 4. sysup guarded upgrade: dropped 2026-11-09, arch-update covers it (item_174 Obsolete).
- [ ] 5. ADR, rollback runbook and docs (written against the shipped scripts and the arch-update config).
- [ ] 6. Validate each wave on the real machine with dry-run flags first; the first real arch-update run is done by the owner.
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`
- `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`
- `item_173_daily_system_update_check_with_arch_news_gate`
- `item_174_sysup_guarded_system_upgrade_command`
- `item_175_update_policy_adr_rollback_runbook_and_docs`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC4 -> `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`. Proof deferred to slice closeout.
- request-AC6 -> `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`. Proof deferred to slice closeout.
- request-AC1 -> `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`. Proof deferred to slice closeout.
- request-AC6 -> `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`. Proof deferred to slice closeout.
- request-AC2 -> `item_173_daily_system_update_check_with_arch_news_gate`. Proof deferred to slice closeout.
- request-AC4 -> `item_173_daily_system_update_check_with_arch_news_gate`. Proof deferred to slice closeout.
- request-AC3 -> `item_173_daily_system_update_check_with_arch_news_gate`. Proof deferred to slice closeout.
- request-AC5 -> `item_175_update_policy_adr_rollback_runbook_and_docs`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
