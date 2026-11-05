## req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal - Cyberdeck theme pack: droid console identity for the shell and terminal
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-11-05 14:28:01

# AI Context
- Summary: Second official identity pack: a droid-console look with three registers (Protocol, Netrunner, Phosphor), an OFL display font, original ornaments, pack-controlled kitty ANSI slots for crow deck, and the crow agents and screensaver look. CyberArch-Shell ideas (HUD gauges, scanner launcher, kill mode, layout profiles) scoped as core or plugin slices.
- Keywords: cyberdeck, theme, pack, droid, console, identity, shell, terminal
- Use when: Building or reviewing the cyberdeck pack, its kitty output, or crow surfaces inside it.
- Skip when: Grimdark work, the screensaver engine itself (item_085), or gundam (item_129).

# Needs
- Owner request (2026-11-05): a second official identity pack after Grimdark, built on the same pack system, so crow runs in a matching environment on the desk and in the terminal.
- Direction: cyberdeck, sci-fi, CR-0W as a droid character (protocol droids, cyberpunk AIs). Original work only: no Cyberpunk 2077 or other IP assets, fonts or logos; fonts under open licences (OFL).
- Cover: tokens and palette, display font, ornaments and textures, panel styles, pack settings (registers like Grimdark), the kitty ANSI 16 output so crow deck matches, the crow agents module and the future screensaver in the pack.
- Ideas from github.com/ARCANGEL0/CyberArch-Shell (no licence, ideas only, no code or assets): HUD gauge bars for CPU/RAM/disk/battery, a scanner-style launcher, a kill-mode overlay, layout profiles.

# Context
- Pack system: pack.json + tokens.json (Layer A tokens, Layer B fx and motion), styles/<Component>.qml delegates (Layer C), configSchema pack settings (Layer D). Grimdark is the model: one chassis, three registers (Legion, Ordos, Forge) deep-merged over the base colours.
- Kitty follows a pack through scripts/themes/templates/kitty-colors.conf.tmpl: fixed slots (color4 = blue, color5 = pink, color6 = teal), brights equal normals. crow deck draws frames in ANSI slot 4, so a pack whose accent is not blue never reaches the terminal (seen in the 2026-11-05 Netrunner draft render).
- Draft registers rendered 2026-11-05 (throwaway packs, never committed): Protocol (droid console, cyan accent, amber warnings, Oxanium), Netrunner (neon magenta accent, cyan live, Chakra Petch, scanlines), Phosphor (green CRT, amber warnings, VT323, scanlines). All pass contrast-check --strict.
- Behaviour stays core (adr_026 skin/structure boundary): a pack restyles, it never adds kill mode or layout profiles. Those are core or plugin features the pack styles.
- Roadmap: identity packs are 1.1 add-ons (road_001). item_129 holds cyberpunk and gundam; this request is the cyberpunk half in detail.

# Acceptance criteria
- AC1: A cyberdeck pack exists under packs/ with its own palette, roles and registers, selectable live, passing contrast-check --strict for every register.
- AC2: The pack ships an OFL display font, original ornaments and textures and pack panel styles, with no third-party IP asset.
- AC3: kitty and crow deck match the active register: the pack controls which palette colour lands in each ANSI slot, brights included.
- AC4: The crow agents module and the screensaver read the pack tokens and look native in each register.
- AC5: HUD gauges, a scanner launcher style, a kill-mode overlay and layout profiles are scoped as core or plugin features with a pack-styled look, each in its own slice.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)

# References
- archeotech-shell docs/THEME_PACK.md
- archeotech-shell packs/grimdark
- archeotech-shell scripts/themes/templates/kitty-colors.conf.tmpl
- logics/backlog/item_129_additional_add_on_identity_packs_cyberpunk_and_gundam.md
- logics/backlog/item_085_idle_and_screensaver_mode.md
- logics/backlog/item_151_theme_pack_wallpapers_grimdark_hud_angular.md
- cr-0w integrations/archeotech/crow-agents
- cr-0w logics/request/req_015_wishlist_ambient_mobile_voice_colleague_ideas.md
- cr-0w local/state/shots/cyberdeck-pack (draft registers, renders, compare page)

# Backlog
- `item_154_cyberdeck_pack_chassis_palette_roles_and_three_registers`
- `item_155_cyberdeck_display_font_and_type_scale`
- `item_156_cyberdeck_ornaments_textures_and_panel_styles`
- `item_157_pack_controlled_kitty_ansi_slots_so_crow_deck_matches_the_register`
- `item_158_crow_agents_module_and_screensaver_in_the_cyberdeck_pack`
- `item_159_hud_gauge_face_for_system_stats_cpu_ram_disk_battery`
- `item_160_scanner_launcher_style_kill_mode_overlay_and_layout_profiles`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Notes
- 2026-11-05: first pass (token-only Protocol/Netrunner/Phosphor registers) rejected by the owner as a colour filter on the stock shell. Redone as three full directions (Megacorp, Netrunner, Deck) with their own structure, rendered as QML mockups; research in .claude/CYBERDECK_RESEARCH.md, compare page cr-0w local/state/shots/cyberdeck-pack/compare2.html. Direction pick pending. Owner direction: cyberdeck aesthetic, megacorp corporate terminals, matrix data, CR-0W droid.
