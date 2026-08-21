## task_001_orchestrate_archeotech_shell_delivery - Orchestrate Archeotech shell delivery
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: orchestrate, archeotech, shell, delivery
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [ ] 1. Round 1 floating overlays: migrate CalendarPopup/WifiPopup/BtPopup (CurveRenderer, keep glass fill, asymmetric enter/exit, StateLayer + surfaceWarm on nested buttons/rows only)
- [ ] 2. Round 1: migrate MediaPanel + MediaWidget (StateLayer transport buttons, album-art card warmth + shadow, glass panel)
- [ ] 3. Round 3 leftover: migrate EditOverlay/WidgetPalette builder buttons onto GlassButton/StateLayer
- [ ] 4. Round 3 leftover: run a full design pass over all of Settings (consistency, spacing, readability) using ui-ux-pro-max as a lens + multi-persona review
- [ ] 5. Round 4: strip openers (PanelOpenerWidget) - 44px rounded accent bg, stateHover/statePressed, card scale-in, surfaceWarm fill, holder-edge hover glow
- [ ] 6. Round 4: warm BarPill showActiveBg fill via statePressed/stateHover (strip openers only, bar stays flat)
- [ ] 7. Round 4: EditOverlay/WidgetPalette chip/tile hover+press states
- [ ] 8. Round 4: Bar SAFE-only tweaks (smoother icon recolor curve); hover-fill/active-border only with explicit sign-off
- [ ] 9. Deferred design-pass items: media album-art lift + 3D progress knob (small layout wrappers)
- [ ] 10. Extract the copy-pasted screen-space sheen into a shared GlassSheen helper across the 6+ cards to stop drift
- [ ] 11. Stand up the automated screenshot + multi-persona playtest harness on the proven shot.sh path
- [ ] 12. Feel-gated rhythm throughout: pilot one surface -> Super+Shift+R live-test -> tune -> commit
- [ ] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [ ] Keep commit creation under operator control; do not force one commit per micro-step.
- [ ] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_001_test_the_auto_day_night_schedule_end_to_end`
- `item_002_visual_pass_on_the_light_themes`
- `item_003_verify_vscode_colorcustomizations_regen_on_non_catppuccin_themes`
- `item_004_check_widened_settings_panes_760_940_don_t_look_sparse`
- `item_005_fix_dock_undock_freeze_wlroots_output_hotplug_on_mangowm_0_16`
- `item_006_live_colour_preview_on_scroll_in_pickers`
- `item_007_async_fade_in_on_wallpaper_thumbnails`
- `item_008_eager_warm_the_wallpapers_service_at_shell_startup`
- `item_009_palette_crossfade_on_theme_apply`
- `item_010_move_thumbnail_cache_to_freedesktop_shared_path`
- `item_011_decide_and_apply_lid_close_while_docked_suspend_behaviour`
- `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`
- `item_013_layout_loadouts_presets`
- `item_014_tiling_layout_picker_deferred_nice_to_haves`
- `item_015_auto_hide_sides_in_fullscreen`
- `item_016_launcher_keyboard_first_master_search`
- `item_017_panel_keybinds_dismissal_consistency`
- `item_018_lock_screen_customization_widgets_settings_pane`
- `item_019_theme_applier_plugins_refactor`
- `item_020_core_plugin_optional_extraction`
- `item_021_theme_packs_official_community`
- `item_022_visual_builder_drag_and_drop_spatial_zone_representation`
- `item_023_dev_workflow_bar_widgets_docker_keyboardlayout_capslock`
- `item_024_dev_workflow_rofi_scripts_aws_terraform_vscode_monitor`
- `item_025_clipboard_improvements`
- `item_026_multi_monitor_compositor_utilities`
- `item_027_named_scratchpads`
- `item_028_tool_discovery_system`
- `item_029_quick_tools_context_menu_super_x`
- `item_030_screenshot_recording_improvements`
- `item_031_kitty_session_presets`
- `item_032_ssh_quick_connect_super_ctrl_s`
- `item_033_per_workspace_wallpapers`
- `item_034_portability_machine_profiles`
- `item_035_coherency_audit_slice_2_selector_unification_remaining`
- `item_036_coherency_audit_slice_3_flat_mode_sweep`
- `item_037_coherency_audit_slice_4_dedup_inputs`
- `item_038_coherency_audit_slice_5_one_offs_tokens`
- `item_039_glass_themed_system_tray_context_menu_tooltip`
- `item_040_demo_onboarding_mode`
- `item_041_r_d_missing_common_niche_shell_os_features`
- `item_042_r_d_r_unixporn_ricing_inspiration_pass`
- `item_043_fix_dashboard_auto_close_right_after_boot`
- `item_044_workspace_indicators_3d_polish`
- `item_045_edit_mode_stragglers_onto_3d_glass_theme`
- `item_046_dashboard_customizable_grid`
- `item_047_dashboard_pinnable_projects`
- `item_048_dashboard_hero_rotating_quote`
- `item_049_dashboard_customizable_system_notes_data_reliability`
- `item_050_gradient_sheen_on_nested_cards_experiment`
- `item_051_named_theme_personalities_as_glass_base_variants`
- `item_052_someday_terminal_editor_tooling`
- `item_053_someday_developer_tooling`
- `item_054_someday_browser_apps`
- `item_055_someday_communication_productivity`
- `item_056_someday_music_media`
- `item_057_someday_visual_flair`
- `item_058_someday_tools_to_evaluate`
- `item_059_someday_reading_cs_books_setup`
- `item_060_someday_color_extraction_tools_evaluation`
- `item_061_someday_small_quick_win_installs`

# Definition of Done (DoD)
- [ ] Generated request, product, backlog, and task docs are present.
- [ ] Context-pack handoff is available when requested.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> `item_001_test_the_auto_day_night_schedule_end_to_end`. Proof deferred to slice closeout.
- request-AC6 -> `item_001_test_the_auto_day_night_schedule_end_to_end`. Proof deferred to slice closeout.
- request-AC1 -> `item_002_visual_pass_on_the_light_themes`. Proof deferred to slice closeout.
- request-AC5 -> `item_002_visual_pass_on_the_light_themes`. Proof deferred to slice closeout.
- request-AC1 -> `item_003_verify_vscode_colorcustomizations_regen_on_non_catppuccin_themes`. Proof deferred to slice closeout.
- request-AC5 -> `item_004_check_widened_settings_panes_760_940_don_t_look_sparse`. Proof deferred to slice closeout.
- request-AC4 -> `item_005_fix_dock_undock_freeze_wlroots_output_hotplug_on_mangowm_0_16`. Proof deferred to slice closeout.
- request-AC5 -> `item_006_live_colour_preview_on_scroll_in_pickers`. Proof deferred to slice closeout.
- request-AC1 -> `item_006_live_colour_preview_on_scroll_in_pickers`. Proof deferred to slice closeout.
- request-AC5 -> `item_007_async_fade_in_on_wallpaper_thumbnails`. Proof deferred to slice closeout.
- request-AC5 -> `item_008_eager_warm_the_wallpapers_service_at_shell_startup`. Proof deferred to slice closeout.
- request-AC4 -> `item_008_eager_warm_the_wallpapers_service_at_shell_startup`. Proof deferred to slice closeout.
- request-AC5 -> `item_009_palette_crossfade_on_theme_apply`. Proof deferred to slice closeout.
- request-AC1 -> `item_009_palette_crossfade_on_theme_apply`. Proof deferred to slice closeout.
- request-AC4 -> `item_010_move_thumbnail_cache_to_freedesktop_shared_path`. Proof deferred to slice closeout.
- request-AC4 -> `item_011_decide_and_apply_lid_close_while_docked_suspend_behaviour`. Proof deferred to slice closeout.
- request-AC5 -> `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`. Proof deferred to slice closeout.
- request-AC1 -> `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`. Proof deferred to slice closeout.
- request-AC3 -> `item_013_layout_loadouts_presets`. Proof deferred to slice closeout.
- request-AC2 -> `item_014_tiling_layout_picker_deferred_nice_to_haves`. Proof deferred to slice closeout.
- request-AC4 -> `item_014_tiling_layout_picker_deferred_nice_to_haves`. Proof deferred to slice closeout.
- request-AC2 -> `item_015_auto_hide_sides_in_fullscreen`. Proof deferred to slice closeout.
- request-AC4 -> `item_015_auto_hide_sides_in_fullscreen`. Proof deferred to slice closeout.
- request-AC2 -> `item_016_launcher_keyboard_first_master_search`. Proof deferred to slice closeout.
- request-AC3 -> `item_016_launcher_keyboard_first_master_search`. Proof deferred to slice closeout.
- request-AC2 -> `item_017_panel_keybinds_dismissal_consistency`. Proof deferred to slice closeout.
- request-AC2 -> `item_018_lock_screen_customization_widgets_settings_pane`. Proof deferred to slice closeout.
- request-AC3 -> `item_018_lock_screen_customization_widgets_settings_pane`. Proof deferred to slice closeout.
- request-AC1 -> `item_019_theme_applier_plugins_refactor`. Proof deferred to slice closeout.
- request-AC3 -> `item_019_theme_applier_plugins_refactor`. Proof deferred to slice closeout.
- request-AC3 -> `item_020_core_plugin_optional_extraction`. Proof deferred to slice closeout.
- request-AC4 -> `item_020_core_plugin_optional_extraction`. Proof deferred to slice closeout.
- request-AC3 -> `item_021_theme_packs_official_community`. Proof deferred to slice closeout.
- request-AC1 -> `item_021_theme_packs_official_community`. Proof deferred to slice closeout.
- request-AC3 -> `item_022_visual_builder_drag_and_drop_spatial_zone_representation`. Proof deferred to slice closeout.
- request-AC2 -> `item_023_dev_workflow_bar_widgets_docker_keyboardlayout_capslock`. Proof deferred to slice closeout.
- request-AC3 -> `item_023_dev_workflow_bar_widgets_docker_keyboardlayout_capslock`. Proof deferred to slice closeout.
- request-AC2 -> `item_024_dev_workflow_rofi_scripts_aws_terraform_vscode_monitor`. Proof deferred to slice closeout.
- request-AC2 -> `item_025_clipboard_improvements`. Proof deferred to slice closeout.
- request-AC4 -> `item_026_multi_monitor_compositor_utilities`. Proof deferred to slice closeout.
- request-AC2 -> `item_026_multi_monitor_compositor_utilities`. Proof deferred to slice closeout.
- request-AC2 -> `item_027_named_scratchpads`. Proof deferred to slice closeout.
- request-AC2 -> `item_028_tool_discovery_system`. Proof deferred to slice closeout.
- request-AC2 -> `item_029_quick_tools_context_menu_super_x`. Proof deferred to slice closeout.
- request-AC2 -> `item_030_screenshot_recording_improvements`. Proof deferred to slice closeout.
- request-AC2 -> `item_031_kitty_session_presets`. Proof deferred to slice closeout.
- request-AC2 -> `item_032_ssh_quick_connect_super_ctrl_s`. Proof deferred to slice closeout.
- request-AC2 -> `item_033_per_workspace_wallpapers`. Proof deferred to slice closeout.
- request-AC4 -> `item_033_per_workspace_wallpapers`. Proof deferred to slice closeout.
- request-AC4 -> `item_034_portability_machine_profiles`. Proof deferred to slice closeout.
- request-AC5 -> `item_035_coherency_audit_slice_2_selector_unification_remaining`. Proof deferred to slice closeout.
- request-AC1 -> `item_035_coherency_audit_slice_2_selector_unification_remaining`. Proof deferred to slice closeout.
- request-AC5 -> `item_036_coherency_audit_slice_3_flat_mode_sweep`. Proof deferred to slice closeout.
- request-AC5 -> `item_037_coherency_audit_slice_4_dedup_inputs`. Proof deferred to slice closeout.
- request-AC5 -> `item_038_coherency_audit_slice_5_one_offs_tokens`. Proof deferred to slice closeout.
- request-AC2 -> `item_038_coherency_audit_slice_5_one_offs_tokens`. Proof deferred to slice closeout.
- request-AC2 -> `item_039_glass_themed_system_tray_context_menu_tooltip`. Proof deferred to slice closeout.
- request-AC5 -> `item_039_glass_themed_system_tray_context_menu_tooltip`. Proof deferred to slice closeout.
- request-AC2 -> `item_040_demo_onboarding_mode`. Proof deferred to slice closeout.
- request-AC6 -> `item_040_demo_onboarding_mode`. Proof deferred to slice closeout.
- request-AC2 -> `item_041_r_d_missing_common_niche_shell_os_features`. Proof deferred to slice closeout.
- request-AC5 -> `item_042_r_d_r_unixporn_ricing_inspiration_pass`. Proof deferred to slice closeout.
- request-AC2 -> `item_043_fix_dashboard_auto_close_right_after_boot`. Proof deferred to slice closeout.
- request-AC5 -> `item_044_workspace_indicators_3d_polish`. Proof deferred to slice closeout.
- request-AC5 -> `item_045_edit_mode_stragglers_onto_3d_glass_theme`. Proof deferred to slice closeout.
- request-AC3 -> `item_045_edit_mode_stragglers_onto_3d_glass_theme`. Proof deferred to slice closeout.
- request-AC3 -> `item_046_dashboard_customizable_grid`. Proof deferred to slice closeout.
- request-AC2 -> `item_046_dashboard_customizable_grid`. Proof deferred to slice closeout.
- request-AC2 -> `item_047_dashboard_pinnable_projects`. Proof deferred to slice closeout.
- request-AC5 -> `item_048_dashboard_hero_rotating_quote`. Proof deferred to slice closeout.
- request-AC2 -> `item_049_dashboard_customizable_system_notes_data_reliability`. Proof deferred to slice closeout.
- request-AC4 -> `item_049_dashboard_customizable_system_notes_data_reliability`. Proof deferred to slice closeout.
- request-AC5 -> `item_050_gradient_sheen_on_nested_cards_experiment`. Proof deferred to slice closeout.
- request-AC1 -> `item_051_named_theme_personalities_as_glass_base_variants`. Proof deferred to slice closeout.
- request-AC3 -> `item_051_named_theme_personalities_as_glass_base_variants`. Proof deferred to slice closeout.
- request-AC2 -> `item_052_someday_terminal_editor_tooling`. Proof deferred to slice closeout.
- request-AC2 -> `item_053_someday_developer_tooling`. Proof deferred to slice closeout.
- request-AC4 -> `item_053_someday_developer_tooling`. Proof deferred to slice closeout.
- request-AC2 -> `item_054_someday_browser_apps`. Proof deferred to slice closeout.
- request-AC2 -> `item_055_someday_communication_productivity`. Proof deferred to slice closeout.
- request-AC2 -> `item_056_someday_music_media`. Proof deferred to slice closeout.
- request-AC5 -> `item_057_someday_visual_flair`. Proof deferred to slice closeout.
- request-AC2 -> `item_058_someday_tools_to_evaluate`. Proof deferred to slice closeout.
- request-AC2 -> `item_059_someday_reading_cs_books_setup`. Proof deferred to slice closeout.
- request-AC1 -> `item_060_someday_color_extraction_tools_evaluation`. Proof deferred to slice closeout.
- request-AC2 -> `item_061_someday_small_quick_win_installs`. Proof deferred to slice closeout.

# Validation
- (no validation recorded yet)

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
