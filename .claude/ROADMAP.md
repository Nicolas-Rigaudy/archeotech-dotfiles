# Roadmap

**Last Updated:** 2026-07-30  
**See also:** `ANALYSIS.md` — research, reference projects, confirmed QML APIs, settings ecosystem deep-dives.

---

## Project Vision

Archeotech is a **fully composable, community-extensible Quickshell shell** targeting MangoWC (primary), Hyprland, and Niri. The goal is a publishable v1.0 that anyone can install, customize, and extend without editing QML.

**Four pillars:**
1. **Module system** — every panel, widget, and bar element is a self-describing module (`module.json`). Drop a folder into `~/.local/share/archeotech/modules/` to install.
2. **Theme system** — themes are pure JSON + asset folders (`theme.json` + wallpaper + app-overrides). Drop into `themes/` to install.
3. **Visual builder** — drag-and-drop edit mode wires any module to any trigger (edge hover, bar icon, keyboard, desktop widget). Config persists to `DrawerConfig.json`, hot-reloads instantly.
4. **Compositor abstraction** — `CompositorService` facade means one codebase runs on MangoWC, Hyprland, and Niri.

**Target release:** v1.0 after Sprint 30 (Distribution). Subsequent sprints add depth (Go daemon, dev workflow, more themes).

---

## Sprint History

