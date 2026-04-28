# Roadmap & Ideas

Everything worth building, customizing, or investigating — from deep workflow automation to visual flair. This is a living document.

**Last Updated:** 2026-04-21

---

## Quickshell Migration — Full Desktop Shell

The long-term vision: replace the current patchwork of waybar + rofi settings hub + swaync with a single unified Quickshell shell that looks and feels like one person designed it. Everything shares the same QML codebase, the same animation system, the same theme variables. This is how caelestia-dots and end-4/dots-hyprland achieve their coherence.

**Why Quickshell over AGS/eww:**
- QML is its own thing regardless of prior experience — no JS/TS knowledge wasted
- Higher ceiling than AGS: animations, live window previews, blur, full compositor integration
- Single process for everything (bar + panels + notifications + control center) = consistent rendering
- Caelestia (the main reference) is built on Quickshell — its source is readable and well-structured

**MangoWC caveat:** Most Quickshell examples target Hyprland's IPC. MangoWC uses `mmsg`. Quickshell can shell out to any command and watch stdout, so this is workable — but we can't copy-paste from caelestia directly. We build our own IPC bridge layer.

---

### Phase 1 — Learn QML, Build the Control Center (replaces settings hub)

**Goal:** One contained widget that proves out the QML workflow. Learn the tool on something bounded before touching the bar.

**What it replaces:** `scripts/settings-hub.sh` (rofi dmenu — can't do real toggles, can't reflect state)

**What it will do:**
- Real toggle switches (on/off with animated thumb)
- Real sliders (night light temperature, maybe brightness)
- Live state reflection (focus mode actually shows current state)
- Submenu navigation with animated transitions
- Glass morphism panel matching the existing aesthetic
- Keybind: `Super+,` (same as now — transparent replacement)

