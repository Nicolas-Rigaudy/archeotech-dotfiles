## task_011_style_delegate_registry_decorator_fx_motion_tokens_pack_scoped_settings_remaining - style-delegate registry + decorator/FX + motion tokens + pack-scoped settings (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
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

# Report
- Not started.

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
