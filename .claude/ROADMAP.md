# Roadmap

**Last Updated:** 2026-05-19  
**See also:** `ANALYSIS.md` — research, reference projects, confirmed QML APIs, settings ecosystem deep-dives.

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

**Sprint 3 — remaining items blocked on Quickshell 0.3.0** (track: `paru -Qu quickshell`):
- Audio → `Quickshell.Services.Pipewire`
- Network → `Quickshell.Networking`
- Battery → `Quickshell.Services.UPower`
- Idle inhibitor → `Quickshell.Wayland.IdleInhibitor`

---

## Upcoming Sprints

### Sprint 11 — Settings Foundation ← NEXT

**Goal:** Dedicated settings window with Config singleton persistence, NavRail navigation, and 6 initial panes. CC gear button deep-links into it.

**Architecture:**
- `Services/Persistence/Config.qml` — `pragma Singleton`, reads/writes `~/.config/archeotech/config.json` via `JsonAdapter`, `setNestedValue(dotted.key, val)` with 50ms debounce, `property bool ready`
- `Services/Persistence/Persistent.qml` — UI state only (last-open pane, collapsed sections) → `~/.local/share/archeotech/state.json`
- `Modules/Settings/Settings.qml` — `FloatingWindow`, min 800×700, default 900×800, IPC trigger from CC gear button
- `Modules/Settings/SettingsSidebar.qml` — vertical NavRail, icon + label, wheel-scroll navigation
- `Modules/Settings/PaneRegistry.qml` — singleton, declarative list of `{id, label, icon, component}`
- `Modules/Settings/SettingsContent.qml` — `Loader` per pane, carousel via `y: -activeIndex * height`
- `Modules/Settings/Widgets/` — `ToggleRow`, `SliderRow`, `DropdownRow`, `ButtonGroupRow`, `SectionDivider`

**Initial panes (6):**
- Appearance — theme variant selector, accent color, padding/rounding/spacing scales, font size scale
- Bar — height, clock format, module visibility toggles
- Notifications — timeout, max visible toasts, show-on-fullscreen toggle
- Connections — placeholder with deep-link to CC WiFi/BT sections (Sprint 13 fills out)
- Audio — sink list, source list (Sprint 13 fills out)
- About — version, links

**CC integration:**
- CC gear button → `qs ipc call settings open`
- CC section "More" links → `qs ipc call settings openPane connections`
- `Commons/State.settingsVisible` added to global state bus; mutual exclusion with CC, NC, Launcher

**Checklist:**
- [ ] `Config.qml` + `Persistent.qml` singletons with JSON persistence
- [ ] `Settings.qml` FloatingWindow + IPC handler
- [ ] `SettingsSidebar.qml` NavRail
- [ ] `PaneRegistry.qml` singleton
- [ ] `SettingsContent.qml` carousel loader
- [ ] `Widgets/` — 5 reusable row types
- [ ] 6 initial panes wired to Config singleton
- [ ] CC gear button → settings deep-link
- [ ] `Super+Shift+S` keybind in mango config

---

### Sprint 12 — Theme System

**Goal:** All shell colors in a `theme.json` hot-reload chain. Runtime switching between Catppuccin variants. Foundation ready for named personality themes (Shadow Spear, Gundam HUD, etc.).

**Architecture:**
- `Services/Theming/ThemeLoader.qml` — `FileView { watchChanges: true }` on `~/.config/archeotech/theme.json`; `onFileChanged` debounce (50ms) → re-parse JSON → push to `Commons/Appearance.qml`
- `Commons/Appearance.qml` reads all color + geometry tokens from `ThemeLoader`, not hardcoded hex
- `themes/archeotech-macchiato/theme.json` — extract all current hardcoded values
- `themes/archeotech-mocha/theme.json` — second variant proof-of-concept
- `scripts/theme-switch.sh` — copies selected `theme.json` to `~/.config/archeotech/theme.json`, patches MangoWC border/shadow/radius config, patches kitty include, patches rofi vars, calls `mango-reload.sh`
- Appearance pane in Settings → variant picker (Macchiato / Mocha / Frappe / Latte radio buttons)

**Named personalities (design intent — full per-personality files in future sprints):**

| Theme | Palette | MangoWC feel | Personality |
|-------|---------|--------------|-------------|
| **Archeotech Macchiato** | Catppuccin Macchiato + Mauve | Soft pills, 12px radius, purple glow shadow | Default — cyber-monastic |
| **Archeotech Mocha** | Catppuccin Mocha + Mauve | Same, deeper bg | Darker variant |
| **Shadow Spear** | Near-black + blood violet | 4px radius, black void shadow + red glow | WH40K Raven Guard |
| **Gundam HUD** | Navy/steel + cyan + orange | 0px radius (square), cyan shadow | Mecha cockpit |
| **Neon Liturgy** | Near-black + neon pink/teal | 6px radius, thick neon border + diffuse glow | Cyberpunk ritual |

