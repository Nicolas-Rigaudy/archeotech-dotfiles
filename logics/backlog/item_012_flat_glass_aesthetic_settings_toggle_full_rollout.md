## item_012_flat_glass_aesthetic_settings_toggle_full_rollout - Flat <-> glass aesthetic Settings toggle full rollout
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Aesthetic tokens
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-04 15:31:20

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: flat, glass, aesthetic, settings, toggle, full, rollout
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Flat-mode spike shipped on migrated surfaces only; un-migrated popups/media/edit-mode/openers stay glassy

# Scope
- In:
  - Route remaining surfaces' sheen+shadows through flatMode/shadowStrength tokens so the toggle flips the whole shell
- Out:
  - Named theme personalities

# Acceptance criteria
- AC5: The Settings flat/glass toggle flips every surface consistently

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: The Settings flat/glass toggle flips every surface consistently
- request-AC1 -> This backlog slice. Proof: AC5: The Settings flat/glass toggle flips every surface consistently

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — flatMode token gates shadowStrength (delivered); remaining: accent-gradient gating shell-wide. Keep Ready.
- Finding 2026-09-04 (from item_036 flat/3D sweep): translucent NEUTRAL tile fills lose all contrast in flat mode. `surface0Alpha` (fixed 0.60) reads as a raised tile only over the frosted glass panel; in flat the panel is opaque `surfaceCard` (== opaque surface0), so a translucent surface0 tile collapses INTO its container and the tile box vanishes. This is an ELEVATION gap, not an opacity one — making the token merely opaque doesn't help (tile would still equal the panel); flat-mode raised tiles must step to a lighter tint above their container. QuickLaunch fixed locally (shell 0240347: flat → Qt.lighter(surfaceCard,1.12)); the SAME pattern still affects every other `surface0Alpha` tile-on-panel surface — Launcher, WallpaperPicker(Body), SettingsSidebar, LayoutPickerBody. Proper fix here = a flat-aware "raised tile" elevation token so the whole toggle flips these consistently, rather than N local patches.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_022_flat_glass_aesthetic_settings_toggle_full_rollout`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Tasks
- `task_022_flat_glass_aesthetic_settings_toggle_full_rollout`

# Notes
- Task `task_022_flat_glass_aesthetic_settings_toggle_full_rollout` was finished via `logics-manager flow finish task` on 2026-09-04.
