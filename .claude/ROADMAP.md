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

### Sprint 25 — Hierarchical Theming System (family → flavor → accent) ← CODE COMPLETE (manual follow-ups pending)

*(Sprint 24 — Settings Depth — shipped 2026-06-15; see Sprint History. Remaining deferred items: full Pipewire audio-service migration is a Sprint 3 backlog item; a shared `WifiList`/`BtList` extraction for the bar popups + Connections is a nice-to-have cleanup, not blocking.)*

**Why deferred:** Raised during the S24 ColorScheme discussion. The current theme system is a **flat list of full `theme.json` variants** (one card per variant). That doesn't scale — Catppuccin alone is 4 flavors × 14 accents = 56 combinations, and adding light variants bloats the flat card grid. The right model is hierarchical, and it cleanly subsumes the original S24 "ColorScheme depth" goals (dark/light + schedule).

**Model:** `family → flavor → accent`
- **Family** = a theme identity (Catppuccin, Dracula, Gruvbox, Tokyo Night, Nord, Monochrome).
- **Flavor** = a palette within the family. **The flavor axis IS the light/dark axis** — light flavors (Catppuccin Latte, Tokyo Night Day, Gruvbox Light, Dracula Alucard) are "light mode"; the rest are dark. Per-family flavors:
  - Catppuccin: Latte (light) / Frappé / Macchiato / Mocha
  - Tokyo Night: Day (light) / Storm / Night / Moon
  - Gruvbox: Light / Dark (× hard/medium/soft contrast, optional)
  - Dracula: Alucard (light) / Dracula (dark)
  - Nord: Dark (+ a hand-built light, no canonical one)
  - Monochrome: Light / Dark
- **Accent** = which palette color drives `accent` (Catppuccin: 14 named colors). Accent customization is the hard part — see below.

**UI** (replaces the flat `ThemeGridBody` cards): family cards → on select, reveal a **flavor selector** (segmented/pills) + an **accent swatch row**. Lives in a dedicated **ColorScheme** Settings pane; the bottom Appearance switcher shows a compact version.

**Light/dark + day-night cycle** (the original S24 ColorScheme depth, folded in here):
- Mode: Dark / Light / Auto. Dark/Light pick which flavor of the chosen family to use.
- Auto = day-night schedule: off / manual (light-start + dark-start times) / location (sunrise-sunset). A `ColorScheme` service singleton ticks a `Timer` and applies the right flavor on transition.

**Config model** (`Persistence.Config`): `colorScheme.family`, `colorScheme.flavorDark`, `colorScheme.flavorLight`, `colorScheme.accent`, `colorScheme.mode` (dark|light|auto), `colorScheme.schedule` ({mode, lightStart, darkStart}). Keep `theme.variant` as the resolved/applied variant the rest of the shell reads.

