## req_005_2026_09_28_audit_upgrade_program - 2026-09-28 audit upgrade program
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Complexity: High
> Theme: Audit upgrade program
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-09-29 14:09:06

# AI Context
- Summary: Upgrade program from the 2026-09-28 five-area audit: safety net, correctness, design system v2, utility layer, Contexts, 1.0 release.
- Keywords: 2026, audit, upgrade, program
- Use when: Planning or scoping any work that came out of the 2026-09-28 audit.
- Skip when: Working on items outside req_005; evidence lives in .claude/audits/2026-09-28/.

# Needs
- Act on the 2026-09-28 five-area audit (architecture, design, features, roadmap, tooling) plus the isolated theme/pack/mode render matrix.
- Make AI-assisted development safe and verifiable before more polish lands: shot.sh currently runs the owner's full mango autostart (incl. a name-selected qs ipc call that can reach the live shell) and writes the real HOME state.
- Fix verified correctness bugs hiding under the polish (double-instantiated bar widgets, dropped service commands, ToggleSwitch binding break, fake notification settings).
- Rebuild the design system on a semantic, mode-aware token layer with designed light themes and pack chrome moved out of core; commit to the Corvus Dataslate base identity.
- Close the daily-utility gap versus DMS/Noctalia/Caelestia (launcher command palette, notifications v2) and ship Contexts as the 1.0 headline differentiator.
- Reach a 1.0 installable by a stranger, with identity packs (Grimdark, cyberpunk, gundam...) delivered as add-ons through community pack support rather than built in.

# Context
- Owner decisions 2026-09-28: Contexts is the 1.0 headline; Corvus Dataslate (violet/obsidian per STYLE_GUIDE) is the base identity; personal dotfiles items move to a separate roadmap; Angular and HUD were test-only packs and are retired - real packs ship as add-ons.
- Full evidence and file:line citations live in .claude/audits/2026-09-28/ (five reports, contact sheets, render-matrix.sh).

# Acceptance criteria
- AC1: Safety net - a worktree edit can be rendered headless with the live bar and the real HOME untouched (verified by timestamps), and guard hooks block the forbidden live-session commands.
- AC2: Correctness - every bug verified in the audit is fixed and a golden render matrix (themes x packs x modes x panel states) passes with image diff and contrast checks.
- AC3: Design system v2 - no hex literal outside tokens, every golden passes WCAG AA in glass, flat and light, and no pack-specific chrome lives in core primitives.
- AC4: Utility layer - the launcher is a command palette with clipboard/window/project/emoji/calc/command providers and notifications support actions, history and grouping.
- AC5: Contexts - one switch applies project, AWS profile/SSO, kube context, git identity, layout, accent and focus mode.
- AC6: 1.0 - a scripted fresh-Arch install passes the goldens on MangoWC and Hyprland, plugins read shell services through a versioned API, and a third-party pack installs from a URL.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)

# References
- .claude/audits/2026-09-28/audit-architecture.md
- .claude/audits/2026-09-28/audit-design.md
- .claude/audits/2026-09-28/audit-features.md
- .claude/audits/2026-09-28/audit-roadmap.md
- .claude/audits/2026-09-28/audit-tooling.md

# Backlog
- `item_101_isolate_shot_sh_fully_and_render_any_worktree`
- `item_102_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents`
- `item_103_live_bar_on_a_pinned_worktree_with_a_promote_script`
- `item_104_docs_and_repo_hygiene_after_the_audit`
- `item_105_service_command_runner_queue_and_startup_gating`
- `item_106_bar_and_strip_widget_instantiation_fixes`
- `item_107_no_fake_toggles_sweep_controls_bound_to_real_state`
- `item_108_toast_osd_and_network_service_hardening`
- `item_109_visual_defects_found_in_the_audit_render_matrix`
- `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
- `item_111_designed_light_themes_with_their_own_surface_recipe`
- `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`
- `item_113_primitive_library_completion_with_focus_and_disabled_states`
- `item_114_unified_motion_presets_with_reduced_motion_and_animation_scale`
- `item_115_corvus_dataslate_base_identity`
- `item_116_glass_material_decision_real_blur_or_satin`
- `item_117_retire_angular_and_hud_test_packs_to_test_fixtures`
- `item_118_launcher_command_palette_with_providers`
- `item_119_notifications_v2_actions_images_grouping_history`
- `item_120_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet`
- `item_121_native_quickshell_networking_and_bluetooth_services`
- `item_122_contexts_one_switch_for_project_cloud_and_workspace_state`
- `item_123_dev_radar_widgets_aws_sso_pill_and_git_pr_ci_radar`
- `item_124_claude_ask_panel`
- `item_125_signature_motion_panels_grow_from_the_bar_interruptible`
- `item_126_versioned_plugin_api_exposing_shell_services`
- `item_127_portability_hardening_for_strangers_machines`
- `item_128_fresh_arch_install_test_and_hyprland_service_parity`
- `item_129_additional_add_on_identity_packs_cyberpunk_and_gundam`
