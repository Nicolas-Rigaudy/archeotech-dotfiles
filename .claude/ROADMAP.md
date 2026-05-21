# Roadmap

**Last Updated:** 2026-05-21  
**See also:** `ANALYSIS.md` — research, reference projects, confirmed QML APIs, settings ecosystem deep-dives.

---

## Project Vision

Archeotech is a **fully composable, community-extensible Quickshell shell** targeting MangoWC (primary), Hyprland, and Niri. The goal is a publishable v1.0 that anyone can install, customize, and extend without editing QML.

**Four pillars:**
1. **Module system** — every panel, widget, and bar element is a self-describing module (`module.json`). Drop a folder into `~/.local/share/archeotech/modules/` to install.
2. **Theme system** — themes are pure JSON + asset folders (`theme.json` + wallpaper + app-overrides). Drop into `themes/` to install.
3. **Visual builder** — drag-and-drop edit mode wires any module to any trigger (edge hover, bar icon, keyboard, desktop widget). Config persists to `DrawerConfig.json`, hot-reloads instantly.
4. **Compositor abstraction** — `CompositorService` facade means one codebase runs on MangoWC, Hyprland, and Niri.

**Target release:** v1.0 after Sprint 21 (Distribution). Subsequent sprints add depth (Go daemon, dev workflow, more themes).

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

**Sprint 3 — remaining items blocked on Quickshell 0.3.0** (track: `paru -Qu quickshell`):
- Audio → `Quickshell.Services.Pipewire`
- Network → `Quickshell.Networking`
- Battery → `Quickshell.Services.UPower`
- Idle inhibitor → `Quickshell.Wayland.IdleInhibitor`

---

## Upcoming Sprints

### Sprint 14 — Mission Dashboard

**Goal:** `Super+Home` → full-screen overlay panel. Cyber-monastic mission briefing. All data from subprocess polling, no extra deps.