**The accent challenge (why it's a chunk, not a checkbox):** changing accent isn't only QML recolor. GTK and VSCode ship **per-accent theme packages** (`catppuccin-macchiato-mauve-standard` vs `…-blue-…`, VSCode `Catppuccin Macchiato` is accent-agnostic but icon themes/others vary). So `theme-switch.py` must template the chosen accent into each app target: mango `focuscolor`/`bordercolor`, rofi `border`, GTK theme name, VSCode where applicable, plus the QML `accent` token. Families without 14-accent packages (Gruvbox/Nord/Mono) expose a smaller accent set or none.

**theme.json restructure:** group by family — either a `family.json` listing `flavors[]` (each with its palette + `mode`) and `accents[]`, or keep per-variant files but add `family` / `flavor` / `mode` / `accent-capable` metadata + a resolver. Migration: the 7 current flat variants map onto families (Macchiato/Mocha → Catppuccin; the rest are single-flavor families today).

**Phase 1 — complete (uncommitted, 2026-06-22):**
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

**Manual follow-ups (need user / system):**
- [ ] Install Catppuccin light/flavor GTK packages — built but the install step needs a sudo password (couldn't run headless): `paru -S catppuccin-gtk-theme-{latte,frappe,mocha}`. Until then, light Catppuccin + per-accent GTK on those 3 flavors falls back to default-accent GTK (QML/terminal/rofi/mango still recolor).
- [ ] Reload Quickshell to load the new theming UI (`pkill quickshell && quickshell &`) — note this re-resolves the theme from `config.json`.
- [ ] Obsidian gruvbox/nord community CSS themes aren't installed in all vaults (pre-existing); base light/dark + accent still apply.
- [ ] (nice-to-have) Script the per-variant theme symlinks in `install.sh` for fresh-deploy reproducibility.

**Side addition (separate commit, not Sprint 25 scope):** Scroller proportion controls — ShellPane SCROLLER section (window-width slider 80–100%, 60ms debounce → `MangoWC.setProportion()`; "Save as default" → `setDefaultProportion()` surgical sed on config.conf); mango: `scroller_focus_center=1`, default proportion 0.98, `Super+O` = `switch_proportion_preset`, presets `0.8,0.85,0.9,0.95,0.98`.

---

### Sprint 26 — Multi-Compositor Support

**Goal:** Make Archeotech installable by anyone regardless of compositor. `CompositorService` facade dispatches all WM calls to the right backend. Source-inspected from Noctalia (supports MangoWC/DWL, Hyprland, Niri, Sway, Scroll, Labwc).

**Reference:** Noctalia `Services/Compositor/` — `CompositorService.qml` (singleton facade), `MangoService.qml` (DWL protocol), `HyprlandService.qml` (socket IPC), `NiriService.qml` (JSON IPC), `SwayService.qml` (i3-compatible IPC).

**API contract** (compositor-agnostic):
```qml
CompositorService.switchWorkspace(n)
CompositorService.focusWindow(id)
CompositorService.activeWorkspace       // readable property
CompositorService.focusedApp            // readable property
CompositorService.activeWindowTitle     // readable property
```

**Architecture validation tasks** (from S17 + S20 audits):
- Verify 4× 1px ExclusionStrip PanelWindows behave correctly on Hyprland/Niri (layershell anchors with `implicitHeight: 1` — may need compositor-specific tweaks)
- Per-compositor blur namespace handling — MangoWC `layerrule = blur, namespace:archeotech-shell` vs Hyprland `layerrule = blur, archeotech-*`
- `Services/Compositor/Blur.qml` — abstraction for compositor-specific blur rules

**Checklist:**
- [ ] `Services/Compositor/CompositorService.qml` — detects active compositor on startup (`$XDG_CURRENT_DESKTOP`, `$WAYLAND_DISPLAY` hints), delegates to detected backend
- [ ] `Services/Compositor/MangoService.qml` — current `mmsg -w` subprocess pattern, promotes to primary backend
- [ ] `Services/Compositor/HyprlandService.qml` — Hyprland IPC socket (`/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.ipc`), workspace + window events
- [ ] `Services/Compositor/NiriService.qml` — Niri IPC socket (`$NIRI_SOCKET`), JSON event stream
- [ ] `Services/Compositor/Blur.qml` — per-compositor blur rule abstraction
- [ ] Replace all direct MangoWC calls in widgets/services with `CompositorService.*`
- [ ] Verify ShellSurface + ExclusionStrips work on Hyprland (backup compositor)
- [ ] `docs/COMPOSITOR_SUPPORT.md` — supported compositors, how to add a new backend

---

### Sprint 27 — Distribution & GitHub Release

**Goal:** Clean, documented, installable by a stranger on a fresh Arch Linux machine. Everything hardcoded to `/home/corvus` is gone. Module + theme APIs are documented. Community can publish extensions. **v1.0 milestone.**

**Checklist:**
- [ ] Hardcoded path audit — zero `/home/corvus` in any config or script; all paths via `$HOME` or `Paths.qml`
- [ ] `scripts/install-packages.sh` — full `paru -S` list for fresh Arch; split: required vs optional
- [ ] Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, service enable, verification
- [ ] `docs/INSTALL.md` — step-by-step for fresh Arch + MangoWC from zero; also Hyprland path; documents `shell-config.json` per-side configuration
- [ ] `docs/MODULE_API.md` — finalized (from S21); example module walkthrough
- [ ] `docs/THEME_SPEC.md` — finalized (from S19); community submission guidelines
- [ ] `docs/WIDGET_API.md` — finalized (from S18)
- [ ] README harden — screenshots of bar, OSD, CC, launcher, dashboard, settings, edit mode
- [ ] Demo GIF of edit mode + theme switching + per-side reconfiguration
- [ ] Version tag `v1.0.0` on first release
- [ ] GitHub repo description, topics, social preview
- [ ] `CONTRIBUTING.md` — how to submit a module, how to submit a theme

---

### Sprint 28 — Go Daemon
Only for raw Wayland protocols that QML can't reach natively:
- `archeotech-daemon` Go binary — Unix socket, newline-JSON RPC
- `Services/ArcheotechDaemon.qml` — Quickshell Socket, exponential-backoff reconnect
- Handles: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot)
- Does NOT handle: audio, network, BT, notifications, lock (all native QML)

### Sprint 29 — Dev Personality + Shadow Spear
- `themes/shadow-spear/` full theme package (compositor + kitty + starship raven sigil + rofi + wallpaper set)
- Git branch widget (`Widgets/Bar/GitWidget.qml`) — CWD from focused window, dims when no git context
- AWS profile widget (`Widgets/Bar/AwsWidget.qml`) — always visible, dims when `$AWS_PROFILE` unset
- Terraform workspace indicator (`Widgets/Bar/TerraformWidget.qml`) — shows `terraform workspace show`, only in tf repos
- Per-workspace wallpapers via `CompositorService.onTagSwitched` hook (S26 dependency)
- **Stretch:** SDF GLSL shader for corner blob (replaces ShapePath cubic bezier for ultra-smooth corners — Caelestia §15.2 line 2143)

---

## Feature Backlog

Well-defined features not yet scheduled into a sprint.

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

### Keybinds Cheatsheet
`Super+?` → rofi menu or Quickshell overlay showing all active keybindings grouped by category. Data sourced from a flat text file (same approach as tips.txt in the dashboard) or parsed from mango.conf.

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
