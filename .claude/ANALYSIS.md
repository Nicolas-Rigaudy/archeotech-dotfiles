# Archeotech Dotfiles — Full System Analysis

**Last Updated:** 2026-07-09 (added §18 — Polish & Liveliness motion/depth/warmth catalogue)  
**Purpose:** Comprehensive research reference — ecosystem findings, confirmed QML APIs, source-inspected patterns, settings deep-dives. Sprint plan lives in `ROADMAP.md`.

---

## Table of Contents

1. [Quickshell Ecosystem Research](#1-quickshell-ecosystem-research)
2. [Reference Projects — Full Catalog](#2-reference-projects--full-catalog)
3. [Current System Audit](#3-current-system-audit)
4. [Gap Analysis — Where We Are vs Where We Want To Be](#4-gap-analysis)
5. [Dead / Obsolete Files Found](#5-dead--obsolete-files)
6. [Architecture Decision: Build vs Fork](#6-architecture-decision)
7. [Sprint Plan](#7-sprint-plan)
8. [Installation Design](#8-installation-design)
9. [Settings Ecosystem Research — WiFi / Audio / BT Patterns](#9-settings-ecosystem-research--cross-repo-findings)
10. [Settings Panel Research — Dedicated Settings Apps](#10-settings-panel-research--wave-2-dedicated-settings-apps)
11. [QML Patterns & Design Principles](#11-qml-patterns--design-principles)
12. [Widget & Bar Systems — Cross-Repo Deep Dive](#12-widget--bar-systems--cross-repo-deep-dive)
13. [Information Architecture — Grouping, Icons, Quick vs. Deep](#13-information-architecture--grouping-icons-quick-vs-deep)
14. [Technical Unknowns — Resolved Pre-Sprint Research](#14-technical-unknowns--resolved-pre-sprint-research)

---

## 1. Quickshell Ecosystem Research

### What Makes a Shell "Polished"

Based on analysis of the top Quickshell projects (end-4 at 14.3k stars, DankMaterialShell at 6.1k, Noctalia at 6.3k), the gap between "functional" and "polished" comes down to these specific things:

#### Animation system
- Every panel open/close uses a state machine with enter/exit transitions
- Spring physics easing (`NumberAnimation { easing.type: Easing.OutBack }`) not just linear
- Element-level micro-animations: hover scale, press depress, active color fill
- The OSD is the only animated piece in our current shell — everything else snaps

#### State architecture
- **Singleton registry pattern**: All state lives in singletons. UI binds, never copies.
- **No polling for D-Bus-capable services**: Bluetooth, network, battery should use D-Bus signals or `busctl monitor`, not timers
- **External state sync**: If user changes power profile from terminal, UI updates within 2s
- **Lazy component loading**: `active: false` until first use, deactivation timer unloads

#### Theme system
- Colors in one QML singleton (`Appearance.qml` — we have this ✅)
- A `theme.json` file on disk that the singleton reads — enables live theme switching without restart
- Hot-reload: changing `theme.json` propagates to all bound properties instantly

#### Configuration persistence
- Settings written to a JSON file on every change, not just read at startup
- Control center state (DND, power profile, night light) reflects external changes
- Nothing hardcoded in QML — everything reads from config/theme files

#### Missing features that users expect
- Native notification center (not outsourced to swaync)
- Lock screen as a Quickshell component
- MPRIS media card in bar + control center
- App launcher (we use rofi externally — invisible seam)
- Screenshot integration with annotation

---

## 2. Reference Projects — Full Catalog

### Tier 1 — Primary References (Architecture + Polish)

#### end-4/dots-hyprland ★14.3k
**URL:** https://github.com/end-4/dots-hyprland
**What it does:** The most complete Quickshell shell. Bar, sidebar panels, workspace overview with live previews, AI integration (Gemini/Ollama), Material Design 3.
**Source-inspected 2026-05-04. Confirmed patterns:**
- **JsonAdapter** — `Config.qml` `pragma Singleton` wraps a `FileView` with two 50ms debounce timers: `onFileChanged → fileReloadTimer → reload()` (external edits), `onAdapterUpdated → fileWriteTimer → writeAdapter()` (QML-side mutations). `blockWrites` guard for bulk imports. `JsonObject` nesting is unlimited.
- **FileView hot-reload** — `watchChanges: true` only. No inotifywait subprocess. One `onFileChanged` signal, one debounce timer. Simple.
- **Lazy component loading** — two patterns: `LazyLoader { active: GlobalStates.barOpen }` destroys the surface when false. `Loader + Timer`: OSD visible → timer restarts; timer triggers → sets state to false → Loader destroys. Optional `keepLoaded` opt-out.
- **Appearance.qml** — flat `QtObject` with `m3colors`, `colors`, `animation`, `rounding`, `font`, `sizes` sub-objects. `ColorQuantizer` samples wallpaper for auto-transparency. Colors reloaded at runtime by `MaterialThemeLoader.qml` (runs Python, rewrites Appearance.m3colors.* properties).
- **MPRIS** — `Quickshell.Services.Mpris` only, no playerctl calls. `MprisController.qml` singleton with `Instantiator` on `Mpris.players`, auto-tracks playing player, exposes `IpcHandler { target: "mpris" }` for CLI control.
- **NotificationServer** — `Quickshell.Services.Notifications.NotificationServer` in QML. Popup suppressed when `sidebarRightOpen`. Persistence via `FileView` serializing list to JSON. Grouping done in JS as derived property.
- **Hot-reload** — `Quickshell.reload()` signal + `ReloadPopup.qml` showing progress bar. No EngineGeneration isolation.
- **Services** — 46 files, all `pragma Singleton`. Imports via `import qs.services` module directory. No explicit singleton registry.
**Why not fork:** Hyprland-only IPC. Our MangoWC `mmsg` layer would need full rewrite of the WM integration.

#### Noctalia Shell ★6.3k
**URL:** https://github.com/noctalia-dev/noctalia-shell
**What it does:** Multi-compositor shell (Hyprland, Niri, Sway, MangoWC, Scroll, Labwc). ~100 plugins. GLSL shaders.
**Source-inspected 2026-05-04. Confirmed patterns:**
- **Directory structure:** `Commons/` (Logger, Settings, ShellState, Style, I18n, Keybinds, Time), `Services/` (grouped by domain: Compositor/, Hardware/, Media/, Networking/, Power/, System/, Theming/, UI/, Location/, Keyboard/, Noctalia/), `Modules/` (Bar/, Dock/, LockScreen/, OSD/, Notification/, Panels/), `Widgets/` (N-prefixed primitives: NButton, NSlider, NIcon), `Shaders/frag/` + `Shaders/qsb/`, `Assets/` (fonts, color schemes JSON, translations, templates, sounds).
- **No qmldir files** — Quickshell resolves module URIs from directory layout directly (`qs.Services.Networking`, `qs.Modules.Bar`, `qs.Commons`). This eliminates all our current qmldir boilerplate.
- **MangoWC IPC** — `Services/Compositor/MangoService.qml` uses `Quickshell.DWL` (`DwlIpc` + `DwlIpcOutput`) as primary channel. `mmsg` CLI used only for two things DWL protocol can't do: display scale queries (`mmsg -g -A`) and some fallback workspace switching. Everything else (tags, title, appId, layout, selmon) comes from native DWL protocol. Window tracking in pure QML JS: `Map<ToplevelObject, UniqueID>`, `windowTagMap` for persistence.
- **CompositorService facade** — runtime-dispatching singleton that detects active compositor and delegates `switchToWorkspace`, `focusWindow`, etc. to MangoService/HyprlandService/NiriService/SwayService/LabwcService. One canonical API, multiple backends.
- **Services vs Widgets vs Modules** — Services: `pragma Singleton`, no visuals, independently importable. Widgets: stateless UI primitives, all N-prefixed, no business logic. Modules: stateful full surfaces that import Services. Commons: cross-cutting (logging, i18n, style tokens, settings schema, shell state).
- **Dev workflow** — `lefthook` pre-commit: runs `Scripts/dev/qmlfmt.sh` (QML formatting) and `Scripts/dev/build-settings-search-index.py`, re-stages changed files. `Scripts/dev/shaders-compile.sh` compiles .frag → .qsb (Qt Shader Baker). Both source and compiled shaders committed.
- **Nix flake** — full NixOS/home-manager integration. Not relevant for Arch but shows distribution target.
**MangoWC support:** Yes — best reference for MangoWC IPC patterns. Use `Quickshell.DWL` not `mmsg -w`.
**Closest to our use case.** Our target directory structure should mirror theirs.

#### DankMaterialShell ★6.1k
**URL:** https://github.com/AvengeMedia/DankMaterialShell
**What it does:** Complete shell replacement (bar, lock, idle, notifications, launcher). Go backend + QML frontend.
**Source-inspected 2026-05-04. Confirmed patterns:**
- **Two Go binaries** — `dms` (shell daemon + CLI via Cobra) and `dankinstall` (TUI installer). `CGO_ENABLED=0`, pure Go, cross-compiled for amd64/arm64.
- **IPC: Unix domain socket, newline-delimited JSON** — socket at `$XDG_RUNTIME_DIR/danklinux-<pid>.sock`. Protocol: `{"id": N, "method": "namespace.action", ...params}`. Integer IDs for correlation, `"subscribe"` method for push events. QML reads socket path from `$DMS_SOCKET` env var. `DankSocket.qml` wraps Quickshell's `Socket` type with exponential-backoff reconnect.
- **Go package structure** — `core/cmd/dms/` (Cobra CLI), `core/internal/server/` (socket server + all managers), sub-packages per domain: `network/`, `brightness/`, `bluez/`, `clipboard/`, `cups/`, `evdev/`, `freedesktop/`, `loginctl/`, `wayland/`, `wlroutput/`, `dwl/`, `dbus/`, `sysupdate/`. `core/internal/proto/` has pre-generated Go Wayland protocol bindings.
- **What Go handles that QML can't** — raw Wayland protocol sockets (wlr-gamma-control, wlr-output-management, wlr-screencopy, ext-workspace), complex D-Bus state machines (BlueZ pairing agent, NetworkManager subscriptions, logind sessions), evdev `/dev/input` reads, udev hotplug, persistent clipboard store (bbolt), screenshot (wlr-screencopy + SHM), color picker (Wayland SHM pixel sampling).
- **What Go does NOT handle** — workspace/window state (Quickshell's native DWL/Hyprland/Niri IPC handles that in QML). Go is purely for things Quickshell can't reach.
- **For Archeotech:** Go daemon makes sense in Sprint 8+ for: `wlr-output-management` (display layout without wlr-randr shell calls), `wlr-gamma-control` (night light without wlsunset shell calls), screenshot backend. Everything else (MPRIS, notifications, audio, battery, network, BT, lock screen) is native QML and does NOT need Go.
**Why not fork:** Material Design 3 aesthetic is opposite of Archeotech's cyber-monastic direction.

#### caelestia-dots/shell ★9.3k
**URL:** https://github.com/caelestia-dots/shell
**What it does:** The original primary visual reference for this project. Material Design 3 with wallpaper-extracted dynamic theming via `matugen`. Complete shell: bar, launcher, notification system, media dashboard, system controls, widgets, lock screen. C++ plugin for performance-critical paths.
**Source-inspected 2026-05-04. Confirmed patterns:**
- **Directory structure** — `components/` (pure UI atoms: StyledRect, StyledText, MaterialIcon, controls/*, effects/*, images/*), `modules/` (per-screen Wayland surfaces: bar/, background/, lock/, osd/, notifications/, sidebar/, launcher/, session/, utilities/, drawers/), `services/` (global `pragma Singleton`), `utils/` (stateless helpers: Icons, Paths, Strings, fzf.js, lrcparser.js), `plugin/src/Caelestia/` (C++ QML plugin), `assets/` (shaders .frag/.qsb).
- **Unified Drawers panel** — `modules/drawers/Panels.qml` is one full-screen `Item` per monitor hosting ALL sliding surfaces (sidebar, OSD, notifications, session, launcher, bar popouts) in one coordinate space. `DrawerVisibilities` per-screen boolean bus controls show/hide. `modules/drawers/Interactions.qml` is a `CustomMouseArea` translating hover zones + drag gestures into `visibilities.*` writes. No separate notification panel window — sidebar IS the notification + CC surface.
- **Theme pipeline** — `caelestia scheme set` (external CLI) runs matugen, writes `~/.local/state/caelestia/scheme.json`. `services/Colours.qml` watches with `FileView { watchChanges: true; onLoaded: root.load(text(), false) }`. C++ `Tokens`/`TokensAttached` object exposes spacing/curves as attached properties.
- **Lock screen** — `modules/lock/Lock.qml` uses `WlSessionLock` (ext-session-lock-v1). One `WlSessionLockSurface` per screen. PAM in `modules/lock/Pam.qml`. Exposed via `IpcHandler { target: "lock" }` — `qs ipc call lock lock` works from CLI. Lock surface has its own media widget, notification dock, clock — fully self-contained.
- **C++ plugin** — `Config/` (GlobalConfig singleton backed by JSON, `MonitorConfigManager` for per-screen overrides, `CONFIG_PROPERTY` macros), `Services/` (reference-counted expensive backends: CavaProvider, BeatTracker, AudioCollector), `Internal/` (HyprExtras IPC socket, LogindManager, SparklineItem/ArcGauge/VisualizerBars custom QSGNode renderers), `Images/` (CachingImageProvider), `Models/` (FilesystemModel, LazyListView).
- **CLI control** — `qs ipc call <target> <method>` via `IpcHandler` declarations in QML. No separate daemon. Companion `caelestia` CLI writes state files that `FileView` watchers pick up.
**Why not fork:** Material You aesthetic conflicts with Archeotech curated themes. Dynamic color extraction is the opposite of what we want (curated hand-crafted theme personalities).
**Status:** Primary visual inspiration. Read the lock screen and drawers modules before building those components.

#### AMBXST (Axenide)
**URL:** https://github.com/Axenide/Ambxst
**Stars:** ~1k, 2219 commits, 19 releases, active Discord
**What it does:** Hyprland shell. Full-featured: launcher, clipboard, notifications, OSD, system monitoring, audio mixing (EasyEffects), Bluetooth, wallpaper manager, emoji picker, color picker, OCR, QR scanning, AI integration, screen recording (gpu-screen-recorder), game mode, power management.
**Steal these patterns:**
- File-watch triggers: watches config files, wallpapers, themes — behavior changes on file update
- Hot-reload with service restart on QML changes
- Integration with external tools rather than reimplementing (OCR → tesseract, recording → gpu-screen-recorder)
- Non-intrusive install: single line sourced into compositor config
- Scope of utility integration (the breadth is the product)
**Note:** Hyprland only. Relevant for feature scope, not IPC patterns.

### Tier 2 — Feature References

#### Qylock ★1.5k
**URL:** https://github.com/Darkkal44/qylock
**What it does:** Quickshell lockscreen specialist. Multiple themes including video backgrounds, pixel art, game-themed (Minecraft, NieR, Genshin).
**Source-inspected 2026-05-04. Confirmed implementation:**
- **PAM auth** — `Quickshell.Services.Pam.PamContext`. No external process. `pam.start()` → `onResponseRequiredChanged` → `respond(password)` → `onCompleted: result === PamResult.Success`. ~15 lines of logic.
- **Session lock** — `WlSessionLock { locked: shellRoot.sessionLocked }` with `surface: Component { WlSessionLockSurface { ... } }`. Compositor-level lock via `ext-session-lock-v1`. On success: `hyprctl keyword misc:allow_session_lock_restore 1`, `loginctl unlock-session`, `Qt.quit()` after 1.5s.
- **Blur/dim** — no separate PanelWindow. The `WlSessionLockSurface` itself is full-screen by protocol. Themes implement overlay via plain `Rectangle` + `opacity` or `Qt5Compat.GraphicalEffects` directly on background item.
- **Video backgrounds** — standard `QtMultimedia`: `MediaPlayer { loops: MediaPlayer.Infinite }` + `VideoOutput { fillMode: VideoOutput.PreserveAspectCrop }`. No special Quickshell component.
- **Clock** — `Timer { interval: 1000; onTriggered: currentTime = Qt.formatTime(new Date(), "hh:mm") }`.
- **Password focus** — `TextInput { echoMode: TextInput.Password }` + `Timer { interval: 300; onTriggered: pwInput.forceActiveFocus() }`. No exclusive protocol grab needed — `WlSessionLock` delivers all input to lock surface automatically.
- **File structure** — `lock_shell.qml` (ShellRoot), `shim/SddmShim.qml` (PAM + power actions), `themes/<name>/Main.qml` (self-contained theme UI).
**Use for:** Sprint 7 — native Quickshell lock screen. Implementation is simpler than expected.

#### NibrasShell ★705
**URL:** https://github.com/AhmedSaadi0/NibrasShell
**What it does:** Async-first architecture. AI system daemon for resource monitoring. Smart Capsule widget (weather, media, stats). Material 3 theming. GIF/video wallpapers. Built-in settings GUI.
**Steal these patterns:**
- Async-first design — all operations non-blocking (prevents UI freezes on slow commands)
- Built-in settings app (no file editing by users)
- Smart capsule widget pattern (dynamic island-style contextual display)

#### Nucleus Shell
**URL:** https://github.com/nucleus-hq/nucleus-shell
**What it does:** Composable modules, JSON config, multiple theme variants (Love, Forests, Passion, Metallic).
**Steal these patterns:**
- Multiple complete visual theme variants from day one
- JSON-only configuration (no QML edits required for customization)

#### tripathiji1312/quickshell ★92
**URL:** https://github.com/tripathiji1312/quickshell
**What it does:** Clean architecture example. Three-tier: Components → Modules → Services.
**Steal these patterns:**
- The three-tier directory structure (best practice separation)
- Full notification server implementation (action buttons, image support)
- Pywal integration pattern

#### YAHR-Quickshell
**URL:** https://github.com/bgibson72/yahr-quickshell
**What it does:** 13 unified themes synchronized across Neovim, Firefox, VSCodium, Kitty, GTK. Glassmorphism as first-class design. SDDM auto-sync. Google Calendar in widgets.
**Steal these patterns:**
- Theme sync scripts (bidirectional sync with editor/browser)
- SDDM color matching automation
- Glassmorphism specs: 92% opacity panels, 1px accent border at 35% alpha, frosted glass cards

#### ColorShell
**URL:** https://github.com/retrozinndev/colorshell
**Note:** AGS-based (not Quickshell). Dynamic theming via pywal16.
**Steal:** Multi-language support approach (EN/FR/PT/RU/TR/JP).

### Tier 3 — Distribution/Install References

#### HyDE ★(gold standard for theme switching)
**URL:** https://github.com/HyDE-Project/HyDE
**What it does:** The gold standard for theme switching. 20+ simultaneous targets (GTK2/3/4, Qt5/6, cursor, icons, dconf, flatpak, fonts, Hyprland). Wallbash auto-generation. Font inheritance. Incremental theme patching. Migration system for version upgrades.
**Steal for installation:**
- Modular script phases: `-i` (pkgs), `-d` (defaults), `-r` (restore), `-s` (system services)
- Declarative restoration format (CSV-like: overwrite|backup|path|config|deps)
- Timestamped backups before any overwrite
- Global function library (300+ utility functions in `global_fn.sh`)
- Theme thumbnail preview in rofi selector
- Migration scripts for version upgrades (`migrations/v26.4.3.sh`)
**Steal for theme switching:**
- Multi-target synchronization approach
- Sanitization before apply (removes conflicting rules)
- Parallel component application (background processes)
- Font inheritance system (per-theme font definitions)

#### JaKooLit/Hyprland-Dots ★3.3k
**URL:** https://github.com/JaKooLit/Hyprland-Dots
**What it does:** Best-in-class interactive install UX. Phased installation. GPU/VM detection. Express vs interactive mode. Auto-backup with cleanup. i18n README (5 languages). Distro-specific repos.
**Steal for installation:**
- Phased approach: high-customization apps first, then standard configs
- `lib_detect.sh` for GPU/VM/NixOS detection
- `lib_prompts.sh` for interactive keyboard/resolution/animation preferences
- Express mode (no prompts, sensible defaults)
- Integrated git-based update mechanism with auto-stash
- Per-app backup strategies (rofi/waybar have special handling)

#### ML4W
**URL:** https://github.com/mylinuxforwork/dotfiles / https://ml4w.com/os
**What it does:** Distribution via hosted scripts. `.dotinst` custom descriptor format. Selective restoration checklist. 50+ individual setting files (each = 1 value). Matugen adaptive colors.
**Steal for installation:**
- Individual setting files pattern (`~/.config/ml4w/settings/` — each setting is 1 file)
- Listener system for runtime config changes
- Per-distro preflight checks
- Piped install: `bash <(curl -s https://ml4w.com/os/stable)`

#### R7rainz/dotfiles
**URL:** https://github.com/R7rainz/dotfiles
**What it does:** Uses `gum` for styled terminal output. Error handler with recovery instructions. Sudo caching. Component-colored output, bordered sections.
**Steal for installation:**
- Visual install script with `gum` (Tokyo Night colors → adapt to Catppuccin Mauve)
- Error handler with recovery guidance
- Progress indication with color-coding

---

## 3. Current System Audit

### File Inventory — Quickshell

```
config/.config/quickshell/
├── shell.qml                    ✅ Main shell root, IPC handlers
├── Appearance.qml               ✅ Theme singleton (colors, fonts, spacing, radii, animations)
├── Osd.qml                      ✅ Volume/brightness OSD, per-screen, 1.5s auto-hide
├── qmldir                       ✅ Module definition
├── bar/
│   ├── Bar.qml                  ✅ Per-screen pill bar, all tray modules, hover popups
│   └── qmldir
├── controls/
│   ├── ControlCenter.qml        ✅ 320px right panel, audio/display/system/idle/tools
│   └── components/
│       ├── ActionButton.qml     ✅ Icon+label button (tools section)
│       ├── PillButton.qml       ✅ Toggle button with active state
│       ├── SectionHeader.qml    ✅ Section label
│       └── ToggleSwitch.qml     ✅ Animated thumb toggle
└── services/
    ├── Audio.qml                ✅ PulseAudio via pactl, subscribe + auto-restart
    ├── Battery.qml              ✅ /sys/class/power_supply/BAT0, 30s poll
    ├── Brightness.qml           ✅ brightnessctl, reads /sys/class/backlight
    ├── Bluetooth.qml            ✅ busctl → org.bluez, 5s poll
    ├── Network.qml              ✅ nmcli monitor (persistent subscription)
    ├── MangoWC.qml              ✅ mmsg -w stream, per-output tags/title/layout
    └── qmldir
```

### Known Weaknesses in Current QML

| Issue | Location | Fix | Sprint |
|-------|----------|-----|--------|
| No panel enter/exit animations | ControlCenter, Bar popups | 200ms slide+opacity, OutQuart easing | 4 |
| Clock updates every 10s | Bar.qml | `interval: 1000` (3-char fix) | 0 |
| Battery hardcoded to BAT0 | Battery.qml | UPower D-Bus (auto-detects battery) | 3 |
| Bluetooth 5s polling | Bluetooth.qml | D-Bus signal subscription via `busctl monitor org.bluez` | 3 |
| State reads at startup only | ControlCenter.qml | 2s poll `onVisible` + D-Bus subscriptions | 3 |
| Silent process failures | All services | Add `onExited: (code) => console.error(...)` | 3 |
| Idle config as shell script | ControlCenter.qml | Keep — functional, not worth rewriting | — |
| 10 lines to close CC (manual bbox) | shell.qml | `State.qml` global boolean bus + `TapHandler` | 3 |
| No spring easing | All animations | `easing.type: Easing.OutBack` on tag/color transitions | 4 |
| No MPRIS integration | Bar.qml | `Quickshell.Services.Mpris` — native, no playerctl | 4 |
| MangoWC IPC via mmsg subprocess | MangoWC.qml | `Quickshell.DWL` DwlIpc + DwlIpcOutput (native protocol) | 2 |
| Flat directory structure | quickshell/ | Full restructure to Commons/Services/Modules/Widgets | 1 |
| qmldir boilerplate | services/qmldir, bar/qmldir | Delete — Quickshell resolves from directory layout | 1 |
| No compositor abstraction | MangoWC.qml | CompositorService facade + MangoService/HyprlandService | 2 |
| Audio via pactl subprocess | Audio.qml | `Quickshell.Services.Pipewire` (native, signal-driven) | 3 |
| Hardcoded paths (`$HOME`) | Multiple | `Commons/Paths.qml` singleton | 3 |

### File Inventory — Scripts

```
scripts/
├── install.sh              ✅ Stow deploy + scripts + systemd
├── uninstall.sh            ✅ Remove symlinks
├── wallpaper-set.sh        ✅ Wallpaper + logo overlay system (awww)
├── wallpaper-picker.sh     ✅ Rofi thumbnail grid
├── battery-alert.sh        ✅ Battery monitor daemon
├── swaylock-launch.sh      ✅ Dynamic wallpaper lock screen
├── mango-reload.sh         ✅ Safe MangoWC reload + wlr-randr re-apply
├── project-jump.sh         ✅ Rofi project launcher
├── wlogout-launch.sh       ✅ Per-monitor adaptive margins
├── setup-snapper.sh        ✅ Automated snapper setup
├── update-system-configs.sh ⚠️  Exists but not called by install.sh
├── show-keybinds.sh.bak    ❌ DEAD — delete
└── assets/
    ├── arch-logo.svg        ✅ Active
    ├── rebel-logo.svg       ✅ Active
    ├── imperial-logo.svg    ✅ Active
    ├── wallpaper-picker.rasi ✅ Active
    └── panel.rasi           ✅ Active
```

### File Inventory — Config Dirs

```
config/.config/
├── hypr/            ✅ Hyprland (backup compositor) — fully configured
├── mango/           ✅ MangoWC (primary) — autostart.sh OUTDATED (see §5)
├── quickshell/      ✅ Active shell
├── waybar/          ⚠️  Two configs: config-mango, config (Hyprland) — possibly redundant
├── swaync/          ✅ Active notification daemon
├── dunst/           ❌ DEAD — replaced by swaync, not autostarted
├── rofi/            ✅ App launcher + wallpaper picker
├── kitty/           ✅ Terminal
├── fish/            ✅ Shell + conf.d/
├── swaylock/        ✅ MangoWC lock screen
├── swayidle/        ✅ MangoWC idle manager
├── wlogout/         ✅ Power menu
├── waypaper/        ✅ Backup wallpaper picker (backend=custom)
├── gtk-3.0/         ✅ GTK3 theme
├── gtk-4.0/         ✅ GTK4 theme
├── btop/            ✅ System monitor
├── yazi/            ✅ TUI file manager
├── zathura/         ✅ PDF viewer
├── bat/             ✅ bat (better cat)
├── cava/            ✅ Audio visualizer
├── xdg-desktop-portal/ ✅ Screen sharing
├── environment.d/   ✅ Env vars (cursor theme, etc.)
├── navi/            ✅ CLI cheatsheets
├── lazygit/         ✅ TUI git client
├── atuin/           ✅ Shell history
└── systemd/user/    ✅ battery-alert.service
```

---

## 4. Gap Analysis

### Phase 2 Bar — What's Missing

| Feature | Status | Priority |
|---------|--------|----------|
| MPRIS now-playing | ❌ Not started | High |
| Brightness in bar tray | ❌ Not started | Medium |
| Clock on 1s tick | ❌ Currently 10s | High (easy fix) |
| Panel enter/exit animations | ❌ None | High |
| Spring easing on all animations | ❌ Linear only | Medium |

### Phase 3 — Notification Center

The single biggest missing piece for a coherent shell. swaync is a separate process with separate CSS — it will never feel unified.

What's needed:
- `org.freedesktop.Notifications` D-Bus server in QML
- Notification popup card component (matching bar/CC aesthetic)
- Notification history panel (slides from right, same glass style)
- DND toggle in panel (real toggle, not swaync relay)
- Action buttons on notifications
- Per-app icon resolution (from desktop file)

Reference: end-4's notification implementation, NibrasShell's async notification handling.

### Phase 3 — Lock Screen

Currently: swaylock (external, separate CSS) for MangoWC. Not a Quickshell component.
What's needed: Quickshell PanelWindow as lock screen with:
- Blur/dim current session behind it
- Clock + date overlay
- Password input field
- Wallpaper background (from `~/.cache/wallpaper/last-wallpaper`)

Reference: Qylock (1.5k stars, specialized in this).

### Theme Switcher — Critical Gap

The Archeotech style guide defines 5 distinct theme personalities (Macchiato, Mocha, Shadow Spear, Gundam HUD, Neon Liturgy). None exist beyond Macchiato.

What's needed for each theme:
- `themes/<name>/theme.json` — Quickshell reads this live (hot-reload, no restart)
- `themes/<name>/mango-overrides.conf` — border/shadow/radius values
- `themes/<name>/kitty-colors.conf` — terminal palette
- `themes/<name>/starship.toml` — prompt style (raven sigil for Shadow Spear, crosshair for Gundam)
- `themes/<name>/rofi-vars.rasi` — color overrides
- `themes/<name>/wallpaper` — path/symlink to wallpaper set

Theme switcher script (`scripts/theme-switch.sh`):
1. Copy `theme.json` to `~/.config/quickshell/theme.json`
2. Patch mango config (border/shadow)
3. Swap kitty include
4. Swap starship symlink
5. Swap rofi vars
6. Call `mango-reload.sh`
7. Send wallpaper transition via `wallpaper-set.sh`

### Developer Modules — Bar

The bar should show contextual dev info (always visible, dims when not relevant):
- Git branch + dirty indicator (from focused window CWD via MangoWC `mmsg`)
- AWS profile (`$AWS_PROFILE` env)
- Terraform workspace (`terraform workspace show`, only in tf repos)

Reference: The roadmap's "Developer Workflow Integration" section.

### Distribution Gaps

For a clean GitHub release:
1. `install.sh` is incomplete (missing 8+ config dirs, no system config deployment)
2. No package installation step (no `pacman -S` / `paru -S`)
3. No prerequisites check (quickshell-git, awww, etc.)
4. No `INSTALL.md` targeting a fresh Arch install
5. No screenshots / demo GIF for README
6. autostart.sh is outdated (launches waybar + dunst instead of quickshell + swaync)

---

## 5. Dead / Obsolete Files

### Delete immediately

| File | Reason |
|------|--------|
| `scripts/show-keybinds.sh.bak` | Backup of replaced script, git-tracked dead weight |
| `config/.config/dunst/dunstrc` | Replaced by swaync. Not autostarted. Misleading to have in repo. |

### Fix immediately

| File | Issue | Fix |
|------|-------|-----|
| `config/.config/mango/autostart.sh` | Launches `waybar` (replaced by quickshell), `dunst` (replaced by swaync), `swww-daemon` (renamed to `awww`), hardcoded wallpaper path | See §7 for corrected version |
| `scripts/install.sh` | CONFIGS array has 19 entries, repo has 27 config dirs. Missing: quickshell, swaync, wlogout, waypaper, navi, lazygit, atuin, swaylock, swayidle | Update CONFIGS array |
| `docs/PACKAGES.md` | Missing `quickshell-git`; `swww` should be `awww` | Update entries |

### Clarify (not broken, but confusing)

| File | Issue |
|------|-------|
| `config/.config/waybar/` | Still has two configs (config, config-mango). Phase 2 of Quickshell migration is "mostly done" but autostart still launches waybar as the primary bar. Once Quickshell Phase 2 is complete, waybar configs should move to `legacy/` or be removed. |
| `scripts/update-system-configs.sh` | Exists, deploys /etc configs, but is never called by install.sh. Should be integrated or documented clearly. |

---

## 6. Architecture Decision

### Verdict: Build Our Own (Option C — pattern study, not fork)

**Why not fork Noctalia:**
- Their aesthetic (Material You, plugin marketplace) conflicts with the Archeotech cyber-monastic identity
- Their theme system is designed for dynamic wallpaper-extracted colors; ours is curated hand-crafted themes
- Forking means fighting their architecture whenever we want something outside their design

**Why not fork AMBXST:**
- Hyprland-only IPC. Our MangoWC `mmsg` layer would need to replace all IPC code.
- Their aesthetic is also generic/neutral

**Why build our own with pattern study:**
- We already have the right foundation: `Appearance.qml` singleton, service singletons, MangoWC IPC layer, multi-monitor bar instantiation
- The quality gap is specific and fixable: no panel animations, state desyncs, 10s clock, no MPRIS
- The Archeotech aesthetic (Shadow Spears, cyber-monastic, named theme personalities) cannot be achieved by theming someone else's shell
- Full ownership means no upstream conflicts when MangoWC adds new IPC features

**What to steal (patterns, not code):**
- end-4: JsonAdapter, FileView hot-reload, lazy component loading
- Noctalia: MangoWC IPC patterns, multi-compositor abstraction structure
- HyDE: theme switching multi-target approach, installation script structure
- JaKooLit: interactive install UX, phased backup approach
- Qylock: Quickshell lock screen implementation

---

## 7. Sprint Plan

The sprint plan has moved to `ROADMAP.md`. Key architecture decisions confirmed by this research:

- Target structure: `Commons/` + `Services/<Domain>/` + `Modules/` + `Widgets/` (no qmldir files) — confirmed from Noctalia source
- MangoWC IPC: `mmsg -w` subprocess (Quickshell.DWL is in a custom fork, not upstream)
- MPRIS: `Quickshell.Services.Mpris` — native D-Bus, no playerctl
- Notifications: `Quickshell.Services.Notifications.NotificationServer`
- Lock screen: `WlSessionLock` + `Quickshell.Services.Pam.PamContext` (~50 lines — confirmed from Qylock)
- Go daemon: Sprint 17+, only for `wlr-output-management`, `wlr-gamma-control`, `wlr-screencopy`

---

## 8. Installation Design

### Target: Fresh Arch Linux + MangoWC Install

```
git clone git@github.com:corvus/archeotech-dotfiles.git ~/Projects/archeotech-dotfiles
cd ~/Projects/archeotech-dotfiles
./scripts/install.sh
```

### Planned install.sh Flow

```
1. prereq_check()
   - Arch Linux? (check /etc/arch-release)
   - Required tools installed? (stow, git, quickshell-git, awww, swaync, ...)
   - Missing packages? → print install command, ask to continue

2. backup_configs()
   - Timestamped backup of any non-symlink configs
   - Keeps only latest backup per component (JaKooLit approach)

3. deploy_stow()
   - stow -t ~ config
   - Covers all 27 config dirs atomically

4. install_scripts()
   - Symlink all scripts/ to ~/.local/bin/
   - chmod +x all scripts

5. enable_services()
   - battery-alert.service symlink + systemctl enable

6. interactive_prompts()
   - "Which compositor? MangoWC / Hyprland / Both" → set default autostart
   - "Apply wallpaper now? Y/n"

7. verify()
   - Check all symlinks exist
   - Check quickshell --check (if available)
   - Print next steps
```

### Distribution Checklist (Before First GitHub Release)

- [ ] All configs in repo (no manual steps required)
- [ ] `install.sh` handles full deploy from zero
- [ ] `scripts/install-packages.sh` installs all AUR + pacman packages
- [ ] README has screenshots of all major components
- [ ] README has "Getting Started" (3-command install)
- [ ] INSTALL.md has detailed step-by-step for fresh Arch
- [ ] All dead files deleted
- [ ] autostart.sh correct (quickshell, swaync, awww)
- [ ] No hardcoded paths (no `/home/corvus/` anywhere in configs)
- [ ] Version tag on first release

### Hardcoded Paths Audit (Must Fix Before Distribution)

Search and replace `corvus` / `/home/corvus` in all configs before distributing:
- `scripts/battery-alert.sh` — may have hardcoded paths
- `config/.config/swayidle/` — may reference specific paths
- `config/.config/mango/autostart.sh` — currently has `~/Projects/archeotech-dotfiles/scripts/battery-alert.sh` (should use `$HOME/.local/bin/battery-alert.sh`)
- Any wallpaper paths (should use `$HOME/Pictures/Wallpapers/` or configurable)

---

## Quick Reference: Key Decisions Made

| Decision | Choice | Reason |
|----------|--------|--------|
| Shell framework | Quickshell (QML) | Highest ceiling, what caelestia uses, MangoWC compatible |
| Architecture | Build own, steal patterns | Archeotech aesthetic can't be achieved by theming another shell |
| Directory structure | Commons/ + Services/<Domain>/ + Modules/ + Widgets/ | Matches Noctalia — source-inspected 2026-05-04 |
| qmldir files | Delete all | Quickshell resolves from directory layout — confirmed from Noctalia source |
| MangoWC IPC | `Quickshell.DWL` (DwlIpc + DwlIpcOutput) | Native protocol, not `mmsg -w` subprocess stream |
| MPRIS | `Quickshell.Services.Mpris` | Native D-Bus, no playerctl — confirmed from end-4 source |
| Notifications | `Quickshell.Services.Notifications.NotificationServer` | Native D-Bus server — confirmed from end-4 source |
| Lock screen | `WlSessionLock` + `Quickshell.Services.Pam.PamContext` | ~50 lines — confirmed from Qylock source |
| Go daemon | Sprint 9+, only for raw Wayland protocols | wlr-output-management, wlr-gamma-control, screencopy only |
| Theme system | JSON file + FileView hot-reload | Live switching without restart |
| Compositor | MangoWC primary, Hyprland backup | Scrolling layouts |
| Notification daemon (current) | swaync | Sprint 6 replacement planned |
| Lock screen (current) | swaylock | Sprint 7 replacement planned |
| Theme palette | Catppuccin Macchiato + named personalities | Curated > dynamic extraction |
| Install approach | stow + install.sh | Simple, auditable, no magic |
| Distribution target | Arch Linux | Primary OS, paru for AUR |

---

## 9. Settings Ecosystem Research — Cross-Repo Findings

**Research date:** 2026-05-12  
**Repos inspected:** caelestia-dots/shell, end-4/dots-hyprland, DankMaterialShell, Noctalia, HyDE (hyprdots), linuxmobile/hyprland-dots

---

### 9.1 The Gap: Nobody Has a Native WiFi Panel

HyDE and linuxmobile both confirmed: no existing Quickshell/waybar rice has a native WiFi management panel. Both fall back to nm-applet tray or nm-connection-editor. Building a native nmcli-backed WiFi section is genuinely novel in this ecosystem.

---

### 9.2 WiFi — Confirmed Patterns

#### Radio toggle
**Noctalia (confirmed):** `Quickshell.Networking.wifiEnabled` is a readable+writable boolean property. Writing it toggles the adapter — no nmcli subprocess needed for the toggle itself.

#### Network list command
All repos using nmcli use this field set:
```
nmcli -g SSID,SECURITY,SIGNAL,ACTIVE,BSSID dev wifi list
```
With `-g` (get-values), fields are `:` separated. **Problem:** SSIDs can contain `:`.

**Caelestia's colon-escape trick (the correct solution):**
```js
const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED"
const line = rawLine.replace(/\\:/g, PLACEHOLDER)
const parts = line.split(":")
const ssid = parts[N].replace(new RegExp(PLACEHOLDER, "g"), ":")
```
nmcli escapes literal colons in values as `\:`. Replace `\:` with a placeholder before splitting, then replace placeholder back after.

#### Deduplication (caelestia)
Keep one entry per SSID: prefer the active network; among duplicates, keep the stronger signal. Key: `"${frequency}:${ssid}:${bssid}"`.

#### Network list structure (Noctalia — clearest UX)
Split into three sections rendered in order:
1. **Connected** — active network, disconnect button
2. **Saved** — known profiles, connect button
3. **Available** — new networks, connect → inline password

#### Connecting
- Saved/open networks: `nmcli connection up id <ssid>` or `nmcli dev wifi connect <ssid>`
- New secured network: `nmcli dev wifi connect <ssid> password <pw>`
- On any auth failure: call `nmcli connection delete <ssid>` before retry (forget-on-failure pattern — both caelestia and DMS). NM writes a partial profile on failed connect; leaving it causes subsequent attempts to fail.

#### Password UI
**Both end-4 and Noctalia confirm: inline expansion inside the network row, not a modal.** The card grows to reveal a `TextInput { echoMode: TextInput.Password }`. Cancel shrinks it back. No dialog, no layer-shell popup.

**Enterprise (802-1x) support (Noctalia):** same inline expansion but adds EAP method ComboBox, phase2 auth, CA cert path, anonymous identity, identity fields — all conditionally visible.

#### Loading state (DMS + Noctalia)
While `connectingTo === ssid`: replace the Connect button with a spinning `sync` icon. `RotationAnimator { running: busy; loops: Infinite; from: 0; to: 360; duration: 1000 }`. The button is `visible: !busy`.

#### List freeze during interaction (DMS + Noctalia)
When a password field is open or a context menu is showing, freeze the model to a snapshot:
```js
property var frozenNetworks: []
property bool menuOpen: false
onMenuOpenChanged: if (menuOpen) frozenNetworks = sortedNetworks
// model: menuOpen ? frozenNetworks : sortedNetworks
```
Prevents the list from reordering under the user's pointer.

#### Card state coloring (Noctalia — most elegant)
Three states:
- **Neutral:** `surface` bg / `on-surface` text
- **Connecting or connected:** `primary` bg / `on-primary` text (accent color fills the card)
- **Error / disconnecting:** `error` bg / `on-error` text

Active border variant (DMS): 2px `primary` border when connected, 1px `surface` border otherwise — less dramatic but works for list rows.

#### Signal-strength icons (caelestia — most complete)
5 tiers × 2 variants (open vs locked) = 10 icons:
```js
function getNetworkIcon(strength, isSecure) {
    const icons = isSecure
        ? ["signal_wifi_0_bar", "network_wifi_1_bar_locked", "network_wifi_2_bar_locked",
           "network_wifi_3_bar_locked", "network_wifi_locked"]
        : ["signal_wifi_0_bar", "network_wifi_1_bar", "network_wifi_2_bar",
           "network_wifi_3_bar", "network_wifi"]
    if (strength >= 80) return icons[4]
    if (strength >= 60) return icons[3]
    if (strength >= 40) return icons[2]
    if (strength >= 20) return icons[1]
    return icons[0]
}
```
(Uses Material Symbols names — adapt to Nerd Font equivalents for our shell.)

---

### 9.3 Audio Sinks — Confirmed Patterns

All three Quickshell repos (caelestia, end-4, Noctalia) use `Quickshell.Services.Pipewire` — not pactl subprocess.

**`PwObjectTracker` is mandatory.** Without it, `sink.audio.volume` won't update reactively. Every repo that uses PipeWire wraps the active sink and source in a tracker:
```qml
PwObjectTracker { objects: sink ? [sink] : [] }
```

**`PwNodeLinkTracker`** exposes `linkGroups` — used to find which application streams are connected to the default sink (needed for per-app volume panel).

**Sink/source lists:**
```qml
readonly property list<PwNode> sinks: Pipewire.nodes.values.filter(n => !n.isStream && n.isSink)
readonly property list<PwNode> sources: Pipewire.nodes.values.filter(n => !n.isStream && n.audio && !n.isSink)
```

**Setting default:**
```qml
function setDefaultSink(node) { Pipewire.preferredDefaultAudioSink = node }
function setDefaultSource(node) { Pipewire.preferredDefaultAudioSource = node }
```

**Device name heuristics (DMS, most complete):**
Priority order: custom user alias → `node.properties["node.description"]` → `node.description` → `node.properties["device.description"]` → pattern-based fallback ("Bluetooth Audio", "Built-in Audio", etc.).

**Device icon heuristics (DMS):**
```js
function sinkIcon(node) {
    const ff = node.properties["device.form-factor"]
    const bus = node.properties["device.bus"]
    if (ff === "headphone" || ff === "headset") return "headset"
    if (bus === "bluetooth") return "headset"
    if (ff === "hifi") return "tv"  // HDMI
    return "speaker"
}
```

**Volume debounce pattern (Noctalia):**
Local `localVolume` property + 100ms Timer before calling `setVolume()`. Guard: `outputVolumeGuard = sliderActive || localVolumeChanging` prevents feedback loop when device changes mid-drag.

---

### 9.4 CC Widget Pattern — CompoundPill (DMS, best for WiFi/BT)

Split a row into two independent hit areas:
- **Left tile** (fixed width, ~48px): icon, toggles the service on/off
- **Right body** (fills remaining): status text, chevron, tapping opens the expansion

```qml
RowLayout {
    // Left tile — toggle
    Rectangle {
        width: 48; height: 48; radius: Appearance.radius.md
        color: service.enabled ? Appearance.colors.accent : Appearance.colors.surface0
        Behavior on color { ColorAnimation { duration: Appearance.anim.fast } }
        Text { anchors.centerIn: parent; text: service.icon() }
        MouseArea { anchors.fill: parent; onClicked: service.toggle() }
    }
    // Right body — expand
    Rectangle {
        Layout.fillWidth: true; height: 48; radius: Appearance.radius.md
        color: expanded ? Appearance.colors.surface1 : Appearance.colors.surface0
        RowLayout {
            anchors { fill: parent; leftMargin: 12; rightMargin: 8 }
            Text { text: service.statusText; Layout.fillWidth: true }
            Text { text: expanded ? "󰅃" : "󰅀" }  // chevron
        }
        MouseArea { anchors.fill: parent; onClicked: expanded = !expanded }
    }
}
```

This pattern gives users a fast toggle (one click on the left) and a details view (one click on the right) without nesting or ambiguity.

---

### 9.5 Collapsible Section Pattern (caelestia — cleanest)

```qml
Item {
    Layout.fillWidth: true
    Layout.preferredHeight: expanded
        ? (contentColumn.implicitHeight + spacing * 2)
        : 0
    clip: true
    Behavior on Layout.preferredHeight { NumberAnimation { duration: Appearance.anim.base; easing.type: Easing.OutCubic } }

    ColumnLayout {
        id: contentColumn
        opacity: expanded ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: Appearance.anim.fast } }
    }
}
```

Key: use `Layout.preferredHeight` (not `height`) for ColumnLayout children — avoids fighting with the layout engine. `clip: true` prevents content from overflowing during animation. Dual animation: height + opacity together feels smoother than height alone.

---

### 9.6 Patterns We Are NOT Adopting (and why)

| Pattern | Source | Reason not adopted |
|---|---|---|
| Multi-pane NavRail CC | Caelestia | Our CC is a single-panel overlay, not a full settings app. NavRail adds complexity we don't need until Sprint 12+ |
| Go daemon IPC | DMS | DMS uses it for network/BT because they target NM via daemon. We talk to nmcli/busctl directly — no daemon needed for our use case |
| Credential token push | DMS | DMS's daemon pushes NM agent credential requests. We initiate connect from QML directly — simpler, no token flow needed |
| Device aliasing + WirePlumber patching | DMS | Power feature, complex restart required. Deferred to post-Sprint 10 |
| Per-app volume panel | end-4 / Noctalia | Deferred — needs PwNodeLinkTracker + stream tracking. Post-Sprint 10 |
| Enterprise WiFi (802-1x) | Noctalia | Full implementation deferred. We ship WPA2-PSK password first |
| Captive portal detection | end-4 | Deferred — needs connectivity level check + browser open. Post-Sprint 9 |
| Drag-to-reorder widget grid | DMS | Post-Sprint 12 — requires full layout engine |
| Adjacent pane preloading | Caelestia | Not applicable until we have a multi-pane CC |

---

## §10 Settings Panel Research — Wave 2 (Dedicated Settings Apps)

*Research date: 2026-05-12. All five shells studied: caelestia, end-4/dots-hyprland, DankMaterialShell, Noctalia, HyDE.*

This section covers dedicated settings panels (as opposed to the quick-settings CC widgets studied in §9). The question: how do mature QML shells build a cohesive, OS-level settings experience?

---

### 10.1 caelestia-dots/shell — CC as Full Settings Panel

caelestia's "Control Center" is simultaneously their quick-settings panel and their full settings app. No separate window.

**Structure:**
```
modules/controlcenter/
  ControlCenter.qml       — GridLayout: NavRail + Panes, session state, wheel-scroll
  NavRail.qml             — vertical icon sidebar, Float Window button
  PaneRegistry.qml        — singleton: list<QtObject> of pane descriptors
  Panes.qml               — ClippingRectangle, y = -activeIndex * height carousel
  WindowFactory.qml       — creates floating copy of any pane
  state/
    BluetoothState.qml, EthernetState.qml, NetworkState.qml, VpnState.qml, LauncherState.qml
  components/
    ConnectedButtonGroup, DeviceDetails, DeviceList, PaneTransition,
    ReadonlySlider, SettingsHeader, SliderInput, SplitPaneLayout,
    SplitPaneWithDetails, WallpaperGrid
  appearance/sections/
    AnimationsSection, BackgroundSection, BorderSection,
    ColorSchemeSection, ColorVariantSection, FontsSection,
    ScalesSection, ThemeModeSection
```

**PaneRegistry.qml** (singleton) — declarative pane manifest:
```qml
pragma Singleton
QtObject {
    readonly property list<QtObject> panes: [
        QtObject { readonly property string id: "network"; label: "network"; icon: "router"; component: "network/NetworkingPane.qml" },
        QtObject { id: "bluetooth"; icon: "settings_bluetooth"; component: "bluetooth/BtPane.qml" },
        QtObject { id: "audio"; icon: "volume_up" },
        QtObject { id: "appearance"; icon: "palette" },
        QtObject { id: "taskbar"; icon: "task_alt" },
        QtObject { id: "notifications"; icon: "notifications" },
        QtObject { id: "launcher"; icon: "apps" },
        QtObject { id: "dashboard" }
    ]
    function getByIndex(index): QtObject
    readonly property int count: panes.length
    readonly property var labels: panes.map(p => p.label)
}
```

**Panes.qml** — vertical carousel via `y` offset:
```qml
ClippingRectangle {
    ColumnLayout {
        y: -root.session.activeIndex * root.height
        Behavior on y { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        Repeater {
            model: PaneRegistry.count
            delegate: Loader {
                width: root.width; height: root.height
                // Smart loading: load active pane + adjacent for instant switching
                active: Math.abs(index - session.activeIndex) <= 1
                source: PaneRegistry.panes[index].component
                asynchronous: true
            }
        }
    }
}
```

**Appearance Pane** — full settings organized as `CollapsibleSection` rows:
- ThemeModeSection: `Colours.setMode("dark"/"light")`
- ColorVariantSection: `M3Variants.list` Repeater with styled radio buttons
- ColorSchemeSection: palette picker from available schemes
- ScalesSection: three `SliderInput` rows (padding 0.5–2×, rounding 0.1–5×, spacing 0.1–2×)
- FontsSection: sans-serif, monospace, Material Symbols — each a filtered system font list
- TransparencySection: enabled toggle + base% + layers% sliders
- BorderSection: `SliderInput` for border rounding, border width
- AnimationsSection: animation duration scale (0.1–5×)
- BackgroundSection: wallpaper enabled, clock position (top/center/bottom + left/center/right)

**SliderInput component** (shared across all panes):
```qml
// Combines slider + text field; supports integer or decimal
// formatValueFunction and parseValueFunction for custom display
// Auto-saves via rootPane.saveConfig() on any change
```

**WallpaperGrid component:**
- `GridView` with `cellWidth = Math.max(200, Math.floor(width / columns)) * columns / columns`
- `CachingImage` with fallback to standard Image
- Checkmark icon on selected, primary-color border highlight
- Gradient filename label at bottom, 1000ms opacity transition

**SplitPaneWithDetails** — master/detail for device panes:
```
RowLayout {
    left pane: fixed min 420px, 40% default ratio
    right pane: Layout.fillWidth = true
    resizable via leftWidthRatio property
}
```

**Key OS-level cohesion factor:** Every appearance setting writes to a shared `Caelestia.Config` / `Tokens` singleton. The shell, bar, CC, and all panes read from the same token system — changing padding scale in settings updates every surface instantly.

---

### 10.2 end-4/dots-hyprland — Standalone QML Settings App

Settings launches as a separate QML application via `qs -p settings.qml`.

**settings.qml top-level:**
```qml
//@ pragma UseQApplication         ← standalone Qt app, not Quickshell overlay
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_SCALE_FACTOR=1

ApplicationWindow {
    // 8 pages with collapsible NavigationRail sidebar
    // Keyboard shortcuts: Ctrl+1…8 to jump to any page
}
```

**8 pages:** Quick, General, Bar, Background, Interface, Services, Advanced, About

**Config.qml** (singleton — the persistence layer):
```qml
pragma Singleton
Singleton {
    property string filePath: Directories.shellConfigPath
    property alias options: configOptionsJsonAdapter  // JsonAdapter
    property bool ready: false
    property int readWriteDelay: 50  // debounce writes
    property bool blockWrites: false

    function setNestedValue(nestedKey, value) {
        // splits "bar.indicators.notifications.showUnreadCount" into path
        // navigates the options object and writes the leaf
    }
}
```

**Persistent.qml** (singleton — UI state, separate from user config):
```qml
pragma Singleton
Singleton {
    property alias states: persistentStatesJsonAdapter
    property string filePath: Directories.state + "/states.json"
}
```

**Page structure — each page follows the same pattern:**
```qml
ContentPage {
    forceWidth: true
    ContentSection {
        icon: "notifications"
        title: Translation.tr("Notifications")
        ConfigSwitch {
            buttonIcon: "counter_2"
            text: Translation.tr("Unread indicator: show count")
            checked: Config.options.bar.indicators.notifications.showUnreadCount
            onCheckedChanged: Config.setNestedValue("bar.indicators.notifications.showUnreadCount", checked)
        }
    }
}
```

**Selected page content:**
- Background: parallax (vertical/horizontal), random wallpaper via external script
- Services: audio settings, AI system prompt + translation locale Process
- Interface: color generation from wallpaper, shell/utilities theming toggle
- Advanced: Cheat sheet super key symbol, distro logo selector

**Widget library** (150+ components in `modules/common/widgets/`):
- Input: `MaterialTextField`, `MaterialTextArea`, `ConfigSwitch`, `ConfigSelectionArray`
- Navigation: `NavigationRail`, `SecondaryTabBar`, `Toolbar`
- Display: `CircularProgress`, `StyledProgressBar`, `MaterialLoadingIndicator`
- Layout: `ContentPage`, `ContentSection`, `ContentSubsection`

**Translation system:** `Translation.tr("key")` — used consistently across all UI text, enabling full i18n.

**Key OS-level cohesion factor:** Config singleton is shared by settings app and shell via same JSON file. Changing a setting in the app = instant effect in the shell (JsonAdapter triggers property bindings immediately on write).

---

### 10.3 DankMaterialShell — Deep Settings with Search

DMS has the most feature-complete settings panel of all studied shells.

**Instantiation:**
```qml
// In FrameWindow.qml (PanelWindow)
LazyLoader {
    id: settingsModalLoader
    active: false
    Component.onCompleted: PopoutService.settingsModalLoader = settingsModalLoader
    onActiveChanged: if (active && item) PopoutService.settingsModal = item
    SettingsModal { ... }
}
```

**SettingsModal.qml** — `FloatingWindow`:
- Min size: 500×400; Default size: 900×900
- Max height: screenHeight − 100
- Header bar (48px): draggable, menu toggle for compact mode, settings icon, window controls
- Split layout: SettingsSidebar (left) + SettingsContent (right, tab Loader)

**SettingsSidebar.qml** — 34 tabs in 10 collapsible categories:
| Category | Tabs |
|---|---|
| Personalization | Wallpaper, Time & Weather, Theme & Colors |
| Keyboard Shortcuts | (standalone tab) |
| Dank Bar | Dank Bar Settings |
| Workspaces & Widgets | Workspaces, Desktop Widgets |
| Dock & Launcher | Dock, Launcher |
| Network | Network (standalone) |
| System | Printers, Locale, Touchpad, Gamma Control |
| Audio | Audio |
| Advanced | Clipboard, Display Config, Gaming, Greeter, Lock Screen, Media Player, OSD, Process List, VPN |
| About | About |

**SettingsContent.qml** — tab switching via `currentIndex` (0–33):
```qml
// Each tab is a Loader — only activates when current, gets focus on activate
Loader { active: currentIndex === 7; onActiveChanged: if (active) Qt.callLater(() => item.forceActiveFocus()) }
```

**PopoutService deep linking** — open settings at any tab from anywhere:
```qml
PopoutService.openSettings()                    // opens at last-used tab
PopoutService.openSettingsWithTab("network")    // by tab name
PopoutService.openSettingsWithTabIndex(7)       // by index
```

**SettingsSearchService** — global settings search:
```qml
// Index: settings_search_index.json with entries: {section, label, category, keywords, icon, description}
// Algorithm: fuzzy match against all fields, max 15 results
// SettingsCard.qml registers with service for highlight-on-match
```

**Settings widget library** (`Modules/Settings/Widgets/`):
```
SettingsToggleRow    — label + icon + DankToggle
SettingsSliderRow    — label + DankSlider (compact)
SettingsSliderCard   — full-width card with label, value display, DankSlider
SettingsDropdownRow  — label + DankDropdown
SettingsButtonGroupRow — label + DankButtonGroup (segmented)
SettingsColorPicker  — label + color swatch → opens PopoutService.colorPickerModal
SettingsDivider      — visual section separator
SettingsCard         — collapsible card, registers with SettingsSearchService
DeviceAliasRow       — custom name input for audio devices
TerminalPickerRow    — dropdown of detected terminal emulators
```

**AudioTab features:**
- Device aliasing: custom display name stored in `AudioService.setDeviceAlias()`
- Visibility toggle: hide specific devices from sink list
- Volume limit: cap per-device max volume

**NetworkTab features:**
- Status overview with backend type + connection state (color-coded)
- Connection preference: Auto / Ethernet / WiFi priority when both connected
- Ethernet: adapter list, expandable details, connect/disconnect
- WiFi: AP list, expandable (SSID, security, signal, IP), password field inline
- VPN: list + connect/disconnect

**WallpaperTab:**
- Modes: Single / Per-Mode (light+dark) / Per-Monitor / Color (solid `#rrggbb`)
- Formats: JPEG, PNG, BMP, GIF, WebP, JXL, AVIF, HEIF, EXR
- Matugen color extraction: generates Material You palette from wallpaper
- "Target" selection: which display to extract from

**Color picker:** `PopoutService.colorPickerModal.selectedColor = "#..."; PopoutService.colorPickerModal.onColorSelectedCallback = fn`

**Plugin system:**
- `PluginService.pluginDirectory` — local scan
- Online browser via DMS registry API, `DMSService.listPlugins()` / `listInstalled()`
- Manifest: `plugin.json` per plugin directory

**Key OS-level cohesion factor:** `SettingsSearchService` makes any setting discoverable from anywhere. `PopoutService.openSettingsWithTab("network")` means CC quick-toggles can deep-link into the full network settings tab. Compact mode sidebar collapses to icon-only rail (like GNOME Settings on narrow screens).

---

### 10.4 Noctalia — Flexible Panel Modes + Connections Depth

**Window:**
```qml
// SettingsPanelWindow.qml
FloatingWindow {
    title: "Noctalia"
    minimumSize: Qt.size(840 * Style.uiScaleRatio, 910 * Style.uiScaleRatio)
    Component.onCompleted: SettingsPanelService.register(root)
}

// SettingsPanel.qml
SmartPanel {
    // settingsPanelMode: "centered" | "attached" | "window"
    // In window mode: FloatingWindow handles display
    // In centered/attached: SmartPanel positions itself relative to bar
}
```

**22 tabs** (all in `Modules/Panels/Settings/Tabs/`):
About, Audio, Bar, ColorScheme, Connections, ControlCenter, Display, Dock, General, Hooks, Idle, Launcher, LockScreen, Notifications, Osd, Plugins, Region, SessionMenu, SystemMonitor, UserInterface, Wallpaper

**Search:**
```
Fuzzy matching across all settings items
subTabName matches boosted 1.5× vs other fields
Collapsible sidebar with search input at top
Results highlight matched settings cards
```

**ConnectionsTab — depth of BT implementation:**
```qml
// ConnectionsTab.qml: WiFi + Bluetooth via NTabBar
NTabBar {
    NTabButton { text: I18n.tr("common.wifi") }
    NTabButton { text: I18n.tr("common.bluetooth") }
}
NTabView { currentIndex: tabBar.currentIndex; WifiSubTab {}; BluetoothSubTab {} }
```

**BluetoothSubTab — most complete BT panel found:**
```
Three device categories:
  1. Connected devices
  2. Paired/trusted devices (disconnected)
  3. Available devices (for pairing)

Per-device info:
  - Battery level
  - Signal strength
  - Connection status

Actions per category:
  - Connected: Disconnect button
  - Paired: Connect button, Unpair option
  - Available: Pair button

State management:
  - Scanning managed based on panel visibility (debounced)
  - Discoverability toggle
```

**ColorSchemeTab — theming depth:**
- Dark mode toggle → `Settings.data.colorSchemes.darkMode`
- Schedule: off / manual (pick sunrise+sunset time) / location-based (auto)
- Generate from wallpaper: per-monitor wallpaper selector → color extraction
- Time picker: `ListModel` with 48 entries (every 30 min from 00:00 to 23:30)
- Schema downloader: `SchemeDownloader.qml` for fetching color schemes from network

**DisplayTab:** Brightness sub-tab + Night Light sub-tab

**GeneralTab:** Basics sub-tab + Keybinds sub-tab

**I18n:** `I18n.tr("key")` used everywhere — string key → translated string via locale files

**Key OS-level cohesion factor:** Three-mode panel (`centered`/`attached`/`window`) adapts to user workflow. Settings panel in "attached" mode slides out from the bar like a second CC layer — feels integrated, not like a separate app.

---

### 10.5 HyDE — OS-Level Theming via Script Templates (Not QML)

HyDE is different: no QML settings app. Theming achieved through shell scripts and template substitution.

**wallbash color pipeline:**
```sh
wallbash.sh <image>
  → ImageMagick extracts dominant colors
  → Applies color curve (default / vibrant / pastel / mono / custom)
  → Outputs: ~/.cache/hyde/<hash>.dcol (shell variable declarations)

# .dcol file format:
export wallbash_pry1="#1e1e2e"
export wallbash_txt1="#cdd6f4"
export wallbash_1xa9="#b4befe"
# ... 50+ color variables
```

**Template propagation:** Each app has a `.dcol` template file in `~/.config/hyde/wallbash/`:
```
Wall-Dcol/
  gtk/gtk3.dcol    → updates GTK3 settings.ini
  gtk/gtk4.dcol    → creates GTK4 symlink
  hypr.dcol        → updates hyprland.conf colors
  kitty.dcol       → writes ~/.config/kitty/theme.conf
  rofi.dcol        → writes ~/.config/rofi/theme.rasi
  waybar.dcol      → writes waybar/style.css variables
  kvantum/         → updates Qt Kvantum theme
```

**Template format** (kitty as example):
```
foreground #<wallbash_txt1>
background #<wallbash_pry1>
color0     #<wallbash_pry2>
...
```

**themeswitch.sh** — applies a named theme:
- Updates: qt5ct.conf, qt6ct.conf, kdeglobals, GTK3 settings.ini, GTK4 symlink, Flatpak env vars
- Calls: `hyprctl` for window border colors, `hyprctl reload` for full refresh
- Triggers: waybar CSS recalculation (separate script)

**UI for theme selection:** Rofi-based menu (NOT QML) — `themeselect.sh` generates a Rofi grid of theme thumbnails, calls themeswitch.sh on selection.

**Key OS-level cohesion factor:** Template substitution touches every app simultaneously. The hash-based cache (`sha1sum` of wallpaper) means color generation runs once per image, then cached forever. This is the most complete "everything matches the wallpaper" system found — but it requires bash expertise and external tools (ImageMagick, swww, Rofi).

**Why we're not adopting HyDE's approach:** It requires launching external apps (Rofi) for settings and depends on a complex bash pipeline. Our goal is native QML. We can adopt the *idea* (wallpaper → color extraction → apply everywhere) but implement it via a QML-first theme system later (Sprint 12+).

---

### 10.6 Cross-Repo Synthesis — What Makes Settings Feel "OS-Level"

These patterns appear across all shells that feel cohesive:

**1. Single config singleton with JSON persistence**
All three QML shells (caelestia, end-4, DMS) use a singleton that reads/writes a JSON file. Writes are debounced (DMS 50ms delay, caelestia saves on user action). Any property change in settings immediately propagates to shell via property binding.

**2. NavRail navigation (not tabs)**
Icon sidebar with labeled items beats horizontal tabs at this pane count (8–34 items). Rail supports collapsible categories (DMS), wheel-scroll navigation (caelestia), keyboard shortcuts (end-4).

**3. CollapsibleSection as the universal atom**
Every pane uses collapsible sections with animated height changes. Prevents overwhelming the user with all settings visible at once. Caelestia's implementation is cleanest (`Layout.preferredHeight` + `clip: true` + dual animation).

**4. Deep linking from CC to settings**
DMS: `PopoutService.openSettingsWithTab("network")`. This is what makes a quick-toggle feel complete: tapping the WiFi quick-toggle opens WiFi, tapping "more options" deep-links to the full network settings pane.

**5. Settings-specific widget library**
All shells define reusable settings widgets beyond what Qt controls provide:
- `ToggleRow` — icon + label + switch in a styled row
- `SliderRow` — icon + label + slider + value display
- `DropdownRow` — icon + label + select
- `ButtonGroupRow` — icon + label + segmented buttons
- `ColorPickerRow` — icon + label + color swatch → modal picker

**6. Search across settings** (DMS, Noctalia)
`SettingsSearchService` with JSON index enables "find anything" UX. Requires each settings card to register itself with keywords. Noctalia boosts subTabName matches to prioritize direct navigation.

**7. Three display modes** (Noctalia)
`centered` (modal), `attached` (slides from bar), `window` (resizable float). Attached mode is what makes settings feel integrated rather than external.

**8. State vs. config separation**
end-4 has two separate singletons: `Config.qml` (user preferences) and `Persistent.qml` (UI state like last-open tab, collapsed sections). DMS similarly separates `SettingsData` from ephemeral open/close state. Our future settings app should follow this.

**9. Template-based app theming** (HyDE approach, adapted)
The idea: one color extraction run → all apps match. Our QML-native adaptation: future `Theme.qml` singleton exports color tokens, all our QML reads from it, external apps get updated via a write to their config files.

---

### 10.7 Implementation Notes for Archeotech Settings

Research-confirmed patterns for each layer — see `ROADMAP.md` for current sprint specs and numbering.

**Config persistence:** `JsonAdapter` + 50ms debounce timer is the universal pattern (end-4, DMS, caelestia all use it). Two singletons: `Config.qml` for user prefs, `Persistent.qml` for UI state (last-open pane, collapsed sections).

**NavRail navigation:** Icon sidebar with labeled items beats horizontal tabs at 6+ panes. Support collapsible categories and wheel-scroll navigation.

**Collapsible sections:** `Layout.preferredHeight` + `clip: true` + dual height+opacity animation (caelestia pattern — cleanest found).

**Deep linking:** `IpcHandler { target: "settings" }` with `openPane(id)` method. CC quick-toggles call `openPane("connections")` — this is what makes quick settings feel complete rather than dead-end.

**Search (later sprint):** DMS `SettingsSearchService` pattern — JSON index, fuzzy match, max 15 results, subTabName matches boosted 1.5×.

---

## 11. QML Patterns & Design Principles

### 11.1 Shell Design Principles

Rules that govern all Quickshell component decisions:

1. **Everything animates.** No instant state changes. Every visibility toggle, color change, and panel transition uses a defined animation token. No exceptions without a documented reason.

2. **Popups connect to their trigger.** A popup drops down from the exact bar element that triggered it — anchored to the icon's x-position, slides down from the bar's bottom edge. No floating dialogs that appear from nowhere.

3. **Catppuccin Macchiato is the law.** All colors come from the palette. No hardcoded hex values outside the theme token file. Future theme switching swaps the token file, not individual components.

4. **One action per surface.** The bar is for glanceable status. CC is for adjustment. NC is for history. Avoid duplicating controls across surfaces — if volume is in CC, the bar icon scrolls and mutes only.

5. **Density is a dial, not a default.** Dense information is acceptable in the bar. Panels use breathing room. Rarely-used controls collapse by default.

6. **Native QML first.** No third-party apps embedded where a native QML component is feasible within a sprint. External tools (`bluetoothctl`, `pactl`) are wrapped via process/service interfaces, not launched as visible windows.

7. **Compositor features are compositor features.** MangoWC overview, window snapping, and tiling are not replicated in shell code. The shell augments, never fights, the compositor.

---

### 11.2 Animation Token System

All durations and easings defined as shared tokens — no component hardcodes a raw duration.

| Token | Duration | Easing | Use cases |
|-------|----------|--------|-----------|
| `Anim.fast` | 100ms | OutCubic | Hover color, icon tint, dot color |
| `Anim.base` | 200ms | OutCubic | Most transitions — opacity, small position shifts |
| `Anim.slow` | 300ms | OutQuart | Panel slides (CC open/close), OSD appear |
| `Anim.spring` | 400ms | OutBack overshoot 1.2 | Tag dot size change, pop-in effects |
| `Anim.entrance` | 200ms | OutCubic | scale `0.92 → 1.0` + opacity `0 → 1`, simultaneous |
| `Anim.exit` | 150ms | OutCubic | opacity `1 → 0` only — no scale on exit, intentionally faster |

**Rules:**
- Panels (CC, NC, launcher, settings) use `Anim.slow` for the slide, `Anim.entrance`/`Anim.exit` for inner content
- Toasts use `Anim.entrance` on appear, `Anim.exit` on dismiss
- Tag dots use `Anim.spring` for size, `Anim.fast` for color
- OSD uses `Anim.slow` for appear, `Anim.exit` for fade out
- Never animate `width`/`height` directly on text — animate a container instead

---

### 11.3 MPRIS Reactive Detection

**caelestia approach** (declarative binding):
```qml
readonly property list<MprisPlayer> list: Mpris.players.values
readonly property MprisPlayer active: props.manualActive ?? list.find(p => ...) ?? list[0] ?? null
```
`Mpris.players.values` typed as `list<MprisPlayer>` — reactive because it is a list property binding. No explicit change handler needed.

**Noctalia approach** (imperative with fallback):
```qml
Connections {
    target: Mpris.players
    function onValuesChanged() { updateCurrentPlayer() }
}
```
`Mpris.players` is an ObjectModel that emits `valuesChanged` when players are added or removed. A `playerStateMonitor` Timer polls every 2s as a fallback.

---

### 11.4 Panel Slide Animations

**caelestia — single `offsetScale` property:**
```qml
property real offsetScale: 1
anchors.rightMargin: (-implicitWidth - 5) * offsetScale
opacity: 1 - offsetScale
Behavior on offsetScale { Anim { type: Anim.DefaultSpatial } }
```
One property drives both position and opacity simultaneously. Value 0 = fully visible, 1 = fully hidden.

**Noctalia — opacity fade only:**
```qml
opacity: 0
Component.onCompleted: { opacity = 1 }
Behavior on opacity { NumberAnimation { duration: Style.animationNormal; easing.type: Easing.OutCubic } }
```
Layer shell window is always present; entrance is a pure opacity fade. No x/y translation needed.

---

### 11.5 Key Architectural Patterns

| Topic | Pattern | Notes |
|-------|---------|-------|
| Window visibility | Overlay window always present; show/hide via opacity or transform | Avoids window geometry timing issues from toggling `visible` |
| Slide axis | caelestia uses `anchors.rightMargin` instead of `x` | Anchors recalculate automatically on window resize |
| Width reference | Neither uses `parent.width` directly | Use anchors or implicit sizing instead |
| Collapsible sections | `Layout.preferredHeight` (not `height`) + `clip: true` + dual height+opacity animation | Avoids fighting ColumnLayout engine |
| Config persistence | `pragma Singleton` + `FileView` (`JsonAdapter`) + 50ms debounce timer | All three QML shells use this exact pattern |
| State vs config | Two separate singletons: `Config.qml` (user prefs) + `Persistent.qml` (UI state) | end-4 and DMS both separate these |
| Deep linking | `IpcHandler` with named targets + `openPane(id)` | Enables CC quick-toggles to open matching settings pane |

---

## 12. Widget & Bar Systems — Cross-Repo Deep Dive

*Research date: 2026-05-21. Repos inspected: caelestia-dots/shell, end-4/dots-hyprland, Noctalia, DankMaterialShell, AMBXST, HyprPanel (AGS — cross-framework reference).*

This section covers the full widget/bar module systems across all reference repos. Primary purpose: inform Sprint 16 (Module Builder) implementation. Cross-reference this section before building any new bar widget or panel type.

---

### 12.1 caelestia-dots/shell — Config-Driven Bar (THE reference pattern)

**Research date:** 2026-05-21 (source-inspected)

caelestia has the cleanest config-driven bar architecture found across all repos. This is the pattern to steal for Sprint 16.

**DelegateChooser pattern** — bar layout is a pure data model, no hardcoded widget placement:
```qml
// Bar.qml
Repeater {
    model: Config.bar.entries  // array of { id: "clock", enabled: true, ...props }
    DelegateChooser {
        role: "id"
        DelegateChoice { roleValue: "clock";       WrappedLoader { source: "Clock.qml" } }
        DelegateChoice { roleValue: "workspaces";  WrappedLoader { source: "Workspaces.qml" } }
        DelegateChoice { roleValue: "activewnd";   WrappedLoader { source: "ActiveWindow.qml" } }
        DelegateChoice { roleValue: "tray";        WrappedLoader { source: "Tray.qml" } }
        DelegateChoice { roleValue: "statusicons"; WrappedLoader { source: "StatusIcons.qml" } }
        DelegateChoice { roleValue: "power";       WrappedLoader { source: "Power.qml" } }
        DelegateChoice { roleValue: "osicon";      WrappedLoader { source: "OsIcon.qml" } }
    }
}
```

**WrappedLoader** — each widget is async-loaded with adaptive margins:
- Loads component asynchronously (`asynchronous: true`)
- Applies conditional left/right margins on first/last elements
- Centers content horizontally within its slot

**Bar widget types (8 built-in):**
| Widget | Description |
|---|---|
| ActiveWindow | Focused window title + app icon; auto-hides in fullscreen |
| Clock | Time display; auto-hides in fullscreen |
| OsIcon | Operating system logo/icon |
| Power | Power menu trigger |
| StatusIcons | Grouped system status badges; auto-hides in fullscreen |
| Tray | System tray, compact/expanded modes; auto-hides in fullscreen |
| TrayItem | Individual tray item renderer |
| Workspaces | Workspace switcher with ActiveIndicator, OccupiedBg, SpecialWorkspaces sub-components |

**Popout module system** — 9 popout panels hanging off bar widgets:
```
modules/bar/popouts/
  ActiveWindow.qml
  Audio.qml
  Battery.qml
  Bluetooth.qml
  Network.qml
  WirelessPassword.qml
  LockStatus.qml
  TrayMenu.qml
  kblayout/          ← keyboard layout sub-popout
```
Each popout follows `Wrapper.qml → ClipWrapper.qml → Content.qml` chain. `PopoutState.qml` manages open/close state per popout. This clean separation means popouts can be swapped independently of the bar widget that triggers them.

**Key implication for Sprint 16:** `Config.bar.entries` is an array in JSON. Reordering or adding widgets = editing the JSON array. The DelegateChooser maps `id` → QML file at runtime. This is exactly the architecture our `DrawerConfig.json` + `ModuleRegistry` should use for the bar zone configurator.

---

### 12.2 Noctalia — Most Complete Bar Widget Catalog

**Research date:** 2026-05-21 (source-inspected)

Noctalia has 30 bar widgets — the largest catalog found across all Quickshell repos. Use this as the reference for what widget types to support.

**Full widget catalog (30 types):**
| Widget | Notes |
|---|---|
| ActiveWindow | Focused app title |
| AudioVisualizer | Canvas-rendered spectrum — 3 modes: linear, mirrored, wave |
| Battery | Percentage + charging state |
| Bluetooth | Toggle + connection status |
| Brightness | Screen brightness indicator |
| Clock | Configurable 12/24h, date formats |
| ControlCenter | Capsule button → CC panel; per-instance config |
| CustomButton | State machine marquee text, shell command execution, JSON output parsing, IPC registration |
| DarkMode | Dark/light mode toggle |
| KeepAwake | Idle inhibitor toggle |
| KeyboardLayout | Current kb layout, click to cycle |
| Launcher | Opens app launcher panel |
| LockKeys | Caps/Num lock indicator |
| MediaMini | MPRIS mini player: reactive property cascading, context menu from player capabilities |
| Microphone | Mic mute toggle + level |
| Network | WiFi/ethernet status |
| NightLight | Night light toggle |
| NoctaliaPerformance | CPU + RAM sparkline bars |
| NotificationHistory | Unread badge → opens NC |
| PowerProfile | Power/battery profile switcher |
| SessionMenu | Power/session actions trigger |
| Settings | Opens settings panel |
| Spacer | Flexible/fixed space between widgets |
| SystemMonitor | Real-time CPU/mem/temp, 1000ms poll, color-coded states, tooltip |
| Taskbar | Running app icons |
| Tray | System tray |
| VPN | VPN connection status |
| Volume | Audio volume slider pill |
| WallpaperSelector | Wallpaper picker trigger |
| Workspace | Dual modes: pill (2.2× scale for active) OR grouped grid with app icon flow + burst animation on switch |

**BarPill pattern** — every widget is wrapped in a capsule container:
```qml
// BarPill.qml → loads BarPillHorizontal.qml or BarPillVertical.qml
property bool barIsVertical: Settings.data.bar.vertical

// BarPillHorizontal.qml
Rectangle {
    width: contentLoader.implicitWidth + padding * 2
    height: parent.height
    radius: Style.barPillRadius
    color: hovered ? Style.colors.surface1 : "transparent"

    Loader { id: contentLoader; sourceComponent: widgetComponent }

    // Signals exposed to widget: clicked, rightClicked, middleClicked, wheel
    // Methods: show(), hide(), showDelayed(ms)
}
```

**BarWidgetLoader.qml** — dynamic instantiation with service registration:
```qml
// Handles onCompleted/onDestruction hooks for resource management
// AudioVisualizer registers with SpectrumService on load, deregisters on destroy
// CustomButton registers IPC handler on load
```

**Notable widget implementation details:**

*AudioVisualizer* — `Canvas` item, `requestPaint()` on every spectrum update from `SpectrumService`. Three render modes with configurable colors, bar count, spacing. Rounded caps via `ctx.arc()`.

*Workspace (grouped mode)* — when a workspace has >1 window, shows a mini icon grid instead of a plain pill. Burst animation on workspace switch: scale 1.0 → 1.3 → 1.0 with spring easing.

*CustomButton* — accepts a `command` string, runs it via `Process`, parses JSON stdout to update its display text. Built-in marquee for long text: phase-based state machine (wait → scroll left → wait → scroll right → repeat).

*MediaMini* — reads MPRIS player metadata, falls back through: user-set override → player-reported metadata → sensible defaults. Context menu generated dynamically from which capabilities the player reports (canPlay, canNext, canPrev, canSeek, canLoop, canShuffle).

*TrayMenu* — `StackView`-based hierarchical menus. Submenu push uses `NoAnim` transition (parent StackView handles the animation externally). Back navigation via top-left chevron.

**Bar layout architecture:**
Three-zone RowLayout (swapped to ColumnLayout for vertical bars). `Settings.getBarWidgetsForScreen(screen?.name)` returns per-screen widget arrays. `BarExclusionZone.qml` prevents window overlap with the bar.

---

### 12.3 end-4/dots-hyprland — Bar Widgets + Panel Families

**Research date:** 2026-05-21 (source-inspected)

**Bar widget types (13):**
| Widget | Notes |
|---|---|
| ActiveWindow | Window title + app icon |
| CircleUtilButton | Small circular button, executes a shell command |
| ClockWidget | 12/24h configurable |
| BatteryIndicator | Color-coded percentage + charging state |
| Media | MPRIS controls + metadata |
| Resource | CPU/mem/disk/temp mini gauges |
| Workspaces | Pill indicators |
| HyprlandXkbIndicator | Keyboard layout |
| LeftSidebarButton | Toggle for left sidebar |
| NotificationUnreadCount | Unread badge |
| SysTray | Compact/expanded modes |
| WeatherBar | Temperature + conditions |
| UtilButtons | Configurable icon buttons |

**BarGroup.qml** — widget grouping container: background rect + padding + corner radius. Standardizes appearance of widget clusters. Widgets placed inside `BarGroup` form a visually cohesive pill.

**Composition approach:** Hardcoded in `BarContent.qml` — no widget registry. However:
- `Config.options` controls which widgets render (`excludedScreens`, `autoHide`, `persistent`)
- `useShortenedForm` property hides lower-priority indicators on narrow screens

**Auto-hide bar pattern:**
```qml
// Bar.qml
MouseArea {
    hoverEnabled: true
    onEntered: barReveal.stop(); bar.anchors.topMargin = 0
    onExited: barReveal.start()
}
NumberAnimation {
    id: barReveal
    target: bar
    property: "anchors.topMargin"
    to: -(bar.height + 4)
    duration: 300; easing.type: Easing.OutCubic
}
```
Simple and effective. The bar anchors to topMargin 0 (visible) or negative (hidden off-screen). No separate surface needed.

**Panel families system** — two complete alternate bar designs:
- `modules/ii/bar/` — primary design
- `modules/waffle/bar/` — alternate design
Switchable via IPC: `qs ipc call bar setFamily waffle`. Each family is a complete self-contained implementation. This is end-4's answer to "multiple bar layouts" — whole-family swap rather than per-widget reconfiguration.

**Settings-driven per-screen config:**
```qml
// Config.options.bar.excludedScreens: ["DP-1"]  → bar not shown on that screen
// Config.options.bar.autoHide: true              → uses the auto-hide animation
```

---

### 12.4 DankMaterialShell — DankBar (30 widgets) + Desktop Layer

**Research date:** 2026-05-21 (source-inspected from previous session)

**DankBar widget types (30):**
AppsDock, AudioVisualization, Battery, CapsLockIndicator, ClipboardButton, Clock, ColorPicker, ControlCenterButton, CpuMonitor, CpuTemperature, DWLLayout, DiskUsage, FocusedApp, GpuTemperature, IdleInhibitor, KeyboardLayoutName, LauncherButton, Media, NetworkMonitor, NotepadButton, NotificationCenterButton, PowerMenuButton, PrivacyIndicator, RamMonitor, RunningApps, SystemTrayBar, SystemUpdate, VPN, Weather, WorkspaceSwitcher

**Three-zone layout:** Left / Center / Right as separate `ScriptModel` instances. Per-zone widget arrays configured in settings JSON.

**Cross-compositor support:** `triggerControlCenterOnFocusedScreen()` dispatches to active compositor backend (Hyprland, Niri, Sway, Scroll, Miracle, DWL). DankBar is one of the few bars designed for multi-compositor from day one.

**Desktop widget layer:**
- Two built-in widgets: Desktop Clock + System Monitor
- Plugin system: additional widgets via `PluginService.pluginDirectory`
- Plugin manifest: `plugin.json` per plugin directory
- Widgets have `x`, `y`, `scale` + grid snapping + boundary clamping
- Config per-monitor: each monitor has its own widget positions in settings

**Panel animation system** — height-based, NOT slide-from-edge:
```qml
// ControlCenterPopout
property real targetPopupHeight  // computed from content implicitHeight + screen constraints
NumberAnimation {
    target: popup; property: "height"; to: targetPopupHeight
    duration: Theme.variantPopoutEnterDuration
    easing: Theme.variantPopoutEnterCurve  // custom Bézier per theme variant
}
```
`collapseAll()` called before closing. Height updates queued via `Qt.callLater()` to batch recalculations. Enter vs exit curves differ — enter is slower (content materializing) than exit (fast dismiss).

---

### 12.5 AMBXST — UnifiedShellPanel + Reveal System

**Research date:** 2026-05-21 (source-inspected from previous session)

**Architecture:** One `UnifiedShellPanel` root item anchored fullscreen with transparent background. All shell surfaces (Bar, Dock, Notch, Frame, Corners) are children with z-index ordering:
```
ScreenFrameContent  z:1
BarContent          z:2
DockContent         z:3
NotchContent        z:4
AssistantSidebar    (dynamic margins)
```

**Reveal system** — visibility driven by boolean properties, not hover zones:
```qml
property bool barReveal:   barEnabled   && barContent.reveal
property bool dockReveal:  dockEnabled  && dockContent.reveal
property bool notchReveal: notchContent.reveal
```
Each content component manages its own `.reveal` internally, based on focus state and fullscreen detection.

**NOT edge-hover based** — screen corners (`ScreenCorners.qml`) are decorative rounded overlays that hide when a fullscreen app is active. Edge interactions are NOT triggered by mouse proximity to screen edges. This is a key distinction from caelestia's `Interactions.qml`.

**Input management:**
- Full-screen `MouseArea` backdrop detects clicks outside modules to dismiss popups
- `FocusGrab` + `FocusGrabManager` coordinate popup focus state
- Switches between `WlrKeyboardFocus.Exclusive` (when text input needed) and `None` (compositor input pass-through)

**Widget module subdirs:** config, dashboard, defaultview, launcher, overview, powermenu, presets, tools. No detailed widget registry found — modules are self-contained QML components.

---

### 12.6 HyprPanel (AGS/TypeScript) — Cross-Framework Widget Reference

**Research date:** 2026-05-21 (source-inspected)
**Framework:** AGS (Aylur's GTK Shell) / Astal / TypeScript / GTK3. Not Quickshell — reference only for widget type catalog and patterns.

**Configuration model:**
```json
// settings.json
{
  "bar": {
    "layouts": {
      "0": {
        "left":   ["dashboard", "workspaces", "windowtitle"],
        "middle": ["media"],
        "right":  ["volume", "network", "bluetooth", "battery", "systray", "clock"]
      }
    }
  }
}
```
Per-screen layouts keyed by monitor index. Most config-driven bar system found — every widget slot is user-editable JSON.

**ListModel sync pattern** — preserves widget delegates on config change:
```typescript
// syncWidgetModel() only adds/removes widgets that changed
// Existing widget instances are reused, not destroyed+recreated
// Prevents jarring animation reset when user saves settings
```
This pattern is critical for a responsive Module Builder — live preview of layout changes without full reload.

**Widget catalog:**
Bar widgets: Calendar/Clock, Media controls, Quick toggles (WiFi, BT, Brightness), Notifications badge, System monitors, Workspace switcher, Window title, Dashboard trigger, Volume, Battery, SysTray, Hyprsunset (night light), Hypridle inhibitor, Power menu.

**Hot corners:** Left edge of leftmost bar widget triggers first widget's popout. Not a separate interaction zone — emerges from widget positioning.

**Per-screen assignment:** `Settings.getBarWidgetsForScreen(screen?.name)` — each monitor can have a completely different bar layout.

---

### 12.7 Cross-Repo Synthesis — Module Builder Design Implications

These patterns appear across multiple repos and should directly inform Sprint 15 (DrawerSurface) and Sprint 16 (Module Builder):

#### The config-driven bar: caelestia DelegateChooser is THE pattern

caelestia's `DelegateChooser` + `Config.bar.entries` is the cleanest implementation found. Steal it directly:

```qml
// Our DrawerConfig.json:
{ "bar": { "left": ["osicon", "workspaces"], "center": ["clock"], "right": ["media", "cc-button", "tray"] } }

// Our Bar.qml:
Repeater {
    model: DrawerConfig.bar.right  // just a JSON array of widget ids
    DelegateChooser {
        role: "modelData"
        DelegateChoice { roleValue: "clock";     BarPill { ClockWidget {} } }
        DelegateChoice { roleValue: "media";     BarPill { MediaMiniWidget {} } }
        DelegateChoice { roleValue: "cc-button"; BarPill { CCButton {} } }
        // new community widget: add one DelegateChoice, drop a module.json
    }
}
```

Adding a new community widget = one new `DelegateChoice` + a `module.json`. Zero changes to existing code.

#### BarPill wrapper: Noctalia's is the most complete

Noctalia's `BarPill` → `BarPillHorizontal`/`BarPillVertical` chain handles orientation switching cleanly. Our `BarPill.qml` should expose:
- `signal clicked`, `rightClicked`, `middleClicked`, `wheel(delta)`
- `method show()`, `hide()`, `showDelayed(ms)`
- `property bool barIsVertical` — swaps RowLayout to ColumnLayout

#### Desktop widget layer: Noctalia DraggableDesktopWidget

Noctalia's implementation is the reference for Sprint 16's desktop widget layer:
- `MouseArea { enabled: editMode }` — drag only in edit mode
- Grid snap: `Math.round(coord / gridSize) * gridSize`
- Persist: `updateWidgetData()` writes x/y to config JSON on release
- Z-raise: `raiseToTop()` while dragging, restore on drop
- Boundary clamp: 75% off-screen tolerance before hard clamp

#### ListModel sync: HyprPanel's preserve-delegates pattern

When the Module Builder writes a new `DrawerConfig.json`, the bar should diff the old vs new widget lists and only add/remove changed items — not destroy and recreate all instances. HyprPanel's `syncWidgetModel()` is the reference.

#### Widget catalog priority for Sprint 16 baseline

Based on frequency across repos (Noctalia 30, DMS 30, end-4 13, caelestia 8, HyprPanel ~15), these widget types appear in every shell and should be our Sprint 16 baseline:

| Widget | Frequency | Priority |
|---|---|---|
| Clock | 5/5 | P0 — already built |
| Workspaces | 5/5 | P0 — already built |
| SystemTray | 5/5 | P0 — already built |
| Media (MPRIS) | 5/5 | P0 — already built |
| Battery | 5/5 | P0 — already built |
| Network | 5/5 | P0 — already built |
| Volume | 5/5 | P0 — already built |
| ActiveWindow | 5/5 | P0 — already built |
| Notifications badge | 4/5 | P1 |
| Bluetooth | 4/5 | P1 — already in CC, needs bar widget |
| Keyboard layout | 4/5 | P1 |
| CPU/RAM monitor | 4/5 | P1 |
| Launcher button | 4/5 | P0 — already built |
| AudioVisualizer | 2/5 | P2 |
| Spacer | 2/5 | P1 — trivial to add |
| Weather | 3/5 | P2 |
| ColorPicker | 2/5 | P2 |
| Clipboard | 2/5 | P2 |
| Idle inhibitor | 3/5 | P1 |
| VPN | 3/5 | P1 — already in CC, needs bar widget |
| Power profile | 2/5 | P2 |
| Brightness | 3/5 | P1 |

P0 = must exist at Sprint 16 launch (most already exist from earlier sprints). P1 = second wave, within Sprint 16. P2 = community contribution targets.

#### Panel animation patterns: height vs slide

| Repo | Panel open animation | Notes |
|---|---|---|
| caelestia | `offsetScale` — single property drives position + opacity | Slide from edge, one Behavior |
| end-4 | Opacity fade only | No position change, simplest |
| Noctalia | Cubic ease on height + opacity | Works for expand-in-place panels |
| DMS | Height-based + custom Bézier per theme | Most customizable, most complex |
| AMBXST | Reveal boolean + internal animation | Unified surface handles it |

**For Archeotech DrawerSurface:** use caelestia's `offsetScale` for edge-panels (CC, NC) and Noctalia's height+opacity for panels that expand from the bar (dashboard, launcher). Both can be implemented as `Behavior on offsetScale` and `Behavior on Layout.preferredHeight` respectively — no special animation engine needed.

---

## 13. Information Architecture — Grouping, Icons, Quick vs. Deep

*Research date: 2026-05-21. Repos inspected: caelestia-dots/shell, Noctalia, end-4/dots-hyprland, DankMaterialShell. Answers the question: what lives where, how is it grouped, what icons/visuals are used.*

---

### 13.1 The Universal 3-Tier Rule

Every mature shell studied uses a strict three-tier information architecture. The same piece of information never lives at two tiers.

| Tier | Surface | Information density | Interaction | Max items |
|---|---|---|---|---|
| **Tier 1 — Glance** | Bar | Icon + state badge only. No labels. | Scroll = adjust, click = toggle/open CC | 8–12 icons |
| **Tier 2 — Quick** | CC / Drawer panel | Icon + label + status text + toggle. One-tap action. Expand for context. | Tap/click. Right-click (Noctalia) = quick toggle | 6–8 cards |
| **Tier 3 — Deep** | Settings panes | Sliders, device lists, schedules, per-item config. Full descriptions. | Navigate, configure, save | Unlimited (scrollable) |

**Decision rule for placement:** "Can a user fix this in one tap?" → Tier 2. "Does this require choices?" → Tier 3. "Is this purely informational?" → Tier 1.

---

### 13.2 CC Grouping Patterns

**caelestia — NavRail + split pane (8 panes):**
8 distinct domains, each a full pane: Network, Bluetooth, Audio, Appearance, Taskbar, Notifications, Launcher, Dashboard. The CC *is* the settings app. Navigation via vertical icon sidebar. Active pane loads left panel (quick controls, 40% width) + right panel (full detail, 60% width). Deep = right side of the same surface.

**Noctalia — Card stack (6–8 cards, ~60–260px each):**
Cards arranged vertically in a ColumnLayout. Not grouped by domain categories — grouped by interaction frequency (most-used at top). Card heights vary by content density: small toggles (52–60px), audio slider (60px), weather widget (210px conditional), media player (260px). Conditional visibility: weather card only renders if enabled in settings. Cards that are disabled don't consume layout space (`implicitWidth/Height = 0`).

Noctalia's key UX insight — **dual-click pattern:**
- **Left-click** on a CC widget → opens the full panel for that domain (deep)
- **Right-click** → immediate toggle, no navigation

This is the cleanest quick/deep separation found. A single widget serves both tiers without separate affordances.

**DMS — Quick toggles + PopoutService deep-link:**
CC is a flat row of CompoundPill toggles. Each pill has a small "⋯" or chevron that calls `PopoutService.openSettingsWithTab("network")`, jumping directly to the corresponding settings tab. The pill itself handles the quick action; the deep-link handles everything else.

**end-4 — Physically separated concerns:**
No CC in the traditional sense. Bar handles all system status + quick toggles. A separate "sidebar" handles productivity tools (AI, translation) — not system settings. This is the most radical approach: the sidebar is not a settings panel at all.

---

### 13.3 What Should Live in Each Tier — Concrete Mapping

Based on cross-repo analysis, here is the canonical assignment for common shell features:

| Feature | Bar (Tier 1) | CC (Tier 2) | Settings (Tier 3) |
|---|---|---|---|
| WiFi | Status icon + SSID | Toggle + current network name + expand → scan list | Known networks, forget, priority, enterprise |
| Bluetooth | Status icon | Toggle + connected device name + expand → device list | Paired devices, discovery, forget |
| Volume | Scroll to adjust, icon = mute | Slider + source selector | Per-app volume, device aliasing |
| Brightness | Scroll to adjust (optional) | Slider | Auto-brightness schedule |
| Battery | % + charging icon | Status + estimate + power profile toggle | Battery health, charge limit, schedule |
| Notifications | Unread count badge | DND toggle | Per-app rules, quiet hours, grouping |
| VPN | Connected indicator | Toggle + profile name | Profile list, add/remove |
| Night light | State icon | Toggle + intensity slider | Schedule (auto/manual), color temp |
| Media | Now-playing pill (compact) | Full player card (art + controls + seek) | — (no deep settings needed) |
| Clock | Time | Date expanded on hover/open | Timezone, format |
| Workspaces | Pill indicators + tags | — | Workspace names, persistent |
| Display | — | Brightness slider | Resolution, scale, arrangement |
| Power | — | Profile toggle (balanced/perf/saver) | Full power plan editor |
| Appearance | — | Theme picker (quick swap) | Full theme editor |
| System tools | — | Quick actions (screenshot, color picker) | — |

---

### 13.4 Icon Systems Used

All three major Quickshell repos (caelestia, end-4, Noctalia) use **Material Symbols** (Google's ligature icon font — successor to Material Icons). DMS uses Material Design Icons (MDI).

**Material Symbols** is the dominant choice because:
- 2,500+ icons, all well-named and consistently drawn
- Ligature-based: `Text { font.family: "Material Symbols Rounded"; text: "wifi" }` renders the WiFi icon
- Three styles (Outlined, Rounded, Sharp) — Rounded is used by every repo
- Variable font: weight, fill, grade, optical size all adjustable via `font.variableAxes`
- AUR package: `ttf-material-symbols-variable-git`

**How repos declare icons:**
```qml
// caelestia — icon name as a string constant, font applied globally
Text {
    font.family: "Material Symbols Rounded"
    text: "router"          // renders WiFi router icon
}
// OR via MaterialIcon component:
MaterialIcon { name: "bluetooth"; size: 20 }
```

**Nerd Fonts** is used for terminal contexts (bar workspace indicators that use powerline glyphs, font in kitty/terminal text), NOT for UI icons. The two coexist — Material Symbols for the shell UI, Nerd Fonts for the terminal.

**Icon naming conventions found in source:**
```
Network/connectivity: router, wifi, wifi_off, signal_wifi_0_bar…wifi_4_bar, vpn_key
Bluetooth: bluetooth, bluetooth_connected, bluetooth_disabled, bluetooth_searching
Audio: volume_up, volume_mute, headset, speaker, mic, mic_off
Power: battery_0_bar…battery_6_bar, battery_charging_full, power_settings_new
Display: brightness_5, brightness_7, monitor, computer
Notifications: notifications, notifications_off, do_not_disturb_on, circle_notifications
System: settings, tune, build, developer_mode, terminal
Media: play_arrow, pause, skip_next, skip_previous, repeat, shuffle, music_note
Weather: sunny, cloud, thunderstorm, water_drop, air, thermostat
```

**Recommendation for Archeotech:** Add `ttf-material-symbols-variable-git` as a dependency. Use Material Symbols Rounded for all CC/Settings/panel UI icons. Keep Nerd Fonts for bar workspace glyphs and terminal integration. This aligns with the entire ecosystem and gives 2,500 icons with consistent visual weight.

---

### 13.5 Visual Density Patterns

**Card sizing (Noctalia — most systematic):**
- Toggle-only card (on/off + label): 52px height
- Toggle + single status line: 60px height  
- Toggle + slider: 72–80px height
- Media player card: 200–260px height (art + controls)
- Weather card: 180–210px (conditional, can be collapsed)

**Row/pill sizing:**
- Bar icons: 16–20px icon, 32–40px pill height
- CC CompoundPill: 48px height — left tile (48×48px icon toggle), right body (fills remaining)
- Settings rows: 48–56px per row, 12–16px padding

**Visual hierarchy cues (across all repos):**
- Section headers: small allcaps label + colored accent line (same as our current SYSTEM STATUS etc.) ✅
- Active/connected state: `accent` color fill, stronger border — not just an icon change
- Disabled/inactive: `overlay1` or `surface0` color — same icon, much lower contrast
- "Expand for more" affordance: right-facing chevron `›` or `󰅀`/`󰅃` Nerd Font glyphs; never a full "Settings" button in the quick tier
- Separator between sections: 1px `surface0` line OR 8–12px gap — not both

**Hover state patterns:**
- Bar icons: background pill appears on hover (`accentAlpha` or `surface0Alpha`)
- CC cards: subtle `surface1` background shift (no border change)
- CC interactive elements (sliders, buttons): `accentAlpha` on hover, `accentBorder` border
- Settings rows: full row highlight on hover

---

### 13.6 The CC Expansion Problem (our specific situation)

Our current CC (`ControlCenter.qml`) has grown to include: audio sink selector, WiFi CompoundPill, BT CompoundPill, VPN CompoundPill, display section, system section (idle/power), and a tools section (snapper, btop, etc.). This is too much for a single panel.

Cross-repo guidance on how to split:

**Keep in CC (Tier 2 — quick actions):**
- WiFi toggle + current network + expand to nearby list
- BT toggle + connected device + expand to device list
- VPN toggle + active profile name
- Volume slider + source selector
- Brightness slider
- Night light toggle
- DND toggle
- Power profile toggle (balanced/perf/saver chips)
- Media player card (compact — art, play/pause, skip)

**Move to dedicated drawer panels triggered from bar icons:**
- Full audio settings (device aliasing, per-app, EQ) → audio panel
- Full display settings (resolution, scale, arrangement) → display panel
- Full network details (known networks, manual IP) → deep-link to Settings

**Move out of CC entirely:**
- Tools section (snapper, btop, etc.) → Quick Launch (already in Dashboard) or Quick Actions panel
- Appearance/theme picker → stays in Settings (too deep for CC)
- Idle settings → stays in Settings

**The guideline:** CC should be fully usable in under 10 seconds without reading a single label. If an item requires choosing from a list longer than 5 items, it belongs in Settings, not CC.

---

### 13.7 Implementation Notes

**For Sprint 15 (DrawerSurface):** When migrating CC into DrawerSurface, also reorganize it per §13.6 — remove the tools section, restructure as 6–8 cards max.

**For Sprint 16 (Module Builder):** Bar modules should map 1:1 to CC cards. The bar WiFi icon → right-click quick toggle, left-click → opens CC to WiFi card. This is the DMS PopoutService deep-link pattern in reverse: bar icon is the entry point, CC card is the quick surface, Settings pane is the deep surface.

**Material Symbols integration:** Add to `Appearance.qml` font declarations. Add to `docs/MODULE_API.md` as the required icon font for community module authors. Include `ttf-material-symbols-variable-git` in the Sprint 21 `install-packages.sh`.

---

## 14. Technical Unknowns — Resolved Pre-Sprint Research

*Research date: 2026-05-21. Four critical unknowns resolved before Sprint 15. Source: Quickshell docs, Quickshell source (git.outfoxxed.me), caelestia issues, Qt6 drag docs, MangoWC rules docs.*

---

### 14.1 Input Passthrough on a Full-Screen DrawerSurface

**Status: RESOLVED — `QsWindow.mask: Region`**

When a full-screen transparent PanelWindow is on WlrLayer.Overlay, input passthrough is controlled via:

```qml
PanelWindow {
    // null = full passthrough (no panels open)
    // Region = only that area receives input
    QsWindow.mask: DrawerVisibilities.anyPanelOpen ? activeRegion : null
}

Region {
    id: activeRegion
    item: currentPanelRect  // the visible panel Rectangle
    intersection: Intersection.Combine
}
```

**Key facts:**
- `QsWindow.mask = null` → all mouse events pass through to windows below
- `QsWindow.mask = Region { item: panelRect }` → only panelRect receives input
- `WlrLayershell.keyboardFocus: WlrKeyboardFocus.None` controls *keyboard* only — does NOT affect mouse passthrough
- `exclusiveZone` is unrelated (controls screen edge reserved space)
- No `WlrLayershell.inputRegion` property exists — `QsWindow.mask` is the only API

**Implementation for DrawerSurface:** Update `QsWindow.mask` whenever `DrawerVisibilities.anyPanelOpen` changes. The `Region` item should reference the active panel's bounding Rectangle, not the full surface.

---

### 14.2 MangoWC Blur on WlrLayer.Overlay Surfaces

**Status: RESOLVED — works, but requires correct layerrule syntax + ignore_alpha**

MangoWC `layerrule = blur` works on Overlay-level surfaces. caelestia's confirmed working configuration:

```ini
# mango.conf — matches all Quickshell surfaces by namespace prefix
layerrule = blur true, match:namespace qs-.
layerrule = ignore_alpha 0.57, match:namespace qs-.
```

`ignore_alpha 0.57` is critical: without it, blur looks over-applied at semi-transparent opacity values (~0.92 for our panels).

**For Archeotech, use:**
```ini
layerrule = blur, namespace:archeotech-drawer
layerrule = ignorealpha 0.1, namespace:archeotech-drawer
```
(The `ignorealpha` value means "don't blur pixels below this alpha threshold" — set low to ensure the panel content blurs but the transparent background doesn't create artifacts.)

**Known caveats:**
- Blur may look incorrect at fractional display scaling — general wlroots issue, not Overlay-specific
- The ext-background-effect-v1 Wayland protocol (2025-era) is what Quickshell uses under the hood; MangoWC must support it

---

### 14.3 Directory Watching for Module Hot-Discovery

**Status: RESOLVED — no native API, use inotifywait subprocess**

`FileView { watchChanges: true }` watches a single file only. **There is no `DirView` or directory-watching type in Quickshell.Io.** QFileSystemWatcher is used internally but not exposed at the QML level.

**Implementation for ModuleRegistry hot-discovery:**

```qml
Process {
    id: dirWatcher
    running: true
    command: ["inotifywait", "-m", "-e", "create,delete,moved_to,moved_from",
              "--format", "%e %f",
              Qt.resolvedUrl(Paths.userModules).toString().replace("file://", "")]
    stdout: SplitParser {
        onRead: line => {
            const [event, filename] = line.split(" ")
            if (filename.endsWith("module.json"))
                ModuleRegistry.rescan()
        }
    }
}
```

`inotifywait` is in the `inotify-tools` package (available in Arch, Ubuntu, etc.). `rescan()` re-reads all `module.json` files and rebuilds the registry.

**Alternative for Sprint 16 MVP:** Skip hot-discovery entirely — scan once on shell start, rescan via IPC `qs ipc call modules rescan`. Hot-discovery is a nice-to-have for v1.0, not a blocker.

---

### 14.4 Cross-Window Drag-and-Drop in the Module Builder

**Status: RESOLVED — unreliable on Wayland, use click-to-assign instead**

QML `Drag`/`DropArea` are designed for single-window trees. Cross-window drag on Wayland has documented state leakage bugs and unreliable MIME handling. No existing Quickshell shell does cross-window drag.

**Decision for Sprint 16: use click-to-assign UX**

```
Edit mode flow:
1. User enters edit mode (Super+Shift+E)
2. Edit overlay appears, showing all slots as highlighted drop targets
3. User CLICKS a module chip (highlights it, shows source slot)
4. User CLICKS a target slot (assigns module, writes DrawerConfig.json)
5. Slots can be dragged to reorder WITHIN the same surface (bar zones, CC cards)
   — this is safe because it's within one Item tree

Desktop widget layer (WidgetLayer.qml):
- Drag-to-reorder works fine (all widgets are children of the same PanelWindow)
- Noctalia's DraggableDesktopWidget pattern applies directly
```

**Why click-to-assign is actually better UX:**
- Works reliably on all compositors
- Keyboard accessible (Tab to cycle through slots, Enter to assign)
- Clearer visual state — selected module is highlighted until assigned or cancelled
- No cursor issues from cross-window drag coordinates

---

### 14.5 Remaining Gaps (Not Yet Fully Resolved)

These are unknowns that will require either additional research before their respective sprints or careful prototyping:

| Gap | Sprint | Risk | Notes |
|---|---|---|---|
| `Quickshell.DWL` availability | Sprint 20 | Medium | ANALYSIS.md notes it may be in a custom fork. Verify via `paru -Qi quickshell-git` build flags before Sprint 20. |
| Niri IPC event format | Sprint 20 | Low | Socket at `$NIRI_SOCKET`, JSON events. Need exact event names for workspace switch + window focus. Research when Sprint 20 starts. |
| `WlSessionLock` + `Pam.PamContext` in current build | Sprint 18 | Low | Qylock confirms the API exists; verify with `quickshell-git` build at Sprint 18 time. |
| Per-monitor DrawerConfig design | Sprint 15/16 | Medium | Global config vs per-monitor overrides. Decision: global config with `perMonitor: {}` override map in DrawerConfig.json. |
| Material Symbols variable font loading in QML | Sprint 15 | Low | Standard font load via `FontLoader`. Variable axes (`fill`, `weight`) via `font.variableAxes: {"FILL": 1}`. Needs one test. |
| Community module security model | Sprint 16/21 | Known | No QML sandboxing possible. Resolution: document that modules are trusted code (same as browser extensions). Verified modules get a `verified` badge in ModuleRegistry. |
| `inotify-tools` as a dependency | Sprint 16 | Low | Not universally installed. Add to `install-packages.sh`. Fallback: polling every 30s if `inotifywait` not found. |

---

### 14.6 Architecture Decisions Locked Before Sprint 15

These cannot be changed mid-sprint without breaking things. Locked here:

| Decision | Choice | Reason |
|---|---|---|
| Input passthrough API | `QsWindow.mask: null / Region` | Only reliable API |
| Blur layerrule namespace | `archeotech-drawer` | Single named namespace for MangoWC layerrule |
| Blur ignorealpha value | `0.1` | Prevents artifact on transparent background; panel content at 0.92 opacity blurs correctly |
| Module Builder drag model | Click-to-assign | Cross-window drag unreliable on Wayland |
| Module hot-discovery | inotifywait subprocess | Only viable approach without native Quickshell API |
| DrawerConfig scope | Global with per-monitor override map | Simpler than full per-monitor configs; matches HyprPanel model |
| State.qml migration | Fully replaced by DrawerVisibilities.qml in Sprint 15 | Clean break, no dual maintenance |
| Bar module data model | `DrawerConfig.bar: { left: [], center: [], right: [] }` — arrays of widget ID strings | Matches caelestia's Config.bar.entries pattern; DelegateChooser maps IDs to QML |

---

## 15. Edge Strips, Multi-Screen Handling & Bar Frame Architecture

*Research date: 2026-05-27. Repos inspected: caelestia-dots/shell, Noctalia, end-4/dots-hyprland, DankMaterialShell. Context: Sprint 16 implementation of per-screen edge strips with hover-reveal, and designing a unified wrap-around bar frame.*

---

### 15.1 Universal Rules (apply to every shell studied)

**Multi-screen:** Every shell uses `Variants { model: Quickshell.screens }` for any window that must appear on each monitor. No exceptions. This is the only correct approach — confirmed in caelestia, Noctalia, end-4, and DMS.

**No cursor barriers:** No shell implements mouse confinement or cursor barriers at screen edges. The compositor (Hyprland/Niri/MangoWC) owns cross-monitor cursor flow entirely. There is no Quickshell API for cursor barriers, and compositors don't expose one either. The consequence: a 6px edge strip on a multi-monitor setup *will* be missed sometimes as the cursor jumps monitors. This is unsolvable at the shell layer.

**Drawers on one screen only:** Even when bars are per-screen, drawer panels (CC, launcher, NC) are single global PanelWindows. The compositor picks which screen they appear on, or QML positions them relative to a specific screen reference. The only shell that avoids this is Noctalia (per-screen state dict). See §15.3.

---

### 15.2 Caelestia — Gold Standard: One Full-Screen PanelWindow Per Monitor

**Architecture:**
- ONE full-screen `PanelWindow` per monitor (created via `Variants { model: Quickshell.screens }`).
- The bar is a plain `Item` *inside* this surface — NOT its own PanelWindow.
- All panels (CC, NC, launcher, drawer) are also children of this same full-screen surface.
- 4 tiny dedicated `PanelWindow` instances per screen for exclusive zone definitions (top/bottom/left/right), each 1px tall/wide. These reserve compositor space so maximized windows don't cover the bar area.

**Why this matters for wrap-around visuals:**
The bar and edge strips are in the **same coordinate space** — they're all children of one Item. There is no "seam" between bar and strip because they're literally the same surface. Corner blending is trivial, since the bar's pill ends and the strip rectangles are siblings. This is why caelestia's corners look seamless.

**Input masking — `Intersection.Xor` Region:**
The full-screen transparent surface would eat all input if not masked. caelestia uses `QsWindow.mask` with `Intersection.Xor` — visible UI regions are added to the mask with XOR so only the bar and strips receive input. The rest is click-through.

```qml
QsWindow.mask: Region {
    item: barRect      // or a combined region of bar + all strips
    intersection: Intersection.Xor
}
```

**`offsetScale` animation:**
Single property `offsetScale` (0 = visible, 1 = hidden) drives both position and opacity simultaneously:
```qml
property real offsetScale: 1
anchors.rightMargin: (-implicitWidth - 5) * offsetScale
opacity: 1 - offsetScale
Behavior on offsetScale { Anim { type: Anim.DefaultSpatial } }
```
This slides panels off-screen (physical translation) rather than fading/scaling in place. One property, one `Behavior`, handles everything.

**SDF blob for corners:**
caelestia uses a custom GLSL shader (SDF — signed distance field) to render a rounded concave blob that connects the bar ends to the side strips. This is not just rounded `Rectangle` corners — it's a continuously smooth curve that "melts" the bar ends into the strips at any geometry. Filed under Sprint 18 as a stretch goal.

**Multi-screen:**
Each screen gets its own full-screen PanelWindow. Drawers open relative to the screen that owns the strip that was clicked — because everything is in the same surface, there's no ambiguity.

---

### 15.3 Noctalia — Explicit Per-Screen State Dictionary

**Architecture:**
Separate `PanelWindow` per edge per screen (NOT a single full-screen window). Each edge strip is its own dedicated thin PanelWindow.

**`BarTriggerZone`:**
A 1px `PanelWindow` anchored full-width/height on one edge per screen. At rest: invisible (1px = invisible). Hover triggers a `Timer` → opens the drawer.

**Per-screen state dictionary:**
```qml
property var stateMap: ({})   // keyed by screen.name, e.g. "DP-1", "eDP-1"

function getState(screen) {
    if (!stateMap[screen.name])
        stateMap[screen.name] = { open: false, activePanel: "" }
    return stateMap[screen.name]
}
```
When a strip on screen "DP-1" is hovered, it looks up `stateMap["DP-1"]` and opens the drawer for that screen. This is the cleanest multi-monitor pattern for sidebars that should open on the interacted screen.

**Why archeotech should adopt this later:**
Our current `DrawerVisibilities` singleton is global — CC always opens on compositor-chosen screen. For a multi-monitor setup with CC on the right, NC on the top, and launcher on the left, the per-screen state dict ensures each drawer opens on the screen the user interacted with. Sprint 17+ improvement.

---

### 15.4 end-4 — Global Single PanelWindow for Sidebars (The Outlier)

**Architecture:**
Bar: per-screen via `Variants { model: Quickshell.screens }`. Sidebars: single global `PanelWindow`. The compositor decides which screen the sidebar appears on.

**Why this is the outlier:**
No per-screen state. The sidebar doesn't know which screen triggered it. On multi-monitor setups, sidebars appear on compositor-chosen screen (usually primary). This is the simplest approach but worst UX on multi-monitor.

**Archeotech's current state:** We follow end-4's approach (global DrawerSurface, DrawerVisibilities singleton). This is fine for now but should be improved to Noctalia's per-screen model in a later sprint.

---

### 15.5 DankMaterialShell — Production Multi-Monitor Features

**`FrameInstance.qml`:**
Per-screen frame rendering with `FrameExclusions` for exclusive zone management. Same `Variants { model: Quickshell.screens }` pattern. Frames can be selectively enabled/disabled per display via `SettingsData.isScreenInPreferences()`.

**`SettingsData.getFilteredScreens()`:**
Users can assign UI elements to specific monitor subsets via settings. Example: "show dock on primary only", "show bar on all monitors". Stored as an array of screen names in `settings.json`. This is the right long-term pattern for archeotech's multi-monitor users.

**Screen recovery system (two-pass, escalating timers):**
When a display disconnects/reconnects, DMS recreates surfaces:
```qml
// 500ms debounce for dock recreation
Timer { interval: 500; onTriggered: recreateDockSurface() }

// 120ms debounce for OSD recreation
Timer { interval: 120; onTriggered: recreateOsdSurface() }
```
Staggered timing prevents compositor sync storms. Real vs. placeholder screen detection (`screen.width > 0 && screen.name !== ""`) prevents instantiating on phantom screens.

**"Goth corners" — `BarCanvas.qml` ShapePath implementation:**
DMS implements concave wing cutouts at bar ends connecting the bar to side strips. These are exactly the Sprint 18 "concave curve connector" concept under a different name.

Key implementation approach:
```qml
// BarCanvas.qml generates a ShapePath for each corner
// The path uses cubic bezier curves to create a concave (inward) cut
// at the junction between bar end and edge strip
Shape {
    ShapePath {
        fillColor: Appearance.colors.glassBg
        startX: ...; startY: ...
        PathCubic { /* concave corner curve */ }
        PathLine  { /* along strip edge */ }
        // ...
    }
}
```
Read `BarCanvas.qml` from DMS when implementing Sprint 18. The concave radius follows the bar's corner radius (`barCornerRadius`) and is derived from the strip width.

**Translate transform animations (NOT offsetScale, NOT opacity+scale):**
DMS uses `Translate { x: value }` transform components to slide panels from their originating edge:
```qml
transform: Translate { x: panelOpen ? 0 : -panelWidth }
Behavior on x { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
```
Physically grounded: the panel slides *from* the edge rather than appearing/scaling in the center. More convincing for edge-anchored panels. Consider adopting for CC/launcher in Sprint 17.

---

### 15.6 Comparison Table — All Shells

| Shell | Bar | Edge strips | Sidebar/drawer | Multi-screen state | Animation |
|---|---|---|---|---|---|
| caelestia | Item inside full-screen PanelWindow | Same surface as bar | Per-screen (same PanelWindow) | Implicit — one window per screen | offsetScale → translate |
| Noctalia | Per-screen PanelWindow | 1px PanelWindow per edge per screen | Per-screen | Explicit dict keyed by screen.name | Opacity+translate |
| end-4 | Per-screen PanelWindow | None | Global single PanelWindow (outlier) | None | Opacity+scale |
| DankMaterialShell | Per-screen Variants | FrameInstance per screen | Per-screen | getFilteredScreens() | Translate transform |
| **archeotech (current)** | Per-screen Variants | Per-screen Variants (6px strip) | **Global** DrawerSurface | DrawerVisibilities singleton (global) | Opacity+scale |

---

### 15.7 Archeotech Gaps & Future Improvements

| Gap | Current state | Fix | Sprint |
|---|---|---|---|
| Drawers open on compositor-chosen screen | Global DrawerSurface, end-4 pattern | Noctalia per-screen state dict | 17+ |
| No screen recovery on disconnect/reconnect | Surfaces may break on hotplug | DMS two-pass timer pattern (500ms/120ms) | 19+ |
| opacity+scale drawer animation | Physically ungrounded for edge panels | Translate from edge (DMS/caelestia pattern) | 17+ |
| No concave corner connectors | Bar pill ends are visually disconnected from strips | ShapePath concave curves (DMS BarCanvas.qml reference) | 18 |
| No per-monitor UI assignment | All screens get identical UI | `getFilteredScreens()` pattern in settings | 17+ |
| No cursor barrier at edge strips | Mouse jumps monitor before strip caught | Not solvable at shell layer — compositor owns this | N/A |

---

### 15.8 Final Implementation — Archeotech Edge Strips

**Implemented 2026-05-27 in `shell.qml`.**

#### The three-action conflict

In a horizontal scrolling layout (MangoWC), the right screen edge can trigger three different actions:
1. **Shell sidebar** — hover strip → expand → click → CC opens
2. **Compositor layout scroll** — cursor reaches edge pixel → next window/tag
3. **Multi-monitor jump** — cursor past edge → lands on next screen

These must be disambiguated without a compositor-level barrier (none exists in MangoWC or Niri).

#### Solution: separated hover zone + expansion delay

**Architecture per strip (right shown, left/bottom are mirrors):**
```
PanelWindow (44px wide, anchored right, mask = _ccZone)
  └─ Item _ccZone (20px when idle, 44px when hovered — drives the mask)
       ├─ Timer _ccExpandTimer (80ms, fires _ccZone._hov = true)
       ├─ HoverHandler (enter → start timer; exit → stop timer + _hov = false)
       └─ Rectangle _ccStrip (6px → 44px visual, anchored right)
            └─ TapHandler (click to toggle CC)
```

**Why 20px hover zone:**
- Caelestia uses 10px (their minimum). 20px gives more margin for fast mouse movement.
- The zone fires when cursor is 20px from the screen edge, well before the compositor's edge-pixel boundary.
- The mask (`_ccZone`) tracks this 20px zone, expanding to 44px when hovered — so input coverage grows with the visual.

**Why 80ms expansion delay:**
- Fast cursor passthrough (layout scroll intent): cursor enters 20px zone and exits in <80ms → timer cancelled → strip never expands → no visual distraction.
- Deliberate approach (sidebar intent): cursor dwells ≥80ms → strip expands to 44px → user clicks.
- 80ms is imperceptible as lag but filters out fast layout navigation. Noctalia uses 100ms; 80ms is sufficient.

**Why click-to-toggle (not hover-to-open):**
- Distinguishes "passing through to next monitor" from "intending to open sidebar."
- Hover only expands the visual strip. The drawer only opens on explicit click.
- Works for both mouse and touchpad users.

**Dynamic mask:**
`mask: Region { item: _ccZone }` — the Region tracks `_ccZone`'s current geometry. When `_hov = true`, `_ccZone` grows to 44px and the input region expands with it. When `_hov = false`, `_ccZone` shrinks to 20px immediately (mask shrinks; visual strip animates back over 200ms).

#### Behaviour matrix

| Action | Cursor speed | Outcome |
|---|---|---|
| Open CC | Slow → edge, dwell ≥80ms, click | Strip expands, CC opens |
| Scroll layout (MangoWC) | Fast through edge zone, no click | Timer cancelled, strip doesn't expand, layout scrolls |
| Jump to monitor 2 | Fast through edge zone, no click | Same as above; cursor lands on monitor 2 |
| Accidental hover | Slow approach but no click | Strip expands, no drawer opens; collapses on exit |

#### Why full-height strips (no bar safety margin):
Bar icons end at `innerPadding: 10px` from screen edges. 20px hover zone starts 20px from the edge. The bar pill at the top does not extend to the top corners, so there is no overlap zone between bar icon hit targets and strip hover zones.

#### Future: caelestia single-surface approach (Sprint 18+):
One full-screen PanelWindow per monitor eliminates the seam between bar and strips entirely. Requires refactoring bar to be an Item child of that surface. Not a blocker — current approach is functionally correct.

## 16. Caelestia Blob System — Full Source Research

**Date**: 2026-05-29  
**Decision**: Deferred. Using plain QML Shape/Rectangle. Full notes → `.claude/CAELESTIA_BLOB_RESEARCH.md`

### Frame sizing

Caelestia uses one constant — `Config.border.thickness = 10px` — for everything:
- Collapsed bar strip width = 10 px (same as border thickness)
- Top / right / bottom content inset = 10 px
- Left inset = `bar.implicitWidth` (grows with bar when visible)
- Frame corner rounding = `Config.border.rounding = 25 px`
- SDF smoothing / feather radius = `Config.border.smoothing = 32`

This gives a perfectly symmetric 10 px gap on all four sides when the bar is hidden.

### What the blob system is

A custom Qt Quick Scene Graph material (`QSGMaterial` + GLSL shader, ~200 lines) compiled as a
QML module (`Caelestia.Blobs`). Renders up to 16 SDF rounded rectangles per frame with:

1. **`smin` goo-merge** (cubic smooth-min, k = 32 px) — rects within 32 px smoothly flow together
2. **Spring physics** (`BlobRect`) — squash-and-stretch deformation matrix driven by scene velocity
   (stiffness = 200, damping = 16)
3. **Frame cutout** (`BlobInvertedRect`) — hollow rect with "border sink" SDF warping so panels
   merge flush into the frame edge
4. **CPU per-corner radius reduction** — corners inside a neighbour's SDF zone shrink to ~2 px;
   this is what makes adjacent panels look seamlessly joined without visible gaps
5. **Ownership masking** — each BlobRect renders only its own pixels; no overdraw

### Core GLSL (the entire visual identity)

```glsl
float sdRoundedBox4(vec2 p, vec2 center, vec2 halfSize, vec4 r) {
    p -= center;
    r.xy = (p.x > 0.0) ? r.xy : r.wz;
    r.x  = (p.y > 0.0) ? r.y  : r.x;
    vec2 q = abs(p) - halfSize + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

float smin(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k * (1.0/6.0);  // cubic smooth-min, C2
}
```

### Portability assessment

| Layer | Approach | Effort |
|---|---|---|
| Full multi-rect SDF + smin + border cutout | `ShaderEffect` + custom UBO packing | ~2–3 days |
| Single-rect SDF (one popup, no merge) | `ShaderEffect` | ~2–4 hours |
| Current approach (Rectangle + Shape) | Already working | 0 |

The shader itself is standard GLSL 300es/330 — no Qt private APIs. The bookkeeping
(ownership masking, `vec4[80]` uniform array via QML, spatial dirty propagation) is
where the effort lives.

## 17. Strip → Popup → Panel — Unified Card Architecture

**Date**: 2026-06-01
**Decision**: The strip's popup card *is* the panel. One component handles all
three states (idle frame, hover popup, active panel). `Panels/Panel.qml` is no
longer mounted in `ShellSurface`; `PanelRegistry` is read directly by the strip.

### Three states, one Shape

A single `Shape` (with concave neck arcs at the strip-attached edge) animates two
dimensions:

- **`_perp`** — depth perpendicular to the strip. Targets:
  `0` idle / `_popupExtra` (= `_bodyDepth + _r`) hover / `_panelSize` (from
  `PanelRegistry`) active.
- **`_axis`** — extent along the strip. Targets: `_bodyAxis + 2*_r` popup /
  full strip Item extent active.

Both have `Behavior on { NumberAnimation 240ms OutCubic }`. The strip `Item`'s
`implicitWidth`/`Height` follows `collapsedSize + _perp` so the Wayland input
mask grows with the popup/panel.

### Why icons stay put

`iconArea` is anchored to the *strip-attached* edge of the card with a `_r/2`
margin, full cross-axis extent, `bodyDepth` thick. In popup mode this puts the
icon row perpendicular-centered in the small card; in panel mode the iconArea
sits next to the strip body, with content filling the new space. Icons within
`iconArea` are positioned via a **clustered formula**:

```
_cluster = (axisLen - bodyAxis) / 2
_center  = _cluster + bodyAxis * (i + 0.5) / N
```

The clustering keeps the icons in a `bodyAxis`-wide band regardless of how wide
the iconArea grows in panel mode — so icons stay at the same screen position
through the popup → panel animation. Content for the active panel loads in a
`Loader` anchored opposite the iconArea, reading `PanelRegistry.panelFor(id).content`.

### Hover state robustness (Qt 6 child-MA shadowing)

Naive parent-`HoverHandler` + child-`HoverHandler` lost hover when the cursor
moved onto a child (Qt 6 nested-handler shadowing). Naive parent-`MouseArea` +
child-`MouseArea` *also* lost hover when child took it. The robust pattern:

- Strip-level `MouseArea` (`acceptedButtons: Qt.NoButton`, `hoverEnabled`)
  tracks "cursor anywhere in strip Item".
- Each icon `MouseArea` increments/decrements `_iconHoverCount` on enter/exit.
- `_updateHover()` (called by both) evaluates `_stripMA.containsMouse ||
  _iconHoverCount > 0`. If either is true, stop the leave-timer and assert
  `_hov=true`. Otherwise restart the 250ms timer.

Even if the strip MA loses `containsMouse` to a child, the icon counter holds
the popup open.

### Click-outside-to-close

Lives on `ShellSurface`'s `_panelOpenMask` (full-surface when any panel is
open). A `TapHandler` checks the tap point against all four `SideLoader`
bounds; if outside every strip, calls `ShellState.close(screenName)`.

### Why Panel.qml is no longer mounted

The slide-from-edge animation in `Panel.qml` re-renders the panel on top of
the strip popup — two cards, same content, fighting for the same edge. The
unified Shape *is* the slide animation (via `_perp`/`_axis` Behaviors),
emerging *from* the popup position rather than from the screen edge. Panel.qml
stays in the tree as a reference; its `panelRoot.close()` / `panelOpen`
interface is mirrored on the strip so existing content modules work unchanged.

---

## 18. Polish & Liveliness — Reference Motion/Depth/Warmth Catalogue (research spike 2026-07-09)

**Why:** the shell reads bland/cold/flat next to Caelestia and other mature Quickshell
shells (user, 2026-07-02). This is the Phase-1 research spike of the "Polish & Liveliness"
pass (ROADMAP → Feature Backlog, scheduled pre-v1.0). Goal = catalogue **concrete adoptable
techniques with exact values**, not vibes. Builds on §1 "Animation system" (which was
high-level). Method: read-only shallow clones of the four reference shells, one deep-inspection
agent per repo across 8 dimensions (easing/durations, spring/overshoot, stagger, hover/press,
depth, colour warmth, empty/loading, icon+type), extracting `file:line` citations.

**Repo caveats (read before trusting a number):**
- **Caelestia** — tokens live in a **C++ plugin** (`plugin/src/Caelestia/Config/`), exposed to
  QML as attached `Tokens.*`. Values are C++ defaults; concepts port to QML, the plumbing doesn't.
- **end-4/dots-hyprland** — pure QML, the cleanest **M3-Expressive** reference; `ii/` (M3) +
  `waffle/` (Fluent) run in parallel. Most directly copyable into our QML.
- **DankMaterialShell** — pure QML, the most **explicitly tokenised** motion system (even a
  user-facing "Typography & Motion" settings tab). Directly copyable.
- **Noctalia** — ⚠️ the checkout is **v5, a from-scratch native C++/OpenGL-ES rewrite with ZERO
  QML**. The old v4 Quickshell shell is *not* in this repo. Its numbers are **conceptual**
  references (SDF shadows, a hand-rolled easing engine), NOT copy-paste QML. Notably v5 has **no
  overshoot/spring** (its `EaseOutBack` is dead code), **no stagger**, and **no hover-scale/
  ripple** — its polish is entirely colour-crossfade + SDF depth. Use it for the accent-tinted
  hover idea and the shadow recipe, not for motion.

### 18.1 Our current baseline (the gap, quantified — `~/Projects/archeotech-shell`)

| Dimension | Current state | Verdict |
|---|---|---|
| Motion tokens (`Commons/Appearance.qml anim`) | 5 **bare durations** `fast:100, base:200, slow:300, spring:400, panel:240`; `spring:400` is a misnamed *duration*, not a curve. Usage: `anim.fast` ×102, `anim.panel` ×14, `anim.base` ×9 — **`anim.slow`/`anim.spring` used 0×** | Everything is a 100ms tween; no named curve presets |
| Easing | `Easing.OutCubic` ×38, `OutBack` ×2, `Linear` ×1, `InOutQuad` ×1 — near-pure decelerate, `easing.type` hand-rolled per site | No overshoot idiom, no enter/exit asymmetry |
| Behaviors | ~130+ `Behavior on` across ~20 files | Plumbing is fine; curves/durations are the flat part |
| Micro-interaction | hover-`scale` in **1** file (WallpaperPickerBody); no press-depress anywhere; `BarPill` swaps icon→accent colour + optional fill (off by default "so bar pills stay flat") | **No shared hover/press primitive**; each widget hand-rolls |
| Depth | **ZERO** — no `MultiEffect`/`DropShadow`/`RectangularShadow`/gradient/glow/elevation anywhere | Fully flat |
| Warmth | `glassBg` = mantle@0.96, `glassBorder` = surface0@0.90; surfaces are pure palette greys; `accentAlpha`(0.15)/`accentBorder`(0.40) defined | No accent-tinted surfaces, no elevation tint |
| Empty/loading | `Commons/Primitives/EmptyState.qml` exists; no skeleton/shimmer/spinner | — |

Constraint (DECISIONS 2026-07-02): **never wrap interactive content in `layer.enabled`; antialiase
Shapes with `Shape.CurveRenderer`.** Any animated interactive surface must honour this.

### 18.2 Cross-repo synthesis — the concrete values to adopt

**Motion curves (M3, consistent across Caelestia + end-4 + Dank — copy verbatim).** These are
Qt `BezierSpline` control-point lists `[c1x,c1y, c2x,c2y, …, 1,1]`:
```
standard          : [0.2, 0, 0, 1, 1, 1]                                   // standard in/out
standardAccel     : [0.3, 0, 1, 1, 1, 1]                                   // accelerate (exit)
standardDecel     : [0, 0, 0, 1, 1, 1]                                     // decelerate (enter)
emphasized        : [0.05,0, 2/15,0.06, 1/6,0.4, 5/24,0.82, 0.25,1, 1,1]   // M3 emphasized (multi-seg)
emphasizedAccel   : [0.3, 0, 0.8, 0.15, 1, 1]
emphasizedDecel   : [0.05, 0.7, 0.1, 1, 1, 1]
// spring/overshoot (control-point y > 1 → overshoot-and-settle, NO physics engine):
expressiveFastSpatial    : [0.42, 1.67, 0.21, 0.90, 1, 1]   // strong overshoot
expressiveDefaultSpatial : [0.38, 1.21, 0.22, 1.00, 1, 1]   // moderate overshoot
expressiveSlowSpatial    : [0.39, 1.29, 0.35, 0.98, 1, 1]
expressiveEffects        : [0.34, 0.80, 0.34, 1.00, 1, 1]   // effects, NO overshoot
```
Cheap integer fallbacks (Dank): `standard ≈ Easing.OutCubic`, `emphasized ≈ Easing.OutQuart`.

**Durations (converged ranges).** Effects (opacity/colour) are short, spatial (move/size) longer:
`effects fast/med/slow = 150/200/300`; `spatial fast/default/slow = 350/500/650`; enter ≈ 400,
exit ≈ 200. **The idiom everyone shares: enter slow+decelerate, exit fast+accelerate** ("enter
gently, leave briskly"). Dank derives a whole family from one user-tunable `baseDuration` via
multipliers (`fast=×0.4, normal=×0.8, large=×1.2, xl=×2.0`) — one slider scales all motion.

**Spring/overshoot rule:** overshoot **only on enter + on spatial (position/size)** props; never
on colour/opacity (they'd flash). Concrete uses: switch-thumb grows to 1.2× on press (Caelestia);
button-group press *grows implicitWidth* and shoves neighbours (end-4 `clickBounce` 400ms); check
icon pops `0.6→1.0` (Dank `emphasized` 200ms).

**Shared hover/press primitive — a state-layer overlay (all three QML repos have one).** A single
overlay `Rect`/`StyledRect` whose alpha = pointer state, animated ~100ms decel on colour:
```
hover α 0.08   pressed α 0.12   (M3 canonical; end-4 runs punchier 0.10/0.15–0.20)
disabled: fill α 0.10, content α 0.38
Behavior on color { duration ~100ms; curve standardDecel }
```
Plus optional scale conventions (Dank, exact): **press-depress `scale 0.98`**, hover-grow `1.05`,
check/enter pop `0.6→1.0`, popup appear `0.9→1.0`. Ripple (Caelestia/end-4/Dank): radial gradient
from click point to farthest corner, ~500–600ms, initial α 0.10, fade-out starting at 60% —
optional/gated behind a setting in Dank.

**Depth — two-shadow (key + ambient) derived from one elevation level.** Best recipes:
- **Caelestia one-formula** (from a `level` 0–5 → dp `[0,1,3,6,8,12]`): `blur=(dp·5)^0.7`,
  `spread=-0.3·dp+(0.1·dp)²`, `offset.y=dp/2`, shadow α 0.7; **animate `dp`** → free hover-lift.
- **Dank 5-step ladder**: blur `4/8/12/16/20`, offset.y `1/4/6/8/10`, α `0.20→0.30`; **ambient
  derived**: `ambientBlur=key·1.75, ambientSpread=1, ambientAlpha=key·0.5`.
- **end-4 discipline**: one token `elevationMargin:10` is *both* the blur radius (×0.9) *and* the
  layout margin every floating panel reserves so the shadow isn't clipped; key shadow #000@0.30.
  Waffle variant: key(blur 10, offset 4, α 0.38) + **ambient as a 1px border** (no blur, α 0.25) —
  GPU-cheap contact edge.
- **QML mechanism:** `MultiEffect` (shadowEnabled) or `RectangularShadow`; NOT layered inside a
  `layer.enabled` interactive item (hit-testing rule).

**Warmth — accent-tinted surfaces, not grey.** (a) **Elevation→surface-tint** (M3 surface tint
that intensifies with elevation): Dank alpha ladder `0.05/0.08/0.11/0.12/0.14` of primary over the
surface. (b) **Accent-tinted hover** (Noctalia): map the hover state-layer to the **accent** colour
at low alpha (~0.08–0.12) instead of white/grey. (c) **Surface containers** instead of flat greys:
generate `surfaceContainerLow/High/Highest` by blending toward the accent, e.g.
`blend(surfaceContainerHigh, primary, 0.45)` (Dank). (d) Use **premultiplied-alpha colour tweens**
when animating between translucent and opaque colours to avoid the mid-transition flash (Dank
`DankColorAnim`).

**Stagger — nobody does per-index temporal stagger.** All four rely on Qt `ListView`
`add`/`remove`/`displaced`/`move` Transitions: item pops in on `opacity+scale` (0→1, ~200–500ms),
removed items slide out with overshoot, and **surviving items glide via `displaced`** — the
"cascade" look comes from displacement, not `index*delay`. Caelestia's alternative: fade+`scale
0.9` the *whole list* out, swap model via `PropertyAction`, fade back (avoids reflow jank). **This
is our one genuine gap if we want true stagger — we'd add `index*delay` ourselves; the refs won't
show us how.** Empty-state entrances worth stealing: Caelestia `scale 0.5→1`; end-4 `PagePlaceholder`
fade + slide-up + icon-rotate `-30°→0`.

**Icon + type rhythm.** Shared 4-based token ramps: spacing `4/8/12/16/(24)`, radii
`8/12/16/24`+pill, type roughly `11–12 / 13–14 / 16 / 20 / 22–24`. Distinctive touches: animate the
**Material Symbols variable `fill` axis 0→1** on toggle/selection (fills in rather than swapping
glyph — Caelestia/end-4); bind icon `opsz` to pixel size for optical correctness (end-4); `grade:
-25` to thin icons in dark mode (Caelestia); auto-swap to a tabular number font on all-digit strings
(end-4 `StyledText`), and end-4's shared `StyledText` animates *every* text change (slide+fade) for
free. (Our FiraCode is not a variable font with these axes — fill/opsz/grade need a variable icon
font like Material Symbols; flag as a dependency if we want them.)

### 18.3 Per-repo detail (condensed; full agent reports in scratchpad `ref-*.md` this session)

**Caelestia** — `Tokens` C++ plugin. Durations `small200/normal400/large600/xl1000` + expressive
spatial `350/500/650` & effects `150/200/300`, all ×global `scale`. Six M3 beziers as above.
Shared `components/StateLayer.qml`: hover α0.08, ripple α0.1 farthest-corner 600ms. `effects/
Elevation.qml`: single `RectangularShadow`, one-formula from `level` (dp `[0,1,3,6,8,12]`), animated
dp = hover-lift. Surfaces = wallpaper-generated M3 tonal palette; translucency uses a
luminance-relative re-tint not flat alpha. `LoadingIndicator` = analytic underdamped spring
(stiffness 180, damping 0.6) driving shape-morph + velocity→scale via `FrameAnimation`. Type: role×
size matrix (headline 32/28/24 … body 16/14/12); icons px÷1.33 → pt; `grade:-25` dark thinning;
`fill 0→1` toggles. Spacing/rounding ramp `4/8/12/16/20/28/32/48`+pill.

**end-4/dots-hyprland** — `modules/common/Appearance.qml:251-385`. Full `animationCurves` +
semantic presets (`elementMoveEnter` 400 decel / `elementMoveExit` 200 accel / `clickBounce` 400
overshoot / `elementMoveFast` 200 effects …) each bundling duration+curve+a reusable `Component`
factory. State layers as `ColorUtils.mix` ratios: Layer1 hover 0.92→8%, active 0.85→15%; Layers2-4
0.90/0.80. `solveOverlayColor` gives tonal-elevation surfaces; `colLayer0` mixes toward wallpaper
primary; auto-transparency = quadratic on wallpaper vibrancy. Shadow: `StyledRectangularShadow`
blur `0.9×elevationMargin(10)=9`, offset (0,1), spread 1, #000@0.30; `elevationMargin` doubles as
reserved layout margin. Waffle = two-layer key+ambient(1px border). `RippleButton` 1200ms,
standardDecel, farthest-corner. `MaterialSymbol` animates `fill` + binds `opsz`. `StyledListView`
add(scale+opacity pop-in)/remove(slide+overshoot)/displaced. `StyledText` auto-number-font +
animated text-change. **No stagger, no hover-scale (colour + bounce instead).**

**DankMaterialShell** — `Common/{Anims,Appearance,Theme,AnimVariants}.qml`. Same six M3 beziers.
User-tunable `baseDuration`(200) → whole family via multipliers; live speed tiers; a settings
"Typography & Motion" tab exposes it. `DankAnim`/`DankColorAnim` = 9-line pre-configured animation
subclasses (one-line call sites). Shared `Widgets/StateLayer.qml`: hover 0.08 / press 0.12,
`Behavior on color` ~100ms decel; M3 tokens `stateLayerHover0.08/Focus0.12/Pressed0.12/Drag0.16`.
Scales: press 0.98, hover 1.05, check 0.6→1, OSD 0.9→1. `DankRipple` gated by setting. `ElevationShadow`
= single-pass shader, key+ambient from one level; 5-step blur `4/8/12/16/20`, α`0.20→0.30`, ambient
= key·1.75/α·0.5, light-direction aware. Elevation→tint α `0.05/0.08/0.11/0.12/0.14`. `blend()`
lerp for containers; premultiplied-alpha colour tween. `ListViewTransitions` singleton (add/remove/
displaced/move) — **no per-index stagger**. `DankSpinner` (1568ms rot + 666ms 16°→270° arc),
`DankBlink` pulse 0.3↔1.0 600ms. Rhythm: spacing 2/4/8/12/16/24, type 12/14/16/20/24, icons
16/24/32, radii 8/12/16/24, one global `fontScale`.

**Noctalia v5 (C++/GL, conceptual only)** — `src/ui/style.h`: `animFast100/Normal200/Slow400`;
7-value polynomial easing engine (`EaseOutBack` exists but **dead code**). Global `MotionService`
speed/enable multiplier; separate `animateTimer()` bypasses it for effects that must ignore speed.
Convention **OutCubic in / InQuad out**. Shared `Button` = snapshot-from → lerp-to colours over
100ms (cancel-in-flight-and-restart). **Hover maps to the `tertiary` accent role** → buttons lerp
toward accent on hover (warmth, not grey). Depth = one über SDF frag shader: rounded rects with
per-corner **concave** corners (the signature notched silhouette) + in-shader drop shadow (blur
12px, #000@0.55×bg-opacity, with a same-shape **cutout** so shadow never paints under the surface).
SDF ring-with-notch spinner 1200ms. No stagger, no scale/ripple. Rhythm: spacing 4/8/12/16, radii
3/6/9/12 (3px step, live-scaled), heights 32/38/44, type 11/13/14/16/20.

### 18.4 Phase-2 recommendations (adopt, don't clone — pending user approval)

Maps the above onto the ROADMAP "Polish sprint" checklist. Ordered by leverage:

1. **Named motion tokens in `Commons/Appearance.anim`** — add curve presets, not just durations.
   Adopt the six M3 beziers (`standard`/`emphasized` + `*Accel`/`*Decel` + `expressive*Spatial`
   overshoot + `expressiveEffects`). Provide reusable `Anim`/`ColorAnim` wrappers (Dank/end-4
   `Component`-factory pattern) so call sites are one line. Keep our existing `fast/base/panel`
   as aliases so the ×125 existing call sites don't churn. Retire the dead `slow`/`spring`
   (rename `spring`→a real overshoot curve).
2. **Enter/exit asymmetry on high-traffic transitions** — panel/strip expand, popup enter/exit,
   tag switch, toggle: enter ≈400ms `emphasizedDecel`, exit ≈200ms `emphasizedAccel`; spatial
   growth gets `expressiveDefaultSpatial` overshoot, colour/opacity stays `expressiveEffects`.
3. **Shared micro-interaction primitive** (`Commons/Primitives/StateLayer.qml` or fold into
   `BarPill`/a `Focusable` base) — hover α0.08 / press α0.12 overlay + optional `scale 0.98`
   press-depress + `1.05` hover-grow, ~100ms decel. Respect the CurveRenderer/no-`layer.enabled`
   rule. Replaces per-widget hand-rolling. (Ripple optional, behind a config toggle.)
4. **Warmth & depth pass on the flat glass** — (a) accent-tinted hover (Noctalia idea): hover
   overlay = accent@~0.10 not grey; (b) elevation→surface-tint ladder for stacked surfaces; (c)
   a real shadow on floating panels/cards via `MultiEffect`/`RectangularShadow` using Caelestia's
   one-formula (animate dp for hover-lift) or Dank's key+ambient ladder; reserve blur margin
   (end-4 `elevationMargin` discipline) so it isn't clipped. Audit the pure-grey surface values.
5. **Appearance stagger on lists/panels** (notifications, launcher results, settings rows) —
   start with the free win (Qt `add`/`displaced` Transitions, scale+opacity pop-in), and add real
   `index*delay` stagger ourselves (the refs don't provide it). Empty-state entrance `scale 0.5→1`.
6. **Icon/type polish (optional, dependency-gated)** — `fill`/`opsz`/`grade` axis animation needs a
   variable icon font (Material Symbols); we ship FiraCode Nerd Font. Either add Material Symbols
   as an icon font or skip these. The animated-text-change and auto-number-font ideas work with
   any font and are cheap wins.
