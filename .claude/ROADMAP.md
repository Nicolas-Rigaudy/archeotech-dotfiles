# Roadmap

**Last Updated:** 2026-06-02  
**See also:** `ANALYSIS.md` — research, reference projects, confirmed QML APIs, settings ecosystem deep-dives.

---

## Project Vision

Archeotech is a **fully composable, community-extensible Quickshell shell** targeting MangoWC (primary), Hyprland, and Niri. The goal is a publishable v1.0 that anyone can install, customize, and extend without editing QML.

**Four pillars:**
1. **Module system** — every panel, widget, and bar element is a self-describing module (`module.json`). Drop a folder into `~/.local/share/archeotech/modules/` to install.
2. **Theme system** — themes are pure JSON + asset folders (`theme.json` + wallpaper + app-overrides). Drop into `themes/` to install.
3. **Visual builder** — drag-and-drop edit mode wires any module to any trigger (edge hover, bar icon, keyboard, desktop widget). Config persists to `DrawerConfig.json`, hot-reloads instantly.
4. **Compositor abstraction** — `CompositorService` facade means one codebase runs on MangoWC, Hyprland, and Niri.

**Target release:** v1.0 after Sprint 22 (Distribution). Subsequent sprints add depth (Go daemon, dev workflow, more themes).

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
| 18 | Configurable Sides + Widget Registry — Noctalia filename-convention registry (drop a file under `Widgets/Bar/` or `Widgets/Strip/`, add id to `shell-config.json` zone, done); async `BarWidgetLoader`/`StripWidgetLoader` with `setSource(path, props)` Noctalia pattern; formalized `barRoot`/`stripRoot` context APIs; primitives moved to `Commons/Primitives/`; HoverCard/CalendarPopup/WifiPopup/BtPopup extracted; ClockWidget + 12 bar widgets + 4 strip icons over `StripIconBase`; stable ListModel diff (HyprPanel preserve-delegates); `plugin:<id>` namespacing reserved for S20; Bar.qml 1537→299 LOC; `docs/WIDGET_API.md` written | 2026-06-02 |

**Sprint 3 — remaining items blocked on Quickshell 0.3.0** (track: `paru -Qu quickshell`):
- Audio → `Quickshell.Services.Pipewire`
- Network → `Quickshell.Networking`
- Battery → `Quickshell.Services.UPower`
- Idle inhibitor → `Quickshell.Wayland.IdleInhibitor`

---

## Upcoming Sprints

### Sprint 19 — Full System-Wide Theme Switcher ← NEXT

**Goal:** One `theme-switch.sh` invocation changes every app simultaneously. Quickshell already hot-reloads; this sprint wires in the rest. Also: redesign the theme picker UI — fluid card/swatch grid with wallpaper thumbnail and avatar logo preview, inspired by caelestia-dots / end-4 style.

**Architecture note:** Theme tokens must be **layout-agnostic** — no hardcoded assumptions about which side has a bar or strip. Themes provide colors, fonts, radii; the layout is controlled by `shell-config.json` (S17/S18). The theme picker overlay (`Super+Shift+T`) is an Item inside `ShellSurface`, not a separate PanelWindow.

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
- [ ] `Super+Shift+T` → theme picker overlay as Item inside ShellSurface (not a separate PanelWindow)
- [ ] `docs/THEME_SPEC.md` — complete theme folder structure, all required + optional fields, preview thumbnail spec (moved from old Sprint 17)

---

### Sprint 20 — Module Builder & Community Extension System

**Goal:** Visual UI for editing `shell-config.json`. Builds on the Widget Registry (S18). Adds module manifest discovery + desktop widget layer. After this, third parties can publish modules and themes that install by dropping a folder.

**Changes from original spec** (was old Sprint 17 — adjusted for new architecture):
- 🔁 **Click-to-assign** instead of drag-and-drop — cross-window drag is unreliable on Wayland (`ANALYSIS.md` line 2092). Workflow: click an empty slot, then click a module from the palette → assigned.
- 🔁 `DrawerConfig.json` → `shell-config.json` everywhere (matches S17 architecture)
- 🔁 `canLiveIn` enum is more granular: `["bar-zone:top.left", "bar-zone:top.center", "bar-zone:top.right", "strip-icon:right", "strip-icon:left", "strip-icon:bottom", "panel-content", "desktop-widget"]`
- ✅ Module manifest, ModuleRegistry, ~/.local/share/archeotech/modules/, DraggableWidget for desktop layer — unchanged (intra-window drag works fine on Wayland)

**Module manifest spec** (`module.json`):
```json
{
  "id": "control-center",
  "name": "Control Center",
  "author": "archeotech",
  "version": "1.0.0",
  "canLiveIn": ["panel-content", "desktop-widget"],
  "defaultSize": { "width": 340, "height": "auto" },
  "configSchema": {},
  "entry": "ControlCenter.qml"
}
```