| Sprint | Title | Date |
|--------|-------|------|
| 0 | Dead file cleanup, clock interval fix | 2026-05-05 |
| 1 | Directory restructure → Commons/Services/Modules/Widgets, delete qmldir files | 2026-05-05 |
| 2 | MangoWC service hardening (per-output QtObject state, dispatch helpers, backoff restart) | 2026-05-05 |
| 3 | Service quality — partial (BT signal subscription, error logging, CC state-sync on open) | 2026-05-05 |
| 4 | Bar polish + MPRIS (marquee, CC media card, popup redesign, tag dot spring easing) | ~2026-05-07 |
| 5 | Polish pass (Anim.* tokens, CC collapsibles, flickable fix, bell → State.ncVisible) | ~2026-05-08 |
| 6 | Notification system (NotificationServer, toasts, history panel, bell badge, plain-object fix) | 2026-05-11 |
| 6+7 | Bar hover popups on all elements + calendar popup on clock hover | 2026-05-11 |
| 7 | Launcher (DesktopEntries, weighted fuzzy + frecency, keyboard nav, centered glass panel) | 2026-05-12 |
| 8 | Bluetooth native (org.bluez D-Bus, CC CompoundPill, connect/disconnect) | 2026-05-12 |
| 9 | Native WiFi + bar WiFi/BT popups (CompoundPill, inline password, scan, CC deep-link) | 2026-05-19 |
| 10 | Audio sinks + VPN (pactl sink selector, VPN CompoundPill, nmcli monitor) | 2026-05-19 |
| 11 | Settings window (FloatingWindow, Config/Persistent singletons, 6 panes, bar wiring, CC gear button) | 2026-05-20 |
| 12 | Theme system (ThemeLoader hot-reload, Appearance bindings, Macchiato/Mocha JSON, theme-switch.sh, AppearancePane picker) | 2026-05-20 |
| 13 | 5 new themes (Dracula, Nord, Gruvbox, Tokyo Night, Monochrome); neutral dark shadows across all themes; theme dirs symlinked (single source of truth); Settings Escape key + FloatingWindow cleanup; ButtonGroupRow Flow + dynamic widths | 2026-05-21 |
| 14 | Mission Dashboard — full-screen PanelWindow overlay; SystemStatus (CPU/RAM/Disk/Bat progress bars); ActiveProjects (git repo scan, branch + dirty); SystemNotes (snapshot, updates, VPN, AWS); QuickLaunch (8-app grid); TipOfSession (42 tips, random pick); auto-show 4s on login via openAuto IPC; Super+Home keybind | 2026-05-21 |
| 15 | Drawer Surface — DrawerConfig.json (edge→panel mapping); DrawerVisibilities singleton (mutual exclusion); DrawerSurface single PanelWindow (CC/NC/Launcher/Dashboard); offsetScale bidirectional animation; per-screen edge hover zones (right→CC, top-right→NC, bottom→Dashboard); mango blur rule for archeotech-drawer | 2026-05-21 |
| 16 | Perimeter frame layout — bar flush with top (marginTop:0), edge strips exclusiveZone:10 (equal 4px gaps all sides via gappoh=4/gappov=4), 10→56px dynamic strips with hover+tap, bar radius:0 (flat until Sprint 18 goth corners) | 2026-05-27 |
| 17 | Unified Shell Surface — one ShellSurface PanelWindow per monitor + ShellExclusions (Caelestia §15.2); ShellConfig/ShellState singletons w/ per-screen stateMap; Sides as Items (Bar/Strip/SideLoader); 4× ShapePath CornerBlends; Panels as content modules (CC/NC/Launcher/Dashboard) mounted inside Strip popup card; popup-becomes-panel animation; outerGap config field (exclusiveZone=sideSize+outerGap); deleted Modules/Drawer + old Bar/CC/NC/Launcher/Dashboard wrappers (-3700 LOC); fixed mango scroller_structs=0 to let windows tile flush | 2026-06-01 |
| 18 | Configurable Sides + Widget Registry — Noctalia filename-convention registry (drop a file under `Widgets/Bar/` or `Widgets/Strip/`, add id to `shell-config.json` zone, done); async `BarWidgetLoader`/`StripWidgetLoader` with `setSource(path, props)` Noctalia pattern; formalized `barRoot`/`stripRoot` context APIs; primitives moved to `Commons/Primitives/`; HoverCard/CalendarPopup/WifiPopup/BtPopup extracted; ClockWidget + 12 bar widgets + 4 strip icons over `StripIconBase`; stable ListModel diff (HyprPanel preserve-delegates); `plugin:<id>` namespacing reserved for S21; Bar.qml 1537→299 LOC; `docs/WIDGET_API.md` written | 2026-06-02 |
| 19 | System-wide theme switcher + WallpaperPicker — `scripts/theme-switch.py` rewrite (Caelestia pattern: atomic temp+rename, `fcntl` lock, template registry, failure-isolated appliers across 8 targets — Quickshell/kitty/mango/rofi/starship/GTK/VSCode/Obsidian); refresh via SIGUSR1/`gsettings`/`mmsg`/`jq`; `theme.json` schema extended with `gtk`/`vscode`/`obsidian`/`card` blocks across 7 themes; AppearancePane redesigned as DMS-style card grid (display name + 4-color accent swatch row, scale 1.03 hover, accent border on active); new WallpaperPicker first-class panel on bottom strip (replaces rofi picker, `Super+W` rebound to `qs ipc call wallpaper toggle`) — combined header row (title + 4 logo tiles centered + items count + palette button), horizontal-scrolling carousel of 3:2 thumbnails with `OpacityMask` rounded corners and `WheelHandler` for vertical-wheel→horizontal-flick; logo selector reuses existing `scripts/assets/*-logo.svg` via `FileView` + in-memory LOGO_COLOR substitution → data URI (no preview duplicates); rofi `theme.rasi` split to `@import "colors.rasi"`; `docs/THEME_SPEC.md` written; Qt 6.11.1 surfaced two latent issues fixed in passing — missing `}` in Strip.qml (Shape block) and ListModel-role auto-binding to inherited required properties broke (now explicit `widgetId: model.widgetId` + restored `qmldir` for `Widgets/Strip/`) | 2026-06-02 |
| 20 | Panel Redesign & Polish — `PanelRegistry` gained `axisSize` (numeric / `"auto"` / `"full"`); `Strip.qml` `_axisTarget` branches on the value, floors at icon-row width, clamps to screen; card stays centered (an icon-anchored variant was tried and reverted — clustered icons pulled the card sideways when switching). Panels migrated: WallpaperPicker 1280, Dashboard 920, Launcher 440 + Recents row, CC 440 trimmed 1264→1020 LOC (DND + Power/Lock kept; DISPLAY restored after the user flagged it's used often; Night Light/Power Profile/Idle relocated), NC went `axisSize: "auto"` via new `implicitAxis` property. New: `Commons/Primitives/EmptyState.qml`, `Commons.Appearance.anim.panel` (240 ms), `docs/PANEL_API.md`. **Follow-ups same day:** new Settings panes `DisplayPane` (monitor layout + night light) + `PowerPane` (profile + idle/sleep) absorb what CC dropped — required fixing `SettingsContent.qml` (carousel was hardcoded, order had to match `PaneRegistry` exactly — a real navigation bug the user hit) + `ButtonGroupRow` (now hides label area when both label/description empty). Launcher pin/unpin from list rows + recents tiles (filled `󰐃` pinned / outline `󰤱` unpinned), pinned list moved from `shell-config.json` → `Persistence.Config` (per-user state, writeable from UI), defaults seed to kitty/zen/code/obsidian. Dashboard SystemNotes pending-updates now uses `checkupdates` (pacman-contrib) for fresh repo counts + `paru -Qua` for AUR — display "5 + 2 AUR" / "up to date". Wallpaper performance overhaul: single-slot `$COMPOSED_IMG` cache replaced by per-(wallpaper, logo, orientation) keyed cache under `~/.cache/wallpaper/composed/<hash>-<logo>-{l,p}.png`; awww transition 1.5s→0.5s; picker shows optimistic UI + dims non-active tiles + blocks re-clicks via `applying` flag; `--warm-all` subcommand pre-renders every combo (16 wallpapers × 3 logos × 2 orientations = 96 files, ~167 MB). Caught and fixed an old bug in `get_wallpaper_color` — `${thumb:-$img}` was wrong (`${var:-x}` checks variable empty, not file exists), so wallpapers without thumbnails rendered logos with no color | 2026-06-02 |
| 21 | Module Builder & Community Extension (Chunks 0–2; Chunk 3 desktop widgets deferred) — `ShellConfig` write-back mutators (`setSideType`/`setZoneWidgets`/`setStripIcons`, deep-clone→reassign→write, `$schema` preserved, no write-loop); edit mode `Modules/Shell/Builder/EditOverlay.qml`+`WidgetPalette.qml` (full-surface glass, `Super+Shift+E`/`editmode` IPC, click-to-assign + chip remove/reorder, per-side type switcher); `holder` side type (hidden-at-rest hover-reveal, gap-0, flush popups); `Services/Shell/ModuleRegistry.qml` (Process+jq scan of `~/.config/quickshell/modules/` + `~/.local/share/archeotech/modules/`, rescan-on-open); `plugin:<id>` routing in Bar/Strip loaders (abs `file://` entry) + `panel-content` auto opener icon + `Strip._metaFor` fallback; example modules `hello`+`notes`; `docs/MODULE_API.md` | 2026-06-03 |
| 23 | Lock Screen — CANCELLED. Built native `WlSessionLock`+`PamContext` QML lock, then reverted: kept swaylock (battle-tested, preferred), closed the only real gap by making it theme-aware via `theme-switch.py` (template + stripped-hex applier). Same session: fixed launcher regression on QS 0.3.0 (`Quickshell.execDetached` instead of a child Process killed on panel close; `highlightMoveDuration 120→0` for instant hover). Confirmed QS upgraded 0.2.1-6→0.3.0 | 2026-06-10 |
| 24 | Settings Depth + IA restructure — dissolved Control Center (~1035 LOC); Settings → unified right-strip card panel (was FloatingWindow); standalone Media panel; DND → Notifications header; theme+wallpaper+logo unified via shared `Widgets/Appearance/{ThemeGridBody,WallpaperPickerBody}`; **Audio** sinks+sources+aliasing+volume cap; **settings search**; **Connections** WiFi/BT segmented tabs + WiFi forget/auto-join + BT scan/pair/trust/remove (persistent `bt-agent.py`, trust-before-connect) + battery; UX pass (de-windowed sidebar, Shell pane w/ Edit-Layout entry + frame controls, StackLayout panes — no flash/slide, global panel close); bar-popup click-through mask. ColorScheme → deferred to Hierarchical Theming sprint. | 2026-06-11→15 |
| 22 | Adaptive Shell Frame — replaced 4 separate `CornerBlend` Items with one `Modules/Shell/FrameBackground.qml` per screen (single `Shape`/`PathSvg`, WindingFill): full-width horizontal bands + between-them vertical bands (no overlap → one clean translucent fill, no seams) + concave fillet wedges at active junctions = dynamic rounded inner corners independent of side thickness. Bar/Strip bodies transparent (host widgets only). `corners.pillMode`+`corners.pillGap` config + edit-mode "Framed ↔ Pill frame" banner toggle. Framed = hugs screen, sharp outer corners, rounded inner junctions, inner-only termination caps. Pill = whole frame floats by `pillGap` (added to `ShellExclusions` too), rounded outer corners + pill-shaped (both-corner) termination caps; cap radii clamped to half band thickness. `ShellExclusions` reserves the breathing gap on off/holder edges too. Fixed `setSideType` to reset `size` to the type default so strip↔bar actually changes geometry | 2026-06-03 |
| 25 | Hierarchical Theming (family → flavor → accent) — `ThemeCatalog` + refactored `ColorScheme` (imperative `_apply`, no binding-loop); Dark/Light/Auto mode + day-night schedule; **light flavors for all 6 families** (Latte, Tokyo Night Day, Gruvbox Light, Dracula Alucard, Nord light, Monochrome light) — each `theme.json` + light kitty conf; **Catppuccin accent picker** (14 swatches → mango/rofi/GTK/VSCode/Obsidian/QML, installed-check GTK fallback); `theme-switch.py` gained `apply_fish`/`apply_zen` + theme-aware kitty opacity + Obsidian vault-registry/light-base + VSCode `colorCustomizations` regen (fixed frozen bg); installed Catppuccin {latte,frappe,mocha} + VSCode tokyo/gruvbox/nord exts; cross-app verified. **Side:** scroller width controls (ShellPane slider + `MangoWC.setProportion`/`setDefaultProportion`, `Super+O` presets). **Zen translucency:** compositor-opacity (`focused_opacity:0.88/0.75,appid:zen` + `noblur:zen`) — app-level glass blocked by Intel WebRender-compositor blocklist; `Super+Shift+O` glass↔opaque toggle; `MOZ_ENABLE_WAYLAND` env. See `TROUBLESHOOTING.md` for the Zen diagnosis. | 2026-06-24 |

**Sprint 3 — remaining items blocked on Quickshell 0.3.0** (track: `paru -Qu quickshell`):
- Audio → `Quickshell.Services.Pipewire`
- Network → `Quickshell.Networking`
- Battery → `Quickshell.Services.UPower`
- Idle inhibitor → `Quickshell.Wayland.IdleInhibitor`

---

## Upcoming Sprints

### Sprint 21 Chunk 3 — Desktop Widget Layer (deferred)

Chunks 0–2 of Sprint 21 shipped (see history table). Chunk 3 remains, scheduled after the lock screen:
- [ ] Desktop widget layer (`Modules/DesktopWidgets/WidgetLayer.qml`) on `WlrLayer.Bottom` — separate PanelWindow, independent of ShellSurface + a "peek desktop" access (mango corner action / keybind)
- [ ] `Modules/DesktopWidgets/DraggableWidget.qml` — intra-window drag (works on Wayland), grid snap, boundary clamp, persist x/y to config (Noctalia pattern)
- [ ] At least 3 desktop widgets: `DesktopClock`, `DesktopSystemStats`, `DesktopMediaPlayer`
- [ ] `panel-content` via `PanelRegistry` proper + `desktop-widget` `canLiveIn` target wired through the builder palette

---

### Sprint 23 — Lock Screen — CANCELLED (kept swaylock, made it theme-aware)

Built the native `WlSessionLock` + `PamContext` QML lock, then cancelled before shipping. swaylock is battle-tested and preferred; the only real gap was theming, which is now solved by adding swaylock to `theme-switch.py` (template + stripped-hex applier — re-themes on every switch). A broken compositor-level lock risks session lockout with no in-session recovery, not worth it for theming alone. See `DECISIONS.md [2026-06-10]`. `WlSessionLock`/`PamContext` confirmed working on QS 0.3.0 if ever revisited.

**Next up:** Sprint 24 (Settings Depth) or Sprint 21 Chunk 3 (Desktop Widget Layer, below).

---

## Planned Sprints

### Sprint 25 — Hierarchical Theming System (family → flavor → accent) ✅ SHIPPED 2026-06-24

**Shipped** — see Sprint History row 25 for the summary, `docs/THEME_SPEC.md` for the family/flavor/accent schema + apply mechanics, and `TROUBLESHOOTING.md` for the Zen-transparency diagnosis. Model delivered: `family → flavor → accent` where the flavor axis carries light/dark, Dark/Light/Auto mode + day-night schedule, light flavors for all 6 families, and a Catppuccin accent picker. Manual follow-ups all resolved (Catppuccin {latte,frappe,mocha} GTK packages installed 2026-06-24; VSCode tokyo/gruvbox/nord exts installed). Remaining nice-to-have (not blocking): script the per-variant theme symlinks in `install.sh` for fresh-deploy reproducibility.

<details><summary>Implementation detail (collapsed — shipped)</summary>

**Phase 1:**
- [x] `Services/Theming/ColorScheme.qml` — refactored to imperative `_apply()` from each setter + clock tick + boot; `_resolveVariant()` pure fn reads Config directly (fixes binding-loop re-entrancy from reactive `onActiveVariantChanged` writing Config); auto-mode clock only runs when `mode === "auto"`; boot eager-init via `shell.qml` touching `effectiveMode` (QS lazy singletons need a property access to fire `Component.onCompleted`)
- [x] `Services/Theming/ThemeCatalog.qml` (new) — 6 families: Catppuccin (Latte/Frappé/Macchiato/Mocha; Latte is the only light flavor), Dracula, Tokyo Night, Gruvbox, Nord, Monochrome (all dark-only until Phase 1 remaining). `_catppuccinAccents` (14 color names) defined for Phase 2.
- [x] `Widgets/Appearance/ColorSchemeBody.qml` — family card grid + flavor pills + Dark/Light/Auto mode selector + day-night schedule time pickers; fixed `> 1` → `>= 1` so single-flavor families show their flavor row; "No light variant for this family yet" label when family has no light flavors
- [x] `theme-switch.py` Phase 1 additions — `apply_fish` (renders `fish-theme.fish.tmpl` → overwrites `conf.d/fish_frozen_theme.fish`; fixes fish 4.3 frozen theme hardcoded to Macchiato, was light-on-light on Latte); `apply_kitty` (theme-aware opacity: 0.9 light / 0.6 dark appended after color include; `dynamic_background_opacity yes` in kitty.conf so SIGUSR1 reloads change opacity live); `apply_obsidian` (uses vault registry at `~/.config/obsidian/obsidian.json` instead of one-level glob; sets `theme` moonstone/obsidian for light/dark + `accentColor`); `apply_zen` (new: writes `archeotech-colors.css` + `@import` into every Zen profile's `userChrome.css`)
- [x] `WallpaperPickerBody.qml` — logo SVG tint was hardcoded `#cad3f5` (dark-lavender, invisible on Latte); now reactive computed property from `Commons.Appearance.colors.text`
- [x] Fish/kitty cleanup — removed `fish_config theme choose "Catppuccin Macchiato"` from `config.fish` (was stomping theme-switch output on every new shell); removed hardcoded `background_opacity 0.4` from `kitty.conf`
- [x] New templates: `scripts/themes/templates/fish-theme.fish.tmpl`, `zen-colors.css.tmpl`
- [x] `theme.json` schema v2 — `family`/`flavor`/`mode`/`accent` fields across all variants
- [x] **Light flavors for all 6 families** (2026-06-22) — Catppuccin Latte + Tokyo Night Day, Gruvbox Light, Dracula Alucard, Nord light (hand-tuned from Snow Storm), Monochrome light. Each = `theme.json` (Adwaita light GTK for non-Catppuccin, Papirus-Light) + a light kitty `.conf`. Generated by `scratchpad/gen_light_themes.py` from one palette spec. Symlinked into `~/.config/archeotech/themes/`. ThemeCatalog now lists both flavors per family.

**Phase 2 — accent picker (2026-06-22, Catppuccin-only):**
- [x] `theme-switch.py` — optional `[accent]` arg; `apply_accent()` overrides mango `focuscolor`/`bordercolor`, rofi border, GTK theme (`catppuccin-<flavor>-<accent>-standard+default`, installed-check + graceful fallback), VSCode `catppuccin.accentColor`, Obsidian accent, QML `accent` name
- [x] `ColorScheme.qml` — `colorScheme.accent` config + `setAccent()`; `_resolveAccent()` (family-gated); `_lastApplied` is now a `variant|accent` key so accent-only changes re-apply; family switch drops a now-invalid accent
- [x] `Appearance.qml` — `accent`/`accentAlpha`/`accentBorder` read the theme's `accent` color name (was hardcoded mauve)
- [x] `ColorSchemeBody.qml` — accent swatch row (14 Catppuccin colors), shown only for accent-capable families
- [x] `ThemeCatalog.accentsFor()` — per-family accent list (drives capability gate)
- [x] `docs/THEME_SPEC.md` — updated for family/flavor/mode/accent schema + accent-override mechanics + new appliers

**Cross-app verification (2026-06-22, per user request):** All 11 appliers tested end-to-end on light + accent paths (kitty opacity 0.9 light / 0.6 dark ✓, Adwaita light GTK ✓, obsidian moonstone base ✓, mango/rofi/fish/starship/swaylock ✓, macchiato+blue accent → `catppuccin-macchiato-blue` GTK + VSCode accent ✓). Installed missing VSCode theme exts (tokyo-night, gruvbox, nord) so all families resolve.

**Follow-up fixes (2026-06-22, from user testing):**
- **VSCode backgrounds froze** — a stale hardcoded `workbench.colorCustomizations` block pinned Macchiato bg hexes so only text changed. `apply_vscode` now **regenerates** that block from the active palette every switch (editor/sidebar/activitybar/panel/statusbar/titlebar/tabs/terminal → base/mantle/crust). Verified tracking across themes.
- **Settings → Appearance cramped** — panel widened 760→**940** (`PanelRegistry`); `AppearancePane` spacing 6→12; `ColorSchemeBody` non-compact spacing 8→10.
- **Appearance switcher hid wallpapers** — bottom `wallpaper` panel height 480→**600**; `ColorSchemeBody` compact mode tightened (family cards 64→50, mode pills 30→28, spacing 5) so the carousel keeps room. Confirmed fixed by user.
- **Zen auto-relaunch** — `ColorScheme.qml` restarts a *running* Zen on an explicit picker change (debounced 2.5 s, never on boot/clock), gated by `colorScheme.restartZen` (default true). Since Zen only reads chrome CSS at startup, this is how theme changes reach it.
- **Zen transparency — settled at compositor-opacity + noblur (the hardware ceiling).** Very long diagnosis; the durable conclusions for future-me:
  - **Two strategies exist, and which one works is GPU-bound.** (a) *App-level alpha* — Zen renders its own ARGB glass like kitty/VSCode/Obsidian/Spotify (premultiplied → crisp, dark stays dark). This is the *good* look but needs the **WebRender native compositor**, which is **blocklisted on this Intel Xe / Mesa** GPU; force-enabling it (`gfx.webrender.compositor.force-enabled`) gives clean glass BUT throws **diamond/star rendering artifacts** + a near-white sidebar. Not viable. (b) *Compositor opacity* — MangoWC dims the whole Zen window via a `windowrule` (it **does** have per-window opacity; my earlier "no per-window opacity" claim was wrong). Works, artifact-free, but inherently looks **more washed than the app-level apps** because external opacity over a background isn't premultiplied — a compositor-vs-app-alpha gap that is **not config-fixable**. We use (b).
  - **Current config:** `windowrule=focused_opacity:0.88,unfocused_opacity:0.75,appid:zen` + **`windowrule=noblur:1,appid:zen`** in `mango/config.conf`. The noblur is important: a translucent **blurred** window renders the blur as a flat **grey** layer *independent of the wallpaper* (the user proved it — grey even over a black wallpaper). Disabling blur lets the translucency show the real wallpaper. firefox/chromium were already noblur'd; zen's appid slipped through.
  - Zen renders **opaque internally** (so mango's dim is the only alpha — no double-blend): profile `user.js` has `zen.widget.linux.transparency=false`, mod `light_tint=0`, `transparent_sidebar/glance=false`, `acrylic-elements=false` (acrylic is a frosted *light* overlay → washout), `gfx.webrender.compositor.force-enabled=false` (explicit false — removing the line wasn't enough, prefs.js retains last value). `zen-colors.css.tmpl` is **variables-only** (palette colors via Zen theming vars; no opaque bg rules).
  - **Toggle:** `scripts/zen-opacity-toggle.sh` (bound `SUPER+SHIFT+O`) flips the rule between glass (0.88/0.75) and opaque (1.0/1.0) + live-reloads — opaque for screen-share/presenting.
  - `config/.config/environment.d/firefox-wayland.conf` (`MOZ_ENABLE_WAYLAND=1`) forces the Wayland backend (Zen was on XWayland: `DISPLAY=:1`, no `MOZ_ENABLE_WAYLAND`) — needed for the app-level path if ever revisited; harmless for compositor-opacity.
  - **Revisit trigger:** if a Mesa update lifts the WebRender-compositor blocklist (check `about:support` → `WEBRENDER_COMPOSITOR` after driver updates), the clean app-level path (a) becomes viable — flip `zen.widget.linux.transparency`+mod transparency back on, set the mango rule to 1.0/1.0, drop noblur.
  - **NOTE:** the Zen profile `user.js`/prefs are runtime state, NOT the dotfiles repo. Only the env.d file, the mango rules, and `zen-opacity-toggle.sh` are repo-tracked.

**Side addition (separate commit):** Scroller proportion controls — ShellPane SCROLLER section (window-width slider 80–100%, 60ms debounce → `MangoWC.setProportion()`; "Save as default" → `setDefaultProportion()` surgical sed on config.conf); mango: `scroller_focus_center=1`, default proportion 0.98, `Super+O` = `switch_proportion_preset`, presets `0.8,0.85,0.9,0.95,0.98`.

</details>

---

> **Re-sequenced 2026-07-01** (see `DECISIONS.md`). The path to v1.0 is *extensibility → plugin story → distribution*, NOT portability. Multi-compositor + Go daemon are real work but only matter for **other people's machines**, so they move to *after* v1.0. The differentiator is "everything super-customizable + a plugin ecosystem," so that comes first.

### Sprint 26 — Widget Extensibility & Plugin Manager ← NEXT

**Goal:** Make every widget/module **per-instance configurable** and manageable from a GUI — the last thing forcing users to hand-edit `shell-config.json`, and the prerequisite for a real plugin ecosystem. The drop-in + place-via-builder half already works (S18 registry + S21 `ModuleRegistry` + edit-mode palette merges built-ins & plugins); this sprint fills the config/management half.

**The three gaps (from the 2026-07-01 audit):**
1. **Per-instance config — the biggest gap.** `configSchema` is declared in `module.json` and carried through `ModuleRegistry` but **nothing consumes it**. Need: a `configSchema` spec → auto-generated settings form; migrate `shell-config.json` zone entries from bare-string ids → `{ id, config: {} }` objects (with a back-compat shim reading old strings); inject the per-instance config into the widget via `BarWidgetLoader`/`StripWidgetLoader`. Enables e.g. two clocks with different formats. (Reference: Noctalia per-instance widget config, DMS deep per-widget settings.)
2. **Reorder is `‹ ›` arrows, not drag-and-drop** + no spatial preview. Intra-overlay drag is Wayland-safe (`ANALYSIS.md` §14.4); optional: render each side as a to-scale mock (§12.7) instead of a chip list.
3. **Vertical-orientation widgets.** Most widgets gate on `barRoot.horizontal`; vertical strips fall back to an icon column, so "fits on *any* side" isn't fully true. Give widgets real vertical layouts (Noctalia `BarPill → Horizontal/Vertical`).

**Checklist:**
- [x] `configSchema` spec in `docs/WIDGET_API.md` + `docs/MODULE_API.md`; auto-generated form component (`Modules/Settings/Widgets/ConfigForm.qml` + new `TextFieldRow`, reuses ToggleRow/SliderRow/DropdownRow/ButtonGroupRow)
- [x] `shell-config.json` zone entries → `{id, config}` objects + compat shim (`ShellConfig._normEntry`, read-time — old bare-string files load untouched, no migration script); `zoneEntries`/`stripEntries`/`setEntryConfig`
- [x] `BarWidgetLoader`/`StripWidgetLoader` inject per-instance `config` (schema defaults merged) via strict-safe `onLoaded` optional-prop pattern; `Bar._syncZone` keys rows on `id#occurrence` + config-as-JSON so two clocks coexist and config edits don't reload the widget; `ClockWidget` migrated as the proof
- [x] **Plugin/Widget Manager** Settings pane (`PluginsPane.qml`) — installed modules (enable/disable via `plugins.disabled`, `verified` badge, uninstall user-dir only w/ confirm) + built-in widget catalogue; per-instance config forms live on the edit-mode chip gear (no global-default layer)
- [x] Fix external-plugin import path — `qs.Commons` can't reach outside the config tree (verified w/ QS docs), so external `plugin:` widgets declare `property var appearance` and the loader injects the theme tokens; documented in `MODULE_API`
- [ ] (optional) intra-overlay drag-and-drop reorder + spatial side mock
- [x] **(follow-up B) same widget on 2+ sides opens its panel on all of them** — DONE (`ShellState` panel state now carries `side`; `""` = wildcard resolves to a primary host). See `DECISIONS.md [2026-07-02]`.
- [x] **(follow-up C = vertical-orientation + holder-awareness)** — DONE. Phased 0–4; 0–2 (2026-07-02, commits `63d74bf`, `f8a5dff`), 3–4 (2026-07-03, uncommitted).
  - [x] **Phase 0 — responsive widgets/panels.** `BarPill` shared capsule owns the horizontal↔vertical fork (icon+value / icon-only; Noctalia/DMS pattern, no text rotation); 9 widgets migrated. ClockWidget stacks HH/MM vertically; WorkspacesWidget row→column. `Bar.qml` vertical path deleted the hardcoded icon Column — vertical bars drive the same zone models via ColumnLayouts. Dashboard/MediaPanel reflow on measured width (2→1 col / row→stack, scroll when tall-narrow); fixed `Layout` height/width bugs (plain `height:`/`width:` on layout children → 0 → overlap). Title/media stay horizontal-only (can't flow).
  - [x] **Phase 1 — `PanelHost`** (`Modules/Shell/Panels/PanelHost.qml`): reusable panel-content kernel (meta resolution + content loaders + size targets), holder-agnostic. Strip left on its own inline copy for now.
  - [x] **Phase 2 — bars host panels.** `BarPanel` drops a panel from the bar edge, anchored to the clicked opener, using the SAME neck `Shape` as the strip card (fuses in identically). Direct opener widgets `dashboard`/`launcher`/`wallpaper` (resolve to `PanelOpenerWidget`, panel = the id, no config step, no hover popup). `ShellSurface` bar-popup input-mask generalised top-only → all 4 sides + click-outside treats a bar panel as inside. `setSideType` carry-over on direct ids. **← delivers "dashboard drops from the top bar".**
  - [x] **Phase 3** (2026-07-03) — one per-side `content: [{id, config, align}]` list; read-time shim in `ShellConfig._sideContent` reads old `zones`/`icons` untouched, mutators write `content` (side converts on first GUI edit), `align` = bar zone / `""` = strip; type-flip keeps both flavours in one list so bar↔strip round-trips are non-destructive. Unified `WidgetRegistry.availableWidgets` with `{bar,strip}` caps (old arrays are filtered views); one `widgetMeta`.
  - [x] **Phase 4** (2026-07-03) — one `holderRoot` contract on Bar+Strip (side/horizontal/type/screen/screenName/thickness/togglePanel/dismissPopups/showsPanel/iconHover*/showPopup — each side stubs the other's half). `StripIconBase` folded into `BarPill` (added active/hover highlight bg) + all 6 strip wrappers deleted → `PanelOpenerWidget` is the one holder-aware opener. One `WidgetLoader` (+ `widgetFile(id,isStrip)` resolver) replaces Bar/StripWidgetLoader; `barRoot`/`stripRoot` renamed `holderRoot` shell-wide. Strip mounts via shared `PanelHost` (inline copy gone). Docs updated (WIDGET/PANEL/MODULE_API).
- [ ] disable-a-module could also unload already-placed instances (currently only hides from palette — the documented ceiling)

---

### Locker: swaylock → hyprlock ✅ SHIPPED 2026-07-08

**Shipped** — hyprlock replaced swaylock as the lock screen: it fixes the resume-freeze segfault (a separate, actively-maintained codebase, not the sway lineage) and restores blur. Verified across suspend/resume + dock/undock in initial testing (laptop-only + 3-monitor); watching day-to-day use before treating the *intermittent* resume case as fully closed. swaylock kept as a documented fallback. See `DECISIONS.md [2026-07-08]` + `TROUBLESHOOTING.md` → "Freeze on resume".

**Delivered:**
- [x] Shell hyprlock config (`config/.config/hypr/hyprlock.conf`) — blur + vignette background via a stable `~/.cache/wallpaper/current` symlink (maintained by `wallpaper-set.sh`; hyprlock's `background { path }` is static, so the symlink is the indirection), theme colors, and the "Console" layout (thin FiraCode-Light clock, date, rotating dev/inspiration phrase, understated boxless underline input, one bottom status bar `user · layout · battery · uptime`).
- [x] Theme-switch template (`scripts/themes/templates/hyprlock.conf.tmpl`) + `apply_hyprlock` applier — colors track the active `theme.json` (stripped-hex → hyprlang `rgb()`/`rgba()`, like the old swaylock applier).
- [x] `scripts/hyprlock-launch.sh` (double-launch guard + ported trigger diagnostics → `~/.cache/hyprlock-trigger.log`) and `scripts/hyprlock-info.sh` (status-bar + rotating-phrase providers, kept in a script because hyprlang mangles `$(...)`/`#` in inline label commands). Both added to `install.sh` LOCAL_SCRIPTS + deployed to `~/.local/bin`.
- [x] Repointed `Super+L` (`mango/config.conf`), swayidle idle-timeout + before-sleep (`swayidle/config.sh`), wlogout, and `Paths.qml` from `swaylock-launch.sh` → `hyprlock-launch.sh`.
- [x] swaylock kept as documented fallback (package + `swaylock-launch.sh` + template retained; de-risks the intermittent case until hyprlock has many cycles of daily use).
- [x] Distribution blocker dropped (resume-freeze resolved).

**Follow-up idea (logged in Feature Backlog):** a "Lock Screen" Settings pane that regenerates `hyprlock.conf` from a config model — phone-lockscreen feel; hyprlock has no live QML, so it's a config generator, not QML widgets.

---

### Sprint 27 — Dev Workflow: First Official Plugin

**Goal:** Ship the git/AWS/Terraform dev tooling as the **first official plugin package** (Obsidian-style official-vs-community model) — high personal value AND it dogfoods the plugin install/manifest/enable story before community authors touch it. Keeps niche dev tooling out of core (most users don't do TF/AWS).

**Checklist:**
- [ ] Plugin manifest fields: `official` / `verified` / `minShellVersion` / `dependencies`
- [ ] Install mechanism: `archeotech plugin install <name>` (git-clone into modules dir) + a repo-hosted `plugins.json` index (official + community catalog)
- [ ] **dev-workflow** official plugin package: `GitWidget` (CWD from focused window, dims when no git ctx), `AwsWidget` (dims when `$AWS_PROFILE` unset), `TerraformWidget` (`terraform workspace show`, tf-repos only), `DockerWidget` (containers badge)
- [ ] Bundled rofi menus in the plugin: AWS console launcher `Super+A` (`granted console`), Terraform commands menu, SSH quick-connect `Super+Ctrl+S`, VSCode project switcher
- [ ] Enable/disable + config via the Sprint 26 Plugin Manager pane

---

### Repo split + hygiene — PRE-30 FOUNDATION ✅ SHIPPED 2026-07-09

**Shipped** — split executed into two repos: public **`archeotech-shell`** (`~/Projects/archeotech-shell`, fresh `git init`, 161 files, repo root = a named Quickshell config run via `qs -c archeotech`, authored as the user, zero Claude artifacts, **not pushed** — user pushes) and private **`archeotech-dotfiles`** (this repo, pruned to 125 files — personal config only). See `DECISIONS.md [2026-07-09]`. All 9 boundary fixes landed (Paths→`~/.local/bin`, portable `~/.config/archeotech/{assets,wallpapers}`, config-driven `dashboard.scanRoots`, DisplayPane output auto-detect, kitty confs co-located into theme packages, launch/IPC → `qs -c archeotech`, single-launcher hardening, private show-keybinds/wallpaper-fallback repointed). Public ships shell + theme system + shell-integral scripts + docs + `examples/` compositor snippets + CI/release workflows + 2 non-IP default wallpapers. Deploy: public `install.sh` symlinks repo→`~/.config/quickshell/archeotech`, themes/assets→`~/.config/archeotech/`, scripts→`~/.local/bin`; private keeps its stow package for everything else. Dead code dropped in passing (`dashboard-*.sh`, rofi `wallpaper-picker.sh`). Remaining nice-to-have: strip internal-doc breadcrumbs (`ANALYSIS.md`/`ROADMAP` mentions) from public source comments.

<details><summary>Original plan (2026-07-09 — collapsed, shipped)</summary>

**Decision (2026-07-09):** split into **two repos** — a public **`archeotech` shell** (the product) and a private **`dotfiles`** (this machine). Matches Noctalia/Caelestia/DMS. Must land **before** Sprint 30 — packaging, install script, docs, and the v1.0 tag all build on the clean base. Full file-by-file inventory done 2026-07-09 (44M / 294 files; splits cleanly).

**Guiding principle (refines the raw inventory):** public = what a *stranger* installs and extends; personal configs are **not** shipped as defaults — the public repo carries **example/reference** compositor snippets, not the actual mango/hypr config. Keeps it a clean product, not "adopt my setup."

- **Public `archeotech`:** `config/.config/quickshell/` (audited clean — no hardcoded `/home/corvus`), theme system (`theme-switch.py` + `scripts/themes/templates/` + `config/.config/archeotech/themes/`), shell-integral scripts (wallpaper-set, hyprlock-launch/-info, wlogout-launch, bt-agent, battery-alert, wifi-scan, list-desktop-apps, zen-opacity-toggle, install/uninstall), `docs/*_API.md` + THEME_SPEC + install/setup guides, example modules (`hello`/`notes`), **1–2 default wallpapers only**, and **example** compositor configs (the shell's *required* mango/hypr settings: `blur_layer=0`, `archeotech-drawer` rules, `qs ipc` binds).
- **Private `dotfiles`:** personal mango/hypr configs (keybinds + the eDP-1/HDMI-A-1/DP-3 monitor rules), kitty/fish/rofi/waybar/swaync/zathura/yazi/gtk/starship/etc, `system/` (sddm/snapper/logid), `mango-reload.sh` (the 3-monitor layout), the full personal wallpaper set (42M).
- **Delete (dead — Fedora removed 2026-04-20): ✅ DONE 2026-07-09** — removed `scripts/fedora-boot-fix/`, `scripts/fix-grub-and-sddm.sh`, `system/etc/grub.d/40_custom` + their references in `update-system-configs.sh` / `system/README.md` / TROUBLESHOOTING.

**Boundary fixes to do during the split (9 flagged; the load-bearing ones):**
- Keybinds referencing `~/Projects/archeotech-dotfiles/scripts/...` → install symlinks to `~/.local/bin`, keybinds call those (already the install pattern for some scripts).
- `Modules/Settings/Panes/DisplayPane.qml` hardcodes `eDP-1` in display presets → auto-detect / externalise output names (e.g. `~/.config/archeotech/outputs.json`). **Real distribution bug**, folds into the S30 hardcoded-path audit.
- `project-jump.sh` / `dashboard-projects.sh` assume `~/Projects` + `~/Documents/repos` → make scan roots config-driven (ties into "Core → plugin / optional candidates") or move to personal.
- mango startup hardcodes `~/Projects/archeotech-dotfiles/wallpapers/arasaka.png` fallback → portable `~/.config/archeotech/wallpapers/`.
- `~/.cache/wallpaper/current` lock-wallpaper contract → already clean; just document in THEME_SPEC.

**Theme-system boundary → theme-applier plugins:** the messiest coupling is `theme-switch.py` writing into external-app configs (kitty/rofi/gtk/vscode/obsidian/zen). **v1.0 minimum:** every applier **skips gracefully when its target app/config is absent** (gtk/obsidian already do) so the public shell ships them safely. **Post-v1.0 (see backlog):** extract each applier into a drop-in **theme-applier plugin**.

</details>

### Sprint 28 — Testing & Visual-Verification Pipeline (planned 2026-07-30)

**Goal:** ship + test features faster and with higher quality before going public; cut the "Claude said done but the output was wrong and didn't verify" back-and-forth; and stand up the AI persona-tester idea (user's colleague's game-testing analogy). Full research + sources + honest limits in **`.claude/TESTING-PIPELINE-RESEARCH.md`** — don't re-derive here.

**Why now / why pre-30:** de-risks the v1.0 release, and the same harness **auto-generates the Sprint 30 README screenshots** (bar/OSD/launcher/dashboard/settings/edit mode) and helps run the Pre-v1.0 QA checklist. Competitive note: Caelestia (leading QS shell) has **no CI/tests** — our existing `ci.yml` already beats it; this puts us ahead of the ecosystem.

**Core loop PROVEN (2026-07-30):** `WLR_BACKENDS=headless mango -s` → `qs -c archeotech` → `grim` renders the full shell to a real 1280×720 PNG with **no GPU** (pixman software render). Diverges from standard Qt "use Xvfb / offscreen is X11-only" advice *because Quickshell is a Wayland client rendering into a headless wlroots compositor* — the compositor is the display. Reusable script: `archeotech-shell/scripts/shot.sh`.

**⚠️ SAFETY RULE (learned the hard way):** the harness must tear down the nested compositor by **captured PID only** — NEVER `pkill -x mango` / `pkill quickshell` (matches the *real* session → logs you out, lost work twice on 2026-07-30). See memory `never-kill-mango-by-name`.

**Blocks (each grounded + written up in the research doc):**
- [ ] **B1 Visual verification** — headless render → PNG. ✅ proven; re-run safety-fixed `shot.sh` once (needs user watching).
- [ ] **B1b Temporal capture** — grim burst for motion *correctness* (played? duration? oscillation/jitter?). **Hard limit:** motion *feel*/smoothness/fps is NOT verifiable headless (software render ≠ real GPU) → stays human + hardware recording (`wf-recorder`, not yet installed).
- [ ] **B2 State-driving** — isolate *state* not the file (widgets need Commons+singletons). Drive via `qs ipc` (handlers already exist: launcher/settings/dashboard/wallpaper/media/editmode/osd/theme/notifications) + `mmsg`. No synthetic input needed. Cheap next step: read the `IpcHandler` bodies → state cookbook.
- [ ] **B3 Visual regression** — ImageMagick `compare` (installed) vs committed goldens; crop-to-component + freeze inputs (fixed theme/static wallpaper/hidden clock) to beat nondeterminism; goldens must be generated by the same headless path (pixman AA drift).
- [ ] **B4 QML logic tests** — greenfield; `qmltestrunner` present. Target pure logic (`ShellConfig._normEntry`, accent resolution, config parse). Caveat: Quickshell-importing singletons won't load under plain-Qt; extract pure JS where valuable; `-platform offscreen` may hit the X11/OpenGL limit → fall back to running inside the headless compositor.
- [ ] **B5 CI** — extend existing `ci.yml` (bash/py/JSON) in an Arch container (`quickshell`+`mango`+`grim`, no Xvfb): `qmlformat --check` → `qmllint` → `qmltestrunner` → headless render smoke (PNG artifact) → visual diff (diff.png on fail). Retires the ci.yml "once a Quickshell CI image is available" placeholder. Open risk: confirm `quickshell` installs in-container.
- [ ] **B6 AI persona-testers** — NOT novel: adapt **UXAgent** (CHI 2025) architecture (Persona Generator + LLM Agent + connector) to the shell — swap their browser connector for screenshot + a11y-tree + `qs ipc`. Personas judge static UX (clarity/contrast/discoverability/wording); can't feel motion from a still. Use **UXBench**'s actionability lens to keep findings triageable. Token-disciplined: small, targeted, on-demand — never a blanket sweep.
- [ ] **B7 Verify-before-done loop** — before I claim a visual change done: drive state (B2) → `shot.sh` (B1) → diff (B3) or paste the image inline → only then "done", with the image attached. For motion: state the declared duration/curve, flag that feel needs your eyes/recording.

**Scope discipline:** B1–B3 + B7 are the high-value core (visual verification + my own verify loop). B4/B5 harden for public. B6 (personas) is the ambitious layer — build last, on the proven B1/B2 foundation.

---

### Sprint 29 — Hyprland as 2nd Compositor (dual setup) ← pulled forward from post-v1.0

**Goal:** the shell runs first-class on **Hyprland** as well as MangoWC, selectable at login (dual session, same `qs -c archeotech`). Builds the `CompositorService` facade the vision's pillar 4 always promised. See `DECISIONS.md [2026-07-30]` for why this moved ahead of v1.0.

**Why now (revises the 2026-07-01 defer):** three inputs changed the calculus —
1. **Audience** — Quickshell is compositor-agnostic; ~nobody runs MangoWC, most of the target users run Hyprland. A public shell that only runs on niche mango has almost no addressable market → Hyprland is table stakes for "anyone can install it," not post-v1.0 depth.
2. **Dogfooding** — there's a `Services/Compositor/MangoWC.qml` but **no facade**. Running daily on *both* compositors is the only forcing function that makes the abstraction real.
3. **Daily stability** — MangoWC hangs on dock-undock (wlroots output-hotplug freeze, 2026-07-30 — see QA below); Hyprland is the most battle-tested docking/multi-monitor wlroots setup → a robust fallback.

**Scope discipline: Hyprland ONLY.** Niri/Sway stay post-v1.0 (see the trimmed Multi-Compositor entry below). Don't gold-plate to "all compositors."

**Coupling surface (measured 2026-07-30):** shallow — **11 `mmsg` call sites across 9 QML files** (`shell.qml`, `Modules/OSD/Osd.qml`, `Modules/Settings/Panes/{ShellPane,AboutPane}.qml`, `Modules/Shell/ShellExclusions.qml`, `Services/Compositor/MangoWC.qml`, `Widgets/Bar/{TitleWidget,WorkspacesWidget}.qml`, `Widgets/Appearance/Carousel.qml`), 0 hyprctl. The Quickshell UI is already portable; only these route to the compositor.

**CompositorService facade plan:**
- [ ] `Services/Compositor/CompositorService.qml` — detect compositor at startup; expose a stable API: `activeWorkspace`/`workspaces`/`focusedWindow`/`activeWindowTitle` + `switchWorkspace()`/`focusWindow()`/`moveToWorkspace()` + signals `workspaceChanged`/`windowFocusChanged`/`outputsChanged`.
- [ ] `MangoService.qml` — extract today's `MangoWC.qml` (the `mmsg -w` stream + dispatch) behind the API. No behaviour change.
- [ ] `HyprlandService.qml` — **prefer the built-in `Quickshell.Hyprland` service** (workspaces/monitors/toplevels + event stream) over a raw `socket2` — much less custom code than mango needed. Fall back to `hyprctl` for dispatch gaps.
- [ ] Route all 11 `mmsg` sites through `CompositorService.*` (delete direct mmsg from widgets).
- [ ] Verify `ShellExclusions` — layer-shell exclusive zones are compositor-agnostic via Quickshell; confirm on Hyprland (the mango-specific bits are the reserve math, not the protocol).

**Compositor config port (not QML — lives in dotfiles + public `examples/`):**
- [ ] `hyprland.conf`: keybinds (from mango `config.conf`), `windowrulev2` (mango `windowrule=monitor:…` → Hyprland), monitor rules, blur (`decoration:blur` + `layerrule = blur, <shell namespace>` mirroring mango `blur_layer`).
- [ ] Dual **SDDM session** — the Hyprland session autostarts `qs -c archeotech` + awww + portals (mirror `mango/autostart.sh`). Hyprland already installed + a `hyprland.conf` exists.
- [ ] Reload parity — a Hyprland `mango-reload.sh` equivalent (`hyprctl reload` + shell restart) or a compositor-agnostic `shell-reload.sh`.
- [ ] Public repo: ship the Hyprland `examples/` snippet alongside the mango one (repo-split already ships `examples/` compositor snippets).

**Acceptance:** log into the Hyprland session → shell renders, workspaces widget tracks, panels/OSD/blur work; dock-undock does NOT freeze (the stability win). `docs/COMPOSITOR_SUPPORT.md` covers both.

---

### Sprint 30 — Distribution & v1.0 Release

**Goal:** Installable by a stranger on fresh Arch. Zero hardcoded paths. APIs documented. Community can publish plugins/themes. **v1.0 milestone.** (Only **1** hardcoded `/home/corvus` left — the audit is nearly done.)

**Checklist:**
- [ ] Hardcoded path audit — zero `/home/corvus`; all via `$HOME`/`Paths.qml`
- [ ] `scripts/install-packages.sh` — `paru -S` list, split required vs optional
- [ ] Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, service enable, verification, first-run experience
- [ ] Script the per-variant theme symlinks (`~/.config/archeotech/themes/<v>` → repo) in `install.sh` for fresh-deploy reproducibility (theme.json + kitty confs are the committed source of truth; the one-shot light-theme generator is gone/not needed)
- [ ] `docs/INSTALL.md` (fresh Arch + MangoWC, also Hyprland) + `docs/PLUGIN_API.md` + `CONTRIBUTING.md` (submit a plugin / theme)
- [ ] Finalize `MODULE_API`/`WIDGET_API`/`THEME_SPEC`/`PANEL_API`
- [ ] README harden — screenshots (bar, OSD, launcher, dashboard, settings, edit mode) + demo GIF (edit mode + theme/accent switch + plugin install) — **auto-generatable via the Testing & Visual-Verification Pipeline harness (`shot.sh` + `qs ipc` state-driving)**
- [ ] `v1.0.0` tag; GitHub description, topics, social preview

---

## Post-v1.0 — "depth" sprints (portability & extras)

*These are real but matter for **other machines**, not the release. Deferred behind v1.0.*

### Multi-Compositor Support — Niri/Sway (was Sprint 26; Hyprland pulled to Sprint 29)
**Hyprland + the `CompositorService` facade moved to pre-v1.0 Sprint 29** (see `DECISIONS.md [2026-07-30]`). What remains here, post-v1.0: add **`NiriService`/`SwayService`** behind the same facade so the shell also runs on Niri/Sway. Ref: Noctalia `Services/Compositor/`. Tasks: implement the two services against the Sprint-29 API (`switchWorkspace`/`focusWindow`/`activeWorkspace`/`focusedApp`/`activeWindowTitle`); per-compositor blur namespace; extend `docs/COMPOSITOR_SUPPORT.md`. Cheap once the facade + Hyprland proved the pattern.

### Go Daemon (was Sprint 28)
Only for raw Wayland protocols QML can't reach: `archeotech-daemon` Go binary (Unix socket, newline-JSON RPC) + `Services/ArcheotechDaemon.qml` (backoff reconnect). Handles `wlr-output-management` / `wlr-gamma-control` / `wlr-screencopy`. NOT audio/network/BT/notifications/lock (native QML).

### Personality & flair (was Sprint 29)
- `themes/shadow-spear/` full theme package (compositor + kitty + starship raven sigil + rofi + wallpaper set) — Corvus persona; ships as an optional theme, not core.
- Per-workspace wallpapers via `CompositorService.onTagSwitched` (multi-compositor dependency).
- **Stretch:** SDF GLSL shader for corner blob (replaces ShapePath bezier — Caelestia §15.2 line 2143).

---

## Feature Backlog

Well-defined features not yet scheduled into a sprint.

### Pre-v1.0 QA checklist (from the 2026-07-01 session audit)
Loose ends from the S25 theming/Zen work — verify/fix before the v1.0 release. *Several of these (light-theme visual pass, Settings-width sparseness) become automatable via the **Testing & Visual-Verification Pipeline** — screenshot each state, eyeball or diff.*
- [x] **Resume freeze — RESOLVED 2026-07-08 via hyprlock.** `swaylock-effects` segfaulted on resume (unmaintained fork hitting the known sway-ecosystem output-hotplug-during-resume bug). Migrated to hyprlock — a separate, maintained codebase (not the sway lineage) — which fixes the crash and restores blur. Verified across suspend/resume + dock/undock in initial testing; monitoring day-to-day for the intermittent case. No longer blocks distribution. Full history in `TROUBLESHOOTING.md` → "Freeze on resume" + `DECISIONS.md [2026-07-08]`; migration summary in the "Locker" section above.
- [x] **Zen chrome color — RESOLVED (2026-07-01):** solid palette backgrounds *did* recolor the chrome but flattened Zen's per-workspace **gradient** to a flat fill (Monochrome → flat black). Reverted the zen template to **light-touch** (accent + text vars only, no bg fills) so the gradient survives. Conclusion: Zen owns its chrome color via the workspace gradient (`zen_workspaces` DB, set in Zen's UI) and userChrome can't cleanly override it — so Zen's main chrome does NOT follow the shell theme by CSS. **Real fix = drive the workspace gradient from the palette during the Zen restart window** (queued: theme-packs / Sprint 26 — see the Zen-gradient note there). Interim: user sets a palette-matched gradient manually.
- [ ] **Test the auto day/night schedule end-to-end** — `ColorScheme` Dark/Light/Auto + schedule logic was built but never watched flip at a scheduled time.
- [ ] **Visual pass on the light themes** — Latte/TokyoNightDay/GruvboxLight/DraculaAlucard are official palettes; **Nord light is hand-tuned** (contrast-audited OK, yellow darkened to #977100) — eyeball it on real content.
- [ ] **VSCode `colorCustomizations`** now regenerates bg from the palette for *every* theme — verify it doesn't clash on the non-Catppuccin VSCode themes (Gruvbox/Tokyo/Nord); gate to Catppuccin if it does.
- [ ] **Settings panel widened 760→940** globally — check the other panes don't look sparse at the new width.
- [ ] **Dock-undock freeze — diagnosed 2026-07-30.** Unplugging the dock (removes HDMI-A-1/DP-3 while focus/windows live there) hangs MangoWC completely — screen frozen, *even the laptop's built-in kbd/trackpad dead*; recover only by replugging. Root cause = wlroots **output-hotplug hang** in the dwl/mango lineage (not our config; nothing crashes in logs — it's a hang). **Expected fixed by the `mangowc`→`mangowm` update (links wlroots 0.20, where hotplug fixes live) — verify after the switch + relogin.** If it persists: real MangoWC bug (draft upstream report) and a strong argument for the Sprint 29 Hyprland fallback. **Distribution-blocking for laptop+dock users.** (Same docked-laptop hotplug family as the lid-close item below.)

### Wallpaper & Theme picker redesign (three carousels) — core SHIPPED 2026-07-17; only deferred upgrades open

> Full cross-repo study + mechanics in `ANALYSIS.md §19`; debugging gotchas in `DECISIONS.md [2026-07-16]`. Triggered by the picker reading bloated + opening slow/jittery. Decided with the user: the **Super+W quick panel** becomes **three stacked carousels in one style** (Wallpaper / Theme / Logo); **Settings→Appearance keeps its fuller layout** (grid + schedule).

- [x] Persistent `Services/Theming/Wallpapers.qml` singleton — scan + thumbnail cache **once**, never re-scan on open (was the main slowness)
- [x] Reusable `Widgets/Appearance/Carousel.qml` — snap-to-centre `PathView`, centred item enlarged, `cacheItemCount:4` (light/instant), explicit `itemSpacing`
- [x] Wallpaper carousel w/ **real** cached thumbnails — fixed the `file://` URL doubling (`Paths.cache` is a URL) that made every thumb fail → silently decode the full 4K/6K original
- [x] `mango-reload.sh` restores full shell restart (Super+Shift+R) — required because new singletons / one-time scans don't apply on QML hot-reload
- [x] Restructure the Super+W quick panel into 3 stacked carousels (`13aa275`) — freed room, bigger wallpaper items, fixed "too small/too many"
- [x] Logo carousel — `Widgets/Appearance/LogoCarousel.qml` (reuses `Carousel`)
- [x] Theme carousel — `Widgets/Appearance/ThemeCarousel.qml`: **families** (one tile per family, 4-colour swatch) + mode pills + flavor/accent rows above the carousel, built exactly per the §19.3 recommendation. Later polished onto GlassButton/StateLayer/3D cards (`d7cee9e`, `34146f0`; see `docs/POLISH_ROLLOUT.md`)

**Deferred "feel" upgrades** (nice-to-have, from the §19 study):
- [ ] Live **colour preview on scroll** — add `--print-color` to `wallpaper-set.sh` (extract accent, print, don't apply) + an in-shell preview palette (Caelestia `-p` pattern); our `wallpaper-set.sh` is heavy (magick + logo compose + awww) so live-apply-on-scroll is intentionally avoided
- [ ] Async **fade-in** on thumbnails (end-4, 200 ms opacity) so they bloom in, not pop
- [ ] **Eager-warm** the Wallpapers service at shell startup so even the *first* open is instant
- [ ] **Palette crossfade** on theme apply (Noctalia per-frame lerp, interruption-safe) instead of a snap
- [ ] (alt) move thumb cache to the **freedesktop** shared path `~/.cache/thumbnails/…` (end-4) so file managers reuse it

### Unexpected lock / suspend on lid-close while docked — NEEDS DECISION (diagnosed 2026-07-16)

The "random" locks are **real lid-close → suspend** events (`systemd-logind: Lid closed. Suspending…` → kernel suspend entry, confirmed in the journal + `~/.cache/hyprlock-trigger.log`, all `trigger: before-sleep`). `logind.conf` is empty (all defaults), so it suspends on lid-close even with the 3 external monitors connected — it isn't detecting the desk as "docked". Fix needs a `logind` drop-in (sudo) + a behaviour call:
- [ ] Decide lid behaviour: **never auto-suspend** (`HandleLidSwitch=ignore`, rely on swayidle's 30-min idle-suspend) vs **ignore-on-AC-only** (`HandleLidSwitchExternalPower=ignore`, still suspends on battery) vs keep as-is
- [ ] Apply via `/etc/systemd/logind.conf.d/*.conf` + `systemctl restart systemd-logind`
- [ ] (minor) `hyprlock-launch.sh` suspend-detection regex misses `Suspending…` / `Reached target Suspend`, so the trigger log logged `recent-suspend: none` when a suspend *did* happen — widen the pattern

### Polish & Liveliness pass (research → adopt) — feels bland/cold vs Caelestia

> **Scheduled BEFORE v1.0 (decided 2026-07-09).** The user wants the shell to feel lively/warm before it's tagged 1.0 — so this runs in the pre-v1.0 path (alongside/ahead of Sprint 30 distribution work), not as post-release polish.

**Motivation (user, 2026-07-02):** next to Caelestia and other mature Quickshell shells, ours reads bland, strict, and cold — motion is minimal and mechanical rather than organic/lively, and the styling is flat. Want a deliberate pass on animation, micro-interaction, and warmth. Ties into the existing S26 follow-up C (holder-aware layout) and the `HoverCard`/`Strip` animation work already in flight.

**1. Research spike ✅ DONE 2026-07-09** — source-inspected all four reference shells (read-only shallow clones, one deep-inspection agent per repo across the 8 dimensions). **Full catalogue with exact values + `file:line` citations in `ANALYSIS.md §18`** ("Polish & Liveliness — Reference Motion/Depth/Warmth Catalogue"), including our own quantified baseline gap (§18.1), the cross-repo synthesis of concrete adoptable numbers (§18.2 — the six M3 bezier tuples, duration ranges, state-layer alphas, shadow formulas, warmth ladders), and per-repo detail (§18.3). Key caveats captured there: **Noctalia's checkout is v5 (C++/GL rewrite, zero QML)** so it's conceptual-only; **nobody does per-index temporal stagger** (all use Qt `displaced`/`add` transitions — true stagger is ours to build); **`fill`/`opsz`/`grade` icon-axis anims need Material Symbols** (we ship FiraCode). Phase-2 recommendations (mapped to the checklist below, leverage-ordered) in §18.4.
  - Repos inspected: **Caelestia** (C++ `Tokens` plugin), **end-4/dots-hyprland** (cleanest QML M3-Expressive ref), **DankMaterialShell** (most explicitly tokenised), **Noctalia v5** (conceptual).

**2. Then a polish sprint** (adopt, don't clone). **Approach agreed 2026-07-09:** land a **single-panel taste-test slice on the Launcher first** (motion tokens + enter/exit + StateLayer hover + depth/warmth on one surface) to check the feel before rolling shell-wide. Full plan in `ANALYSIS.md §18.4`. Checklist:
- Motion tokens in `Commons/Appearance.anim` beyond `fast/base/spring` — named easing presets (`emphasized`/`standard`/`decelerate`) so widgets stop hand-rolling durations.
- Organic easing (spring/overshoot) on high-traffic transitions: panel/strip expand, popup enter/exit, tag switch, toggle, hover.
- Consistent micro-interactions via a shared primitive (hover scale/glow, press depress, active fill) instead of per-widget.
- Warmth & depth: revisit the flat glass — layered shadow, subtle gradient/tint, accent-tinted surfaces; audit the "cold" pure-grey values.
- Appearance stagger on lists/panels (notifications, launcher results, settings rows).

**Phase-2 SHIPPED shell-wide (2026-07-17 → 07-22) — tracked in `docs/POLISH_ROLLOUT.md`.** The foundation (M3 `curve` presets + semantic durations in `Appearance.qml`, `Commons/Anim.qml`+`ColorAnim.qml`, `Commons/Primitives/StateLayer.qml`) plus new `GlassButton` + `SettingsCard` primitives are now used everywhere. Rolled out: **Launcher** (StateLayer hover/warmth/depth, two-line rows), **chrome liquid-glass sheen** (subtle vertical gradient, no blur), **Dashboard** (hero+bento rework), **Notifications** (toast + centre), **Round 3 full Settings redesign** (GlassButton/SettingsCard/StateLayer across every pane), **ToggleSwitch/SliderRow 3D**, accent 3D swatch dots. The initial Launcher list-transition thrash was found + fixed early (`0b875ab`). **Remaining polish (see POLISH_ROLLOUT.md):** Round 1 leftovers (CalendarPopup/WifiPopup/BtPopup, MediaPanel), Round 3 leftovers (EditOverlay/WidgetPalette buttons, a full consistency/spacing design pass, screenshot+playtest harness), and all of **Round 4** (Strip openers, `BarPill` active fill, Bar safe-only tweaks). Do NOT re-plan the shipped items here — POLISH_ROLLOUT.md is the live tracker.

### mangowm 0.16.1 upgrade — follow-ups (2026-08-17)

Updated mangowc 0.15.5 → **mangowm 0.16.1** (+ wlroots0.20 0.20.2, rofi 2.0.0) this
morning. **mmsg IPC JSON shape is unchanged** — shell (`MangoWC.qml`) + reload script
verified fine, no port needed (unlike the 0.15 migration). Config audited: the only
silent breakage was two touchpad keys (`scroll_method`/`disable_while_typing` →
`trackpad_*`), fixed in `config.conf`. Bound the new `dwindle_toggle_current_split`
(Super+Alt+\). Open follow-ups:
- [ ] **Test dock-undock** (wlroots 0.20.2) — is the output-hotplug freeze (diagnosed
  2026-07-30, a main driver for the Hyprland fallback) resolved? If yes, record in
  DECISIONS — de-risks mango-as-primary.
- [ ] **Verify rofi 2.0** — Super+K cheat sheet + Super+R launcher still theme/render
  correctly (major version; theme/CLI syntax may have shifted).
- [ ] **Picker robustness** — drive the tiling-layout picker from `mmsg get layouts`
  (new 0.16 IPC) instead of the hardcoded 14-layout list + symbol map.
- [ ] Optional adopt: `tag_gather` (auto-drop empty tags), wildcard `tagrule=id:*`,
  per-device `devicerule`, customizable tag count.
- 0.16 bugfixes we benefit from: suspend-crash on certain monitors, keyboard-layout-set
  crashes, kill-client crashes, screenshot rotation on rotated screens (our portrait DP-3).

### Flat ↔ glass aesthetic toggle (user idea 2026-07-31)

A **Settings toggle** (not a keybind — user pref 2026-07-31) to flip the whole shell between the default "liquid glass" look and a **flatter** aesthetic: no sheen gradient, no drop shadows, flatter (less-translucent, un-tinted) cards. Mechanism lives at the token layer — `Appearance.flatMode` (persisted `appearance.flatMode`) drives `glassSheenTop/Bot` (→ flat fill), `surfaceCard` (→ opaque, no accent), and a new `shadowStrength` token (1→0) that shared primitives multiply into their shadow alpha. **Gated on the polish rollout:** only surfaces already on the shared tokens/primitives flip; un-migrated ones (CalendarPopup/WifiPopup/BtPopup, MediaPanel, EditOverlay, Strip/Bar openers — see `POLISH_ROLLOUT.md`) stay glassy until Round 1/4 finish routing their sheen+shadows through the tokens. **Spike shipped 2026-07-31** (token + `GlassButton`/`SettingsCard`/`DashCard` shadows + AppearancePane toggle) to eyeball flat-vs-glass on the migrated surfaces before committing to the full rollout.

### Layout loadouts / presets (user idea 2026-07-02)

Save named snapshots of the whole bar/strip layout and switch between them in one click, instead of re-arranging widgets by hand. Cheap because `shell-config.json`'s `sides` block already *is* the full layout — a loadout is just a stored copy of it (+ optionally `corners`/`outerGap`). Sketch:
- `ShellConfig.saveLoadout(name)` snapshots current `sides`/`corners`/`outerGap` into a `loadouts: { <name>: {...} }` map in the config (or a sidecar file); `applyLoadout(name)` writes it back through the existing `_mutate` path → hot-reloads live.
- UI: a loadouts row in the Shell settings pane / edit-mode banner — save current, apply, rename, delete. Per-instance widget config (S26) rides along automatically since it lives in the entries.

### Tiling-layout picker with visual previews (user idea 2026-07-30) — ✅ SHIPPED 2026-07-31

**Shipped:** `Widgets/Appearance/LayoutPickerBody.qml` + `Modules/Shell/Panels/Content/LayoutPicker.qml`, panel id `layout`, opener on the bottom strip, `Super+Shift+T` / `qs ipc call layout toggle`. Grid of all 14 mango layouts as static Rectangle mini-diagrams (mauve master accent), per-layout keybind chip (quicksheet) + hover description, active highlight, arrows+Enter nav, click to `setlayout`. First real use of the Sprint 28 `shot.sh` harness (verified headless). Bundled UX work: `circle_layout` extended to all 14 (Super+T cycles everything), new direct binds (right_tile/center_tile, zoom→master, focusstack/focuslast/overview), dropped the scroller tagrules so reload preserves the live layout, and fixed shell-wide click-outside-to-dismiss to hit the panel card rect not the full edge. See `DECISIONS.md [2026-07-31]` + `TILING-PICKER-RESEARCH.md`. Deferred nice-to-haves below still open.


A Quickshell panel to choose the **tiling layout** (scroller/tile/dwindle/grid/monocle/fair/…) from **visual thumbnails** — each a mini-diagram of little rectangles arranged the way that layout tiles windows — instead of memorising `Super+Alt+<key>` or cycling blind with `Super+T`. Fits the existing panel system (like the wallpaper/theme pickers): a `PanelRegistry` panel themed with tokens, a grid of layout cards, click/arrow-select → `setlayout` (via `CompositorService` once Sprint 29's facade lands, or the mango dispatch directly meanwhile), active layout highlighted. Each card's diagram is cheap static QML (`Rectangle`s in the layout's arrangement); nice-to-have: a one-line description on hover. **First real payoff of the Sprint 28 headless `shot.sh` harness** — build it and verify the render without touching the live session. Small, self-contained; rides on the `setlayout`/`switch_layout`/`circle_layout` already wired up.
- Nice-to-haves: a couple of built-in presets (minimal / full / dev), export/import a loadout as JSON to share.

### Auto-hide sides in fullscreen (user idea 2026-07-03)

Bars/strips eat a sliver of screen — annoying in fullscreen (presentations, video, games). Want them to get out of the way. Two mechanisms, ship both:
- **Auto-detect fullscreen** — hide all sides when the focused window is fullscreen, reveal on exit. Compositor-dependent (needs a "focused window is fullscreen" signal); on MangoWC check what IPC exposes, else route through the planned `CompositorService` facade (post-v1.0 multi-compositor work). A strip in `holder` mode already reserves no space + hover-reveals, so "auto-hide" for bars ≈ making them behave like holders while fullscreen (collapse + edge hover-catch), reusing the existing reveal path rather than new chrome.
- **Manual toggle** — a keybind / setting to force-hide the shell regardless of window state (`ShellState`-level "shell hidden" flag gating `ShellSurface` visibility + exclusion zones), for when auto-detect misfires or the user just wants a clean screen.

Cheap-ish: the exclusion-zone + holder-reveal machinery already exists; this is mostly a global "hidden" gate + a fullscreen signal to drive it.

### Launcher → keyboard-first master search (user idea 2026-07-03)

Launcher isn't keyboard-usable enough. Concrete gaps + vision:
- **Search field must auto-focus on open** — especially when opened via keybind, typing should land in the search box immediately (type-to-search), Enter opens the top result. Right now focus doesn't go to the input. Likely a `forceActiveFocus()` on the TextField when the panel opens + making the panel/surface grab keyboard focus (tie into the panel focus handling that Strip/BarPanel already do for Esc).
- **Master search** (KDE KRunner / macOS Spotlight model): one field that searches apps **and** actions/tools — not just app launch. Candidate providers: apps, open windows, settings entries, wallpaper/theme switch, power actions, calculator, unit convert, maybe web search / project-jump. Keyboard-driven: arrow/Tab to move, Enter to run, per-provider prefixes optional. Pluggable provider list so plugins can register search sources.
- Ties into the panel keybind item below (Enter to open, Esc to dismiss).

### Panel keybinds / dismissal (user idea 2026-07-03)

More keybinds for panel control — notably **keys to exit/close panels** (Esc already closes strip/bar panels via the surface focus grab; extend to a global "close any open panel" bind, and possibly per-panel open binds). Audit which panels grab keyboard focus so Esc works consistently across all holders (bar panels + strip panels). Overlaps the launcher focus work above.

### Lock screen customization / "widgets" pane (user idea 2026-07-08)

Configure the hyprlock lock screen from a Settings pane — a phone-lockscreen feel: toggle/arrange which elements show (clock, date, rotating phrase, status bar, battery, uptime; later weather/media/avatar), pick a layout preset, edit the phrase list, choose the clock format.

**Key constraint:** hyprlock is a *separate process* driven by a static text file (`~/.config/hypr/hyprlock.conf`) with no live QML/IPC — so this is **not** arbitrary QML widgets on the lock surface. It's a **config generator** that emits `hyprlock.conf` from a config model, the same mechanism `theme-switch.py` already uses to render that file (colors from the active `theme.json`).

Fits existing patterns: swap today's fixed template for a config-driven generator, store choices in `Persistence.Config`, add a "Lock Screen" Settings pane (element show/hide toggles + layout presets + phrase-list editor + clock format), regenerate on change. The current hand-authored template — the "Console" layout (thin FiraCode-Light clock, date, rotating dev/inspiration phrase via `hyprlock-info.sh`, understated underline input, one bottom status bar `user · layout · battery · uptime`) — becomes the default preset the generator templates from. Self-contained small sprint; do it once the default lock is settled (it is, as of 2026-07-08).

### Theme-applier plugins (user idea 2026-07-09; post-v1.0 refactor)

Turn `theme-switch.py`'s hardcoded applier table into **drop-in theme-applier plugins** — the clean resolution to the theme-system split boundary (and it removes the standing "edit the Python table per app" coupling noted in `DECISIONS.md [2026-05-12]`). Each applier = a folder discovered like a module:
- **Declarative** (covers rofi/starship/fish/swaylock/hyprlock — just render→write→reload): a manifest, no code — `{ target, template, output, color_transform: hash|strip, reload_cmd, skip_if_missing }`.
- **Script escape-hatch** for the complex ones (gtk gsettings, vscode JSON-merge, obsidian vault-registry, zen userChrome, mango in-place sed): an executable fed the theme JSON on stdin.
`theme-switch.py` becomes a thin **runner** that discovers + invokes appliers (keeping today's per-target failure isolation). Wins: core ships only official appliers (kitty/rofi/gtk); personal ones (obsidian/zen) become your own plugins, not core; community can ship appliers for apps you don't use; Theme Packs bundle them. **v1.0 doesn't need this** — the "skip-if-missing" minimum (see the Repo-split section) is enough to ship; this is the depth version. Rides on Sprint 27's plugin install mechanism.

### Core → plugin / optional candidates (for "super-customizable" + a lean default)
Things currently baked into core that are really *personal* and should be extractable:
- **Dev-workflow tooling** → first official plugin (already Sprint 27).
- **Logo overlay set** (Arch/Rebel/Imperial) — the compositing mechanism is fine, but the 3 hardcoded logos are personal. Make the logo set **data-driven** (users drop their own SVGs); ship distro-logo or none by default. Folds into Theme Packs (below).
- **Machine-specific config** — logiops (MX Master 3S), the exact 3-monitor rules (DP-3 portrait), battery thresholds, AZERTY/QWERTY → **machine profiles** (Portability section); not sane defaults for a stranger.
- **Dashboard persona/dev bits** — AWS/VPN system-notes → dev-workflow plugin; the `~/Projects` + `~/Documents/repos` scan paths → configurable.
- **Accent picker is Catppuccin-only** — QML/terminal/rofi/mango accent works for *any* palette color (only GTK needs per-accent packages), so expose accent for **all families** with graceful GTK fallback.
- **Obsidian per-vault theme lock** (shipped this session) — `.obsidian/.archeotech-theme-lock` marker keeps a vault's community theme; only light/dark flips. Document in THEME_SPEC.

### Theme Packs (full-featured themes, official + community)
*Beyond palettes — a "pack" bundles the whole aesthetic identity.* User vision: Warhammer / Star Wars / Gundam / Cyberpunk etc. as optional installable packs, the flagship examples of the plugin/theme ecosystem.
- A pack = palette (theme.json) **+** wallpaper set **+** logo/sigil SVG **+** matching **Zen gradient** **+** optional persona (kitty/starship flavor, rofi, dashboard tips).
- This is where the **logo overlay** stops being 3 personal hardcodes and becomes pack content, and where **palette-driven Zen gradient** lives (theme-switch writes the workspace gradient from the pack's palette — see the Zen-gradient note; needs the `zen_workspaces` DB write, done during the Zen relaunch window).

**Zen dynamic-theming avenues (researched 2026-07-01 — for the palette→Zen work):**
- **Firefox Theme API via a WebExtension** (the [Pywalfox](https://github.com/Frewacom/pywalfox) model): a native-messaging host fed by a color file + a small extension apply chrome colors **dynamically, no restart, no userChrome CSS** — the ecosystem-standard way to drive Firefox chrome externally. `theme-switch.py` could write the color file; a bundled extension applies it. **Caveat:** the Zen bridge [PywalZen](https://github.com/Axenide/PywalZen) is archived/broken and "overrides custom gradients" — so the Theme API still fights the gradient (same tradeoff, better plumbing / dynamic).
- **userChrome.js live-reload** (Zen discussion [#11180](https://github.com/zen-browser/desktop/discussions/11180), [bug 1409065](https://bugzilla.mozilla.org/show_bug.cgi?id=1409065)): a `userChrome.js` script polls the CSS + re-registers the sheet via `nsIStyleSheetService` + `chrome-flush-caches` → live-reloads our chrome CSS **without restarting Zen**. Needs an fx-autoconfig loader. Kills the restart requirement independent of the gradient issue.
- **`zen.theme.accent-color` pref** — tried 2026-07-01, **no visible effect** with a workspace gradient set (the gradient subsumes the accent). Dead for gradient users; not pursued.
- **Bottom line unchanged:** gradient-vs-external-palette is a real tradeoff in *every* mechanism; keeping the gradient AND following the theme still requires the `zen_workspaces` gradient write. These avenues make the palette route *dynamic* rather than restart-based.
- Distribution model: a couple of **official** packs (incl. shadow-spear) + a **community** pack index (same `plugins.json` mechanism as plugins). Depends on the Sprint 26 plugin manager + Sprint 27 install/registry work.

### Visual Builder enhancements (extends Sprint 21 edit mode)
*(User-requested during S21: "in the end I'd like a more visual representation of what is in each, to really drag and drop all the widgets where I want them.")*
- **Drag-and-drop arrangement** — replace the S21 `‹ ›` reorder arrows with true drag-and-drop of widget chips within and between zones. Intra-window drag is reliable on Wayland (same basis as the S21 desktop `DraggableWidget`, `ANALYSIS.md` line 2092); the edit overlay is a single window, so cross-zone drag works. Drop order persists via `ShellConfig.setZoneWidgets` / `setStripIcons`.
- **Spatial zone representation** — render each bar zone / strip as a to-scale mock of the real side (icons shown in place) instead of a chip list, so arranging widgets maps 1:1 to what appears on screen.

### Dev Workflow Bar Widgets
*(sprint 28 covers git + AWS + terraform; these are the rest. All become `Widgets/Bar/*.qml` files per S18 widget registry.)*
- `DockerWidget` — containers count badge, click to open btop or lazydocker
- `KeyboardLayoutWidget` — QWERTY/AZERTY indicator, reflected from MangoWC `keyboardLayout` state
- `CapsLockWidget` — low priority, currently undetected

### Dev Workflow Scripts
Quick-access rofi menus for cloud/infra work:
- **AWS Console Launcher** (`Super+A`) — `aws configure list-profiles` → rofi → `granted console <profile>` opens browser console
- **Terraform commands menu** — rofi list: plan / apply / destroy / workspace list / workspace select / output / state list → runs selected command in a new kitty window
- **VSCode project switcher** — parse `~/.config/Code/User/globalStorage/storage.json` recent folders → rofi → `code <path>`
- **Monitor layout switcher** (`Super+Shift+M`) — presets: laptop-only / home / work / present → wlr-randr; complements CC display section for quick switching

### ~~Keybinds Cheatsheet~~ ✅ DONE
`Super+?` overlay showing active keybindings — already implemented.

### Clipboard Improvements
- Image clipboard support in cliphist — paste images from clipboard history
- Pin clipboard entries — mark certain items as permanent (don't expire)

### Multi-Monitor & Compositor
- **Monitor layout presets via keybinds** — `Super+F1` = laptop only, `Super+F2` = extend (work dock), `Super+F3` = present (mirror); calls existing wlr-randr scripts
- **Hotplug auto-detection** — script triggered on output plug/unplug (udev or MangoWC event) to auto-apply the right layout; MangoWC wildcard rules partially handle this already
- **Tags follow monitors on undock** — when external monitor disappears, windows on those tag sets move gracefully to remaining screen
- **Gaming mode** — keybind to disable blur/shadows/animations for performance; swap compositor config or kill effects temporarily

### Named Scratchpads
- Music player: ncspot (TUI Spotify) — keybind TBD
- Calculator: rofi-calc or qalculate-gtk — keybind TBD
- System monitor: btop in kitty — keybind TBD
- Current: `Super+grave` terminal already done

### Tool Discovery System
- Navi cheatsheets for all installed tools (`navi-cheats/` directory) — grouped: terminal, dev, system
- Categorized tools rofi launcher: `scripts/tools-launcher.sh`, icon + name + one-line description per entry, keybind TBD

### Quick Tools Context Menu
`Super+X` → rofi:
- Color picker (wl-color-picker)
- Screenshot region
- Screenshot window (active window only)
- Screen recording toggle (`wf-recorder`)
- OCR from screen (frog — `paru -S frog`)
- Calculator (rofi-calc)
- Emoji picker (rofimoji)

### Screenshot & Recording Improvements
- swappy annotation layer post-capture (pipe grim output → swappy before clipboard copy)
- Screen recording toggle: `Super+Shift+R` starts/stops `wf-recorder`, saves to `~/Videos/Recordings/`
- Window-only screenshot: `grim -g` with active window geometry from MangoWC IPC

### Kitty Session Presets
Named session files for common work contexts:
```
sessions/
├── dev.conf     # editor tab + terminal tab + lazygit tab
├── aws.conf     # AWS CLI tab + terraform tab + logs tab
└── default.conf # single clean terminal
```
Triggered from project jump menu: select project → open VSCode + kitty dev session simultaneously.

### SSH Quick Connect
`Super+Ctrl+S` → rofi: parses `~/.ssh/config` for `Host` entries → `kitty ssh <host>`.

### Per-Workspace Wallpapers
Different awww image per tag, transitions on switch. Hook on tag change via `CompositorService.onTagSwitched`. Tag 1 = default purple, Tag 2 = blueprint/schematic for code, etc.

### Portability & Machine Profiles

| Profile | Target | Key differences |
|---------|--------|-----------------|
| `swe-laptop` | HP EliteBook (current) | Full dev stack, AWS/Terraform, MangoWC |
| `gaming-desktop` | Personal PC (future) | Gaming mode, different compositor tuning, no work tools |

Install script accepts `--profile` flag; each profile declares its package list + which configs to stow.

---

## Ideas & Someday

Lower-priority ideas — worth keeping visible but not actively scheduled.

### Terminal & Editor
- **Neovim** — kickstart.nvim as starting point; Vim motions in VSCode first as stepping stone
- **Kitty deep config** — tab bar style, rename tabs per project, bird's-eye tab overview via rofi
- **Fish functions** — project jump, AWS switch, per-directory `.envrc` via `direnv`
- **Kanata** — Caps Lock → Esc/Ctrl tap-hold; home row mods evaluation

### Developer Tooling
- **glab** — GitLab CLI (`paru -S glab`); MRs, pipelines, issues from terminal (work repos)
- **K8s context switcher** — `kubectl config get-contexts` → rofi → `kubectl config use-context`; `Super+Ctrl+K`
- **tmux / zellij** — evaluate only if SSH session persistence becomes a pain point; kitty tabs may be enough
- **Hyprland backup sync** — when updating MangoWC config (keybinds, window rules, etc.), port the same changes to Hyprland so the fallback compositor stays usable

### Browser & Apps
- **Zen Browser** — Catppuccin theme + Stylus extension for GitHub, Reddit, YouTube, Twitch, Discord
- **YouTube PWA** — install as standalone PWA window
- **Excalidraw PWA** — quick diagrams, architecture sketches, braindumps; install via browser as PWA (`excalidraw.com`)

### Communication & Productivity
- **Thunderbird / Betterbird** — native email+calendar (vs browser Gmail); Catppuccin theme available
- **Obsidian workflow** — Templater plugin for daily notes, Dataview, Canvas, possible AI plugin; quick-capture keybind to open daily note instantly from anywhere
- **AppFlowy** — open-source Notion alternative, self-hosted; evaluate vs Obsidian for structured data
- **RSS Feeds** — follow blog posts, Arch news, GitHub releases without a social feed; tools to evaluate: Newsboat (TUI), Miniflux (self-hosted web UI), Fraidycat (minimal feed tracker)

### Music & Media
- **Spicetify** — Catppuccin Macchiato theme for Spotify desktop (`paru -S spicetify-cli`)
- **ncspot** — Rust TUI Spotify client for scratchpad use (`paru -S ncspot`)

### Visual Flair
- **Hex open/close animations** — investigate MangoWC SceneFX for geometric window transitions
- **Screensaver rotation** — `swayidle` hook → random terminal animation (cmatrix / cbonsai / asciiquarium / pipes.sh) before lock kicks in; run inside a kitty window spawned on idle trigger
- **SDDM idle animation** — animation between login sessions
- **Hyprshot** — Hyprland-native screenshot tool; evaluate as alternative to grim+slurp (`paru -S hyprshot`)
- **Hyprpicker** — freezes screen while picking color (better UX than wl-color-picker); `Super+Shift+C` (`paru -S hyprpicker`)

### Tools to Evaluate

| Tool | Category | What to check |
|------|----------|---------------|
| Walker | App launcher | Speed vs Quickshell launcher, plugin ecosystem |
| Ghostty | Terminal | Stability, feature parity with kitty |
| LM Studio | Local LLM | Hardware viability on i7-1355U/32GB |
| Mission Center | System monitor | GUI alternative to btop (`paru -S mission-center`) |
| frog | OCR | Screen text extraction (`paru -S frog`) |
| mdcat | Terminal markdown | Render markdown in terminal (`paru -S mdcat`) |
| espanso | Text expander | Keyword replacement + snippets (`paru -S espanso`) |
| Rnote | Drawing | Native whiteboard, stylus support |
| Kanshi | Monitor hotplug | Auto monitor profiles on dock/undock (may be redundant — MangoWC wildcard rules cover it) |
| Omarchy | Dotfiles inspiration | DHH's opinionated Arch setup — steal ideas |

### Reading & Books
CS books worth downloading and reading in Zathura (stored in `~/Documents/Books/`):
- **SICP** (Structure and Interpretation of Computer Programs) — Abelson & Sussman; programming fundamentals
- **CSAPP** (Computer Systems: A Programmer's Perspective) — Bryant & O'Hallaron; how computers actually work
- **DDIA** (Designing Data-Intensive Applications) — Kleppmann; databases, distributed systems

Zathura setup for reading: dark background, vim keybinds already configured; use `:bmark` for bookmarks, reflow mode for long PDFs.

### Color Extraction Tools
For future wallpaper-extracted theme work (Sprint 12+ lays the QML foundation):
- **matugen** — Material 3 palette generator from wallpaper; used by caelestia-dots
- **Wallust** — pywal successor, generates coordinated colorscheme from wallpaper, exports to 30+ app templates
- **pywal** — classic wallpaper→colorscheme, widest app template support

### Small Installs (Quick Wins)
These are just `paru -S <package>` away whenever convenient:
- `frog` — OCR
- `mdcat` — terminal markdown renderer
- `espanso` — text expander
- `mission-center` — modern system monitor GUI

---

## Reference

Key reference projects (all source-inspected 2026-05-04):

| Topic | Project |
|-------|---------|
| MangoWC IPC / multi-compositor | [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) |
| JsonAdapter / FileView / MPRIS / Notifications | [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) |
| Unified panel / DrawerVisibilities / lock screen / C++ plugin | [caelestia-dots/shell](https://github.com/caelestia-dots/shell) |
| Lock screen PAM + WlSessionLock | [Qylock](https://github.com/Darkkal44/qylock) |
| Go backend IPC pattern | [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) |
| System-wide theme switching (script approach) | [HyDE (prasanthrangan)](https://github.com/prasanthrangan/hyprdots) |

→ Full source-inspected findings, confirmed APIs, QML patterns, and settings research in `ANALYSIS.md`.
