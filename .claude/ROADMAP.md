# Roadmap

**Last Updated:** 2026-06-03  
**See also:** `ANALYSIS.md` — research, reference projects, confirmed QML APIs, settings ecosystem deep-dives.

---

## Project Vision

Archeotech is a **fully composable, community-extensible Quickshell shell** targeting MangoWC (primary), Hyprland, and Niri. The goal is a publishable v1.0 that anyone can install, customize, and extend without editing QML.

**Four pillars:**
1. **Module system** — every panel, widget, and bar element is a self-describing module (`module.json`). Drop a folder into `~/.local/share/archeotech/modules/` to install.
2. **Theme system** — themes are pure JSON + asset folders (`theme.json` + wallpaper + app-overrides). Drop into `themes/` to install.
3. **Visual builder** — drag-and-drop edit mode wires any module to any trigger (edge hover, bar icon, keyboard, desktop widget). Config persists to `DrawerConfig.json`, hot-reloads instantly.
4. **Compositor abstraction** — `CompositorService` facade means one codebase runs on MangoWC, Hyprland, and Niri.

**Target release:** v1.0 after Sprint 27 (Distribution). Subsequent sprints add depth (Go daemon, dev workflow, more themes).

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
- [ ] `configSchema` spec in `docs/WIDGET_API.md` + `docs/MODULE_API.md`; auto-generated form component (reuse Settings widgets)
- [ ] `shell-config.json` zone entries → `{id, config}` objects + compat shim; `ShellConfig` setters updated
- [ ] `BarWidgetLoader`/`StripWidgetLoader` inject per-instance `config` as a required property
- [ ] **Plugin/Widget Manager** Settings pane — list built-ins + discovered modules; per-instance config forms; enable/disable; uninstall; `verified` badge
- [ ] Fix external-plugin import path — modules under `~/.local/share/archeotech/modules/` can't `import "../../Commons"` (`MODULE_API` known issue); expose a stable import path **before** promoting community plugins
- [ ] (optional) intra-overlay drag-and-drop reorder + spatial side mock
- [ ] (optional) vertical-orientation widget layouts

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

### Sprint 28 — Distribution & v1.0 Release

**Goal:** Installable by a stranger on fresh Arch. Zero hardcoded paths. APIs documented. Community can publish plugins/themes. **v1.0 milestone.** (Only **1** hardcoded `/home/corvus` left — the audit is nearly done.)

**Checklist:**
- [ ] Hardcoded path audit — zero `/home/corvus`; all via `$HOME`/`Paths.qml`
- [ ] `scripts/install-packages.sh` — `paru -S` list, split required vs optional
- [ ] Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, service enable, verification, first-run experience
- [ ] Script the per-variant theme symlinks (`~/.config/archeotech/themes/<v>` → repo) in `install.sh` for fresh-deploy reproducibility (theme.json + kitty confs are the committed source of truth; the one-shot light-theme generator is gone/not needed)
- [ ] `docs/INSTALL.md` (fresh Arch + MangoWC, also Hyprland) + `docs/PLUGIN_API.md` + `CONTRIBUTING.md` (submit a plugin / theme)
- [ ] Finalize `MODULE_API`/`WIDGET_API`/`THEME_SPEC`/`PANEL_API`
- [ ] README harden — screenshots (bar, OSD, launcher, dashboard, settings, edit mode) + demo GIF (edit mode + theme/accent switch + plugin install)
- [ ] `v1.0.0` tag; GitHub description, topics, social preview

---

## Post-v1.0 — "depth" sprints (portability & extras)

*These are real but matter for **other machines**, not the release. Deferred behind v1.0.*

### Multi-Compositor Support (was Sprint 26)
`CompositorService` facade so the shell runs on Hyprland/Niri/Sway, not just MangoWC. Ref: Noctalia `Services/Compositor/`. API: `switchWorkspace`/`focusWindow`/`activeWorkspace`/`focusedApp`/`activeWindowTitle`. Tasks: `CompositorService.qml` (detect on startup) + `MangoService`/`HyprlandService`/`NiriService`/`Blur.qml`; replace direct MangoWC calls (incl. S25's `MangoWC.setProportion`/`setDefaultProportion`) with `CompositorService.*`; verify ShellSurface + 4× ExclusionStrips + per-compositor blur namespace on Hyprland; `docs/COMPOSITOR_SUPPORT.md`.

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
Loose ends from the S25 theming/Zen work — verify/fix before the v1.0 release:
- [x] **Zen chrome color — RESOLVED (2026-07-01):** solid palette backgrounds *did* recolor the chrome but flattened Zen's per-workspace **gradient** to a flat fill (Monochrome → flat black). Reverted the zen template to **light-touch** (accent + text vars only, no bg fills) so the gradient survives. Conclusion: Zen owns its chrome color via the workspace gradient (`zen_workspaces` DB, set in Zen's UI) and userChrome can't cleanly override it — so Zen's main chrome does NOT follow the shell theme by CSS. **Real fix = drive the workspace gradient from the palette during the Zen restart window** (queued: theme-packs / Sprint 26 — see the Zen-gradient note there). Interim: user sets a palette-matched gradient manually.
- [ ] **Test the auto day/night schedule end-to-end** — `ColorScheme` Dark/Light/Auto + schedule logic was built but never watched flip at a scheduled time.
- [ ] **Visual pass on the light themes** — Latte/TokyoNightDay/GruvboxLight/DraculaAlucard are official palettes; **Nord light is hand-tuned** (contrast-audited OK, yellow darkened to #977100) — eyeball it on real content.
- [ ] **VSCode `colorCustomizations`** now regenerates bg from the palette for *every* theme — verify it doesn't clash on the non-Catppuccin VSCode themes (Gruvbox/Tokyo/Nord); gate to Catppuccin if it does.
- [ ] **Settings panel widened 760→940** globally — check the other panes don't look sparse at the new width.

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
