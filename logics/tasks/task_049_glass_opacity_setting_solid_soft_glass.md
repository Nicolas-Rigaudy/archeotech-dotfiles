## task_049_glass_opacity_setting_solid_soft_glass - Glass opacity setting: solid, soft, glass
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-10-01 10:05:14

# AI Context
- Summary: Settings > Appearance opacity preset (solid / soft / glass) driving panel, card and kitty alpha from one table, themes/glass-presets.json.
- Keywords: glass, opacity, setting, solid, soft
- Use when: Changing surface transparency, the glass presets, or kitty background opacity.
- Skip when: Palette/role changes (adr_033) or real compositor blur (item_116).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_139_glass_opacity_setting_solid_soft_glass`

# Acceptance criteria
- AC1: Switching the preset changes panel, card and kitty opacity live on light and dark themes.
- AC2: The contrast of text roles still meets the floor at the most transparent preset over a mid-grey wallpaper.

# Plan
- [x] themes/glass-presets.json: per-preset, per-mode alpha for panel, panelAlt, card, kitty (soft = current look).
- [x] Appearance.glassAlpha(role) feeds glassBg/glassBgLight/sheen/surfaceCard; pack flat/matte stays opaque.
- [x] shell.qml binds appearance.glass; AppearancePane gets an Opacity ButtonGroupRow.
- [x] theme-switch.py reads the preset for kitty; `--glass <preset>` patches kitty only; ColorScheme runs it on change.
- [x] contrast-check.py --glass gates text through each preset over mid-grey (AC2), added to CI; tune alphas to pass.
- [x] A/B renders, live-switch proof, goldens, qml-reviewer.
- [x] Use `python3 -m logics_manager flow progress task task_049_glass_opacity_setting_solid_soft_glass.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_049_glass_opacity_setting_solid_soft_glass.md` after implementation.

# Validation
- archeotech-shell fc71e41. contrast-check.py --glass --strict: 0 gated roles below floor over #808080 at solid/soft/glass (tokyo-night-day reported exempt via its mantle exemption); contrast-check --strict 0; theme-fidelity 0; tests/run.sh 31/31; golden.sh 25/25 after --update of 8 *-light scenarios (light soft panels 0.92/0.90 -> 0.96/0.95) + settings-dark (new Opacity row). Renders (visual-verifier PASS 5/5): macchiato soft = main (0.11% px, clock noise); solid opaque; glass more bleed. Live switch in shot.sh (solid -> glass via config.json edit): frame matches static glass (0.22% px) not solid (4.0%); stubs.log shows theme-switch.sh --glass solid then --glass glass. Pack active: glass vs soft identical (0.07%). theme-switch --glass in a fake HOME: kitty background_opacity 1.0/0.9/0.8 (light) patched; unknown preset exits 1.
- Owner test 2026-09-30: Solid left kitty transparent. Causes: (1) kitty's SIGUSR1 reload never re-applies background_opacity to open OS windows (kitty 0.49.1 boss.apply_new_options), fixed by socket-only remote control in kitty.conf (c661273) + theme-switch kitty @ set-background-opacity --all per $XDG_RUNTIME_DIR/kitty-* socket (7a88f91); isolated test: open kitty 0.3 -> opaque live. (2) mango focused_opacity=0.85/unfocused_opacity=0.5 applies to every window; presets now carry winFocused/winUnfocused and theme-switch patches + reloads mango. mango 0.17.4 fixes a window's opacity at map time: reload_config and setoption only affect windows opened afterwards (isolated test: existing window 227,10,12 unchanged, new window 255,0,0).
- Owner confirmed on hardware 2026-10-01: Solid/Glass switch panels, cards and open kitty windows live (kitty opened in Glass goes fully opaque on Solid and back).
- command: `python3 scripts/contrast-check.py --glass --strict && tests/run.sh && scripts/golden.sh` | result: passed | date: 2026-10-01
- Finish workflow executed on 2026-10-01.
- Linked backlog/request close verification passed.

# Report
- One table themes/glass-presets.json (per preset x mode: panel, panelAlt, card, kitty) read by Appearance.qml glassAlpha(), theme-switch.py (kitty; new --glass <preset> kitty-only mode, queued on ColorScheme's apply runner) and contrast-check.py --glass (CI). Settings > Appearance > Style has an Opacity Solid/Soft/Glass control (config appearance.glass; default soft = previous look). AC2 forced alpha floors: light panels >= 0.94 (gruvbox-light) and dark >= 0.82 (monochrome), so light Glass is subtle by design; light Soft panels were raised 0.92 -> 0.96 because the old default was under AA over mid-grey. Packs own material: the preset falls back to the default while a pack is active. Pending owner: after promote, switch the preset once and confirm kitty follows (real kitty never ran in the isolated renders).
- Finished on 2026-10-01.
- Linked backlog item(s): `item_139_glass_opacity_setting_solid_soft_glass`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- Owner 2026-09-30: two presets only, Solid + the base transparent look (Soft); Glass dropped (archeotech-shell f8384d9). A saved unknown preset falls back to the default. Owner test: kitty opacity switches live; windows opened under Soft keep mango's 0.85 after switching to Solid because mango 0.17.4 assigns per-window opacity only at map time (src/mango.c:3848; reload_config does not re-apply it): reopen the window.
- 2026-10-01: preset renamed soft -> glass (archeotech-shell, owner: soft means little). kitty no longer gets mango opacity (windowrule appid:kitty 1.0/1.0, dotfiles f49e094) so Solid/Glass switch open kitty windows fully live; kitty Glass alpha 0.5 dark / 0.77 light = old 0.6/0.9 x mango 0.85. Other apps still take mango opacity at map time.

# AC Traceability
- request-AC2 -> This task. Proof: Solid/Glass preset switches panel, card and kitty opacity live (owner confirmed on hardware 2026-10-01); contrast-check --glass --strict 0 failures over mid-grey (CI).
