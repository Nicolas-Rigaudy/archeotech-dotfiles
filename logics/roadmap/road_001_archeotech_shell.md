## road_001_archeotech_shell - Archeotech shell
> Date: 2026-08-20
> Status: Proposed
> Related product: `prod_001_archeotech_shell`
> Related request: `req_000_archeotech_shell_dotfiles`
> Reminder: Update status, milestone scope, linked refs, risks, and success signals when you edit this doc.

# AI Context
- Summary: Roadmap for Archeotech shell.
- Keywords: roadmap, milestones, versions, archeotech shell
- Use when: Planning or sequencing versions for Archeotech shell.
- Skip when: You need execution details for a single backlog item or task.

# Summary
Plan the path from first usable increment to stable release for archeotech shell.

# Milestones
## 0.26 - Widget Extensibility & Plugin Manager






























- `item_050_gradient_sheen_on_nested_cards_experiment`: Gradient sheen on nested cards experiment
- `item_045_edit_mode_stragglers_onto_3d_glass_theme`: Edit mode + stragglers onto 3D/glass theme
- `item_044_workspace_indicators_3d_polish`: Workspace indicators 3D polish
- `item_043_fix_dashboard_auto_close_right_after_boot`: Fix dashboard auto-close right after boot
- `item_039_glass_themed_system_tray_context_menu_tooltip`: Glass-themed system-tray context menu + tooltip
- `item_038_coherency_audit_slice_5_one_offs_tokens`: Coherency audit Slice 5 - one-offs + tokens
- `item_037_coherency_audit_slice_4_dedup_inputs`: Coherency audit Slice 4 - dedup + inputs
- `item_036_coherency_audit_slice_3_flat_mode_sweep`: Coherency audit Slice 3 - flat-mode sweep
- `item_035_coherency_audit_slice_2_selector_unification_remaining`: Coherency audit Slice 2 - selector unification (remaining)
- `item_017_panel_keybinds_dismissal_consistency`: Panel keybinds / dismissal consistency
- `item_016_launcher_keyboard_first_master_search`: Launcher keyboard-first master search
- `item_015_auto_hide_sides_in_fullscreen`: Auto-hide sides in fullscreen
- `item_012_flat_glass_aesthetic_settings_toggle_full_rollout`: Flat <-> glass aesthetic Settings toggle full rollout
- `item_010_move_thumbnail_cache_to_freedesktop_shared_path`: Move thumbnail cache to freedesktop shared path
- `item_009_palette_crossfade_on_theme_apply`: Palette crossfade on theme apply
- `item_008_eager_warm_the_wallpapers_service_at_shell_startup`: Eager-warm the Wallpapers service at shell startup
- `item_007_async_fade_in_on_wallpaper_thumbnails`: Async fade-in on wallpaper thumbnails
- `item_006_live_colour_preview_on_scroll_in_pickers`: Live colour preview on scroll in pickers
- `item_004_check_widened_settings_panes_760_940_don_t_look_sparse`: Check widened Settings panes (760->940) don't look sparse
- `item_002_visual_pass_on_the_light_themes`: Visual pass on the light themes
- `item_048_dashboard_hero_rotating_quote`: Dashboard hero rotating quote
- `item_047_dashboard_pinnable_projects`: Dashboard pinnable projects
- `item_049_dashboard_customizable_system_notes_data_reliability`: Dashboard customizable System Notes + data reliability
- `item_046_dashboard_customizable_grid`: Dashboard customizable grid
- `item_018_lock_screen_customization_widgets_settings_pane`: Lock screen customization / widgets Settings pane
- `item_013_layout_loadouts_presets`: Layout loadouts / presets
- `item_062_desktop_widget_layer_sprint_21_chunk_3_deferred`: Desktop widget layer (Sprint 21 Chunk 3, deferred)
- `item_022_visual_builder_drag_and_drop_spatial_zone_representation`: Visual Builder drag-and-drop + spatial zone representation
- `item_064_holder_aware_panels_responsive_vertical_orientation_widgets`: Holder-aware panels + responsive vertical-orientation widgets
- `item_063_configschema_auto_forms_plugin_widget_manager_pane`: configSchema auto-forms + Plugin/Widget Manager pane
- Goal: Make every widget/module per-instance configurable and manageable from a GUI, removing the last need to hand-edit shell-config.json.
- Scope: configSchema-driven auto-generated settings forms, `{id, config}` zone entries with back-compat shim, per-instance config injection through the widget loaders, a Plugins/Widget Manager settings pane, and responsive vertical-orientation widgets + holder-aware panels (bars can host panels).
- Exit signal: Two clocks with different formats coexist, plugins enable/disable and configure from the manager pane, and every widget lays out correctly on any side (horizontal or vertical); only optional drag-reorder polish remains open.

