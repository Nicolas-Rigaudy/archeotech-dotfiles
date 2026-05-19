# Archeotech Dotfiles — Full System Analysis

**Last Updated:** 2026-05-19  
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