**Neon glow note:** Achievable today via MangoWC `shadowscolor` + `shadows_size`. No plugins needed. Per-theme values:
- Macchiato: `shadowscolor=0xc6a0f666`, size 20
- Shadow Spear: `shadowscolor=0x8b000088`, size 25
- Gundam: `shadowscolor=0x00ffffaa`, size 15
- Neon Liturgy: `shadowscolor=0xff79c666`, size 30

**Checklist:**
- [ ] `ThemeLoader.qml` singleton with hot-reload
- [ ] Appearance.qml reads from ThemeLoader
- [ ] `themes/archeotech-macchiato/theme.json` extracted
- [ ] `themes/archeotech-mocha/theme.json` second variant
- [ ] `scripts/theme-switch.sh` patches MangoWC + kitty + rofi
- [ ] Appearance pane variant picker
- [ ] `Super+Shift+T` → future theme picker overlay (this sprint: just sets via Settings)

---

### Sprint 13 — Mission Dashboard

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

### Sprint 14 — Lock Screen (Native QML)

**Goal:** Replace swaylock with a first-class Quickshell component. Now that the design system (Sprint 12) and token system are in place, build it properly.

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

### Sprint 15 — Settings Depth
Fill out Sprint 11's placeholder panes with full native implementations:
- Connections pane: WiFi sub-tab (known networks, forget, priority) + BT sub-tab (connected/paired/available per Noctalia model, battery level, signal)
- Audio pane: PipeWire sinks + sources (once QS 0.3.0 lands), device aliasing, per-device volume limit
- ColorScheme pane: dark mode toggle, schedule (off/manual/location), wallpaper color extraction toggle
- Settings search: fuzzy index per registered pane, max 15 results, sidebar search input

### Sprint 16 — Distribution
- `scripts/install-packages.sh` — full `paru -S` list for fresh Arch
- Rewrite `scripts/install.sh` — prereq check, timestamped backup, stow deploy, verification
- `scripts/backup-configs.sh` — timestamped snapshot of current working configs (pre-update safety net)
- `scripts/restore-configs.sh` — deploy configs to a new machine from backup
- `docs/INSTALL.md` — step-by-step for fresh Arch + MangoWC from zero
- Harden README — screenshots of bar, OSD, CC, launcher, dashboard
- Hardcoded path audit — no `/home/corvus/` in any config or script
- Version tag for first GitHub release

### Sprint 17 — Go Daemon
Only for raw Wayland protocols that QML can't reach natively:
- `archeotech-daemon` Go binary — Unix socket, newline-JSON RPC
- `Services/ArcheotechDaemon.qml` — Quickshell Socket, exponential-backoff reconnect
- Handles: `wlr-output-management` (display layout), `wlr-gamma-control` (night light), `wlr-screencopy` (screenshot)
- Does NOT handle: audio, network, BT, notifications, lock (all native QML)

### Sprint 18 — Dev Personality + Shadow Spear
- `themes/shadow-spear/` full theme package (compositor + kitty + starship raven sigil + rofi + wallpaper set)
- Git branch module in bar — CWD from focused window, dims when no git context
- AWS profile module in bar — always visible, dims when `$AWS_PROFILE` unset
- Terraform workspace indicator — shows `terraform workspace show`, only in tf repos
- Per-workspace wallpapers via tag-switch hook

---

## Feature Backlog

Well-defined features not yet scheduled into a sprint.

### Full System-Wide Theme Switcher

Beyond QML tokens (Sprint 12), a full `theme-switch.sh` that patches every layer of the system simultaneously:

| Layer | Mechanism |
|-------|-----------|
| MangoWC | Config patch (border, radius, shadow color/size) + `mango-reload.sh` |
| Quickshell | Live `theme.json` reload — no restart |
| Kitty | Include file swap + `kill -USR1 $(pgrep kitty)` |
| Starship | Config symlink swap (raven `󱉧` for Shadow Spear, crosshair for Gundam) |
| Rofi | rasi variable file swap |
| GTK apps | `gsettings set` (theme + icon + cursor) |
| VSCode | `jq` patch on `settings.json` |
| Obsidian | `jq` patch on `obsidian.json` |
| Zen Browser | CSS file swap (userChrome.css, best effort) |
| Wallpaper | `awww` transition to theme wallpaper family |
| swaylock | Config patch (bg tint) |
| GRUB | Config patch (applies next boot only) |

**Keybind:** `Super+Shift+T` → Quickshell theme picker overlay (swatches + wallpaper thumbnail, keyboard nav).

### Dev Workflow Bar Modules
*(sprint 18 covers git + AWS + terraform; these are the rest)*
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