**Checklist:**
- [ ] `module.json` spec finalized; `docs/MODULE_API.md` written
- [ ] `Modules/ModuleRegistry.qml` — singleton scanning `Modules/*/module.json` + `~/.local/share/archeotech/modules/*/module.json`, FileView watcher for hot-discovery
- [ ] Edit mode overlay (`Modules/Builder/EditOverlay.qml`) — full-screen glass surface inside ShellSurface, exit on `Escape` or `Super+Shift+E`
- [ ] **Click-to-assign** flow: click slot → palette opens → click module → assigned. Click occupied slot → unassign or open settings.
- [ ] Side type switcher (per-side: bar / strip / none) — toggles in edit overlay
- [ ] Bar configurator — Left / Center / Right zone slots per side, click-to-assign chips
- [ ] Strip icon configurator — Column of icon slots, click-to-assign
- [ ] Desktop widget layer (`Modules/DesktopWidgets/WidgetLayer.qml`) on `WlrLayer.Bottom` — separate PanelWindow, independent of ShellSurface
- [ ] `Modules/DesktopWidgets/DraggableWidget.qml` — intra-window drag (works on Wayland), grid snap, boundary clamp, persist x/y to config (Noctalia pattern)
- [ ] At least 3 desktop widgets: `DesktopClock`, `DesktopSystemStats`, `DesktopMediaPlayer`
- [ ] `~/.local/share/archeotech/modules/` — user module install path, scanned alongside built-in modules
- [ ] All edits write to `shell-config.json` → `ShellConfig` hot-reloads → shell reconfigures instantly

---

### Sprint 21 — Lock Screen (Native QML)

**Goal:** Replace swaylock with a first-class Quickshell component. Now that the design system (Sprint 12/13) and token system are in place, build it properly.

**Reference:** Qylock (source-inspected — `WlSessionLock` + `PamContext`, ~50 lines of real logic).

**Architecture note:** Lock screen is **independent of ShellSurface** — uses `WlSessionLock` + `WlSessionLockSurface` (ext-session-lock-v1 protocol). Compositor-level lock, not layershell.

**Checklist:**
- [ ] `Modules/LockScreen/LockScreen.qml` — `WlSessionLock` surface on all outputs
- [ ] Clock + date overlay on blurred/wallpaper background
- [ ] Password input (`echoMode: TextInput.Password`), PAM auth via `PamContext`
- [ ] Shake animation on failed auth, clear field
- [ ] Wire `swayidle` to `qs ipc call lock lock` (replaces `swaylock-launch.sh`)
- [ ] Triggered from CC power section + keybind

---

## Planned Sprints

### Sprint 22 — Settings Depth
Fill out Sprint 11's placeholder panes with full native implementations:
- Connections pane: WiFi sub-tab (known networks, forget, priority) + BT sub-tab (connected/paired/available per Noctalia model, battery level, signal)
- Audio pane: PipeWire sinks + sources (once QS 0.3.0 lands), device aliasing, per-device volume limit
- ColorScheme pane: dark mode toggle, schedule (off/manual/location), wallpaper color extraction toggle
- Settings search: fuzzy index per registered pane, max 15 results, sidebar search input
- **Layout pane** (new) — UI for `shell-config.json` side type switcher (top/right/bottom/left = bar/strip/none) + per-zone widget chooser. Bridge between current Settings and full Module Builder UI (Sprint 20). Lets users reconfigure sides from a familiar settings interface without needing the visual edit mode.

### Sprint 23 — Multi-Compositor Support

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

**Architecture validation tasks** (from S17 audit):
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

### Sprint 24 — Distribution & GitHub Release

**Goal:** Clean, documented, installable by a stranger on a fresh Arch Linux machine. Everything hardcoded to `/home/corvus` is gone. Module + theme APIs are documented. Community can publish extensions. **v1.0 milestone.**

**Checklist:**
- [ ] Hardcoded path audit — zero `/home/corvus` in any config or script; all paths via `$HOME` or `Paths.qml`
- [ ] `scripts/install-packages.sh` — full `paru -S` list for fresh Arch; split: required vs optional
- [ ] Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, service enable, verification
- [ ] `docs/INSTALL.md` — step-by-step for fresh Arch + MangoWC from zero; also Hyprland path; documents `shell-config.json` per-side configuration
- [ ] `docs/MODULE_API.md` — finalized (from S20); example module walkthrough
- [ ] `docs/THEME_SPEC.md` — finalized (from S19); community submission guidelines
- [ ] `docs/WIDGET_API.md` — finalized (from S18)
- [ ] README harden — screenshots of bar, OSD, CC, launcher, dashboard, settings, edit mode
- [ ] Demo GIF of edit mode + theme switching + per-side reconfiguration
- [ ] Version tag `v1.0.0` on first release
- [ ] GitHub repo description, topics, social preview
- [ ] `CONTRIBUTING.md` — how to submit a module, how to submit a theme

---

### Sprint 25 — Go Daemon
Only for raw Wayland protocols that QML can't reach natively:
- `archeotech-daemon` Go binary — Unix socket, newline-JSON RPC
- `Services/ArcheotechDaemon.qml` — Quickshell Socket, exponential-backoff reconnect
- Handles: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot)
- Does NOT handle: audio, network, BT, notifications, lock (all native QML)

### Sprint 26 — Dev Personality + Shadow Spear
- `themes/shadow-spear/` full theme package (compositor + kitty + starship raven sigil + rofi + wallpaper set)
- Git branch widget (`Widgets/Bar/GitWidget.qml`) — CWD from focused window, dims when no git context
- AWS profile widget (`Widgets/Bar/AwsWidget.qml`) — always visible, dims when `$AWS_PROFILE` unset
- Terraform workspace indicator (`Widgets/Bar/TerraformWidget.qml`) — shows `terraform workspace show`, only in tf repos
- Per-workspace wallpapers via `CompositorService.onTagSwitched` hook (S23 dependency)
- **Stretch:** SDF GLSL shader for corner blob (replaces ShapePath cubic bezier for ultra-smooth corners — Caelestia §15.2 line 2143)

---

## Feature Backlog

Well-defined features not yet scheduled into a sprint.

### Dev Workflow Bar Widgets
*(sprint 26 covers git + AWS + terraform; these are the rest. All become `Widgets/Bar/*.qml` files per S18 widget registry.)*
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