## 0.27 - Dev Workflow: First Official Plugin







- `item_021_theme_packs_official_community`: Theme Packs (official + community)
- `item_024_dev_workflow_rofi_scripts_aws_terraform_vscode_monitor`: Dev-workflow rofi scripts (AWS/Terraform/VSCode/monitor)
- `item_023_dev_workflow_bar_widgets_docker_keyboardlayout_capslock`: Dev-workflow bar widgets (Docker/KeyboardLayout/CapsLock)
- `item_019_theme_applier_plugins_refactor`: Theme-applier plugins refactor
- `item_020_core_plugin_optional_extraction`: Core -> plugin / optional extraction
- `item_066_plugin_manifest_schema_official_verified_minshellversion_deps`: Plugin manifest schema (official/verified/minShellVersion/deps)
- `item_065_archeotech_plugin_install_mechanism_plugins_json_index`: archeotech plugin install mechanism + plugins.json index
- Goal: Ship the git/AWS/Terraform/Docker dev tooling as the first official plugin package, dogfooding the plugin install/manifest/enable story.
- Scope: plugin manifest fields (official/verified/minShellVersion/dependencies), `archeotech plugin install <name>` git-clone mechanism + repo-hosted plugins.json index, a dev-workflow plugin bundling GitWidget/AwsWidget/TerraformWidget/DockerWidget plus rofi menus, all enabled/configured via the S26 Plugin Manager.
- Exit signal: A user can install the dev-workflow plugin by name from the index and enable/configure it through the manager, with niche dev tooling kept out of core.

## 0.28 - Testing & Visual-Verification Pipeline





- `item_003_verify_vscode_colorcustomizations_regen_on_non_catppuccin_themes`: Verify VSCode colorCustomizations regen on non-Catppuccin themes
- `item_001_test_the_auto_day_night_schedule_end_to_end`: Test the auto day/night schedule end-to-end
- `item_069_ai_persona_testers_verify_before_done_loop`: AI persona-testers + verify-before-done loop
- `item_068_visual_regression_vs_goldens_qml_logic_tests_arch_container_ci`: Visual-regression vs goldens + QML logic tests + Arch-container CI
- `item_067_headless_render_harness_shot_sh_qs_ipc_state_driving`: Headless render harness (shot.sh + qs-ipc state-driving)
- Goal: Ship and verify features faster and with higher quality before going public, cutting the "claimed done but wrong" cycle and standing up AI persona-testers.
- Scope: headless render-to-PNG visual verification (safety-fixed shot.sh), temporal/burst capture for motion correctness, qs-ipc state-driving, ImageMagick visual-regression vs goldens, QML logic tests, CI extension in an Arch container, UXAgent-style AI persona-testers, and a verify-before-done loop.
- Exit signal: A visual change can be driven into state, rendered headless, diffed against a golden, and shown inline before being called done; the harness auto-generates the S30 README screenshots.

## 0.29 - Hyprland as 2nd Compositor






- `item_026_multi_monitor_compositor_utilities`: Multi-monitor & compositor utilities
- `item_011_decide_and_apply_lid_close_while_docked_suspend_behaviour`: Decide and apply lid-close-while-docked suspend behaviour
- `item_072_docs_compositor_support_md_for_both_compositors`: docs COMPOSITOR_SUPPORT.md for both compositors
- `item_071_hyprland_config_port_dual_sddm_session_reload_parity`: Hyprland config port + dual SDDM session + reload parity
- `item_070_compositorservice_facade_mango_hyprland_service_extraction`: CompositorService facade + Mango/Hyprland service extraction
- `item_005_fix_dock_undock_freeze_wlroots_output_hotplug_on_mangowm_0_16`: Fix dock-undock freeze (wlroots output-hotplug) on mangowm 0.16
- Goal: Run the shell first-class on Hyprland as well as MangoWC, selectable at login, realizing the CompositorService abstraction (vision pillar 4).
- Scope: a CompositorService facade with a stable API, extracting today's MangoWC into a MangoService, a HyprlandService on the built-in Quickshell.Hyprland service, routing all 11 mmsg sites through the facade, plus a Hyprland compositor config port (keybinds/window rules/monitor/blur), a dual SDDM session, and reload parity.
- Exit signal: Logging into the Hyprland session renders the shell with tracking workspaces, working panels/OSD/blur, and no dock-undock freeze; docs/COMPOSITOR_SUPPORT.md covers both compositors.

