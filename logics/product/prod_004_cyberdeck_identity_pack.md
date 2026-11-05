## prod_004_cyberdeck_identity_pack - Cyberdeck identity pack
> Date: 2026-11-05
> Status: Proposed
> Related request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
> Related backlog: `item_154_cyberdeck_pack_chassis_palette_roles_and_three_registers`, `item_155_cyberdeck_display_font_and_type_scale`, `item_156_cyberdeck_ornaments_textures_and_panel_styles`, `item_157_pack_controlled_kitty_ansi_slots_so_crow_deck_matches_the_register`, `item_158_crow_agents_module_and_screensaver_in_the_cyberdeck_pack`, `item_159_hud_gauge_face_for_system_stats_cpu_ram_disk_battery`, `item_160_scanner_launcher_style_kill_mode_overlay_and_layout_profiles`
> Related task: `task_076_orchestrate_the_cyberdeck_theme_pack`
> Related architecture: (none yet)
> Reminder: Update status, linked refs, scope, decisions, success signals, and open questions when you edit this doc.

# Overview
A droid-console identity pack (CR-0W as the machine's resident AI) for the shell, kitty and crow deck, with three registers.

# Goals
- One pack restyles the desk, the terminal and crow surfaces together.
- Registers give three moods on one chassis: Protocol, Netrunner, Phosphor.
- Everything original and openly licensed, publishable with the shell.

# Non-goals
- Recreating Cyberpunk 2077, Blade Runner or any other IP look, font or logo.
- New behaviour inside the pack (keybinds, IA, config semantics stay core).

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
- Product back-reference: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Task back-reference: `task_076_orchestrate_the_cyberdeck_theme_pack`
