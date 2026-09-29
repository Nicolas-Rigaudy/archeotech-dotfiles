## task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales - Semantic token layer with contrast floor and spacing/type scales
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-29 16:00:45

# AI Context
- Summary: Four waves: (1) theme slot fidelity + semantic colour roles on official palette steps with a contrast floor, (2) type scale + weights + UI/font scale, (3) 4pt spacing grid + radius spread, (4) opacity/elevation tiers + CI grep invariant.
- Keywords: semantic, token, layer, contrast, floor, spacing, type, scales
- Use when: Changing Commons/Appearance tokens, theme.json slot mappings, or migrating literal colours/sizes.
- Skip when: Surface recipes / pack chrome (item_112) or motion presets (item_114).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`

# Acceptance criteria
- AC1: No hex literal or raw font size outside Commons token files.
- AC2: Automated contrast check passes AA for text roles on every theme.

# Plan
- [ ] Wave 1a: theme slot fidelity. Check every non-Catppuccin themes/*/theme.json slot against the upstream official palette (nord: overlay0-2 are nord1-3 backgrounds, muted must be the official comment colour #616e88; tokyo-night-day: surface0 = bg_highlight, cards must sit on bg/bg_dark). Owner rule: official colours only, never mixed.
- [ ] Wave 1b: semantic colour roles in Appearance (textPrimary/Secondary/Muted/Disabled/OnAccent, borderSubtle/Strong, focus), each resolved per theme to the weakest official step that passes its floor (body 4.5, muted 3.0) on base/mantle/surface0; contrast-check.py checks roles and runs --strict in CI. ADR records the rule.
- [ ] Wave 1c: migrate text colour call sites (overlay0 x44, subtext*/overlay1 picks) to roles; before/after contact sheet across themes x dark/light/flat for owner sign-off; goldens updated.
- [ ] Wave 2: type scale (display/headline tiers, weight + tracking tokens, UI/font scale multiplier); migrate 82 literal font sizes.
- [ ] Wave 3: 4pt spacing grid, wider radius scale; migrate ~226 literal spacings.
- [ ] Wave 4: opacity + elevation tiers (29 shadow sites); CI grep invariant (no hex colour or raw font size outside Commons).
- [ ] Use `python3 -m logics_manager flow progress task task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales.md` after implementation.

# Validation
- Wave 1 (landed 5e38db3 + de16daf): theme-fidelity.py 0 problems (main: 18 invented tones + unmapped nord-light); contrast-check.py --strict 0 gated failures over 13 themes + grimdark and its registers (main fails 13 roles under the same check); 253 text call sites + System Notes values migrated; qmllint no file worse than main (59 files); tests/run.sh 31 passed; runtime renders with --pack grimdark / latte / dracula: 0 TypeErrors; live theme switch via IPC in the nested session matches a fresh render (0.6% vs 36%); visual-verifier PASS on 6 themes x 3 panels; golden diffs verified text-only, 10 goldens regenerated, worktree golden.sh 25/25 ok. Owner reviewed focus sheets + REVIEW-flags.png and approved after fixes (System Notes neutral values -> textSecondary, tokyo-night-day accent -> blue).

# Report
- Wave 1 done: official palette snapshots (themes/_official) + fidelity gate; slot fixes (dracula/alucard/tokyo-night-day invented tones, gruvbox ladder, nord overlays, tokyo-night-day text surfaces on bg); nord-light removed; per-theme and grimdark pack roles; Appearance textPrimary/Secondary/Muted/Disabled/OnAccent, borderSubtle/Strong, focus; strict role contrast in CI; adr_033. Deferred to item_111: light-theme surface recipe (owner: glass looks wrong on light themes) and AA text-on-accent on gruvbox-light / tokyo-night-day / grimdark (no official colour passes; restyle selected pills instead of recolouring accents). Next: wave 2 type scale.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# Notes
- 2026-09-29 owner decisions: (1) official palettes only, never mixed or interpolated; a failing role means our placement is wrong. (2) nord-light is removed (Nord has no official light variant; ours had invented tones and 9 invented accents). (3) When a palette has fewer tones than the 12-slot ladder (Dracula ~5 neutrals), roles reuse official colours and hierarchy comes from borders/weight/size. Fidelity audit vs upstream (catppuccin/palette, folke/tokyonight.nvim extras, morhetz/gruvbox, nordtheme/nord+vim, dracula/dracula-theme README): Catppuccin 4/4 correct; gruvbox(-light) official but overlay ladder reversed (overlay0=light4 brightest); tokyo-night official but surface0=bg_highlight; tokyo-night-day 3 invented tones + surface0=bg_highlight; nord official but overlay0-2 = background shades nord1-3; dracula and alucard 8 invented tones each; monochrome(-light) custom by design.