## 1.0 - Distribution & v1.0 Release







- `item_040_demo_onboarding_mode`: Demo / onboarding mode
- `item_034_portability_machine_profiles`: Portability & machine profiles
- `item_077_readme_screenshots_demo_gif_v1_0_0_tag`: README screenshots + demo GIF + v1.0.0 tag
- `item_076_api_install_contributing_docs`: API + INSTALL + CONTRIBUTING docs
- `item_075_scripted_per_variant_theme_symlinks`: Scripted per-variant theme symlinks
- `item_074_install_sh_rewrite_install_packages_sh_required_vs_optional`: install.sh rewrite + install-packages.sh (required vs optional)
- `item_073_hardcoded_path_audit_zero_home_corvus`: Hardcoded-path audit (zero /home/corvus)
- Goal: Installable by a stranger on fresh Arch with zero hardcoded paths, documented APIs, and a community that can publish plugins/themes.
- Scope: hardcoded-path audit (zero /home/corvus), install-packages.sh (required vs optional), rewritten install.sh (backup/stow/verify/first-run), scripted per-variant theme symlinks, INSTALL/PLUGIN_API/CONTRIBUTING docs, finalized MODULE/WIDGET/THEME/PANEL API docs, README screenshots + demo GIF (auto-generated via the S28 harness), and the v1.0.0 tag with GitHub metadata.
- Exit signal: A fresh-Arch install by a stranger produces a working shell and the v1.0.0 tag is published with docs, screenshots, and a plugin/theme contribution path.

## post-1.0 - Depth Sprints (portability & extras)





















- `item_061_someday_small_quick_win_installs`: Someday: small quick-win installs
- `item_060_someday_color_extraction_tools_evaluation`: Someday: color extraction tools evaluation
- `item_059_someday_reading_cs_books_setup`: Someday: reading & CS books setup
- `item_058_someday_tools_to_evaluate`: Someday: tools to evaluate
- `item_057_someday_visual_flair`: Someday: visual flair
- `item_056_someday_music_media`: Someday: music & media
- `item_055_someday_communication_productivity`: Someday: communication & productivity
- `item_054_someday_browser_apps`: Someday: browser & apps
- `item_053_someday_developer_tooling`: Someday: developer tooling
- `item_052_someday_terminal_editor_tooling`: Someday: terminal & editor tooling
- `item_042_r_d_r_unixporn_ricing_inspiration_pass`: R&D: r/unixporn + ricing inspiration pass
- `item_041_r_d_missing_common_niche_shell_os_features`: R&D: missing common + niche shell/OS features
- `item_032_ssh_quick_connect_super_ctrl_s`: SSH quick connect (Super+Ctrl+S)
- `item_031_kitty_session_presets`: Kitty session presets
- `item_030_screenshot_recording_improvements`: Screenshot & recording improvements
- `item_029_quick_tools_context_menu_super_x`: Quick tools context menu (Super+X)
- `item_028_tool_discovery_system`: Tool discovery system
- `item_027_named_scratchpads`: Named scratchpads
- `item_025_clipboard_improvements`: Clipboard improvements
- `item_033_per_workspace_wallpapers`: Per-workspace wallpapers
- `item_051_named_theme_personalities_as_glass_base_variants`: Named theme personalities as glass-base variants
- Goal: Extend reach and flair beyond the release for other machines, once the facade and Hyprland have proven the pattern.
- Scope: NiriService/SwayService behind the CompositorService facade (multi-compositor), an archeotech-daemon Go binary for raw Wayland protocols QML can't reach (wlr-output/gamma/screencopy), and personality/flair (shadow-spear theme package, per-workspace wallpapers, SDF GLSL corner shader).
- Exit signal: The shell also runs on Niri and Sway behind the same facade, the Go daemon serves the low-level protocols, and optional persona themes ship as variants without touching core.

# Sequencing
- Deliver milestones in ascending version order unless dependencies force a documented exception.
- Keep each increment independently reviewable and linked to concrete workflow docs.

# Risks
- Long-term scope can drift unless every milestone keeps a clear exit signal.
- Version labels are planning targets, not release promises.

# References
- Product brief(s): `prod_001_archeotech_shell`
- Request(s): `req_000_archeotech_shell_dotfiles`
- Backlog item(s): (none yet)
- Task(s): (none yet)