**Layout:**
```
┌──────────────────────────────────────────────────────────────────────┐
│  ARCHEOTECH-OS ── corvus@archeotech ──────────────────── 2026-05-19  │
│  ────────────────────────────────────────────────────────────────────│
│                                                                      │
│  ┌── SYSTEM STATUS ────────┐   ┌── ACTIVE PROJECTS ───────────────┐  │
│  │ CPU  ████░░░  42%       │   │ ● archeotech-dotfiles   main  ✗  │  │
│  │ RAM  ██████░  68%       │   │ ● work-project-alpha    dev   ✗  │  │
│  │ Disk ███░░░░  51%       │   │ ○ terraform-infra       main  ✔  │  │
│  │ Bat  ████░░░  72% ↑     │   └──────────────────────────────────┘  │
│  └─────────────────────────┘                                         │
│                               ┌── QUICK LAUNCH ─────────────────┐   │
│  ┌── SYSTEM NOTES ──────────┐ │  terminal  browser  code        │   │
│  │ Last snapshot: 2d ago    │ │  obsidian  lazygit   yazi       │   │
│  │ Pending updates: 3       │ └─────────────────────────────────┘   │
│  │ VPN: inactive            │                                        │
│  │ AWS: prod-account        │  ┌── TIP OF THE SESSION ────────────┐  │
│  └──────────────────────────┘  │ zoxide: `z proj` jumps to most  │  │
│                                │ visited matching directory       │  │
│                                └──────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

**Data sources (no extra deps):**
- System stats: `/proc/meminfo`, `/proc/stat`, `df`, `upower -i /org/freedesktop/UPower/devices/battery_BAT0`
- Active projects: scan `~/Projects/` + `~/Documents/repos/` for git repos → `git branch --show-current` + `git status --short`
- Snapshots: `snapper list` last entry date
- Pending updates: `checkupdates | wc -l`
- VPN: `nmcli con show --active | grep vpn`
- AWS: `$AWS_PROFILE` env
- Tips: curated flat text file (`assets/tips.txt`) — one tip per line, random on open

**Checklist:**
- [ ] `Modules/Dashboard/Dashboard.qml` — full-screen glass overlay, `PanelWindow` covering all outputs
- [ ] `Modules/Dashboard/panels/SystemStatus.qml` — CPU/RAM/Disk/Bat progress bars
- [ ] `Modules/Dashboard/panels/ActiveProjects.qml` — git repo scan via `Process`, branch + dirty flag
- [ ] `Modules/Dashboard/panels/SystemNotes.qml` — snapshot date, pending updates, VPN, AWS
- [ ] `Modules/Dashboard/panels/QuickLaunch.qml` — icon grid, click to launch
- [ ] `Modules/Dashboard/panels/TipOfSession.qml` — random line from `assets/tips.txt` via `FileView`
- [ ] Auto-shown for 4s on login (via autostart), then dismissed; shown on demand any time
- [ ] `Super+Home` keybind in mango config → `qs ipc call dashboard toggle`
- [ ] `Commons/State.dashboardVisible` + mutual exclusion
- [ ] `assets/tips.txt` — write 30+ tips covering all installed tools

---

### Sprint 15 — UI Architecture: Drawer Surface + Glassmorphism

**Goal:** Replace the per-panel PanelWindow approach with a single `DrawerSurface` overlay per monitor. All sliding panels become children of one shared coordinate space. Enable edge hover zones (caelestia-style). Apply consistent glassmorphism via a single MangoWC blur target.

**Architecture: Drawer Overlay hybrid**
- Bar stays as its own PanelWindow (untouched)
- New `DrawerSurface.qml` on `WlrLayer.Overlay` sits above everything
- CC, NC, Dashboard, Launcher all move inside DrawerSurface
- Panels anchor to `y = Appearance.bar.height` (top-bar) or `x = Appearance.bar.width` (left-bar) — true bar-origin animation
- `DrawerInteractions.qml` — edge hover zones mapping to `DrawerVisibilities`
- MangoWC applies blur once to the drawer's named layer namespace

**Edge interaction zones (caelestia-inspired):**
- Right edge → CC slides in from right
- Top-right corner → NC slides down
- Bottom edge (or `Super+Home`) → Dashboard slides up
- Top-left area / `Super+Space` → Launcher
- Left edge (left-bar mode only) → sidebar equivalent

**Glassmorphism visual spec (from YAHR-Quickshell source-inspection):**
- Panel bg: `Qt.rgba(r, g, b, 0.92)` — 92% opacity from Catppuccin mantle
- Border: 1px accent at 35% alpha
- Blur: MangoWC `layerrule = blur, namespace:archeotech-drawer`
- No solid `colors.base` backgrounds inside the drawer

**Critical design constraint — config-driven from day one:**
Sprint 15 must wire all panel-to-trigger mappings through `DrawerConfig.json` (not hardcode them), because Sprint 16 (Module Builder) adds the UI to edit that config. ~20 extra lines in Sprint 15, eliminates a full rewrite in Sprint 16.

**Checklist:**
- [ ] `Modules/Drawer/DrawerConfig.qml` — singleton reading `~/.config/quickshell/drawer-config.json` via `FileView`; properties: `barEdge`, `edgeRight`, `edgeLeft`, `edgeBottom`, `edgeTop`, `barModules[]`; hot-reloads on file change
- [ ] `Modules/Drawer/DrawerSurface.qml` — full-screen transparent PanelWindow, `WlrLayer.Overlay`, `WlrLayershell.namespace: "archeotech-drawer"`, mouse passthrough except on active panels; panel slots read from `DrawerConfig`
- [ ] `Modules/Drawer/DrawerVisibilities.qml` — singleton replacing `State.qml` per-panel booleans; `ccVisible`, `ncVisible`, `dashboardVisible`, `launcherVisible`; mutual exclusion logic
- [ ] `Modules/Drawer/DrawerInteractions.qml` — thin HoverHandler strips at screen edges; drag gesture detection; edge→panel mapping reads from `DrawerConfig`
- [ ] `Modules/Drawer/DrawerAnimations.qml` (or inline) — `offsetScale` pattern: one property 0.0↔1.0 drives both position and opacity; `Behavior` with `Anim.slow` easing
- [ ] Migrate `Modules/ControlCenter/ControlCenter.qml` into DrawerSurface — anchored right, slides from right edge
- [ ] Migrate `Modules/NotificationCenter/NotificationCenter.qml` into DrawerSurface — anchored top-right, slides down
- [ ] Migrate `Modules/Dashboard/Dashboard.qml` into DrawerSurface — anchored below bar, slides down
- [ ] Migrate `Modules/Launcher/Launcher.qml` into DrawerSurface — centered below bar, scale+opacity entrance
- [ ] Remove now-redundant per-panel PanelWindows from `shell.qml`
- [ ] `mango.conf`: add `layerrule = blur, namespace:archeotech-drawer`; remove `noblur` overrides for CC/NC/Dashboard
- [ ] `DrawerConfig.barEdge: "top" | "left"` — affects panel anchor points and edge zone positions
- [ ] Left-bar mode: DrawerSurface panels anchor to `x = barWidth`, edge zones swap axes
- [ ] Dashboard revisited inside new drawer — can now animate from bar origin correctly
- [ ] Ship default `drawer-config.json` with sensible defaults

---

### Sprint 16 — Module Builder & Community Extension System

**Goal:** Turn the shell into a fully composable platform. Every panel, widget, and bar element becomes a self-describing module with a manifest. A drag-and-drop edit mode lets users wire any module to any trigger (bar icon, edge hover, keyboard shortcut, desktop). Third parties can publish new modules and themes that install by dropping a folder.

**Why this sprint:** Once DrawerConfig exists (Sprint 15), the builder is a UI layer on top. Doing this before the Theme Switcher and Lock Screen means both of those can be built as installable modules that demonstrate the system.

**Module manifest spec** (`module.json`):
```json
{
  "id": "control-center",
  "name": "Control Center",
  "author": "archeotech",
  "version": "1.0.0",
  "canLiveIn": ["edge-panel", "bar-popout", "desktop-widget"],
  "defaultSize": { "width": 340, "height": "auto" },
  "configSchema": {},
  "entry": "ControlCenter.qml"
}
```

**ModuleRegistry** — scans `Modules/*/module.json` + `~/.local/share/archeotech/modules/*/module.json` (user-installed). FileView watcher picks up newly installed modules without shell restart.

**Edit mode** — activated via `Super+Shift+E` or a settings button. Overlay shows:
- All slot targets (edges, bar zones) as labelled drop zones
- Available modules as draggable chips with their icon + name
- Desktop widget grid with resize handles + drag-to-reorder (Noctalia-style grid snapping)
- On drop: writes to `DrawerConfig.json` → `DrawerConfig` hot-reloads → shell reconfigures instantly

**Bar configurator** — Left / Center / Right zones (DMS-style). In edit mode, bar modules are draggable chips within their zones. Zone contents persist to `DrawerConfig.barModules.left[]` etc.

**Desktop widget layer** — new `Modules/DesktopWidgets/` surface on `WlrLayer.Background` or `.Bottom`. In edit mode: widgets become draggable (Noctalia `DraggableDesktopWidget` pattern — MouseArea only active in edit mode, grid snap, boundary clamp, persist x/y to `DrawerConfig`).

**Theme spec for community publishing:**
```
themes/<name>/
  theme.json          — color tokens, fonts, radii, animation timings, metadata
  wallpaper.*         — default wallpaper (jpg/png)
  logo.svg            — optional theme avatar
  app-overrides/
    kitty-colors.conf
    starship.toml
    rofi-colors.rasi
  preview.jpg         — thumbnail shown in theme picker
