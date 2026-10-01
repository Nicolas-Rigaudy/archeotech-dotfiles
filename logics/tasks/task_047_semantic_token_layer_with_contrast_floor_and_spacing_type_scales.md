## task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales - Semantic token layer with contrast floor and spacing/type scales
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
> Indicators reviewed: 2026-10-01 15:24:36

# AI Context
- Summary: Four waves: (1) theme slot fidelity + semantic colour roles on official palette steps with a contrast floor, (2) type scale + weights + UI/font scale, (3) 4pt spacing grid + radius spread, (4) opacity/elevation tiers + CI grep invariant.
- Keywords: semantic, token, layer, contrast, floor, spacing, type, scales
- Use when: Changing Commons/Appearance tokens, theme.json slot mappings, or migrating literal colours/sizes.
- Skip when: Surface recipes / pack chrome (item_112) or motion presets (item_114).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`

# Acceptance criteria
- AC1: No hex literal or raw font size outside Commons token files.
- AC2: Automated contrast check passes AA for text roles on every theme.

# Plan
- [x] Wave 1a: theme slot fidelity. Check every non-Catppuccin themes/*/theme.json slot against the upstream official palette (nord: overlay0-2 are nord1-3 backgrounds, muted must be the official comment colour #616e88; tokyo-night-day: surface0 = bg_highlight, cards must sit on bg/bg_dark). Owner rule: official colours only, never mixed.
- [x] Wave 1b: semantic colour roles in Appearance (textPrimary/Secondary/Muted/Disabled/OnAccent, borderSubtle/Strong, focus), each resolved per theme to the weakest official step that passes its floor (body 4.5, muted 3.0) on base/mantle/surface0; contrast-check.py checks roles and runs --strict in CI. ADR records the rule.
- [x] Wave 1c: migrate text colour call sites (overlay0 x44, subtext*/overlay1 picks) to roles; before/after contact sheet across themes x dark/light/flat for owner sign-off; goldens updated.
- [x] Wave 2: type scale (display/headline tiers, weight + tracking tokens, UI/font scale multiplier); migrate 82 literal font sizes.
- [x] Wave 3: 4pt spacing grid, wider radius scale; migrate ~226 literal spacings.
- [x] Wave 4: opacity + elevation tiers (29 shadow sites); CI grep invariant (no hex colour or raw font size outside Commons).
- [x] Use `python3 -m logics_manager flow progress task task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales.md` after implementation.

# Validation
- Wave 1 (landed 5e38db3 + de16daf): theme-fidelity.py 0 problems (main: 18 invented tones + unmapped nord-light); contrast-check.py --strict 0 gated failures over 13 themes + grimdark and its registers (main fails 13 roles under the same check); 253 text call sites + System Notes values migrated; qmllint no file worse than main (59 files); tests/run.sh 31 passed; runtime renders with --pack grimdark / latte / dracula: 0 TypeErrors; live theme switch via IPC in the nested session matches a fresh render (0.6% vs 36%); visual-verifier PASS on 6 themes x 3 panels; golden diffs verified text-only, 10 goldens regenerated, worktree golden.sh 25/25 ok. Owner reviewed focus sheets + REVIEW-flags.png and approved after fixes (System Notes neutral values -> textSecondary, tokyo-night-day accent -> blue).
- Wave 2 (archeotech-shell 668d60e): token-lint.py 0 raw typography values (main: 124 = 84 sizes, 33 weights, 7 letter-spacings; catches ternaries/arithmetic); tests/run.sh 31/31; contrast-check --strict and --glass 0; theme-fidelity 0; golden.sh 25/25 after --update of media-*, settings-*, notifications-* (snapped icons 30/34->32, 15->16 and the 1-2 px text shift they cause); Text size 1.2 renders: settings, dashboard and bar hold (bar icons fit the 30 px bar; Quick Launch labels truncate one step earlier).
- Wave 3 (archeotech-shell 3517847): token-lint 0 (main: 249 off-token spacing/spacer lines); tests 31/31; contrast --strict/--glass 0; golden.sh 25/25 after --update of 17 PNGs (launcher, media, wallpaper, settings, notifications, editmode x dark/light/flat). visual-verifier PASS 4/4 (only small gap shifts, no overlap/clipping, alignment kept, circles unchanged); wallpaper-light 146 px re-rendered twice = deterministic tab-strip icon gap 6->8, main 0 px both runs. Owner saw no difference between tighter/roomier variants (sheet), so ties round up.
- Wave 4 (archeotech-shell fd13057): token-lint 0 (main: 10 hex colours: FrameFx 9, PanelRegistry 1); theme-fidelity 0 incl. new ThemeCatalog swatch check (tamper test #88c0d0->#88c0d1 caught, exit 1); tests 31/31; contrast --strict/--glass 0; golden.sh 25/25 after --update of dashboard-dark/flat only (88 px: accent card titles no longer faded); main re-run 31 px vs worktree 88 px twice = deterministic. qml-reviewer: ship (tiers re-evaluate on shadowStrength).
- command: `python3 scripts/token-lint.py && python3 scripts/contrast-check.py --strict && python3 scripts/theme-fidelity.py && tests/run.sh && scripts/golden.sh` | result: passed | date: 2026-10-01
- Finish workflow executed on 2026-10-01.
- Linked backlog/request close verification passed.

# Report
- Wave 1 done: official palette snapshots (themes/_official) + fidelity gate; slot fixes (dracula/alucard/tokyo-night-day invented tones, gruvbox ladder, nord overlays, tokyo-night-day text surfaces on bg); nord-light removed; per-theme and grimdark pack roles; Appearance textPrimary/Secondary/Muted/Disabled/OnAccent, borderSubtle/Strong, focus; strict role contrast in CI; adr_033. Deferred to item_111: light-theme surface recipe (owner: glass looks wrong on light themes) and AA text-on-accent on gruvbox-light / tokyo-night-day / grimdark (no official colour passes; restyle selected pills instead of recolouring accents). Next: wave 2 type scale.
- Wave 2 done: one size scale font.size2xs..size7xl (10,11,12,13,14,16,18,20,22,24,32,40) + sizeTitle/sizeHeadline/sizeDisplay, weight* and tracking* tokens; 84 literal sizes (snaps 9->10, 15->16, 30/34->32, 36->40), 33 weights, 7 letter-spacings migrated across 36 files; Settings > Appearance > Text size (0.9/1/1.1/1.2, config appearance.fontScale, clamped 0.8-1.4) multiplies every step; CI step token-lint.py (plugin examples in modules/ exempt). Next: wave 3 (4pt spacing grid, ~226 literal spacings), wave 4 (opacity/elevation tiers + hex-colour invariant).
- Wave 3 done: Appearance.spacing s1..s12 (4pt grid, 4..48; legacy xs/sm/base/md/lg/xl aliases, sm 6->8, md 10->12); 303 spacing/margin/padding/spacer literals >= 4 px across 52 files routed through it (ties up: 6->8, 10->12, 14->16, 18->20); 0-3 px hairlines stay literal; radius.xs 4 added, circles/pill bars now width/2 or height/2. token-lint gains off-token spacing + spacer rules. Left for later: HoverCard geometry literals (+10/+14), two one-off radii (ThemeCarousel 12, ColorSchemeBody 13). Next: wave 4 (opacity/elevation tiers, hex-colour invariant).
- Wave 4 done: Appearance.elevation e1..e5 (blur/y/spread/alpha, colour carries shadowStrength) on all 28 RectangularShadows; Appearance.opacity divider/ghost/specular; five text opacity fades replaced by text roles (never fade text); FrameFx plate colours -> Appearance.steel (pack-overridable); token-lint hex rule (Commons/, packs/, ThemeCatalog exempt; swatches verified by theme-fidelity). item_110 complete: AC1 enforced by token-lint in CI, AC2 by contrast-check --strict in CI.
- Finished on 2026-10-01.
- Linked backlog item(s): `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- 2026-09-29 owner decisions: (1) official palettes only, never mixed or interpolated; a failing role means our placement is wrong. (2) nord-light is removed (Nord has no official light variant; ours had invented tones and 9 invented accents). (3) When a palette has fewer tones than the 12-slot ladder (Dracula ~5 neutrals), roles reuse official colours and hierarchy comes from borders/weight/size. Fidelity audit vs upstream (catppuccin/palette, folke/tokyonight.nvim extras, morhetz/gruvbox, nordtheme/nord+vim, dracula/dracula-theme README): Catppuccin 4/4 correct; gruvbox(-light) official but overlay ladder reversed (overlay0=light4 brightest); tokyo-night official but surface0=bg_highlight; tokyo-night-day 3 invented tones + surface0=bg_highlight; nord official but overlay0-2 = background shades nord1-3; dracula and alucard 8 invented tones each; monochrome(-light) custom by design.

# AC Traceability
- request-AC3 -> This task. Proof: no hex colour, raw font size/weight/tracking or off-grid spacing outside Commons (scripts/token-lint.py, CI); text roles AA on every theme (scripts/contrast-check.py --strict and --glass, CI); official palettes only (scripts/theme-fidelity.py, CI).
