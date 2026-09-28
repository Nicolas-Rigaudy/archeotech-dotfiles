# Archeotech — Feature-set & UX audit vs. the 2026 state of the art

Audit date: 2026-09-28. Scope: `~/Projects/archeotech-shell` (HEAD `e94770f`, 207 commits) plus the shell-adjacent
pieces that live in `archeotech-dotfiles` (mango keybinds, rofi scripts, swayidle/hyprlock). Read-only; nothing was run.
Builds on `.claude/ANALYSIS.md` §2 (architecture catalogue, 2026-05) and §20 (motion/applet/visual sweep, 2026-09).
Those passes were mostly about *how to build* and *how it looks*. This one asks *what it does* and *how it feels to use*.

Paths without a prefix are relative to `archeotech-shell/`. `dotfiles:` = `archeotech-dotfiles/`.

---

## 0. TL;DR

- **Where Archeotech is ahead.** It is the only shell in this field that treats *layout and look* as user data you edit
  in place: a WYSIWYG builder, swappable widget faces, theme packs with style delegates, ornaments/FX, and window
  decoration pushed to the compositor. It also has a real multi-surface theme applier (kitty, rofi, GTK, fish, starship,
  zen, VSCode), first-class MangoWC support, and a strong *engineering* baseline: a CompositorService facade, the
  shot.sh headless harness, and logics-driven planning. Nobody else combines the curated identity-pack model with the
  WYSIWYG edit mode.
- **Where it is behind.** Everything in the "daily-driver utility" layer is either missing, handed off to rofi/hyprlock
  scripts outside the shell, or rough. That covers clipboard, emoji, window switching, files, a notification model with
  actions and grouping, quick-settings toggles, a native lock, an idle UI, a keybind cheatsheet, a session menu and
  weather/calendar. In 2026, DMS 1.6, Noctalia 5, Caelestia and end-4/ii all ship all of these *inside* the shell. The
  launcher has 3 providers (settings / power / calc); DMS Spotlight has ~8 plus 330+ plugins.
- **Integrity bugs that break design rule #6 ("no fake toggles").** All 4 Notifications-pane settings are
  **write-only**: nothing reads them. The toast timeout is hardcoded at 5 s, max-toasts is not enforced, and DnD is
  never persisted. The README advertises a "keybind" trigger for modules that does not exist. Hyprland parity is
  partial (no fullscreen detection, no clients list).
- **The biggest opportunity is the one competitors don't serve: the dev/cloud workflow.** Everybody else optimizes for
  ricers. This user context-switches between AWS accounts, repos and work↔home docks all day. A **Context** primitive
  (project + AWS profile + kube ctx + monitor loadout + focus mode + workspace apps) surfaced in the bar, launcher and
  dashboard would be unique and highly valuable. Next come a launcher that is a real command palette, and a Claude
  "ask" surface.

---

## 1. Feature inventory (today)

Maturity: **Solid** = works, bound to real state, polished. **Rough** = works but has gaps, shell-outs or UX holes.
**Stub** = placeholder, demo or not wired. **External** = the feature exists for the user, but outside the shell (rofi,
hyprlock, scripts).

### 1.1 Frame, bar, strips, layout

| Feature | Maturity | Refs / notes |
|---|---|---|
| One full-screen surface per monitor: frame + 4 sides (bar/strip/none) + panels in one coord space; exclusion windows | Solid | `Modules/Shell/ShellSurface.qml`, `ShellExclusions.qml`, `FrameBackground.qml` |
| Edge **strips** (collapsed 10px → hover-expands to a 240px icon card) | Solid | `Modules/Shell/Sides/Strip.qml` (506 lines) |
| Top **bar** with left/center/right zones, H/V orientation-aware widgets | Solid | `Modules/Shell/Sides/Bar.qml`, `WidgetLoader.qml` |
| Per-screen overrides (`perScreen` in shell-config.json) | Rough | `Services/Shell/ShellConfig.qml:39`. Exists in config, but no UI in the builder to author per-monitor layouts |
| Auto-hide sides in fullscreen + manual hide (Super+Shift+H) | Solid on Mango / **broken on Hyprland** | `ShellState.sidesHidden`. `HyprlandService.isFullscreen()` returns `false` (`Services/Compositor/HyprlandService.qml:55`) |
| **Visual builder / edit mode** (WYSIWYG edge mocks, always-visible widget library, click-to-assign + intra-surface drag) | Solid (differentiator) | `Modules/Shell/Builder/EditOverlay.qml` (972 lines), item_022/097/099 Done |
| Per-instance widget config via `configSchema` → auto-form | Solid | `Modules/Settings/Widgets/ConfigForm.qml`, `Services/Shell/WidgetRegistry.qml` |
| **Swappable faces** (dashboard cards, media panel) | Solid (differentiator) | `Modules/Shell/FaceHost.qml`, `Modules/Dashboard/panels/faces/*` |
| Layout loadouts (named layout snapshots) | Missing | item_013 Ready |
| Window HUD corner brackets on real windows (pack FX) | Solid on Mango / none on Hyprland | `Modules/Shell/WindowBrackets.qml`. `HyprlandService.clientsFor()` returns `[]` |

### 1.2 Bar widgets (`Widgets/Bar/`)