```

**Checklist:**
- [ ] `module.json` spec finalized and documented in `docs/MODULE_API.md`
- [ ] `Modules/ModuleRegistry.qml` — singleton scanning module dirs, `list<QtObject> available`, FileView watcher for hot-discovery
- [ ] Edit mode overlay (`Modules/Builder/EditOverlay.qml`) — full-screen glass surface, slot drop zones, module chip palette, exit on `Escape` or `Super+Shift+E`
- [ ] Drag-and-drop: chips → slot targets write to `DrawerConfig.json` via JS `JSON.stringify`
- [ ] Bar configurator — zone slot UI in edit mode, drag chips between left/center/right
- [ ] Desktop widget layer (`Modules/DesktopWidgets/WidgetLayer.qml`) on `WlrLayer.Bottom`
- [ ] `Modules/DesktopWidgets/DraggableWidget.qml` — edit mode drag, grid snap, persist, z-raise on drag
- [ ] At least 3 desktop widgets to demonstrate the system: `DesktopClock`, `DesktopSystemStats`, `DesktopMediaPlayer`
- [ ] `~/.local/share/archeotech/modules/` — user module install path, scanned alongside built-in modules
- [ ] `docs/MODULE_API.md` — module manifest spec, QML entry point contract, config schema format
- [ ] `docs/THEME_SPEC.md` — complete theme folder structure, all required + optional fields, preview thumbnail spec
- [ ] Default `drawer-config.json` ships with the repo as the reference configuration

---

### Sprint 17 — Full System-Wide Theme Switcher

**Goal:** One `theme-switch.sh` invocation changes every app simultaneously. Quickshell already hot-reloads; this sprint wires in the rest. Also: redesign the theme picker UI — fluid card/swatch grid with wallpaper thumbnail and avatar logo preview, inspired by caelestia-dots / end-4 style.

**Layers to add (MangoWC + Quickshell + Kitty already done in Sprint 12/13):**

| Layer | Mechanism |
|-------|-----------|
| Starship | Config symlink swap (`~/.config/starship.toml` → `themes/<name>/starship.toml`) |
| Rofi | rasi variable file swap (`~/.config/rofi/colors.rasi` → per-theme) |
| GTK apps | `gsettings set org.gnome.desktop.interface` (gtk-theme + icon-theme + cursor-theme) |
| VSCode | `jq` patch on `~/.config/Code/User/settings.json` (`workbench.colorTheme`) |
| Obsidian | `jq` patch on vault `.obsidian/appearance.json` (`cssTheme`, `baseFontSize`) |
| Zen Browser | CSS file swap (`userChrome.css` → per-theme variant, best effort) |
| Wallpaper | `awww` transition to theme wallpaper family |
| swaylock | Config patch (`~/.config/swaylock/config`, bg tint) |

**Theme picker UI redesign:**
- Replace the current radio button list with a fluid card grid (2-3 cols) — each card shows: wallpaper thumbnail, theme name, accent color swatch strip
- Avatar/logo picker: per-theme logo option (raven sigil, mech crosshair, etc.) shown in card; click to override independently
- Animated transition between selected card (scale + border highlight)
- Wallpaper picker: file browser row below the cards, or a separate tab in AppearancePane
- Reference: caelestia-dots AppearancePage, end-4 quickshell theme overlay

**Checklist:**
- [ ] `scripts/theme-switch.sh` extended — Starship symlink, rofi rasi swap, `gsettings`, VSCode `jq` patch, Obsidian `jq` patch, Zen CSS swap, wallpaper, swaylock
- [ ] Per-theme starship config stubs in `themes/<name>/starship.toml`
- [ ] Per-theme rofi colors stub in `themes/<name>/rofi-colors.rasi`
- [ ] AppearancePane card grid redesign — wallpaper thumbnail + accent swatches per card
- [ ] Wallpaper picker (file row or sub-tab) wired to `awww`
- [ ] Per-theme logo/avatar field in `theme.json`, picker in card
- [ ] `Super+Shift+T` → theme picker overlay (dedicated Quickshell panel, not Settings window)

---

### Sprint 18 — Lock Screen (Native QML)

**Goal:** Replace swaylock with a first-class Quickshell component. Now that the design system (Sprint 12/13) and token system are in place, build it properly.

**Reference:** Qylock (source-inspected — WlSessionLock + PamContext, ~50 lines of real logic).

**Checklist:**
- [ ] `Modules/LockScreen/LockScreen.qml` — `WlSessionLock` surface on all outputs
- [ ] Clock + date overlay on blurred/wallpaper background
- [ ] Password input (`echoMode: TextInput.Password`), PAM auth via `PamContext`
- [ ] Shake animation on failed auth, clear field
- [ ] Wire `swayidle` to `qs ipc call lock lock` (replaces `swaylock-launch.sh`)
- [ ] Triggered from CC power section + keybind

---

## Planned Sprints

### Sprint 19 — Settings Depth
Fill out Sprint 11's placeholder panes with full native implementations:
- Connections pane: WiFi sub-tab (known networks, forget, priority) + BT sub-tab (connected/paired/available per Noctalia model, battery level, signal)
- Audio pane: PipeWire sinks + sources (once QS 0.3.0 lands), device aliasing, per-device volume limit
- ColorScheme pane: dark mode toggle, schedule (off/manual/location), wallpaper color extraction toggle
- Settings search: fuzzy index per registered pane, max 15 results, sidebar search input

### Sprint 20 — Multi-Compositor Support

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

**Checklist:**
- [ ] `Services/Compositor/CompositorService.qml` — detects active compositor on startup (`$XDG_CURRENT_DESKTOP`, `$WAYLAND_DISPLAY` hints), delegates to detected backend
- [ ] `Services/Compositor/MangoService.qml` — current `mmsg -w` subprocess pattern, promotes to primary backend
- [ ] `Services/Compositor/HyprlandService.qml` — Hyprland IPC socket (`/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.ipc`), workspace + window events
- [ ] `Services/Compositor/NiriService.qml` — Niri IPC socket (`$NIRI_SOCKET`), JSON event stream
- [ ] Replace all direct MangoWC calls in bar/modules with `CompositorService.*`
- [ ] `docs/COMPOSITOR_SUPPORT.md` — supported compositors, how to add a new backend
- [ ] Test on Hyprland (backup compositor already in the repo)

---

### Sprint 21 — Distribution & GitHub Release

**Goal:** Clean, documented, installable by a stranger on a fresh Arch Linux machine. Everything hardcoded to `/home/corvus` is gone. Module + theme APIs are documented. Community can publish extensions.

**Checklist:**
- [ ] Hardcoded path audit — zero `/home/corvus` in any config or script; all paths via `$HOME` or `Paths.qml`
- [ ] `scripts/install-packages.sh` — full `paru -S` list for fresh Arch; split: required vs optional
- [ ] Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, service enable, verification
- [ ] `docs/INSTALL.md` — step-by-step for fresh Arch + MangoWC from zero; also Hyprland path
- [ ] `docs/MODULE_API.md` — finalize from Sprint 16 draft; add example module walkthrough
- [ ] `docs/THEME_SPEC.md` — finalize from Sprint 16 draft; add community submission guidelines
- [ ] README harden — screenshots of bar, OSD, CC, launcher, dashboard, settings, edit mode
- [ ] Demo GIF of edit mode + theme switching
- [ ] Version tag `v1.0.0` on first release
- [ ] GitHub repo description, topics, social preview
- [ ] `CONTRIBUTING.md` — how to submit a module, how to submit a theme

---

### Sprint 22 — Go Daemon
Only for raw Wayland protocols that QML can't reach natively:
- `archeotech-daemon` Go binary — Unix socket, newline-JSON RPC
- `Services/ArcheotechDaemon.qml` — Quickshell Socket, exponential-backoff reconnect
- Handles: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot)
- Does NOT handle: audio, network, BT, notifications, lock (all native QML)

### Sprint 23 — Dev Personality + Shadow Spear
- `themes/shadow-spear/` full theme package (compositor + kitty + starship raven sigil + rofi + wallpaper set)
- Git branch module in bar — CWD from focused window, dims when no git context
- AWS profile module in bar — always visible, dims when `$AWS_PROFILE` unset
- Terraform workspace indicator — shows `terraform workspace show`, only in tf repos
- Per-workspace wallpapers via tag-switch hook

---

## Feature Backlog

Well-defined features not yet scheduled into a sprint.

### Dev Workflow Bar Modules
*(sprint 23 covers git + AWS + terraform; these are the rest)*
- Docker containers count badge — click to open btop or lazydocker
- Keyboard layout indicator — QWERTY/AZERTY, reflected from MangoWC `keyboardLayout` state
- Caps Lock indicator — low priority, currently undetected

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
