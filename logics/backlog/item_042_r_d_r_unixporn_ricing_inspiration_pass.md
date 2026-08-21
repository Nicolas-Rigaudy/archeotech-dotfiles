## item_042_r_d_r_unixporn_ricing_inspiration_pass - R&D: r/unixporn + ricing inspiration pass
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 95%
> Confidence: 90%
> Progress: 100%
> Complexity: Low
> Theme: Research
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:01:07

# AI Context
- Summary: Inspiration sweep over r/unixporn + ricing communities and the peer Quickshell shells (Noctalia, Caelestia, DankMaterialShell, end-4/dots-hyprland). NOTE: archeotech is a themeable-shell platform = a neutral glassmorphism BASE theme + swappable identity PACKS (Gundam-HUD, 40K dataslate, cyberdeck neon, later Star Wars/games). Findings are triaged as "base-theme polish" vs "theme-pack material" and feed the polish pass (task_002) + 1.0 scope (task_001).
- Keywords: unixporn, ricing, inspiration, pass, matugen, overview, cava, HUD, scanlines, motion-language
- Use when: Planning the next design-polish wave, or deciding which visual-flair features are worth net-new backlog items before 1.0.
- Skip when: Implementing a specific already-scoped polish item, or working release/portability plumbing (own items).

# Problem
- Untapped inspiration for making the shell cooler/more customizable/more appealing

# Scope
- In:
  - Inspiration pass over ricing communities; feed findings into the polish pass
- Out:
  - Direct implementation

# Acceptance criteria
- AC5: An inspiration findings list feeds the polish backlog

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: An inspiration findings list feeds the polish backlog

# Findings (2026-08-21)

## Method
- Swept r/unixporn 2025-26 trend commentary + the peer Quickshell shells (Noctalia, Caelestia, DankMaterialShell — DMS also targets MangoWC, end-4/dots-hyprland) and the cyberpunk/HUD ricing corner.
- Triaged every idea against (a) the themeable model — a neutral glassmorphism base + swappable identity packs (Gundam-HUD, 40K dataslate, cyberdeck; STYLE_GUIDE describes these influences), and (b) what the shell + backlog already cover — noting dupes rather than re-proposing them.
- Landscape note: Hyprland+matugen Material-You rices are now saturated/cookie-cutter. Archeotech differentiates two ways: (1) a clean glass BASE that competes on the standard axis, and (2) swappable identity PACKS (WH40K/mecha/cyberpunk lore) that most single-look rices can't offer. Findings favour a strong base + distinctive packs over trend-following.
- Note on A1-A4 below: several "adopt" items are actually **theme-pack material** (HUD framing, shaders), not base-theme polish — tagged inline.

## Adopt — high aesthetic fit, net-new (candidates for new backlog items feeding task_002)
- **A1. HUD framing kit** [THEME-PACK material — Gundam/cyberdeck packs]: clipped/angular corner cuts, corner brackets/ticks, thin technical grid/reticle overlays, all-caps monospace micro-labels. A reusable primitive packs opt into; NOT on the neutral base. Promoted -> item_078.
- **A2. cava audio visualizer element** [BASE-capable, pack-flavored] — bar/dashboard/lock-screen spectrum; opt-in widget usable on base, restyled per pack. Pairs with existing MPRIS surface. Promoted -> item_079.
- **A3. Subtle tech-noir shader overlays** [THEME-PACK material — cyberdeck/40K packs]: faint scanlines / chromatic-aberration / grain / parchment-grain on lock + ritual moments (NOT everywhere). A per-pack texture layer, off on the base.
- **A4. Motion language pass** [BASE polish + per-pack overrides] — shared bezier easings (Material-3-style) for panel open/close, workspace change, OSD. Base gets one tasteful easing set; packs may override for character. Codify an easing token set (coherency-audit sibling).

## Consider — good, but scope/lore-fit needs a decision
- **C1. Optional accent-from-wallpaper** — extract ONLY the accent, keep Macchiato base + token pipeline intact (relates to Someday "color extraction tools evaluation"). Opt-in, so it doesn't dilute the fixed-palette identity.
- **C3. Anti-flashbang / auto-dim** bright surfaces (end-4). Small QoL, fits "quiet, dark" persona.
- **C4. Ritual-styled OSD** — volume/brightness/caps as a themed HUD readout rather than a plain bar.

## Skip — off-persona or low ROI for this shell
- AI assistant sidebar (Gemini/ChatGPT) — scope creep for 1.0; Corvus is dev-focused but this isn't shell identity.
- Screen translation / Google Lens / on-screen keyboard (end-4 niceties) — off-persona.
- Full wallpaper-driven Material You theming — deliberately declined (see landscape note); it's the trend the shell differentiates *against*.

## Already covered (confirmed, not re-proposed)
- Window/workspace **overview** — already shipped as MangoWC corner-action overview mode (do NOT re-propose an exposé).
- Launcher master search item_016 · clipboard item_025 · per-workspace wallpapers item_033 · lock-screen customization item_018 · palette crossfade item_009 · live colour preview item_006 · glass system-tray item_039 · notifications/MPRIS/system-tray shipped · flat<->glass toggle item_012.

## Disposition
- Adopt A1-A4 and Consider C1-C4 are the feed into task_002 / task_001. Recommend promoting **A1 (HUD framing kit)** and **A2 (cava visualizer)** into backlog items first (highest fit-to-effort), and raising **C1 (overview)** as a 1.0-scope decision. Left as findings pending the user's promote call — not auto-created.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
