## task_031_orchestrate_2026_09_28_audit_upgrade_program - Orchestrate 2026-09-28 audit upgrade program
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 30%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:45
> Owner: claude

# AI Context
- Summary: Orchestrates req_005 delivery across milestones 0.30 to 1.0 in road_001 order.
- Keywords: orchestrate, 2026, audit, upgrade, program
- Use when: Choosing the next audit-program item or checking milestone progress.
- Skip when: Implementing a single item; open that backlog item instead.

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. 0.30 Safety net: item_101 shot.sh isolation, item_102 Claude tooling, item_103 live worktree, item_104 docs hygiene, plus item_068 goldens and CI.
- [ ] 2. 0.31 Correctness sweep: items 105-109.
- [ ] 3. 0.40 Design system v2: items 110-117 plus item_039, item_045, item_017, item_091 and the picker-feel items 006/007/009.
- [ ] 4. 0.50 Utility layer: items 118-121 plus item_049.
- [ ] 5. 0.60 Contexts and signature: items 122-125.
- [ ] 6. 1.0 Release: items 126-128 plus item_065, item_021, item_075, item_076, item_072, item_077, item_040.
- [ ] 7. Work each item in its own worktree with an isolated contact sheet; update logics docs at checkpoints and closeout, not per wave.
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

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
- `item_068_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci`
- `item_039_glass_themed_system_tray_context_menu_tooltip`
- `item_045_edit_mode_stragglers_onto_3d_glass_theme`
- `item_017_panel_keybinds_dismissal_consistency`
- `item_091_accent_picker_for_all_theme_families_with_gtk_fallback`
- `item_006_live_colour_preview_on_scroll_in_pickers`
- `item_007_async_fade_in_on_wallpaper_thumbnails`
- `item_009_palette_crossfade_on_theme_apply`
- `item_049_dashboard_customizable_system_notes_data_reliability`
- `item_013_layout_loadouts_presets`
- `item_065_archeotech_plugin_install_mechanism_plugins_json_index`
- `item_021_theme_packs_official_community`
- `item_075_scripted_per_variant_theme_symlinks`
- `item_076_api_install_contributing_docs`
- `item_072_docs_compositor_support_md_for_both_compositors`
- `item_077_readme_screenshots_demo_gif_v1_0_0_tag`
- `item_040_demo_onboarding_mode`
- `item_010_move_thumbnail_cache_to_freedesktop_shared_path`
- `item_003_verify_vscode_colorcustomizations_regen_on_non_catppuccin_themes`
- `item_083_theming_engine_ornament_asset_overlay_fx_pack_font_hook_flagship_gap`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> `item_101_isolate_shot_sh_fully_and_render_any_worktree`. Proof deferred to slice closeout.
- request-AC1 -> `item_102_claude_code_project_tooling_guard_hooks_qt6_lint_skills_and_reviewer_agents`. Proof deferred to slice closeout.
- request-AC1 -> `item_103_live_bar_on_a_pinned_worktree_with_a_promote_script`. Proof deferred to slice closeout.
- request-AC1 -> `item_104_docs_and_repo_hygiene_after_the_audit`. Proof deferred to slice closeout.
- request-AC2 -> `item_105_service_command_runner_queue_and_startup_gating`. Proof deferred to slice closeout.
- request-AC2 -> `item_106_bar_and_strip_widget_instantiation_fixes`. Proof deferred to slice closeout.
- request-AC2 -> `item_107_no_fake_toggles_sweep_controls_bound_to_real_state`. Proof deferred to slice closeout.
- request-AC2 -> `item_108_toast_osd_and_network_service_hardening`. Proof deferred to slice closeout.
- request-AC2 -> `item_109_visual_defects_found_in_the_audit_render_matrix`. Proof deferred to slice closeout.
- request-AC3 -> `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`. Proof deferred to slice closeout.
- request-AC3 -> `item_111_designed_light_themes_with_their_own_surface_recipe`. Proof deferred to slice closeout.
- request-AC3 -> `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`. Proof deferred to slice closeout.
- request-AC6 -> `item_112_surface_recipes_and_pack_chrome_out_of_core_primitives`. Proof deferred to slice closeout.
- request-AC3 -> `item_113_primitive_library_completion_with_focus_and_disabled_states`. Proof deferred to slice closeout.
- request-AC3 -> `item_114_unified_motion_presets_with_reduced_motion_and_animation_scale`. Proof deferred to slice closeout.
- request-AC3 -> `item_115_corvus_dataslate_base_identity`. Proof deferred to slice closeout.
- request-AC3 -> `item_116_glass_material_decision_real_blur_or_satin`. Proof deferred to slice closeout.
- request-AC6 -> `item_117_retire_angular_and_hud_test_packs_to_test_fixtures`. Proof deferred to slice closeout.
- request-AC4 -> `item_118_launcher_command_palette_with_providers`. Proof deferred to slice closeout.
- request-AC4 -> `item_119_notifications_v2_actions_images_grouping_history`. Proof deferred to slice closeout.
- request-AC4 -> `item_120_state_driven_osd_generic_panel_ipc_and_keybind_cheatsheet`. Proof deferred to slice closeout.
- request-AC4 -> `item_121_native_quickshell_networking_and_bluetooth_services`. Proof deferred to slice closeout.
- request-AC5 -> `item_122_contexts_one_switch_for_project_cloud_and_workspace_state`. Proof deferred to slice closeout.
- request-AC5 -> `item_123_dev_radar_widgets_aws_sso_pill_and_git_pr_ci_radar`. Proof deferred to slice closeout.
- request-AC5 -> `item_124_claude_ask_panel`. Proof deferred to slice closeout.
- request-AC5 -> `item_125_signature_motion_panels_grow_from_the_bar_interruptible`. Proof deferred to slice closeout.
- request-AC6 -> `item_126_versioned_plugin_api_exposing_shell_services`. Proof deferred to slice closeout.
- request-AC6 -> `item_127_portability_hardening_for_strangers_machines`. Proof deferred to slice closeout.
- request-AC6 -> `item_128_fresh_arch_install_test_and_hyprland_service_parity`. Proof deferred to slice closeout.
- request-AC6 -> `item_129_additional_add_on_identity_packs_cyberpunk_and_gundam`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- 2026-09-28 checkpoint: 0.30 Safety net done except item_103 activation (owner runs archeotech-live.sh init). 0.31: item_105, item_106, item_107 done and landed (archeotech-shell 1c22858, 45a3cc7, b35817f); next item_108, item_109, item_068, item_049. Resume note: .claude/handoffs/RESUME.md; per-item method: .claude/skills/shell-item/SKILL.md.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
