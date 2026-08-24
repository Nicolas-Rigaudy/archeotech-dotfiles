## task_011_style_delegate_registry_decorator_fx_motion_tokens_pack_scoped_settings_remaining - style-delegate registry + decorator/FX + motion tokens + pack-scoped settings (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 60%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-08-21 17:57:25

# AI Context
- Summary: Build the theming engine per adr_027 as additive LAYERS over the reactive `Appearance` singleton — NOT a per-component style-registry rewrite. Wave 1: pack `activePack` + reactive token overlay (pack tokens.json > base theme.json > fallback) at the singleton, + `base` reference pack. Wave 2: additive decorator/FX + frame-chrome at chrome mount points + motion-token overlay. Wave 3: curated `minShellVersion`-gated style-delegate seam (~6 components, filename-convention `<packDir>/styles/<ComponentId>.qml`) + `docs/STYLE_API.md`. Wave 4: pack-scoped settings via existing ConfigForm (item_063) under `packs.<id>.*`.
- Keywords: style, delegate, registry, decorator, motion, tokens, pack, scoped, settings, overlay, activePack, minShellVersion, adr_027
- Use when: Building any wave of the theming engine or the versioned style contract.
- Skip when: Authoring a concrete pack (item_082 consumes this) or working plugin install/manifest plumbing (item_065/066).

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_081_theming_capability_surface_engine_token_tree_component_style_registry_decorator_fx_motion_hooks_pack_scoped_settings`

# Acceptance criteria
- AC1: A pack can override tokens, shape, fonts, decorator/FX, motion, and assets, and declare pack-scoped settings, without touching core behaviour/IA/keybinds.
- AC2: The component style-delegate contract is versioned (minShellVersion-checkable) and documented for pack authors.

# Plan
- [ ] Wave 1 — Pack token overlay (backbone): `Appearance.activePack` (persisted via Config) + reactive merge (pack `tokens.json` > base `theme.json` > fallback) at the singleton; cache merged tokens on activePack change; load a pack's dir via injected-appearance (adr_016); ship the current glass look as the `base` reference pack. Verify headlessly with shot.sh (isolated fake-HOME) that a token-only pack reskins the whole shell.
- [ ] Wave 2 — Decorator/FX + motion: additive overlay items (bg texture/shader, glow/sheen, frame chrome) at chrome mount points (FrameBackground, panel shells, bar frame), gated by activePack + global on/off; motion-token overlay over `Appearance.anim`/`curve`.
- [ ] Wave 3 — Curated versioned style-delegate contract: delegate seam for ~6 load-bearing components (GlassButton, DashCard, SegmentedControl, BarPill, PanelShadow, one form Row); pack visual via `<packDir>/styles/<ComponentId>.qml` (base fallback); gate on `minShellVersion`; write `docs/STYLE_API.md`.
- [ ] Wave 4 — Pack-scoped settings: pack `configSchema` → existing ConfigForm (item_063), persisted under `packs.<id>.*`, shown only when active; base 3D/flat toggle becomes a base-pack setting.
- [ ] Use `flow progress task <this> --progress <n>%` at each wave boundary; `flow finish task <this>` after Wave 4.

# Validation
- Wave 1 (Layer A token overlay) delivered + headless-verified 2026-08-22. Appearance.activePack + tokens.json overlay (pack > base > fallback) in Commons/Appearance.qml; wired via shell.qml Binding to Config appearance.activePack; docs/THEME_PACK.md authoring reference. Proof: isolated fake-HOME + a test-crimson pack reskinned the whole shell (crimson glass frame, red accents) vs sapphire baseline with zero component edits and no QML errors (shot.sh). archeotech-shell commit c72080e.
- Wave 1 Layer A now usable end-to-end (2026-08-23). Added Services/Shell/PackRegistry.qml (bundled packs/ + XDG discovery via Process+jq, mirrors ModuleRegistry), Appearance.activePackDir (dir resolved by PackRegistry in shell.qml — keeps Commons free of Services imports), a Theme Pack DropdownRow selector in AppearancePane bound to Config appearance.activePack, and a bundled example pack packs/angular (official Catppuccin palette + mauve accent + crisp radius; no hand-rolled colours). Headless proof: PackRegistry discovered angular, selecting it reskinned the shell (mauve accents + sharp corners) with no QML errors. archeotech-shell commit 880b0c2.
- Correction (2026-08-23): the Wave-1b selector was first built with a DropdownRow/ComboBox — off-brand and its native popup mispositions in the layer-shell settings window. Replaced with a SegmentedControl matching the pane's existing Mode/Flavor pickers; verified visually by rendering AppearancePane in isolation (_packharness.qml + shot.sh --qml): Theme Pack row now shows Base|Angular in the same language as Mode/Flavor, no popup. archeotech-shell commit for the fix supersedes the earlier claim.
- Wave 1 token-bypass fix (2026-08-23): user testing found some surfaces stayed rounded under the angular pack. Wallpaper preview corners hardcoded radius:14 → now read Appearance.radius.lg (genuine bypass; verified crisp under angular via _wpharness.qml). Popup necks already read radius.md (arc, not angle — shape change deferred to Layer B/C). Bar/strip frame corners were user-layout config, not a token — folded into Wave 2 (below). archeotech-shell commit aea699c.
- Wave 2 window-chrome round from user testing (2026-08-24): the theme now reaches the REAL windows (always the intended direction, not scope creep). (1) Per-window brackets: MangoWC extended to `watch all-clients` (live client geometry) + monitor offsets; new Modules/Shell/WindowBrackets.qml draws sharp/rounded corner brackets at EVERY visible window's corners on the Overlay surface (above windows), focused window full-strength + unfocused dimmed (brackets carry focus indication). Replaces the old 4-screen-corner brackets (removed from FrameFx). (2) Pack-driven window decoration: pack `window` block {cornerRadius, borderWidth} → MangoWC.applyWindowDecor seds mango border_radius/borderpx + `mmsg dispatch reload_config`, IDEMPOTENT (greps current values, only reloads on real change → no keyboard-layout cycle on matching-config startup; preserves layout across the reload). Wired from shell.qml on pack change. HUD pack now: sharp+borderless windows, sharp per-window brackets, no clashing accent border. (3) Glow was mistakenly rendered as a rim around the content hole (reading as ON the windows) — moved back ONTO the frame (bar/strip-side gradient bands, full-width top/bottom so corners are covered). Verified in nested mango WITH windows + a borderless/sharp mango config; sed/grep change-detection logic unit-checked. archeotech-shell commits b2a49f6, 933fe9a.
- Wave 2 FX fixes from user testing (2026-08-24): (1) glow left a dark unglowed notch at each rounded corner (4 axis-aligned gradient bands didn't cover the corner arc) — replaced with a single blurred rounded-rect rim (MultiEffect) that follows the corner continuously; (2) HUD grid texture was invisible at opacity 0.06 — brighter/denser asset + opacity 0.18; (3) HUD brackets sat as sharp marks over the outer tiled windows' rounded corners (screen-frame motif, only 4 corners, inherent) — dropped from the HUD default (mechanism kept for packs that want it). Verified in a nested compositor WITH real kitty windows open (new: prior shots rendered an empty desktop, hiding frame↔window interaction). archeotech-shell commit b206e8c. Bundled HUD demo pack commit a2c3686.
- Wave 2 (Layer B: frame shape + motion + decorator/FX) delivered + headless-verified 2026-08-24. (a) Frame corner connections follow the pack: ShellConfig.cornerRadius() consults Appearance.packFrameRadius() (pack `frame.cornerRadius` wins, user Settings→Shell value is fallback) — theme owns always-visible chrome per user call; FrameBackground rebuilds on pack change, ShellSurface _r binding tracks it. Verified: base round-12 fillet vs angular crisp-3 corner (commit d8e375a). (b) Motion tokens: Appearance.anim (durations) + curve (M3 beziers) route through _tok so a pack retunes shell-wide motion; defaults preserved (commit a9bf0da, also fixed the frame pack-rebuild signal handler name on_PackDataChanged). (c) Decorator/FX: new Modules/Shell/FrameFx.qml — additive, pack-gated overlay mounted once over FrameBackground (z:1), driven by pack `fx` block: tiled texture over the frame bands (content hole clean), accent rim glow (gradient, no blur), HUD corner brackets. Anchors to content-hole geometry FrameBackground now publishes (contentRect + cornerR). Verified with a test-hud pack (peach accent) — all three composite correctly, base look untouched with no fx (commits 71b7a16, 93b772c). Docs: THEME_PACK.md updated for Layer B (commit b2afc4b). NB: mid-build broken intermediate saves briefly broke the LIVE shell (repo is symlinked to ~/.config/quickshell/archeotech, hot-reloads) — recovered; lesson logged to keep watched-file saves valid.

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
