## req_000_archeotech_shell_dotfiles - Archeotech shell & dotfiles
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: High
> Theme: Desktop shell
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-09-02 14:27:43

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: archeotech, shell, dotfiles
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Needs
- A fully composable, community-extensible Quickshell desktop shell anyone can install, customize, and extend without editing QML
- Every panel/widget/bar element is a self-describing drop-in module (module.json) placed in a modules directory
- Themes as pure JSON + asset folders (theme.json + wallpaper + app-overrides), drop-in installable
- A drag-and-drop visual builder edit mode wiring any module to any trigger, persisted to config with instant hot-reload
- One codebase running across compositors (MangoWC primary, Hyprland, later Niri/Sway) via a CompositorService abstraction
- Per-instance widget configuration and a GUI plugin/widget manager so users never hand-edit shell-config.json
- A polished, lively, warm liquid-glass aesthetic that does not read bland/cold next to mature shells like Caelestia

# Context
- Targets MangoWC (primary) on Wayland; Hyprland pulled forward pre-v1.0; Niri/Sway post-v1.0
- Built on Quickshell (QML); runs as a named config via qs -c archeotech
- Distributed for fresh Arch Linux installs (paru package lists, install.sh stow deploy)
- Hierarchical theme system (family -> flavor -> accent) driven by theme-switch.py across ~11 app appliers
- Split into public archeotech-shell (the product) + private archeotech-dotfiles (this machine's config)

# Acceptance criteria
- AC1: Theming coherency and cross-app consistency (family/flavor/accent, appliers, selector unification, flat/glass toggle)
- AC2: New widgets, panels, and shell features (system tray, launcher search, pickers, dev-workflow tooling, desktop widgets)
- AC3: Extensibility and the plugin ecosystem (per-instance config, plugin manager, plugin install/manifest, theme packs, visual builder)
- AC4: Stability, portability, and multi-compositor support (CompositorService, Hyprland, dock/undock, hardcoded-path audit, machine profiles)
- AC5: Polish, aesthetics, and liveliness (3D/glass rollout, motion tokens, StateLayer, depth/warmth, legibility/coherency audit)
- AC6: Testing, visual verification, and distribution readiness (headless render harness, visual regression, install/docs, v1.0 release)

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)

# References
- .claude/ROADMAP.md (archived source)
- .claude/DECISIONS.md

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
- `item_062_desktop_widget_layer_sprint_21_chunk_3_deferred`
- `item_063_configschema_auto_forms_plugin_widget_manager_pane`
- `item_064_holder_aware_panels_responsive_vertical_orientation_widgets`
- `item_065_archeotech_plugin_install_mechanism_plugins_json_index`
- `item_066_plugin_manifest_schema_official_verified_minshellversion_deps`
- `item_067_headless_render_harness_shot_sh_qs_ipc_state_driving`
- `item_068_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci`
- `item_069_ai_persona_testers_verify_before_done_loop`
- `item_070_compositorservice_facade_mango_hyprland_service_extraction`
- `item_071_hyprland_config_port_dual_sddm_session_reload_parity`
- `item_072_docs_compositor_support_md_for_both_compositors`
- `item_073_hardcoded_path_audit_zero_home_corvus`
- `item_074_install_sh_rewrite_install_packages_sh_required_vs_optional`
- `item_075_scripted_per_variant_theme_symlinks`
- `item_076_api_install_contributing_docs`
- `item_077_readme_screenshots_demo_gif_v1_0_0_tag`
