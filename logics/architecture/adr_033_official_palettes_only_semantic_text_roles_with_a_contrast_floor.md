## adr_033_official_palettes_only_semantic_text_roles_with_a_contrast_floor - Official palettes only; semantic text roles with a contrast floor
> Date: 2026-09-29
> Status: Accepted
> Related request: `req_005_2026_09_28_audit_upgrade_program`
> Related backlog: `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
> Related task: `task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
> Drivers: owner decision 2026-09-29; 63 text-token pairs below the contrast floor in the 2026-09-28 audit; themes with invented tones
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Themes use their designers' official colours exactly, and components draw text through semantic roles that each theme maps to an official slot passing a contrast floor.

# Context
- The shell's palette is a 12-step Catppuccin-shaped ladder (base, mantle, crust, surface0-2, overlay0-2, subtext0-1, text). Most other palettes do not have 12 neutrals, so earlier ports either misplaced official colours (gruvbox overlay ladder reversed; Nord overlays set to background shades nord1-3; Tokyo Night cards on bg_highlight) or invented in-between tones (Dracula and Alucard 8 each, Tokyo Night Day 3, nord-light entirely).
- Components picked raw steps (`overlay0` was the second most used text colour, 1.3-2.6:1 on cards), so contrast depended on each theme's ladder.
- Owner (2026-09-29): "keep official looks from official palettes; if we use the wrong colours in the wrong place it is our fault, not the designer's."

# Decision
- Every colour in a non-custom theme must exist in its official palette, snapshotted in `themes/_official/<family>.json` with upstream source and commit (Catppuccin palette.json, tokyonight.nvim extras, morhetz/gruvbox, nordtheme nord + vim, dracula README + visual-studio-code). `scripts/theme-fidelity.py` enforces it in CI. Archeotech's own themes (monochrome) are listed as custom.
- Nothing is mixed, lightened or interpolated to fill a slot or to pass contrast. When a palette has fewer tones than the ladder, slots reuse an official colour; hierarchy then comes from borders, weight and size.
- Components use semantic roles: `textPrimary`, `textSecondary`, `textMuted`, `textDisabled`, `textOnAccent`, `borderSubtle`, `borderStrong`, `focus` (`Appearance.colors.*`). Each theme's `roles` maps a role to a slot; packs may override. Fallbacks are the Catppuccin dark map.
- Floors, on base, mantle and card (surface0): body roles 4.5:1 (AA), muted 3:1; disabled is exempt. A failing role is fixed by mapping it to a stronger official slot, or by moving text onto a surface where the official text passes (Tokyo Night Day: every text surface is `bg`). `scripts/contrast-check.py --strict` enforces it in CI.
- Nord has no official light variant, so nord-light was removed.

# Consequences
- All 13 themes pass every text role; main failed 13 roles under the same check.
- Some themes lose a visible tier: Dracula and Nord muted text equals secondary text (their comment colours fail 3:1 on cards); Latte and Tokyo Night Day secondary equals primary. Hierarchy there must come from type (item_110 wave 2).
- Applied themes pick up `roles` on the next theme apply; until then the Catppuccin dark fallback map applies.
- Glass sheen gradients still blend surface colours for depth; that is material, not palette, and is decided with item_112 / item_116.
- Tokyo Night Day's surfaces are flat (base = mantle = card = `bg`); cards separate by shadow and rim only. Dracula and Nord muted equals secondary; Latte and Tokyo Night Day secondary equals primary.
- The check measures palette slots. Real cards use a derived `surfaceCard` (surface0 pulled toward the accent, translucent over the wallpaper), so on light themes the rendered contrast is lower than the token contrast (Tokyo Night Day muted captions roughly 2-3:1 on cards). The card material is decided in item_112 / item_116.
- Packs that own a palette declare their own roles and are checked per faction register (Grimdark: textSecondary = subtext1, because subtext0 is 4.36:1 in Forge).
- Open: text on the accent is below 4.5:1 on gruvbox-light (best official colour 4.35:1 on its yellow accent), Tokyo Night Day (3.33:1) and the Grimdark default register (4.14:1). No official colour reaches AA there, so the fix is which accent those themes default to. Reported, not gated, pending an owner decision.

# References
- Related request: (none yet)
- Related backlog: `item_110_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
- Related task: `task_047_semantic_token_layer_with_contrast_floor_and_spacing_type_scales`