| Widget | Maturity | Notes |
|---|---|---|
| Workspaces (tag dots, click to switch, 3D glass) | Solid | `WorkspacesWidget.qml`. No window icons per tag, no scroll-to-cycle, no drag-to-move |
| Title | Solid | `TitleWidget.qml` |
| Media marquee → MediaPanel | Solid | `MediaWidget.qml`, `Modules/Shell/Panels/Content/MediaPanel.qml` (full/compact faces) |
| Clock + calendar popup | Rough | `ClockWidget.qml`, `CalendarPopup.qml`: month grid only, **no events** (no vdir/CalDAV/khal) |
| Volume (click mute, wheel ±5) / Mic (click mute) | Solid | `VolumeWidget.qml`, `MicWidget.qml`. Native Pipewire (`Services/Media/Audio.qml`) |
| Brightness | Rough | `Services/Hardware/Brightness.qml` uses `brightnessctl` only, so **no DDC/CI for external monitors** (the user has 2–3 externals) |
| Network + WiFi popup (toggle, scan, connect) | Solid | `NetworkWidget.qml`, `WifiPopup.qml`, `Services/Networking/Network.qml` |
| Bluetooth + BT popup (event-driven, pair agent) | Solid | `BluetoothWidget.qml`, `BtPopup.qml`, `scripts/bt-agent.py` |
| Battery | Solid | `BatteryWidget.qml`. Alerts come from an external `scripts/battery-alert.sh` |
| Notifications badge | Solid | `NotificationsWidget.qml` |
| System tray (SNI, DBusMenu) | Rough | `TrayWidget.qml`. The context menu is the unthemed Qt platform menu (item_039 Ready) |
| Settings / Power buttons / generic panel opener | Solid / External / Solid | `PowerWidget.qml` spawns **wlogout** |
| VPN | Rough | `Services/Networking/VPN.qml`: nmcli toggle, shown in Settings, no bar widget |
| Keyboard layout / CapsLock / Docker | Missing (layout wiring partial) | item_023 |
| Git / AWS / Terraform bar widgets | Missing | item_023 notes that "Sprint 27" was meant to cover them. Never built |

### 1.3 Panels

| Panel | Maturity | Refs / notes |
|---|---|---|
| **Launcher** (fuzzy apps, usage-ranked, pins, recents, + settings deep-links, power actions, calculator) | Rough→Solid | `Modules/Shell/Panels/Content/Launcher.qml` (799 lines). Provider list at `:221` = `[_provSettings, _provPower, _provCalc]`. Calc is a whitelisted `Function()` eval (no units, currency or qalc). **No prefixes/modes, no clipboard, emoji, files, windows, web, commands or plugin providers** |
| **Dashboard** ("base of operations" hero + 2×2 bento) | Solid, a genuine dev angle | `Modules/Shell/Panels/Content/Dashboard.qml`; `ActiveProjects.qml` (git branch + dirty count over `dashboard.scanRoots`, opens VSCode + kitty); `QuickLaunch.qml` (8 hardcoded tiles); `SystemNotes.qml` (snapper, updates, AUR, VPN, **`$AWS_PROFILE` of the shell process**, uptime, IP); `SystemStatus` + 3 faces; `TipOfSession.qml`. Customizable grid, pinnable projects and custom notes are items 046/047/049 |
| **Notification Center** | Rough | `Modules/Shell/Panels/Content/NotificationCenter.qml`, `Services/System/Notifications.qml`: flat list, dismiss, clear all, DnD toggle. `actionsSupported: false`, **no actions, no inline reply, no images, no grouping by app, history not persisted across restarts, no keyboard nav** |
| **Toasts** | Rough | `shell.qml:220-330`, `Modules/NotificationCenter/NotifToast.qml`. Critical urgency never expires (good). Timeout is hardcoded (`NotifToast.qml:55-62`), toasts appear only on the top-right of whichever output the layer lands on, and there are no actions |
| Media panel | Solid | `MediaPanel.qml`, `faces/MediaFull.qml`, `MediaCompact.qml` |
| Wallpaper picker (carousel, thumbnails, logo overlay) | Solid | `WallpaperPicker.qml`, `Widgets/Appearance/WallpaperPickerBody.qml`, `scripts/wallpaper-set.sh` |
| Tiling layout picker (Super+Shift+T) | Solid (Mango-specific differentiator) | `LayoutPicker.qml`, `Widgets/Appearance/LayoutPickerBody.qml` |
| Settings (9 panes, sidebar, search index, `openPane` IPC) | Rough | `Modules/Settings/*`. Detailed in §3.9 |
| Quick notes / Hello (plugin demos) | Stub | `modules/notes/Notes.qml` (42 lines), `modules/hello/` |
| Plugin system (drop-a-folder modules, manifest, official/verified, minShellVersion, deps) | Solid core, **no install/registry** | `Services/Shell/ModuleRegistry.qml`, `docs/MODULE_API.md`, Plugins pane. Install mechanism = item_065 Ready. `desktop-widget` target is ⏳ |

### 1.4 System surfaces

| Surface | Maturity | Notes |
|---|---|---|
| OSD (volume, brightness; per screen) | Rough | `Modules/OSD/Osd.qml`. **Volume/brightness only**, and triggered by the *keybind* calling IPC (dotfiles `mango/config.conf` binds). Volume changes made elsewhere (pavucontrol, a headset button) show no OSD. There is no mic-mute, caps/num-lock, kbd-layout, power-profile or media-track OSD. OSD shows on **all** screens (`shell.qml:255`) |
| Lock screen | External | hyprlock (`scripts/hyprlock-launch.sh`, templated `scripts/themes/templates/hyprlock.conf.tmpl`). Not native, not live-themed beyond the template; item_018 (config generator) Ready |
| Idle | External + Rough | Power pane writes `~/.cache/swayidle.conf` and runs `~/.config/swayidle/config.sh` (`Modules/Settings/Panes/PowerPane.qml:48-79`). That script lives in **dotfiles**, so a stranger installing the shell gets a pane that silently does nothing. No caffeine/inhibit toggle |
| Session / power menu | External | wlogout (`scripts/wlogout-launch.sh`) + launcher power actions |
| Night light | Rough | `DisplayPane.qml` spawns wlsunset with 3 fixed temps. There is no schedule UI (the theme day/night schedule exists separately in `Services/Theming/ColorScheme.qml`) |
| Display layout | Rough | `DisplayPane.qml`: wlr-randr "Extend / Mirror / Laptop / External" presets + "open wdisplays". Hotplug re-apply lives in dotfiles `scripts/monitor-hotplug.sh` |
| Power profiles | Solid | `PowerPane.qml` → `powerprofilesctl` |
| Theme system (family→flavor→accent, day/night auto, ~11 external targets, packs with tokens/styles/ornaments/fonts/window decor) | Solid (flagship differentiator) | `scripts/theme-switch.py`, `Services/Theming/*`, `Services/Shell/PackRegistry.qml`, `packs/{grimdark,hud,angular}`, `docs/THEME_SPEC.md`, `docs/THEME_PACK.md`, `shell.qml:95-127` |
| IPC surface | Solid but ad-hoc | `shell.qml` targets: theme, notifications, launcher, settings(+openPane), dashboard, sides, wallpaper, media, layout, editmode, osd. **No generic `panel open <id>`**, so plugin panels can't be keybound. That also contradicts README ("wire any module to any trigger … keybind") |