**Learning resources:**
- [Quickshell docs](https://quickshell.outfoxxed.me)
- [caelestia-dots/shell source](https://github.com/caelestia-dots/shell) — read the QML, don't copy it
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) — see how they structure panels

**Steps:**
- [x] Install `quickshell-git` (AUR)
- [x] Read QML basics: properties, bindings, anchors, signals
- [x] Build a minimal "hello world" panel that appears on a keybind
- [x] Implement the control center panel with real toggles for: Focus Mode, Night Light, Power Profile, Bluetooth, Do Not Disturb
- [x] Wire each toggle to the same shell commands as the current settings hub
- [x] Style with Catppuccin Macchiato glass aesthetic
- [x] Replace `Super+,` binding in mango.conf
- [ ] Add sliders for Night Light temperature (deferred to later)

---

### Phase 2 — Replace Waybar with Quickshell Bar

**Goal:** A status bar that's part of the same Quickshell process as the control center. Consistent rendering, shared theme variables, no inter-process seams.

**What it replaces:** `~/.config/waybar/` (both mango and hyprland variants)

**Design vision (inspired by current waybar + inspiration repos):**
- Floating pill/island style — same as current waybar aesthetic
- Left: tag/workspace indicators with live client count (via `mmsg -w` watch mode)
- Center: clock with date, styled
- Right: system tray area — volume, network, battery, brightness
- Right edge: notification bell (swaync integration or replace), settings gear, power
- All modules clickable, consistent hover animations
- Battery shows percentage + charging animation
- Volume shows level, scroll to change

**MangoWC integration:**
- `mmsg -w` (watch mode) streams tag/client/layout events — Quickshell `Process` component reads this as a live data source
- No Hyprland IPC needed — we build a thin QML wrapper around `mmsg`

**Steps:**
- [ ] Complete Phase 1 first — understand QML anchors and layouts properly
- [ ] Build a minimal bar (clock only) that replaces waybar
- [ ] Add tag indicators with `mmsg -w` watch mode
- [ ] Port all current waybar modules one by one
- [ ] Match current floating pill aesthetic
- [ ] Add custom modules: keyboard layout, AWS profile indicator
- [ ] Remove waybar autostart from mango.conf, add quickshell

---

### Phase 3 — Replace swaync with Quickshell Notification Center

**Goal:** Notifications and the notification panel as Quickshell components, consistent with bar and control center.

**What it replaces:** swaync (separate process, separate styling, CSS has to be maintained separately)

**What it will do:**
- Popup notifications: styled cards with Catppuccin Macchiato, matching blur
- Notification history panel: slides in from right (or top-right), animated
- DND toggle inside the panel (real toggle, not a fake swaync button)
- Action buttons on notifications (dismiss, action buttons from apps)

**Note:** swaync is a separate Wayland layer-shell surface — Quickshell can render layer-shell surfaces natively (it's a first-class feature). This is how caelestia does it.

**Steps:**
- [ ] Complete Phase 2 first
- [ ] Research Wayland notification protocol (org.freedesktop.Notifications DBus)
- [ ] Build notification popup component in QML
- [ ] Build notification history panel
- [ ] Wire DND toggle
- [ ] Test with all apps that currently use swaync (Teams, system alerts, battery script)
- [ ] Remove swaync autostart

---

### Phase 4 — Dashboard / Overview Widget

**Goal:** A rich on-demand overlay (like end-4's overview) — not a permanent bar element but a keybind-summoned panel.

**Inspiration:** end-4/dots-hyprland overview, caelestia dashboard

**What it could contain:**
- Live workspace/tag overview with window thumbnails
- System stats (CPU, RAM, disk, battery) — pretty, not btop-level detail
- Current track (playerctl integration)
- Quick launcher shortcuts
- Date/calendar widget

**Keybind:** `Super+Tab` or `Super+D` (currently unused)

**Steps:**
- [ ] Complete Phase 3 first
- [ ] Design the layout on paper before coding
- [ ] Implement workspace overview using MangoWC geometry (`mmsg -g -x`)
- [ ] Add system stats via shell polling
- [ ] Add playerctl integration

---

### Focus Mode — DROPPED

**Status:** Removed from settings hub.

**Reason:** MangoWC copies `unfocused_opacity` per-client at window creation time. There is no IPC command, no `reapply_opacity` function, no mechanism to update existing clients. `reload_config` updates globals but never retroactively applies to open windows. The feature works only for newly opened windows after toggle, making it effectively useless as a live toggle.

**Potential future revisit:** If MangoWC adds a `reapply_window_rules` or `set_opacity` IPC dispatch in a future version, this becomes trivial to implement.

---

## Settings Hub & Control System

### Phase 1 — SwayNC ✅ COMPLETE

swaync installed, replaces dunst. Catppuccin glass panel, DND toggle, notification history. Waybar bell icon (`󰂜`) with unread count. `Super+;` keybind.

Key lessons (also in TROUBLESHOOTING.md):
- `buttons-grid` toggle type doesn't reflect real state — don't use for stateful toggles
- `blur_layer=0` + `layer_shadows=0` required globally — `layerrule=noblur` doesn't work for layer-shell surfaces
- swaync has no click-outside-to-close — Escape only

### Phase 2 — Rofi Settings Hub

**Keybind:** `Super+,`

**Menu structure:**
```
⚙  Settings
├── 🖥  Display     → wdisplays or kanshi profile picker
├── 🎨  Appearance  → nwg-look (GTK theme, icons, cursor, fonts)
├── 🔊  Audio       → pavucontrol
├── 📡  Network     → nm-connection-editor
├── 🖼  Wallpaper   → wallpaper-picker.sh (existing rofi picker)
├── ⚡  Power       → submenu: Balanced / Performance / Power Saver (power-profiles-daemon)
│                     + Night Light: Off / 4500K / 3500K / 2700K (wlsunset)
├── 💾  Disk        → duf in kitty
├── 🔵  Bluetooth   → blueman-manager
└── 🔒  Power menu  → wlogout (already themed ✅)
```

**Implementation steps:**
1. `paru -S wdisplays nwg-look wlsunset mission-center gnome-disk-utility kanshi`
2. Write `scripts/settings-hub.sh` — rofi dmenu with icons, each line maps to a command
3. Write `scripts/assets/settings-hub.rasi` — matches wallpaper-picker glass style
4. Wire `Super+,` keybind in mango config
5. Add waybar gear icon (right of bell) opening settings hub

**Design rules:**
- Same glass Catppuccin Macchiato style as the wallpaper picker
- Icons via Papirus-Dark; no text-only entries
- No fake toggles — open the real tool, don't try to reflect state in rofi

- [x] **Rofi Settings Hub** (`Super+,`) — script + rasi theme + keybind + waybar gear icon (󰒓, left of bell) all done
  - Icons fixed: `icon-theme: "Papirus-Dark"` added to rofi config.rasi (was missing)
  - Back navigation: all submenus have `← Back` + Escape returns to main menu
  - Power → `wlogout-launch.sh`, Lock → `swaylock-launch.sh` (dynamic wallpaper)
  - Appearance removed — nwg-look is GTK-only, misleading as a full theme switcher
- [x] **Display submenu** — extend/mirror/laptop-only/external-only/adjust via wlr-randr; detects connected externals dynamically; wdisplays as manual escape hatch
- [x] **Night Light** — wlsunset off/4500K/3500K/2700K submenu
- [x] **Power Profile** — power-profiles-daemon balanced/performance/power-saver submenu
- [x] **Cursor theme** — catppuccin-macchiato-mauve-cursors set in mango.conf + environment.d/cursor.conf (nwg-look only affects GTK, not compositor)
- [x] **wlogout theme** — Catppuccin Macchiato glass pill buttons, icon-only, full-span overlay, adaptive portrait layout; launched via `scripts/wlogout-launch.sh` (computes per-monitor margins via xrandr)
  - **Known limitation**: button shapes inconsistent across monitors (GTK/wlogout limitation, no clean fix)
- [x] **Waybar gear icon** — `custom/settings-hub` module, 󰒓 icon, `@subtext1` color, mauve hover, sits left of notification bell

### Phase 3 — Display Profiles (kanshi) — DROPPED

kanshi auto-switches monitor layouts on plug/unplug, but MangoWC's wildcard monitorrules already handle this. The manual Display submenu in the settings hub covers ad-hoc layout switching (meetings, TVs, presentations) better than kanshi's profile system would. Not worth the setup complexity.

### Phase X — Theme Switcher (Future)

A script that changes the full system theme at once — not just GTK.

**Problem:** nwg-look only writes to `gtk-3.0/settings.ini` and `gtk-4.0/settings.ini`. The compositor cursor (`mango.conf` + `environment.d/cursor.conf`), Waybar (`style.css`), Kitty (`kitty.conf`), and Rofi (`theme.rasi`) are all independent — no single tool controls them all.

**Goal:** `theme-switch.sh [macchiato|mocha|latte]` — patches all config files and restarts affected services in one command.

**Scope:**
- [ ] Patch `gtk-3.0/settings.ini` (GTK theme, icon theme, cursor)
- [ ] Patch `mango/config.conf` (cursor_theme)
- [ ] Patch `environment.d/cursor.conf` (XCURSOR_THEME)
- [ ] Patch `waybar/style.css` (color variables or @import swap)
- [ ] Patch `kitty/kitty.conf` (color include swap)
- [ ] Patch `rofi/theme.rasi` (color variables)
- [ ] Restart waybar, reload mango config
- [ ] Inspired by Hyde/Caelestia theme switching approach

**Note:** Appearance entry removed from settings hub until this exists — nwg-look gave false impression of full theme control.

### Phase 4 — Polish & Cohesion

- [ ] Waybar gear icon opening settings hub
- [ ] All rofi menus share one `.rasi` base theme (single source of truth for colors/radius/blur)
- [ ] Consistent animation timing across rofi menus, swaync panel, waybar
- [ ] `Super+?` → rofi keybinds cheatsheet

### Keybind Plan

| Keybind | Action | Status |
|---------|--------|--------|
| `Super+;` | Toggle swaync notification panel | ✅ Done |
| `Super+,` | Open settings hub (rofi) | ✅ Done |
| `Super+F1` | Display profile: desk (3 monitors) | TODO |
| `Super+F2` | Display profile: present (laptop + external) | TODO |
| `Super+F3` | Display profile: solo (laptop only) | TODO |
| `Super+?` | Keybinds cheatsheet | TODO |

---

## Tool Discovery System

A system to help remember and discover all the installed tools and utilities.

### Phase 0 — Quick Installs

Small productivity tools worth installing whenever:

- [ ] **Frog** — OCR: copy text from screen/images (`paru -S frog`)
- [ ] **Mdcat** — render markdown in terminal (`paru -S mdcat`)
- [ ] **Espanso** — text expander / keyword replacer (`paru -S espanso`)
- [ ] **Mission Center** — modern system monitoring GUI (`paru -S mission-center`)
- [ ] **SwayNC OSD** — volume/brightness popup on media key press (overlay notification when keys pressed)

### Phase 1 — Navi Cheatsheets (Quick Win)

Write custom navi cheatsheets (`navi-cheats/`) for all installed tools, grouped by category. Already wired to `Super+Shift+N`. Just needs content.

- [ ] Write cheatsheets for: terminal tools (duf, ncdu, dust, gdu, lsblk, bat, eza, zoxide, yazi)
- [ ] Write cheatsheets for: dev tools (lazygit, atuin, navi, granted, terraform)
- [ ] Write cheatsheets for: system tools (btop, fastfetch, gping, thefuck, tealdeer)

### Phase 2 — Tools Rofi Launcher

A rofi menu grouped by category (Development / System / Media / etc.) — select a tool to launch it or see a description. Backed by the same data as navi cheatsheets.

- [ ] `scripts/tools-launcher.sh` — categorized rofi list of all tools
- [ ] Each entry: icon + tool name + one-line description
- [ ] Keybind: `Super+Shift+T` (or integrate into settings hub)

### Phase 3 — Welcome / Dashboard Screen (Future)

A rich startup dashboard shown on login or on demand — combines multiple info sources into one beautiful screen:

- **Tip of the day** — random tool from your installed arsenal with a usage example
- **System snapshot** — uptime, current profile, battery, last snapshot date
- **Today's agenda** — git status of active projects, any pending updates
- **Quick launch** — most-used tools one click away
- Inspired by: `fastfetch` but interactive, more like a dashboard than a status dump
- Could be built with: a rofi custom mode, a waybar popup, or a standalone GTK/QML window
- [ ] Design the layout and data sources before picking the implementation

---

## Table of Contents

- [Theme System Architecture](#theme-system-architecture)
- [Window Manager Deep Config](#window-manager-deep-config)
- [Custom Workflow Scripts](#custom-workflow-scripts)
- [App Launcher Evolution](#app-launcher-evolution)
- [Waybar Deep Customization](#waybar-deep-customization)
- [Productivity Tools](#productivity-tools)
- [Visual Flair & Animations](#visual-flair--animations)
- [AWS & Cloud Workflow](#aws--cloud-workflow)
- [Terminal & Editor Deep Config](#terminal--editor-deep-config)
- [Browser Customization](#browser-customization)
- [Email & Communication](#email--communication)
- [Note Taking & Knowledge Base](#note-taking--knowledge-base)
- [Reading & Books](#reading--books)
- [OS-Level Controls & Settings](#os-level-controls--settings)
- [Music & Media](#music--media)
- [Screensaver & Lock Screen](#screensaver--lock-screen)
- [Tools to Evaluate](#tools-to-evaluate)
- [Completed / Shipped](#completed--shipped)

---

## Feature Vision — The Desired End State

These are the high-level features that define what this setup should feel like when complete. Each maps to one or more roadmap sections below.

### Full Coherent Theme Switcher
**Inspired by:** HyDE (prasanthrangan), caelestia dynamic color, the Corvus style guide

The single most impactful cohesion feature. One action switches the entire visual identity of the desktop — not just colors, but **personality**. Each theme is a complete coordinated set covering everything from compositor shadows to VSCode color theme to Starship prompt symbols.

Dynamic/wallpaper-extracted themes are **not a priority** — the switcher works with curated hand-crafted themes only. Color extraction already exists for logo overlays and stays there.

**Planned themes:**
| Theme | Base palette | Wallpaper family | Compositor feel | VSCode theme |
|-------|-------------|-----------------|-----------------|-------------|
| **Archeotech Macchiato** | Catppuccin Macchiato + Mauve | Current collection | Soft pills, 12px radius, purple glow shadow | Catppuccin Macchiato |
| **Archeotech Mocha** | Catppuccin Mocha + Mauve | Deeper/richer variants | Same as above, deeper bg | Catppuccin Mocha |
| **Shadow Spear** | Near-black + blood violet + deep red | Raven Guard / WH40K art, dark gothic cityscapes | 4px radius (sharp), wide borderpx, black void shadow + colored glow, Quickshell gothic corner ornaments (Phase 3+) | One Dark Pro or custom |
| **Gundam HUD** | Navy/steel + cyan + orange accent | Mecha blueprints, cockpit schematics | 0px radius (square), hairline 1px border, cyan shadow, blueprint-grid bar geometry | Tokyo Night |
| **Neon Liturgy** | Near-black + neon pink/teal | Cyberpunk rainy city, neon reflections | 6px radius, thick neon border, diffuse pink/teal glow shadow | Night Owl or Dracula |

**What a theme switch touches — full scope:**

| Layer | What changes | Mechanism |
|-------|-------------|-----------|
| MangoWC compositor | Border color, border width, border radius, shadow color/size/spread, focused/unfocused opacity | Config patch + `mango-reload.sh` |
| Quickshell shell | All colors, geometry (pill vs rectangular), bar layout style | Live `theme.json` reload — no restart |
| Kitty terminal | Full color palette | Include file swap + `kill -USR1 $(pgrep kitty)` |
| Starship prompt | Colors, symbols (raven `󱉧` for Shadow Spear, crosshair for Gundam) | Config symlink swap |
| Rofi menus | Colors, border radius | rasi variable swap |
| GTK apps (Thunar etc) | GTK theme, icon theme | `gsettings set` |
| Cursor | Cursor theme | `gsettings set` + mango.conf patch |
| VSCode | Color theme | `jq` patch on `settings.json` |
| Obsidian | UI theme | `jq` patch on `obsidian.json` |
| Zen Browser | Accent color (userChrome.css) | CSS file swap (best effort) |
| Wallpaper | Auto-transitions to theme wallpaper family | `awww` transition |
| swaylock | Lock screen bg tint | Config patch |
| GRUB | Boot theme | Config patch (applies next boot only) |

**Border embellishments — what MangoWC supports vs what needs Quickshell:**

MangoWC (via SceneFX) can do:
- Border color, width (`borderpx`), corner radius
- Shadow color, size, blur, position — **this is the neon glow mechanism** (see below)
- SceneFX has `fx_gradient` internally but MangoWC hasn't exposed it as a config key — no gradient borders without patching the compositor

**Neon glow is already possible in MangoWC.** taylor85345/hyprland-dotfiles achieves the neon halo effect purely via colored drop shadows (`shadow_range=30`, bright `col.shadow`). MangoWC has the same capability — just change `shadowscolor` to a bright saturated color and increase `shadows_size`. Currently set to black at low opacity — per theme this becomes:
- Macchiato: `shadowscolor=0xc6a0f666` (purple, 40% opacity), size 20
- Shadow Spear: `shadowscolor=0x8b000088` (blood red), size 25, large blur
- Gundam: `shadowscolor=0x00ffffaa` (cyan), size 15, tight blur
- Neon Liturgy: `shadowscolor=0xff79c666` (hot pink), size 30, very diffuse

Hyprland limitation MangoWC shares: only **one global shadow color** — can't do focused=red, unfocused=cyan like taylor85345. Per-theme works fine.

Quickshell (Phase 3+) can add on top:
- Gradient borders as a layer-shell overlay positioned over each window
- SVG corner ornaments (gothic arches, targeting reticles, circuit traces)
- Animated border glow pulse on focus (the shadow itself can't animate, but a Quickshell overlay can)
- These require `mmsg -g -x` polling to track window geometry

**Immediate per-theme differentiation (achievable right now, pre-Quickshell):** shadow color + radius + borderpx combination reads as completely different personalities. This is high-impact and zero new tech.

**Implementation approach:**
Each theme is a directory under `~/.config/themes/<theme-name>/` containing variable files for each component. The switcher patches/symlinks them and triggers reloads. Quickshell reads a single `theme.json` at runtime — changing the file live-reloads all QML bindings without restart (hot-reload is a first-class Quickshell feature).

```
themes/
├── archeotech-macchiato/
│   ├── theme.json          # Quickshell reads this — all color + geometry vars
│   ├── mango-colors.conf   # border/shadow/opacity values for config patch
│   ├── kitty-colors.conf   # include swap
│   ├── starship.toml       # prompt style
│   ├── rofi-vars.rasi      # color overrides
│   ├── wallpaper           # symlink or path to wallpaper set dir
│   └── vscode-theme.txt    # "Catppuccin Macchiato" (theme name string)
├── shadow-spear/
│   └── ...
```

**Keybind:** `Super+Shift+T` → Quickshell theme picker overlay (shows theme name + preview swatch + wallpaper thumbnail, keyboard navigable)

---

### Unified Shell Feel (Quickshell)
Everything bar, panel, notification, overview — one process, one design language, zero visual seams. See Quickshell Migration section above.

---

### Workspace Overview / Mission Control

MangoWC's built-in `toggleoverview` is already a full working panel — all tags tiled at once, functional, complete. Already bound to 4-finger swipe up. **No Quickshell replacement planned** — live window thumbnails would require xdg-screencopy protocol which adds significant complexity for marginal gain over the working built-in.

**Status:** Done, use the built-in.

---

### Per-Workspace Wallpapers
Different wallpaper per tag, transitions when switching. Tag 1 = Arch/purple default, Tag 2 = blueprint/schematic for code work, etc. Already partially possible with `awww` + a hook on tag switch via `mmsg -w`.

---

### Developer Workflow Integration
Quickshell bar shows contextual dev info — always visible but collapses/grays out gracefully when not relevant (so bar layout stays stable, no elements jumping in and out).

**Planned modules:**
- Git branch + dirty indicator — shows branch name, grayed icon when no git context in focused window
- AWS profile — always visible (you switch profiles frequently), shows `$AWS_PROFILE` env
- Terraform workspace — shows `terraform workspace show` output, only meaningful in a tf repo
- Active Docker containers count — small badge, click to open btop or lazydocker

**Implementation:** Always show, dim when irrelevant. Width animates on content change. Reassess after living with it — conditional display (only when terminal/VSCode focused) can be added later if the bar feels cluttered.

---

### Terminal Session Persistence & Project Workspaces
**Inspired by:** tmux session management, kitty sessions

Two related but distinct features:

**1. Kitty session presets (priority)**
Named session files that open a full multi-tab/split terminal layout for a specific project or context:
```
sessions/
├── dev.conf        # Editor tab + terminal tab + lazygit tab
├── aws.conf        # AWS CLI tab + terraform tab + logs tab
├── default.conf    # Single clean terminal
```
Launched via: `kitty --session ~/.config/kitty/sessions/dev.conf`
Could be triggered from the project jump menu — select project → opens VSCode + kitty dev session for that project simultaneously.

**2. Session restore on unlock/reboot**
Save current kitty window/tab layout before lock, restore after. `kitty @ ls` dumps current session state as JSON, a script converts it to a session file, `swayidle` calls save on lock trigger. Lower priority than presets.

**Note on tmux/zellij:** The roadmap lists these for evaluation. With kitty's native tabs + sessions, tmux is probably unnecessary unless you need SSH session persistence (detach/reattach on remote). Evaluate when you have a specific pain point.

---

### Quick Project Jump ✅ DONE

**Keybind:** `Super+Ctrl+P`

Scans `~/Projects` (personal, 󱍽 icon) and `~/Documents/repos` (work, 󰃖 icon). Selecting a repo opens VSCode + a kitty terminal in that directory. Implemented as `scripts/project-jump.sh`, reuses the settings-hub rofi theme.

---

### Named Scratchpad Utility Layer
A set of persistent floating overlay tools, each on a dedicated keybind — always accessible regardless of current tag, like a utility layer on top of the workspace.

**Planned scratchpads:**
| Tool | What | Note |
|------|------|------|
| Terminal | Already done (`Super+\``) | ✅ |
| Music player | ncspot (TUI Spotify) | Need to pick a free keybind |
| Calculator | `rofi-calc` or `qalculate-gtk` | Need to pick a free keybind |
| System monitor | btop in kitty | Need to pick a free keybind |

Current `Super+grave` taken by terminal. Good candidates for others: `Super+F1–F4`, or a scratchpad layer mode where a keymode activates and numbers pick tools.

---

### Welcome / Mission Dashboard
**Keybind:** `Super+Home` — or auto-shown for ~5s after login then auto-dismissed

A full Quickshell overlay panel (not a bar widget), styled as a cyber-monastic mission briefing. Shown on demand during the day.

**Layout concept:**
```
┌──────────────────────────────────────────────────────────────┐
│  ARCHEOTECH-OS ── corvus@archeotech ───────────── 2026-04-21 │
│  ─────────────────────────────────────────────────────────── │
│                                                              │
│  ┌── SYSTEM STATUS ──────┐  ┌── ACTIVE PROJECTS ─────────┐  │
│  │ CPU  ████░░░  42%     │  │ ● archeotech-dotfiles  main │  │
│  │ RAM  ██████░  68%     │  │ ● work-project-alpha   dev  │  │
│  │ Disk ███░░░░  51%     │  │ ○ terraform-infra    clean  │  │
│  │ Bat  ████░░░  72% ↑   │  └─────────────────────────────┘  │
│  └───────────────────────┘                                   │
│                            ┌── QUICK LAUNCH ──────────────┐  │
│  ┌── SYSTEM NOTES ───────┐ │  terminal  browser  code     │  │
│  │ Last snapshot: 2d ago │ │  obsidian  lazygit  yazi     │  │
│  │ Pending updates: 3    │ └─────────────────────────────┘   │
│  │ VPN: inactive         │                                   │
│  │ AWS: prod-account     │ ┌── TIP OF THE SESSION ────────┐  │
│  └───────────────────────┘ │ zoxide: `z proj` jumps to    │  │
│                             │ most-visited matching dir    │  │
│                             └─────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

**Data sources (all no extra deps):**
- System stats: `/proc/meminfo`, `/proc/stat`, `df`, `upower`
- Projects: scan `~/Projects/` for git repos, `git -C <path> branch --show-current` + `git status --short`
- Snapshots: `snapper list` last entry
- Pending updates: `checkupdates | wc -l`
- VPN: `nmcli con show --active | grep vpn`
- AWS: `$AWS_PROFILE` env
- Tips: curated rotating list in a flat text file — one tip per line, shuffled

**Implementation:** Quickshell QML grid layout, shell commands polled via `Process` component. Build this in Phase 4 after the bar is stable.

---

### Intuitive Daily Driver UX
The "easy like a Mac" goal — power user capabilities with zero friction:
- App launcher (`Super+R`) feels instant and beautiful
- Every module in the bar is clickable and does the obvious thing
- Dock/undock automatically reconfigures monitors (kanshi or script)
- Battery, VPN, and audio always visible and always one-click to change
- Lock screen is beautiful (clock + blurred wallpaper)
- Screenshots go to clipboard instantly, saved to disk

Most of this is already done. Remaining gaps: kanshi for hotplug, clickable bar modules.

---

## Theme System Architecture

Full Catppuccin multi-variant theme switcher — not just colors, but coordinated system-wide theme changes.

### Variants to Support

| Variant | Status | Feel |
|---------|--------|------|
| **Macchiato** | Active (default) | Dark, warm — preferred |
| **Mocha** | Planned | Dark, deep/rich |
| **Frappe** | Maybe later | Dark, cooler |
| **Latte** | Optional | Light mode |
| **Dynamic (wallpaper-extracted)** | Future | Generated from current wallpaper — see below |
| **Non-Catppuccin** | Future | Gruvbox, Nord, Tokyo Night, etc. — same switcher infra |

### What Changes Per Theme

| Component | What Changes | Mechanism |
|-----------|-------------|-----------|
| Hyprland | Border colors, active window glow | `colors.conf` symlink |
| MangoWC | Border colors | `colors.conf` symlink or direct conf |
| Waybar | Background, text, module accent colors | `style.css` symlink |
| Rofi | Background, selection, text colors | `theme.rasi` symlink |
| Kitty | Terminal color palette | `colors.conf` symlink |
| Dunst/Swaync | Notification colors | config symlink |
| GTK apps | System theme | `gsettings` |
| Cursors | Cursor theme | `gsettings` |
| Wallpaper | Background image | `swww` transition |
| VSCode | Editor theme | settings sync (manual) |

### Planned Directory Structure

```
~/.config/themes/
├── catppuccin-macchiato/
│   ├── hyprland-colors.conf
│   ├── waybar-style.css
│   ├── rofi-theme.rasi
│   ├── kitty-colors.conf
│   ├── dunstrc
│   ├── swaync.css
│   └── wallpaper.png
└── catppuccin-mocha/
    └── (same structure)

~/.config/hypr/
├── colors.conf -> ../themes/catppuccin-macchiato/hyprland-colors.conf  (symlink)

~/.config/waybar/
├── style.css -> ../themes/catppuccin-macchiato/waybar-style.css  (symlink)
```

### Theme Switcher Script

```bash
#!/bin/bash
# scripts/theme-switch.sh
THEME_DIR="$HOME/.config/themes"
THEME_NAME="$1"  # e.g. "catppuccin-mocha"

# Update symlinks
ln -sf "$THEME_DIR/$THEME_NAME/hyprland-colors.conf" "$HOME/.config/hypr/colors.conf"
ln -sf "$THEME_DIR/$THEME_NAME/waybar-style.css"     "$HOME/.config/waybar/style.css"
ln -sf "$THEME_DIR/$THEME_NAME/rofi-theme.rasi"      "$HOME/.config/rofi/theme.rasi"
ln -sf "$THEME_DIR/$THEME_NAME/kitty-colors.conf"    "$HOME/.config/kitty/colors.conf"
ln -sf "$THEME_DIR/$THEME_NAME/dunstrc"              "$HOME/.config/dunst/dunstrc"
ln -sf "$THEME_DIR/$THEME_NAME/swaync.css"           "$HOME/.config/swaync/style.css"

# Reload components
hyprctl reload 2>/dev/null || true
pkill waybar && waybar &
pkill dunst && dunst &
swaync-client -rs 2>/dev/null || true
kill -USR1 $(pgrep kitty) 2>/dev/null || true

# Wallpaper with transition
swww img "$THEME_DIR/$THEME_NAME/wallpaper.png" \
  --transition-type fade --transition-duration 2

# GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-$THEME_NAME-Standard-Accent-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-$THEME_NAME-dark-cursors"

# Save current theme
echo "$THEME_NAME" > "$HOME/.config/current-theme"

notify-send "Theme Changed" "Switched to $THEME_NAME"
```

### Dynamic Color Extraction (Wallpaper-Generated Themes)

We already extract dominant colors from wallpapers for the logo overlay system (`imagemagick` + `convert`). That same foundation can generate a full theme palette from any wallpaper.

**Approach:**
1. Pick a wallpaper → extract 8-16 dominant colors with imagemagick
2. Map them to semantic roles: background, surface, accent, text, urgent
3. Write those values into component configs (waybar CSS vars, kitty colors, rofi theme, etc.)
4. Apply the same reload flow as the static theme switcher

**Tools to look at:**
- `pywal` / `wal` — the classic; generates colorschemes from wallpapers and exports to 30+ app templates
- `matugen` — Material 3 palette generator (used by Caelestia-dots), more principled color relationships
- Our own imagemagick pipeline — we already have the extraction, could skip pywal entirely

**Why this is compelling:**
- Every wallpaper becomes its own theme automatically
- Wallpaper picker + theme switcher become one action
- The logo overlay already does contrast-aware color selection — extend that logic

**Inspiration:** Caelestia-dots uses `matugen` to derive the full palette from the wallpaper, then templates every component config from it.

### Theme Picker via Rofi

- Show all themes as a rofi menu with screenshot previews (same grid layout as wallpaper picker)
- Keybind: `Super + Shift + T`
- Long-term: wallpaper picker **is** the theme picker — selecting a wallpaper auto-applies the extracted palette

### Adding Flair to Themes

Beyond just colors — make each theme feel distinct:
- **Different wallpaper families** per variant (same feel, different image)
- **Different gap sizes** (Mocha = tighter, Macchiato = more airy)
- **Different border width/glow intensity** per theme
- **Per-workspace wallpapers** (see wishlist below)

### Catppuccin Macchiato Color Reference

| Color | Hex |
|-------|-----|
| Rosewater | `#f4dbd6` |
| Flamingo | `#f0c6c6` |
| Pink | `#f5bde6` |
| Mauve | `#c6a0f6` |
| Red | `#ed8796` |
| Maroon | `#ee99a0` |
| Peach | `#f5a97f` |
| Yellow | `#eed49f` |
| Green | `#a6da95` |
| Teal | `#8bd5ca` |
| Sky | `#91d7e3` |
| Sapphire | `#7dc4e4` |
| Blue | `#8aadf4` |
| Lavender | `#b7bdf8` |
| Base | `#24273a` |
| Mantle | `#1e2030` |
| Crust | `#181926` |

---

## Window Manager Deep Config

### MangoWC

- [ ] **Explore Hyprland plugins** — see if they can replicate MangoWC's scrolling layout, and evaluate whether to switch back or stay on MangoWC
- [x] **Scratchpad terminal** — `Super+grave` toggle, `Super+Shift+grave` to send window; uses `toggle_named_scratchpad` (auto-spawns kitty on first press); 75%×85% centered float; **note:** MangoWC always centers — true top-drop (Yakuake-style) not possible without patching compositor
- [ ] **Window rules** — pin specific apps to specific tags: VSCode → tag 2, browser → tag 3, terminal → tag 1
- [ ] **Floating window exceptions** — calculator, file pickers, pavucontrol already done; refine for all popup windows
- [ ] **Special layouts for dev workflow** — define named layout presets: "code mode" (editor 60% + terminal 40%), "research mode" (browser 50% + notes 50%)
- [ ] **Focus mode** — hide waybar, disable notifications (`swaync-client -d`), toggle with `Super + Shift + F`
- [ ] **Gaming mode** — disable compositor effects (blur/shadows), maybe switch compositor or disable animations for performance
- [ ] **Per-workspace wallpapers** — different swww image per tag switch via hook/script
- [ ] **Hex animation** on window open/close — look into MangoWC SceneFX or custom animation curves for hexagonal/geometric transitions (inspired by KDE/GNOME effect plugins)

### Multi-Monitor & Dock/Undock

- [ ] **Hotplug detection script** — auto-reconfigure monitor layout when docking/undocking
- [ ] **Monitor layout presets** — "laptop only", "home dock" (laptop + 2 external), "work dock" — switch via rofi
- [ ] **Tags follow monitors** — when undocking, windows on external monitor tags come back to laptop screen gracefully
- [ ] **Keybind:** `Super + Ctrl + ,/.` for monitor focus already done — extend with layout preset switcher

### Hyprland (Backup) Deep Config

- [ ] Port all MangoWC window rules to Hyprland
- [ ] Add animation curves for window transitions
- [ ] Investigate `hyprsome` or similar for better multi-monitor workspace management
- [ ] Keep in sync with MangoWC config changes

---

## Custom Workflow Scripts

### Context Menu / Quick Tools

A radial or rofi context menu with situationally useful tools — like a right-click desktop menu but keyboard-driven:

```
Super + X → rofi menu:
├── Color picker (wl-color-picker)
├── Screenshot region (grim + slurp)
├── Screenshot window
├── Record screen (wf-recorder toggle)
├── OCR text from screen (frog)
├── Quick calculator (rofi-calc)
└── Emoji picker
```

### Screenshot & Recording

- [ ] **Screenshot region** → clipboard: `Super + S` (done)
- [ ] **Screenshot full** → save: `Super + P` (done)
- [ ] **Annotate screenshot** — add `swappy` as post-screenshot annotation layer before copying
- [ ] **Screen recording toggle** — `Super + Shift + R` starts/stops `wf-recorder`, saves to `~/Videos/Recordings/`
- [ ] **Window screenshot** — snap just the active window (grim with `-g "$(hyprctl activewindow -j | jq -r '.at,.size' ...)"`)

### Project Workspace Switcher

Detect git repos in `~/Projects/` and let you jump to them via rofi:

```bash
# scripts/rofi/project-switcher.sh
find ~/Projects -maxdepth 2 -name ".git" -type d \
  | sed 's|/.git||' \
  | xargs -I{} basename {} \
  | rofi -dmenu -p "Project" \
  | xargs -I{} kitty --directory ~/Projects/{}
```

- Opens a kitty terminal in the selected project
- Could also open VSCode with the project: `code ~/Projects/{}`
- Keybind: `Super + Ctrl + T`

### VSCode Project Switcher

Launch VSCode with a recently used project via rofi:

```bash
# Use VSCode's internal recent projects list
# ~/.config/Code/User/globalStorage/storage.json
# Parse recentFolders → rofi → code <path>
```

- Keybind: `Super + P`

### SSH Quick Connect

```bash
# scripts/rofi/ssh-connect.sh
# Parse ~/.ssh/config for Host entries
grep "^Host " ~/.ssh/config | awk '{print $2}' \
  | rofi -dmenu -p "SSH" \
  | xargs -I{} kitty ssh {}
```

- Keybind: `Super + Ctrl + S`

### Monitor Layout Switcher

```bash
# scripts/monitor-layout.sh
# Presets: laptop, home, work, presentation
case "$1" in
  laptop)   # disable externals, laptop only ;;
  home)     # laptop + 2 external monitors ;;
  work)     # laptop + 1 external ;;
  present)  # mirror laptop to external ;;
esac
```

- Launch via rofi: `Super + Shift + M`

### Keyboard Layout Indicator & Switcher

- `Alt + Shift` already toggles QWERTY ↔ AZERTY
- [ ] Add waybar indicator showing current layout
- [ ] Look into `kanata` for more advanced layout/remapping (tap-hold Caps Lock, etc.)

### VPN Status & Control

- [ ] Waybar module showing VPN connected/disconnected + which profile
- [ ] Click to toggle VPN via rofi (list profiles → connect/disconnect)
- [ ] Script: `nmcli con show --active | grep vpn`

---

## App Launcher Evolution

### Rofi Deep Config

Currently using `rofi-wayland` for app launch and clipboard. Deep customization:

- [ ] **Rofi-calc** — `Super + =` launches calculator directly in rofi
- [ ] **Emoji picker** — `rofimoji` or `rofi-emoji` plugin
- [ ] **Custom theme** — full Catppuccin Macchiato rofi theme (background, selection, input colors)
- [ ] **Grid mode** for app launcher (icons + names, not just list)
- [ ] **Rofi as file picker** override (via xdg-desktop-portal)

### Walker vs Rofi

- [ ] **Evaluate Walker** — newer Wayland-native launcher, written in Go
  - Faster startup than rofi
  - Built-in plugins: apps, commands, files, websearch, calc
  - GTK4, better Wayland integration
  - Decision: test it for a week, compare with rofi for daily use

---

## Waybar Deep Customization

Goal: waybar is a live dashboard, not just a clock and workspace switcher.

### Modules to Build/Improve

| Module | Status | Notes |
|--------|--------|-------|
| Workspaces/Tags | Done | Shows active tag |
| Clock | Done | — |
| Battery | Done | With alert script |
| Network/WiFi | Done | nm-applet |
| Volume | Done | PipeWire |
| Bluetooth | Partial | Blueman |
| Brightness | Done | brightnessctl |
| CPU/RAM | Partial | Consider custom script vs btop |
| **Git branch** | To build | Show current branch for focused window's directory |
| **VPN status** | To build | Active VPN profile name + toggle on click |
| **AWS profile** | To build | Currently assumed profile via Granted |
| **Keyboard layout** | To build | Show QWERTY/AZERTY indicator |
| **Docker status** | To evaluate | Running containers count |
| **Swaync unread** | To add | Notification count badge → click to open panel |
| **Terraform workspace** | To evaluate | Show current `terraform workspace` |
| **Hyprpicker trigger** | To add | Click to launch color picker |

### Git Branch Module

```bash
#!/bin/bash
# scripts/waybar/git-branch.sh
# Find git repo for the focused window's working directory
FOCUS_PID=$(hyprctl activewindow -j | jq -r '.pid' 2>/dev/null)
if [ -n "$FOCUS_PID" ]; then
  CWD=$(readlink -f /proc/$FOCUS_PID/cwd 2>/dev/null)
  BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    echo " $BRANCH"
    exit 0
  fi
fi
echo ""
```

### AWS Profile Module

```bash
#!/bin/bash
# scripts/waybar/aws-profile.sh
# Show active AWS profile from granted/env
PROFILE="${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-none}}"
echo " $PROFILE"
```

### Caps Lock Indicator

- [ ] Caps Lock indicator module in waybar (module not detecting currently — low priority)

### Waybar Icons

- [ ] Audit all module icons — ensure Nerd Font icons show correctly
- [ ] Make every module clickable where it makes sense:
  - Battery → open btop
  - Network → open blueman / nm-connection-editor
  - Volume → open pavucontrol
  - Clock → open calendar app
  - Swaync → toggle notification panel
  - AWS → open rofi AWS profile switcher

### Quickshell

- [ ] Investigate **Quickshell** as a future waybar replacement (QML-based, more powerful)
- References: [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland), [caelestia-dots/shell](https://github.com/caelestia-dots/shell)

---

## Productivity Tools

### Clipboard

- [x] `cliphist` + rofi: `Super + V`
- [ ] Image clipboard support (paste images from clipboard history)
- [ ] Pin clipboard entries (keep certain items permanently)

### Hyprshot / Hyprpicker

- [ ] **Hyprpicker** — Hyprland-native color picker (alternative to wl-color-picker)
  - Freezes the screen while picking (better UX)
  - Keybind: `Super + Shift + C`
- [ ] **Hyprshot** — Hyprland screenshot tool with more options than grim+slurp

### Drawing / Whiteboard

- [ ] **Excalidraw** — for quick diagrams and sketches. Run as a PWA in Zen Browser
  - Good for: architecture diagrams, braindumps, quick wireframes
  - App: `excalidraw.com` → install as PWA
- [ ] Could also try: **Rnote** (native Linux drawing app, stylus support)

### RSS Feeds

- [ ] Explore what RSS is and how to use it
- Tools to evaluate:
  - **Newsboat** — TUI RSS reader (terminal)
  - **Miniflux** — self-hosted RSS server with web UI
  - **Fraidycat** — simple, minimal feed tracker
- Use case: follow blog posts, Arch news, GitHub releases, tech articles without a social feed

### Quick Notes / Scratchpad

- [ ] **Obsidian quick capture** — keybind to open a daily note or inbox note instantly
- [ ] Integrate Claude into Obsidian for AI-assisted note taking (look into Obsidian Claude plugin)

### Rofi Settings Menu

A unified settings launcher for OS controls — instead of hunting for GUI panels:

```
Super + Shift + S → rofi settings:
├── Bluetooth (blueman)
├── WiFi (nm-connection-editor)
├── Audio (pavucontrol)
├── Display (wdisplays or custom script)
├── Power (wlogout)
├── Keyboard layout toggle
└── Screen lock
```

---

## AWS & Cloud Workflow

### Version Control Context

- **Personal projects:** GitHub (`github-cli` / `gh`)
- **Work projects:** GitLab (install `glab` — official GitLab CLI)
- Both need SSH keys configured (already done from Fedora migration)

Waybar git branch module should work for both since it reads from the local repo regardless of remote.

### AWS Console Launcher

```bash
# scripts/rofi/aws-launcher.sh
# List AWS profiles → open console in browser for selected
assume --list | rofi -dmenu -p "AWS Profile" \
  | xargs -I{} sh -c 'assume -c {}'
```

- Keybind: `Super + A`

### Terraform Commands

```bash
# scripts/rofi/terraform-menu.sh
echo -e "plan\napply\ndestroy\nworkspace list\nworkspace select\noutput\nstate list" \
  | rofi -dmenu -p "Terraform" \
  | xargs -I{} kitty --title "Terraform" sh -c "terraform {}"
```

- Keybind: `Super + Ctrl + P`

### AWS Profile Indicator

- Waybar module showing active AWS profile (see Waybar section)
- Click to open rofi profile switcher

### K8s Context Switcher

- [ ] `kubectl config get-contexts` → rofi → `kubectl config use-context`
- Keybind: `Super + Ctrl + K`

---

## Terminal & Editor Deep Config

### Kitty Deep Config

- [ ] **Tab management** — improve tab bar style, rename tabs per project
- [ ] **Split panes** — configure horizontal/vertical splits with Kitty's native splits
- [ ] **Window decoration** — borderless with MangoWC, styled border color matches Catppuccin
- [ ] **Image preview** — ensure yazi image preview works properly in kitty
- [ ] **Bird's-eye tab overview** — Ptyxis-inspired: script to list all kitty windows/tabs in rofi
- [ ] **Remote control** — use `kitty @` to script kitty from outside (open tab, run command, etc.)

### Kitty Sessions

Pre-defined workspace layouts launched via command:

```bash
# sessions/dev.conf
new_tab editor
launch --cwd ~/Projects/current-project code .

new_tab terminal
launch --cwd ~/Projects/current-project

new_tab git
launch --cwd ~/Projects/current-project lazygit
```

```bash
# Launch a dev session
kitty --session ~/.config/kitty/sessions/dev.conf
```

### Neovim Setup

- [ ] Install `neovim`
- [ ] Start with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — well-documented minimal config
- [ ] Add plugins incrementally: LSP, treesitter, telescope, oil.nvim (file browser)
- [ ] Catppuccin theme: `catppuccin/nvim`
- [ ] **Vim motions in VSCode first** — install `VSCodeVim` extension, learn the motions before going full Neovim
- [ ] **vim-be-good** game to practice: `paru -S vim-be-good`

### LazyVim Alternative

- LazyVim = opinionated Neovim distribution with batteries included
- Kickstart.nvim = minimal starting point you configure yourself
- Recommendation: start with kickstart, graduate to LazyVim if you want more out of the box

### Fish Shell Deep Config

- [ ] Custom functions for frequent workflows (project jump, AWS switch, etc.)
- [ ] `fish_user_key_bindings` for custom keybinds inside shell
- [ ] Better `$PATH` management
- [ ] Per-directory `.envrc` support via `direnv`

---

## Browser Customization

### Zen Browser

- [ ] **Catppuccin theme** — install via Zen's theme system or userchrome.css
- [ ] **Stylus extension** — apply Catppuccin CSS to popular sites (GitHub, Reddit, YouTube, etc.)
- [ ] **Deep settings exploration** — zen:config, performance settings, privacy tuning
- [ ] **Custom new tab** — minimal, keyboard-focused new tab page
- [ ] **YouTube PWA** — install YouTube as a standalone PWA window (avoids browser chrome)
- [ ] **Vertical tabs** — Zen has native vertical tabs, configure and master it

### Stylus Catppuccin Sites

Priority sites to theme with Stylus:
- GitHub (catppuccin/github)
- Reddit
- YouTube
- Twitch
- Discord (web)
- Google

---

## Email & Communication

### Thunderbird

- [ ] Evaluate **Thunderbird** as native email/calendar client (vs browser Gmail)
- [ ] Or: **Betterbird** — Thunderbird fork with more features and better UX
- [ ] Catppuccin theme available for Thunderbird

### Teams

Currently using Teams PWA in Zen Browser. Improvements:
- [ ] Teams-specific browser profile in Zen (isolated cookies/sessions)
- [ ] PWA mode with desktop integration

---

## Note Taking & Knowledge Base

### Obsidian

Current status: installed, basic use.

- [ ] **Daily notes workflow** — templater plugin for consistent daily note format
- [ ] **Claude AI integration** — Obsidian has community plugins for AI assistants; look into claude.md-based workflows or API-connected plugins
- [ ] **Obsidian Sync or self-hosted** — sync vault across devices (Obsidian Sync, or Syncthing + git)
- [ ] **Canvas** — visual brainstorming in Obsidian, could replace Excalidraw for some uses
- [ ] **Dataview plugin** — query your notes like a database

### AppFlowy

- [ ] Evaluate **AppFlowy** — open source Notion alternative, self-hosted
  - Better for structured data (databases, kanban boards)
  - Compare with Obsidian for personal knowledge management needs

---

## Reading & Books

### CS Book List

Books worth reading — download and read on PC:

| Book | Author | Topic |
|------|--------|-------|
| Structure and Interpretation of Computer Programs (SICP) | Abelson & Sussman | Programming fundamentals, Lisp/Scheme |
| Computer Systems: A Programmer's Perspective (CSAPP) | Bryant & O'Hallaron | How computers actually work — systems programming |
| Designing Data-Intensive Applications (DDIA) | Martin Kleppmann | Databases, distributed systems, data engineering |

**Reading setup:**
- PDFs in `~/Documents/Books/`
- Open with `zathura` (vim keybinds, minimal distraction)
- Or: `mdcat` for markdown-format summaries/notes alongside

### Zathura for Reading

- Dark background reading: Zathura already supports Catppuccin colors via config
- Reflow mode for long PDFs
- Bookmarks: `:bmark` inside zathura

---

## OS-Level Controls & Settings

### Settings Access

Goal: never open a GUI settings app, drive everything from keyboard:

- [ ] **Rofi settings menu** (see Productivity section) — unified launcher for all system settings
- [ ] **Bluetooth toggle** — `blueman` or `bluetoothctl` via rofi, keybind TBD
- [ ] **WiFi switcher** — `nmcli` via rofi, list and connect to networks
- [ ] **Display control** — `wdisplays` or `kanshi` for monitor layout without GUI
- [ ] **Brightness/volume** already on function keys — add fine control via rofi if needed

### Kansi / Auto Monitor Profiles

- [ ] **kanshi** — automatically applies monitor profiles based on which monitors are connected
  - Dock at home → apply home layout
  - Undock → laptop only layout
  - No manual switching needed

### Kanata Key Remapping

- [ ] Install `kanata`
- [ ] Remap Caps Lock: **tap = Esc**, **hold = Ctrl**
- [ ] Evaluate other remaps: F-row as function keys (already mostly done via firmware)
- [ ] Could also implement: Home Row Mods (a/s/d/f = Ctrl/Alt/Super/Shift on hold)

---

## Music & Media

### Spotify Theming

- [ ] **Spicetify** — Spotify desktop client themer
  - Apply Catppuccin Macchiato theme
  - Custom CSS for Spotify desktop
  - Keybindings, custom extensions
  - Install: `paru -S spicetify-cli`

### Ncspot

- [ ] Install `ncspot` — Rust TUI Spotify client
  - Lower resource usage than Electron Spotify
  - Keyboard-driven
  - Good for quick control from terminal

### Media Controls

Waybar already has media control via playerctl. Improve:
- [ ] Show current track name + artist in waybar
- [ ] Click to play/pause
- [ ] Scroll to change volume

---

## Screensaver & Lock Screen

### Screensaver Rotation

Rotate between terminal animations when idle (before lock screen kicks in):

```bash
# scripts/screensaver.sh
#!/bin/bash
# Random screensaver picker
case $((RANDOM % 4)) in
  0) cmatrix -a -b -C cyan ;;
  1) cbonsai -l -t 0.03 ;;
  2) asciiquarium ;;
  3) pipes.sh -p 4 -c 3 ;;
esac
```

- [ ] Wire into `swayidle` — run screensaver after 2 min idle, lock after 5 min
- [ ] Or: run in a kitty window that auto-launches on idle trigger

### Lock Screen

- swaylock (MangoWC): styled with Catppuccin + blurred wallpaper
- hyprlock (Hyprland): same styling

- [ ] **Clock on lock screen** — large time display overlaid on blurred wallpaper
- [ ] **Screensaver on lock screen** — run a terminal animation inside the lock screen (cmatrix behind the time/password prompt)

---

## Visual Flair & Animations

These are the "fun" items — not essential but make the desktop feel alive.

- [ ] **Hex open/close animations** — investigate MangoWC SceneFX or custom animation plugin for hexagonal window transitions (inspired by KDE Wobbly Windows / Burn-My-Windows GNOME extension)
- [ ] **Window blur** — MangoWC SceneFX blur, tune radius and opacity
- [ ] **Active window border glow** — Catppuccin Mauve (#c6a0f6) glow on focused window border
- [ ] **Inactive window opacity** — slightly dim unfocused windows (0.85-0.9 opacity)
- [ ] **Workspace transition animation** — smooth slide when switching tags
- [ ] **Smooth wallpaper transitions** — already using swww, tune transition type and duration per theme
- [ ] **SDDM idle animation** — set a screensaver/animation on the login screen between sessions

---

## Portability & Machine Profiles

The dotfiles repo should be deployable to any machine with minimal friction, adapting to the use case rather than assuming a dev laptop context.

### Machine Profiles

| Profile | Target | Key differences |
|---------|--------|-----------------|
| `swe-laptop` | HP EliteBook (current) | Full dev stack, AWS/Terraform, work integrations, MangoWC |
| `gaming-desktop` | Personal PC (future) | Gaming mode default, different compositor tuning, no work tools |
| `home-productivity` | Personal PC (non-gaming) | Lighter stack, Obsidian/media focus, no work AWS/Terraform |

### How Profiles Would Work

The install script already handles symlinking configs. Extend it to accept a profile argument:

```bash
./scripts/install.sh --profile swe-laptop
./scripts/install.sh --profile gaming-desktop
```

Each profile defines:
- Which packages to install (a packages list per profile)
- Which dotfiles to stow (skip work tools on gaming, skip gaming tools on work)
- Which waybar modules to enable
- Which autostart apps to launch

**Shared across all profiles:** theme system, fish config, kitty, neovim, basic utilities

### Windows Dual Boot Consideration

If deploying to a Windows PC:
- WSL2 + fish/kitty for terminal work (limited)
- Or: proper dual boot, apply the same Arch install + profile system
- Gaming profile would live on Windows side, productivity on Arch
- Dotfiles repo is the same — profile flag determines what gets deployed

### Incremental Philosophy (constraint to keep)

From the project principles — worth writing down explicitly so it doesn't get violated:

1. **Understand everything** — no config line goes in without knowing what it does
2. **One feature at a time** — test before adding the next thing
3. **Stability over aesthetics** — this is a work machine; broken compositor = lost work day
4. **No wholesale dotfile copying** — steal ideas, not configs
5. **If it works, don't touch it** — resist the urge to refactor things that aren't broken

---

## References

### Official Docs
- [Arch Wiki](https://wiki.archlinux.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [MangoWC GitHub](https://github.com/dov-vai/MaGoWC)

### Communities
- r/unixporn, r/hyprland, r/archlinux
- Hyprland Discord

---

## Inspiration Sources

Reference these when planning new features — steal ideas, not configs.

### Shell / Widget Systems

| Tool | Language | What it can do | Link |
|------|----------|---------------|------|
| **Quickshell** | QML (Qt declarative) | Full desktop shells, animations, sliders, toggles, live previews, blur — unlimited ceiling | [quickshell.outfoxxed.me](https://quickshell.outfoxxed.me) |
| **Astal/AGS v2** | TypeScript + GTK4 | Real widgets, toggles, sliders, dynamic theming — good if you know JS/TS | [aylur.github.io/astal](https://aylur.github.io/astal) |
| **eww** | Yuck (Lisp DSL) | Lightweight widgets, events, basic animations — minimal deps | [elkowar.github.io/eww](https://elkowar.github.io/eww) |
| **nwg-shell** | Python + GTK3 | Complete pre-built shell, graphical config — zero coding required | [nwg-piotr.github.io/nwg-shell](https://nwg-piotr.github.io/nwg-shell) |

**Decision:** Quickshell. QML is its own learning investment regardless of prior language knowledge — no point going through AGS as a stepping stone. Quickshell has the highest ceiling and is what caelestia (the primary visual reference) is built on.

---

### Dotfile Repos

| Source | Stack | What makes it special | Link |
|--------|-------|----------------------|------|
| **caelestia-dots** | Quickshell (QML) + matugen | The primary visual reference. Material Design 3, dynamic palette from wallpaper, smooth spring animations throughout, everything one QML process. Full source is readable. | [caelestia-dots/shell](https://github.com/caelestia-dots/shell) |
| **end-4/dots-hyprland** ★8k | Quickshell (migrating from AGS) | Usability-first. Workspace overview with live previews, sidebar panels, best documentation of any dotfiles project. Official Hyprland wiki example. | [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) · [wiki](https://end-4.github.io/dots-hyprland-wiki/en/) |
| **HyDE (prasanthrangan)** ★8.6k | Waybar + Rofi | Theme switching as the core feature — multiple complete visual presets with screenshots. Reference implementation for the theme switcher. | [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots) |
| **JaKooLit/Hyprland-Dots** ★3.3k | Waybar + Rofi + Wallust + QML | Multi-distro installer, 2K-optimized, Wallust for auto-coordinated colors from wallpaper. Good reference for "polished waybar." | [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) |
| **linuxmobile/hyprland-dots** | Waybar + Rofi + Catppuccin | Catppuccin Macchiato/Mocha — same palette as this setup. Closest to current state, good reference for "maximally polished rofi+waybar." | [linuxmobile/hyprland-dots](https://github.com/linuxmobile/hyprland-dots) |
| **ML4W (mylinuxforwork)** | Waybar + installer | Professional/production focus. Graphical installer, multi-distro (Arch/Fedora/openSUSE). Shows how to make setup reproducible and approachable. | [ml4w.com](https://www.ml4w.com) · [GitHub](https://github.com/mylinuxforwork/dotfiles) |
| **taylor85345/hyprland-dotfiles** | Hyprland + eww | Neon glow border effect achieved entirely via large colored drop shadows (`shadow_range=30`, bright `col.shadow`) — no plugin needed. eww bar. Technique directly transferable to MangoWC via `shadowscolor` + `shadows_size`. | [taylor85345/hyprland-dotfiles](https://github.com/taylor85345/hyprland-dotfiles) |
| **saimoomedits/dotfiles** | AwesomeWM (X11) | Expandable sidebar control center concept — not usable directly (X11) but the UI pattern is worth stealing for Quickshell control panel design. | [saimoomedits/dotfiles](https://github.com/saimoomedits/dotfiles) |
| **Adnan's dotfiles** | Waybar + Rofi | Minimalist Catppuccin implementation, clean structure. Good for "less is more" reference. | [Adnan-Malik-26/dotfiles](https://github.com/Adnan-Malik-26/dotfiles) |
| **Omarchy** | Curated Arch setup by DHH | Opinionated tool choices, clean config philosophy — worth reading even if not using directly. | [omarchy.org](https://omarchy.org) |

### Color / Theme Tools

| Tool | What it does | Link |
|------|-------------|------|
| **matugen** | Material 3 palette generator from wallpaper — used by caelestia | [GitHub](https://github.com/InioX/matugen) |
| **Wallust** | pywal successor — generates coordinated colorscheme from wallpaper, exports to app templates | [GitHub](https://github.com/0xb-8/wallust) |
| **pywal** | Classic wallpaper→colorscheme tool, 30+ app templates | [GitHub](https://github.com/dylanaraps/pywal) |

---

## Tools to Evaluate

Things from the notes that need investigation before committing:

| Tool | Category | What to check |
|------|----------|---------------|
| **Walker** | App launcher | Speed vs rofi, plugin ecosystem, Wayland support |
| **Ghostty** | Terminal | Stability, feature parity with kitty |
| **Tabby** | Terminal | SSH management, tab features |
| **Quickshell** | Status bar | Replaces waybar, much more powerful but complex |
| **LM Studio** | Local LLM | Run local AI models — evaluate hardware requirements on i7-1355U/32GB |
| **Mission Center** | System monitor | GUI alternative to btop |
| **Kanata** | Key remapper | Caps Lock → Esc/Ctrl, home row mods |
| **AppFlowy** | Notes | Notion alternative, self-hosted |
| **Rnote** | Drawing | Native whiteboard app, stylus support |
| **Kanshi** | Monitor hotplug | Auto monitor profiles on dock/undock |
| **Wdisplays** | Display control | GUI display layout editor for Wayland |
| **Omarchy** | Dotfiles inspiration | [Look at omarchy](https://omarchy.org) for cool features to steal |
| **glab** | GitLab CLI | Work equivalent of `gh` — MRs, pipelines, issues from terminal |
| **tmux** | Terminal multiplexer | Session persistence for SSH; maybe — kitty tabs + splits may be enough |
| **zellij** | Terminal multiplexer | Rust-based tmux alternative, friendlier UX; same question as tmux |

### Omarchy Notes

- Omarchy is a curated Arch Linux setup by DHH (creator of Rails)
- Interesting for: opinionated tool choices, clean config philosophy
- Worth reading the source even if not using directly

---

## Dotfiles & Reproducibility

- [x] Git repository structure (stow-based, fully tracked)
- [x] Install script (`scripts/install.sh` — stow deploy + local scripts + systemd services)
- [ ] Backup script — automated snapshot of current working configs
- [ ] Restore script — deploy configs to a new machine

---

## Completed / Shipped

Tracking what's done so this doc doesn't become stale:

- [x] Base Arch installation + dual boot with Fedora
- [x] MangoWC as primary compositor
- [x] Hyprland as backup compositor
- [x] Waybar (separate configs per compositor)
- [x] Rofi-wayland app launcher
- [x] Catppuccin Macchiato as base theme
- [x] Fish shell + Starship prompt
- [x] Lazygit with Catppuccin theme
- [x] Atuin shell history
- [x] Navi CLI cheatsheets
- [x] Tealdeer (tldr, Rust)
- [x] Gping (graphical ping)
- [x] Granted (AWS multi-account)
- [x] awww wallpaper with transitions (was `swww` — renamed after pacman update)
- [x] Arch logo overlay system (arch / rebel / imperial logos)
- [x] Rofi wallpaper picker (thumbnail grid)
- [x] Swaylock + swayidle (MangoWC)
- [x] Hyprlock + hypridle (Hyprland)
- [x] Cliphist clipboard history (`Super+V`)
- [x] Grim + Slurp screenshots
- [x] Wl-color-picker
- [x] Battery alert script
- [x] GNU Stow dotfile management
- [x] Swaync (notification center, MangoWC) — with Catppuccin glass CSS, waybar bell module, `Super+;` keybind, DND toggle
- [x] battery-alert.service (systemd user service — persistent battery monitoring, swaync-compatible)
- [x] Portrait monitor support in wallpaper-set.sh (auto-detected, blurred-backdrop variant)
- [x] Logo area normalization in wallpaper-set.sh (all logos same visual weight regardless of aspect ratio)
- [x] Improved color extraction in wallpaper-set.sh (saturation+contrast scoring, grey wallpaper fallback)
- [x] Monitor fallback rules in mango config (HDMI.*/DP-.* wildcards for unknown displays)
- [x] install.sh: install_local_scripts() + enable_user_services() functions
- [x] Obsidian (note taking)
- [x] Yazi (TUI file manager)
- [x] Btop (system monitor)
- [x] Zoxide (smart cd)
- [x] Eza (better ls)
- [x] Bat (better cat)
- [x] Zathura (PDF viewer)
- [x] MPV (video player)
- [x] Blueman (Bluetooth)
- [x] Snapper + snap-pac (btrfs snapshots)

---

**This document is a living roadmap — check off items as they ship and add new ideas freely.**