### 1.5 Outside the shell (what the user actually uses day to day; dotfiles `mango/config.conf`)

| Need | How it's met today |
|---|---|
| Clipboard | `Super+V` → `cliphist list \| rofi -dmenu` |
| Screenshot | `Super+S/P`, Print → grim/slurp → file + wl-copy. No annotate, no OCR, no record |
| Color picker | `Super+Shift+C` → wl-color-picker |
| Project jump | `Super+Ctrl+P` → dotfiles `scripts/project-jump.sh` (rofi) — **duplicates** the Dashboard ActiveProjects card |
| Keybind help | `Super+K` → dotfiles `scripts/show-keybinds.sh` (rofi) |
| Cheatsheets | `Super+Shift+N` → navi in kitty |
| Window switch | `Alt+Tab` → mango `togglejump`; `Super+A` → mango overview |
| Scratchpad | `Super+grave` → named kitty scratchpad |
| Gaming mode | `Super+Ctrl+G` → `gaming-mode.sh` |

The pattern: the **shell owns look and layout, while rofi and scripts own utility.** This split is the root of most
UX inconsistency (rofi menus don't share the panel's focus/Esc/click-out model, the theme-pack chrome, or the search
index).

---

## 2. Competitor matrix (2026)

Snapshot of the field as of Sept 2026:

- **DankMaterialShell 1.6 "Marble Tabby"** (2026-09-03). Quickshell + Go daemon, 330+ plugins, multi-registry
  lockfiles, *Dank Island* bar with drag-drop home faces, dank-greeter with face unlock, dcal (Google, MS, CalDAV,
  iCloud), dsearch file index, dgop process monitor, clipboard with image previews, keybind cheatsheet provider,
  backup/restore, WCAG contrast badges. First-class MangoWC.
  <https://danklinux.com/blog/v1-6-release> · <https://github.com/AvengeMedia/DankMaterialShell> ·
  <https://github.com/AvengeMedia/DankMaterialShell/blob/master/docs/IPC.md> ·
  <https://github.com/AvengeMedia/DankLinux-Docs/blob/master/docs/dankmaterialshell/cli-keybinds-cheatsheets.mdx>
- **Noctalia 5.0.1** (2026-09-03). **Ground-up C++/OpenGL ES rewrite, dropped Qt**, ~6× less RAM per monitor, one
  TOML config with hot reload, **Luau plugins** (24 official), vdir calendar, MRU window switching, per-app dark/light,
  first-class Mango/dwl. No v4→v5 migration.
  <https://github.com/noctalia-dev/noctalia> ·
  <https://byteiota.com/noctalia-5-wayland-desktop-shell-stable-cpp-rewrite/> ·
  <https://www.linuxcompatible.org/story/noctalia-501-stable-release-groundup-rewrite-and-6x-memory-reduction-for-linux/>
- **Caelestia** (active; repo updated 2026-09-27). Morphing drawers, launcher actions (qalc calc, scheme/wallpaper/
  variant, session), VPN manager with live stats, Howdy face unlock on lock, per-monitor config, GIF/video wallpapers
  in forks. <https://github.com/caelestia-dots/shell> · <https://github.com/caelestia-dots/shell/releases>
- **end-4 / illogical-impulse (Quickshell)**. Overview with live previews + drag-drop, **AI sidebar (Gemini/Ollama/…)
  one keybind away**, Circle-to-Search / Lens, screen translation, anti-flashbang, on-screen keyboard, cheatsheet.
  <https://github.com/end-4/dots-hyprland> · <https://ii.clsty.link/en/>
- **Ambxst** (successor of **Ax-Shell, archived 2026-01-29**). Single-PanelWindow design, notch, AI assistant sidebar
  (any provider via curl template, keystore-backed creds, image attachments), clipboard, OCR, QR, gpu-screen-recorder,
  game mode, presets. <https://github.com/Axenide/Ambxst> · <https://axeni.de/ambxst/changelog/> ·
  <https://github.com/Axenide/Ax-Shell>
- **HyprPanel**: **archived 2026-04-27**, maintenance mode, author moved to Rust *Wayle*.
  <https://github.com/Jas-SinghFSU/HyprPanel>
- **Vicinae** (not a shell; the launcher bar to beat). Native C++/Qt Raycast-compatible launcher that **runs Raycast
  extensions** (React/TS), Wayland-first. <https://github.com/vicinaehq/vicinae> · <https://docs.vicinae.com/>
- Newcomers riding the DMS fork wave: HyprMaterialShell, CyShell (<https://github.com/HyprArch-org/HyprMaterialShell>,
  <https://github.com/Cytech-Team/CyShell-Desktop>), iNiR (ii for niri, <https://github.com/snowarch/iNiR>).
  Differentiation by look is getting crowded. Differentiation by *workflow* is not.

Two meta-trends: **(a)** the big shells are becoming *platforms*, with daemons, registries, greeters and calendar
backends. **(b)** Noctalia's rewrite reframes Qt/QML memory as a competitive axis. Archeotech should not chase either
wholesale (principle #1, single user), but it should borrow **registries and providers** and **stay honest about
resource use** (Iris Xe laptop, 3 monitors).

### 2.1 Matrix — ✅ ships · ◐ partial/external · ✗ missing

| Capability | Archeotech | DMS 1.6 | Noctalia 5 | Caelestia | end-4 ii | Ambxst |
|---|---|---|---|---|---|---|
| App launcher, fuzzy + usage | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Launcher calculator | ◐ (JS eval) | ✅ | ✅ | ✅ qalc | ✅ | ✅ |
| Launcher settings deep-links | ✅ | ✅ | ✅ | ◐ | ◐ | ◐ |
| Launcher prefixes / modes | ✗ | ✅ | ✅ | ✅ (`>` actions) | ✅ | ✅ |
| Clipboard history (image previews) in-shell | ◐ rofi | ✅ | ✅ | ◐ | ✅ | ✅ |
| Emoji / symbol picker | ✗ | ✅ | ✅ | ◐ forks | ✅ | ✅ |
| Window switcher / MRU | ◐ mango native | ✅ | ✅ MRU | ◐ | ✅ overview | ✅ |
| File search | ✗ | ✅ dsearch | ◐ | ✗ | ✗ | ◐ |
| Web search / quicklinks | ✗ | ✅ | ◐ | ✗ | ✅ | ◐ |
| Launcher plugins | ✗ (modules can't add providers) | ✅ | ✅ Luau | ◐ custom actions | ◐ | ◐ |
| Notif actions / reply / images | ✗ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Notif grouping + keyboard nav | ✗ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Notif history persisted | ✗ | ✅ | ✅ | ◐ | ✅ | ✅ |
| Quick-settings toggles panel | ◐ (dissolved into bar popups, adr_011) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Native lock (WlSessionLock + PAM) | ✗ hyprlock | ✅ | ✅ | ✅ (+Howdy) | ✅ | ✅ |
| Greeter | ✗ SDDM | ✅ dank-greeter | ✗ | ✗ | ✗ | ✗ |
| Idle manager + caffeine | ◐ external swayidle | ✅ AC/battery split | ✅ | ◐ | ✅ | ✅ |
| OSD beyond vol/bright | ✗ | ✅ | ✅ | ✅ mic | ✅ | ✅ |
| Session menu in-shell | ◐ wlogout | ✅ | ✅ | ✅ | ✅ | ✅ |
| Calendar events | ✗ | ✅ dcal | ✅ vdir | ✗ | ◐ | ◐ |
| Weather | ✗ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Process monitor / kill | ✗ (btop tile) | ✅ dgop | ◐ | ◐ | ◐ | ✅ |
| Screenshot/record/OCR in-shell | ◐ grim binds | ✅ | ◐ | ◐ | ✅ lens/OCR | ✅ |
| Keybind cheatsheet in-shell | ◐ rofi | ✅ | ◐ | ✗ | ✅ | ✅ |
| AI assistant | ✗ | ◐ plugin | ◐ plugin | ✗ | ✅ | ✅ |
| Workspace overview w/ previews | ◐ mango native | ◐ | ◐ | ✗ | ✅ | ◐ |
| DDC/CI external brightness | ✗ | ✅ | ✅ | ◐ | ◐ | ◐ |
| Plugin install / registry | ✗ (drop-folder only) | ✅ 330+ | ✅ 24 official | ✗ | ✗ | ◐ |
| Backup/restore of settings | ✗ (it's git, for this user) | ✅ | ✗ | ✗ | ✗ | ◐ |
| **WYSIWYG layout builder** | **✅** | ◐ island faces | ◐ | ✗ | ✗ | ◐ |
| **Swappable widget faces** | **✅** | ◐ island | ✗ | ✗ | ✗ | ◐ variants |
| **Curated identity packs (tokens + style delegates + ornaments + window decor)** | **✅** | ✗ (matugen) | ◐ palettes | ✗ (matugen) | ✗ (matugen) | ◐ presets |
| **External-app theme applier (~11 targets, curated palettes)** | **✅** | ◐ | ◐ | ◐ | ◐ | ◐ |
| **Tiling-layout picker (visual)** | **✅** | ✗ | ✗ | ✗ | ✗ | ✗ |
| **Dev dashboard (repos + git state + AWS)** | **◐ (unique seed)** | ✗ | ✗ | ✗ | ✗ | ✗ |
| Headless visual test harness | **✅ shot.sh** | ✗ | ✗ | ✗ | ✗ | ✗ |

### 2.2 Genuine differentiators (protect and lean into)

1. **Edit-in-place builder + faces + packs.** This is the "personal OS" story. Keep investing, but it is already ahead;
   the marginal user value is now lower than the utility gaps.
2. **Curated, not generated, identity.** Everyone else pipes wallpaper→matugen. Archeotech's hand-authored families and
   packs (grimdark/HUD/angular, WH40K flagship item_082) are a distinct aesthetic position.
3. **MangoWC-native depth.** The scroller proportion, layout picker, and window brackets from client geometry. Mango
   is small and underserved.
4. **Work-first dev seed.** The Dashboard's ActiveProjects and SystemNotes (snapper/AUR/VPN/AWS) are the only
   "developer console" in the field. This should become the product's centre of gravity for *this* user.

---

## 3. UX audit

### 3.1 Keyboard-first flows

- **Good.** Every panel has an IPC target and most have a Super bind. The launcher is keyboard-first (item_016 Done).
  Esc and click-out work via PanelHost.
- **Gaps.**
  - Keyboard handling exists only in Launcher, Settings sidebar, Strip, BarPanel, LayoutPicker and EditOverlay (grep
    `Keys.`). **Notification Center, Dashboard, Media, Wallpaper and Wifi/BT popups have no arrow/Enter navigation.**
    A keyboard user can open the NC but cannot act on a notification.
  - There is no "focus the bar" mode (DMS/KDE-style `Super+Alt` to walk bar widgets). Wifi/BT popups are mouse-only.
  - Launcher: no Tab-to-cycle between result sections, no `Ctrl+number` quick-select, no secondary actions on a result
    (Raycast `Cmd+K` action panel: open / copy path / open in terminal / reveal).
  - Bind sprawl. ~20 shell-related Super binds across dotfiles `mango/config.conf:223-403`, and some collide in
    intent (`Super+,` and `Super+Shift+S` both toggle settings). Recommendation: **one command palette**
    (Super+Space/Super+R) with prefixes, and keep only the 6–8 highest-frequency direct binds.

### 3.2 Discoverability

- `TipOfSession` is a nice touch. The settings search index (`PaneRegistry.qml:34`) is **hand-authored** and drifts:
  22 entries, and panes don't self-register.
- There is **no in-shell keybind cheatsheet** (rofi `show-keybinds.sh` instead). DMS parses compositor configs into an
  overlay (`dms ipc call keybinds toggle hyprland`). Mango's config is line-oriented `bind=MOD,key,action,args`, which
  is trivial to parse. Add comments as descriptions (the user's config already has comment lines above binds).
- Hover affordances on the thin strips are invisible to a stranger (a 10px band with no hint). Consider a one-time
  pulse on first run and a tooltip showing the bind.

### 3.3 Launcher power (the biggest single gap)

Today: apps (fuzzy, usage-weighted, pins, recents), settings deep-links, 5 power actions, arithmetic.
`Launcher.qml:221` already has a clean **provider registry** (`_providers`), which is the right seam.

Missing, in value order for this user:
1. **Prefix modes** (`>` commands, `=` calc, `:` emoji, `v` clipboard, `w` windows, `/` files, `p` projects,
   `aws` profiles, `?` web/ask). Plus a mode chip in the search field, so the prefix is discoverable.
2. **Clipboard provider** over cliphist, with image thumbnails (`cliphist decode` → cache png), pin (item_025) and
   delete. Retire the rofi Super+V.
3. **Window provider**: search open windows (Mango `get all-clients`, already parsed in `MangoService.clients`) and
   focus with `focusclient`. This is effectively an MRU switcher for free.
4. **Projects provider**: the ActiveProjects scan moves into a service, with actions open-in-code / kitty / lazygit /
   copy-path. Retire dotfiles `project-jump.sh` (it duplicates the card).
5. **Emoji / nerd-glyph provider**: bundled JSON. Nerd-font glyphs matter here; the codebase is full of them.
6. **Calc upgrade**: `qalc -t` for units, currency, hex/bin, dates (the Caelestia approach). Keep JS eval as a
   fallback.
7. **Command / script provider**: user-defined `~/.config/archeotech/commands/*.json` (`{name, icon, cmd, kw}`), i.e.
   Raycast "script commands". This is also what theme switches, gaming-mode, sides-hide and monitor presets become.
8. **Web / quicklinks**: `g foo`, `gh repo`, `aws s3 bucket`, `jira KEY-1`, templated URLs.
9. **Module-contributed providers**: let a `module.json` declare `"launcherProvider": "Provider.qml"`. This is
   the plugin story competitors monetize (DMS, Vicinae).
10. Secondary-action panel (Ctrl+K / Tab) and result previews (a right pane for clipboard images and file previews).

### 3.4 Notifications

- `actionsSupported: false` (`Services/System/Notifications.qml:17`). A dev lives on actionable notifications (Slack
  "Reply", CI "Open", calendar "Join", browser "Open"). That makes this the #1 correctness gap in the notification
  stack.
- There is no `image`/`hints.image-data` rendering and no body markup/links. There is no grouping by app, and no
  "clear app" action.
- History lives only in memory, so it is lost on every hot reload or restart. `keepOnReload: true` helps the server,
  but the JS `history` array still resets.
- **Write-only settings (rule #6 violation):** `notifications.toastTimeout`, `maxToasts`, `showOnFullscreen` and
  `persistDnd` are set in `Modules/Settings/Panes/NotificationsPane.qml:46-76`, and **no other file reads them** (grep
  confirms). The toast timeout is hardcoded at `NotifToast.qml:55-62` and DnD is a plain `property bool`. **Fix first.**
- Toasts render in one `PanelWindow` with no `screen` binding (`shell.qml:268`), so they land on the compositor's
  choice of output rather than the focused one. On a 3-monitor desk they must follow focus.
- DnD should become a **Focus mode** (see §4): scheduled or context-driven, with per-app allowlists and "critical
  breaks through".

### 3.5 Quick settings

adr_011 dissolved the Control Center into bar popups (Wifi/BT popups, click-to-mute). That is clean, but one piece is
missing: **a single place for a dozen toggles** (DnD/focus, night light, caffeine, VPN, mic, power profile, gaming
mode, sides-hide, flat/glass, theme day/night, screen record). macOS Control Center, Windows 11 Quick Settings and
GNOME Quick Settings all converge on a *grid of stateful tiles with an expand-chevron into detail*. Recommend a
**Quick Settings face** of the Dashboard (or a small `qs` panel) built from tiles bound to real services. This fits the
existing FaceHost pattern and adr_011 (the bar stays minimal; tiles are one keystroke away).

### 3.6 Multi-monitor behaviour

- Good: panels open on the **focused output** (`ShellState.openGlobal`, `Services/Shell/ShellState.qml:115`), and
  per-screen state and hotplug are handled (item_005/026 Done).
- Gaps:
  - **OSD shows on every screen** (`shell.qml:255-260`). It should show on focused-only, or be configurable.
  - Toasts are not focus-aware (above).
  - Brightness covers the laptop panel only. The **work desk has HDMI + DP portrait**, so add `ddcutil` per-output
    sliders (DMS/Noctalia ship this).
  - `perScreen` overrides have **no builder UI**. The user's portrait DP-3 is the obvious case: a vertical strip there,
    a full bar on eDP.
  - There is no **dock/undock profile**. Monitor layout, loadout, wallpaper-per-output and audio sink should switch
    together when the output set changes (monitor-hotplug.sh already detects that; the shell should own the
    "profile" concept).
  - Display presets are wlr-randr shell-outs with a "open wdisplays" escape hatch. That is acceptable, but a visual
    arrangement mini-map would suit the builder aesthetic (low priority).

### 3.7 Lock screen

hyprlock via template. It is fine and robust (it fixed a resume segfault), but it **cannot show shell state**:
notifications count, media controls, the current context, or the pack's ornaments. Competitors all went native
(`WlSessionLock` + `PamContext`; ANALYSIS §2 Qylock shows it is ~15 lines of auth logic). Recommendation: keep hyprlock
as the fallback and build a native lock **only once a crash-safe story exists**. Quickshell crash = compositor shows
the locked-out red screen on ext-session-lock. The user was bitten by session crashes before, so this belongs in P1,
behind a test plan (shot.sh can render lock surfaces). The depth-lockscreen (§20.5-5) fits the identity-pack
differentiator.

### 3.8 OSD

Add: mic mute, kbd layout switch (AZERTY↔QWERTY, relevant for this user), caps lock, power profile, DnD/focus change,
media track change (compact), screenshot taken, VPN up/down, AWS context switched. **Drive OSD from service state
changes, not from the keybind** (`Audio.volumeChanged` → show), so external changes also surface. Debounce the startup
burst.

### 3.9 Settings UX

- 9 panes. Several are thin wrappers over shell-outs: Display (wlr-randr/wlsunset), Power (swayidle script in dotfiles).
  The Notifications pane is write-only.
- Settings **leak dotfiles assumptions** into the "publishable product": `~/.config/swayidle/config.sh`
  (`PowerPane.qml:78`), zen restart toggle, VSCode colors, and the AboutPane hardcodes "Catppuccin Macchiato ·
  FiraCode" (`AboutPane.qml`, static text, not the live theme).
- The search index is hand-maintained (item_087 plans self-registration; do it).
- **"Max 2 keystrokes to any setting"** is met only through the launcher settings provider (Super+R, type, Enter = 2
  actions plus typing). That is acceptable if the launcher is *the* entry point; make that explicit in onboarding.
- Missing panes vs competitors: Lock (item_018), Idle (as its own concern with AC/battery split + caffeine),
  Keybinds (read-only view + conflicts), Launcher (providers on/off, prefixes, web engines), Context/Profiles (new, §4).

### 3.10 Onboarding for a stranger

- README is 42 lines, license **TBD**, with no screenshots (item_077). `scripts/install.sh` is tidy (dry-run,
  non-destructive).
- A fresh install **depends on dotfiles-only pieces** without saying so: swayidle config.sh, `monitor-apply.sh`,
  `mango-reload.sh`, project-jump, and show-keybinds. Several settings panes will silently no-op.
- There is no first-run flow (item_040 Ready). A good minimal first run takes 5 cards: pick family/accent → pick
  layout loadout → "your 5 keys" (launcher, settings, edit mode, NC, dashboard) → enable lock/idle →
  done. This doubles as the README GIF via shot.sh.
- Keep `docs/` API-heavy, but add a **USER_GUIDE.md**. It is the only doc a stranger needs (the user explicitly
  allows docs in docs/).

---

## 4. "Next level" ideas tailored to this user

Opinionated. The user is a backend dev and cloud architect (Python, Terraform, AWS), multi-monitor, dock↔undock, who
switches context constantly and wants work-first. Ranked by **value/effort**. Value is 1–5 (daily impact), effort is
S (≤1 day), M (2–5 days) or L (>1 week).

| # | Idea | Value | Effort | Why / sketch |
|---|---|---|---|---|
| 1 | **Context switcher ("Loadouts 2.0")** | 5 | M→L | One named *context* = `{project dir, AWS_PROFILE + region, kube context, git identity, monitor loadout (item_013), wallpaper/accent, focus mode, apps to spawn on tags}`. Switching writes `~/.config/archeotech/context.env` (sourced by fish via a `--on-variable`/prompt hook), sets `aws configure`/`kubectl config use-context`, retints the accent (visual cue: "prod = red"), and spawns the tag layout. Bar pill shows `ctx · acct · region` and turns **red on prod accounts**. This is PowerToys Workspaces ([learn.microsoft.com/windows/powertoys/workspaces](https://learn.microsoft.com/en-us/windows/powertoys/workspaces)) + KDE Activities + macOS Focus, fused for cloud work. No shell ships it. |
| 2 | **AWS profile / SSO widget + launcher provider** | 5 | S→M | Parse `~/.aws/config` profiles; show active profile, SSO token expiry countdown (from `~/.aws/sso/cache/*.json` `expiresAt`), one-click `aws sso login --profile X`, "open console in account" (federated URL, or just `https://<alias>.signin.aws.amazon.com`), and copy-account-id. Today SystemNotes shows the *shell process's* `$AWS_PROFILE` (`SystemNotes.qml:54`), which is always `unset` or stale, so it is effectively misleading. Supersedes item_024's rofi idea. |
| 3 | **Launcher → command palette** (prefixes, clipboard, windows, projects, emoji, qalc, script commands, quicklinks, module providers) | 5 | M | §3.3. Kills 4 rofi scripts, unifies UX, and is the foundation for #1, #2 and #6. |
| 4 | **Fix fake settings + notification actions/grouping/persist/per-focus toasts** | 5 | S→M | Integrity first (§3.4). Actions = `actionsSupported: true` + buttons invoking `action.invoke()`. Persist history to `~/.local/state/archeotech/notifications.json`. |
| 5 | **Git/PR/CI radar** | 4 | M | Extend ActiveProjects into a `Projects` service: per repo branch, dirty, ahead/behind; `gh pr status --json` for *my PRs / review requested / checks state*; a bar pill "2 reviews · 1 failing". Poll only when the dashboard is open, plus a 5-min background interval. Notify on CI failure transitions. (`gh` is on Arch; zero new auth.) |
| 6 | **Claude "Ask" surface** | 4 | M | A launcher `?` prefix / Super+Shift+Space → a streaming answer panel using the Claude API (key via `secret-tool`/libsecret, never in config). Pre-bake **context injectors**: selected text (`wl-paste -p`), clipboard, current repo `git diff`, last terminal error (kitty `get-text` via remote control), a screenshot region. Actions: copy, insert (wtype), open in editor. Keep it a *module* (opt-in, publishable), Ambxst-style provider-agnostic. Pairs with the user's existing Claude Code habit: a "send to Claude Code in this repo" action spawning `kitty -d <repo> claude "<prompt>"` is cheap and very on-brand. |
| 7 | **Focus modes** | 4 | S→M | DnD generalised: `Deep work` (DnD + allowlist, hide sides, pause media, timer + session log), `Meeting` (mic-mute OSD prominent, notifications from calendar only), `Presenting` (sides hidden, DnD, no toasts on the shared output). Scheduled or tied to a context. Surface as a quick-settings tile and a bar pill. |
| 8 | **Dock/undock profiles** | 4 | M | When the output set changes, apply the matching {monitor layout, shell loadout incl. perScreen, audio sink, brightness policy, wallpaper per output}. The detection exists (dotfiles `monitor-hotplug.sh`); expose "work desk / home desk / laptop" in Settings › Display and let the shell drive it. |
| 9 | **Keybind cheatsheet overlay** (parse mango/hypr config comments) | 3 | S | A `Super+K` panel with search, grouped by the config's section comments, showing conflicts. Replaces the rofi `show-keybinds.sh`. |
| 10 | **Quick Settings face** (tile grid) | 3 | S→M | §3.5. Tiles: Focus, Night light, Caffeine, VPN, Mic, Power profile, Gaming mode, Sides, Theme mode, Record. |
| 11 | **Terraform/Infra helpers** | 3 | S | Launcher provider in a repo with `*.tf`: `plan`, `fmt`, `validate`, `workspace select` spawn in kitty at the project; show the current TF workspace in the context pill. Cheap once #3 exists. |
| 12 | **Terminal session presets** | 3 | S | kitty `--session` files per project (item_031) launched from the projects provider ("open with layout: editor+server+logs"). |
| 13 | **Screenshot/record/OCR "snip" panel** | 3 | M | Region → annotate (satty) → copy / save / OCR (tesseract) / *ask Claude about this*. Record toggle via `gpu-screen-recorder` with a bar recording pill. Replaces the raw grim binds (item_029/030). |
| 14 | **External-monitor brightness (ddcutil)** | 3 | S→M | Per-output sliders in the brightness popup; debounce (DDC is slow). Needs `i2c-dev`. |
| 15 | **Calendar events (khal/vdir) + "next meeting" pill** | 3 | M | Work uses a calendar; a "next: standup in 7m [Join]" pill with the meet link parsed from the event. vdir (Noctalia's approach) + `vdirsyncer` keeps it local-first. |
| 16 | **Pomodoro / time-tracking tied to context** | 2 | S | Log per-context time to a CSV, show it on the dashboard. Nice for billable/work splits. |
| 17 | **Docker/Compose widget** | 2 | S | item_023. Running containers badge → lazydocker. |
| 18 | **SSH quick-connect provider** | 2 | S | item_032. Parse `~/.ssh/config` Host entries as a launcher provider. |
| 19 | **Native lock + depth effect** | 2 | L | High polish, low daily value, crash risk. After the above. |
| 20 | **Weather** | 1 | S | Everyone has it; low value for this user. Put it on the dashboard hero only. |

**Things not to do (for now):** a Go/C++ daemon (the DMS/Noctalia path); a plugin *marketplace* before there are
plugins; wallpaper-derived palettes; a workspace overview with live previews (mango's `toggleoverview` already exists);
a greeter.

---

## 5. Prioritized roadmap recommendation

Effort: S ≤1d · M 2–5d · L >1w. Links to existing logics items where they apply. New items would go through
`logics-manager flow new` (not hand-edited).

### P0 — integrity + the daily command surface (next 2–3 weeks)

| Item | Effort | Notes / existing refs |
|---|---|---|
| **Wire or remove the 4 Notifications settings**, persist DnD, follow-focus toasts, bound `maxToasts` | S | Rule #6 violation. `NotificationsPane.qml`, `NotifToast.qml:55`, `shell.qml:220-330` |
| **Notification actions + images + app grouping + persisted history + NC keyboard nav** | M | `Services/System/Notifications.qml`, `NotificationCenter.qml` |
| **Launcher prefix modes + clipboard, window, projects, emoji and qalc providers** | M | `Launcher.qml:221` registry. item_025 (clipboard pin), item_029 (partly), replaces dotfiles `project-jump.sh` and the Super+V rofi |
| **AWS profile/SSO pill + provider** (replace the misleading `$AWS_PROFILE` read) | S→M | `SystemNotes.qml:54`. Supersedes rofi half of item_024 |
| **OSD driven by service state + mic/kbd-layout/caps OSD + focused-screen only** | S | `Modules/OSD/Osd.qml`, `shell.qml:255` |
| **Generic `panel` IPC** (`open/toggle <id>`) so modules and plugin panels are keybindable; fix README "keybind" claim | S | `shell.qml` IPC block, `README.md` |
| **Decouple dotfiles leaks** (swayidle config.sh, About pane static text) or document them as optional deps | S | `PowerPane.qml:78`, `AboutPane.qml` |

### P1 — the differentiator: contexts & dev radar (next 1–2 months)

| Item | Effort | Notes |
|---|---|---|
| **Context switcher** (project + AWS + kube + git identity + loadout + accent + focus + tag apps) | L | Builds on item_013 (loadouts), item_031 (kitty sessions), item_034 (profiles). Needs an ADR (state file, fish integration, "prod" colour semantics) |
| **Focus modes** (DnD generalized, schedule, allowlist) | S→M | Settings › Notifications becomes Focus |
| **Git/PR/CI radar** (`gh`) + CI failure notifications | M | item_047 (pinnable projects), item_049 |
| **Claude Ask module** (launcher `?`, context injectors, send-to-Claude-Code) | M | Opt-in module, libsecret key. Consult the claude-api skill/docs for current model IDs at build time |
| **Keybind cheatsheet overlay** (parsed mango/hypr config) | S | Replaces `show-keybinds.sh` |
| **Quick Settings tile face** | S→M | Respects adr_011 |
| **Dock/undock profiles + perScreen builder UI** | M | item_026 follow-up; portrait DP-3 case |
| **ddcutil external brightness** | S→M | `Services/Hardware/Brightness.qml` |
| **Script commands + quicklinks + module-provided launcher providers** | M | Extends MODULE_API (`launcherProvider`), the plugin story |
| **Hyprland parity**: fullscreen, clients, layout | S→M | `HyprlandService.qml:51-55` |
| **Onboarding first-run + USER_GUIDE.md + screenshots + LICENSE** | M | item_040, item_076, item_077 |

### P2 — polish, breadth, identity (after)

| Item | Effort | Notes |
|---|---|---|
| Native lock (WlSessionLock + PAM) with hyprlock fallback; depth-lock preset | L | item_018, §20.5-5. Crash-safety test plan first |
| Snip panel (annotate / OCR / ask-Claude / record pill) | M | item_029, item_030 |
| Calendar events (vdir/khal) + next-meeting pill | M | |
| Terraform provider, SSH provider, Docker widget, Pomodoro/time log | S each | item_023, item_032 |
| Idle pane rewrite in-shell (AC/battery split, caffeine tile) using `IdleInhibitor`/native idle if QS 0.3 exposes it | M | Removes the swayidle script coupling |
| Themed tray menu | S→M | item_039 |
| Plugin install from index | M | item_065 |
| Weather on dashboard hero | S | |
| Resource budget check (RSS per monitor, poll audit) | S | Noctalia 5 made RAM a talking point; measure before users do |

### Suggested sequencing logic

P0 fixes trust (rule #6) and replaces the rofi utility layer with one keyboard-first palette. Every P1 dev feature
(contexts, AWS, git, Claude) then *plugs into that palette* as providers, and into the bar as pills, so they are cheap.
Visual and identity work (packs, faces, morph, lock depth), where Archeotech is already ahead, can continue in parallel
at a lower share of effort.

---

## Appendix — evidence index

- Launcher providers: `Modules/Shell/Panels/Content/Launcher.qml:221-289`
- Notification server config: `Services/System/Notifications.qml:14-31` (`actionsSupported: false`)
- Write-only settings: `Modules/Settings/Panes/NotificationsPane.qml:46-76`. The same keys are absent from every other
  file (repo-wide grep)
- Hardcoded toast timeout: `Modules/NotificationCenter/NotifToast.qml:55-62`
- Toast window w/o screen binding: `shell.qml:268-285`
- OSD to all screens: `shell.qml:247-265`
- Focus-aware panel open: `Services/Shell/ShellState.qml:110-129`
- Hyprland stubs: `Services/Compositor/HyprlandService.qml:51-55,76-77`
- Idle via dotfiles script: `Modules/Settings/Panes/PowerPane.qml:48-79`
- AWS read of shell env: `Modules/Dashboard/panels/SystemNotes.qml:54`
- Projects scan + open: `Modules/Dashboard/panels/ActiveProjects.qml:28-56`
- Hardcoded quick-launch: `Modules/Dashboard/panels/QuickLaunch.qml:27-34`
- Settings search index (hand-authored): `Modules/Settings/PaneRegistry.qml:34-58`
- Module targets (no keybind target; desktop-widget pending): `docs/MODULE_API.md:58-66`
- External utility binds: dotfiles `config/.config/mango/config.conf:223-446`
- Backlog cross-refs: dotfiles `logics/backlog/item_013, 018, 023, 024, 025, 029, 030, 031, 032, 034, 039, 040, 041,
  046, 047, 049, 065, 076, 077, 087`. **This report is a candidate deliverable for item_041** (R&D: missing
  common/niche shell features).

Competitor sources: DMS <https://danklinux.com/blog/v1-6-release>,
<https://github.com/AvengeMedia/DankMaterialShell/blob/master/docs/IPC.md>; Noctalia
<https://github.com/noctalia-dev/noctalia>, <https://byteiota.com/noctalia-5-wayland-desktop-shell-stable-cpp-rewrite/>;
Caelestia <https://github.com/caelestia-dots/shell>; end-4 <https://github.com/end-4/dots-hyprland>,
<https://ii.clsty.link/en/>; Ambxst <https://github.com/Axenide/Ambxst>, <https://axeni.de/ambxst/changelog/>; Ax-Shell
(archived) <https://github.com/Axenide/Ax-Shell>; HyprPanel (archived) <https://github.com/Jas-SinghFSU/HyprPanel>;
Vicinae <https://github.com/vicinaehq/vicinae>; PowerToys Workspaces
<https://learn.microsoft.com/en-us/windows/powertoys/workspaces>; Raycast <https://www.raycast.com/>.
