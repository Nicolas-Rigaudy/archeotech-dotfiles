# Arch + MangoWC/Hyprland Dotfiles Project

## Project Overview

This is a comprehensive Arch Linux desktop environment with MangoWC (primary) and Hyprland (backup) compositors, built from scratch. Every component is understood, documented, and reproducible. This project serves as both a daily driver system and a learning journey into Linux customization.

**Project Goals:**
1. Build a fully functional, beautiful Arch + Wayland compositor system
2. Understand every component and configuration decision
3. Create reproducible dotfiles that can be deployed to any machine
4. Document everything for future reference and learning
5. Eventually deploy to personal Windows PC (dual-boot or full switch)

**Current Status:** ✅ **FULLY FUNCTIONAL - Daily Driver Ready**
- System installation complete (MangoWC primary, Hyprland backup)
- Development environment working
- Theming applied (Catppuccin Macchiato)
- All core features operational
- Comprehensive documentation in docs/ and .claude/ folders

---

## System Specifications

### Hardware
- **Laptop:** HP EliteBook 860 16 inch G10 Notebook PC
- **CPU:** 13th Gen Intel Core i7-1355U (12 cores, 5.00 GHz)
- **RAM:** 32GB (30.98 GiB usable)
- **GPU:** Intel Iris Xe Graphics @ 1.30 GHz (integrated)
- **Storage:** 512GB Samsung MZVL4512HBLU-00BH1 NVMe SSD
- **Built-in Display:** 1920x1200 @ 60Hz (16", BOE 0x0A32)
- **Keyboard:** AZERTY (French) laptop keyboard
- **External Keyboards:** QWERTY mechanical keyboard (work setup)

### Display Configurations
**Work Setup (3 monitors):**
- eDP-1: 1920x1200 @ 60Hz (laptop, left)
- HDMI-A-1: 1920x1080 @ 60Hz (landscape, middle)
- DP-3: 1920x1080 @ 60Hz (portrait, right) - Iiyama PL2493H

**Home Setup:**
- Laptop screen only, OR
- One 27" 2K monitor, OR
- One ultrawide 1080p monitor, OR
- TV via HDMI (any unknown display)

**Monitor fallback rules (MangoWC):** Named rules for work setup; wildcard `HDMI.*` and `DP-.*` rules catch any other display (landscape, preferred native res, positioned at x:1920,y:60)

### Dual-Boot Configuration
- **Primary OS:** Arch Linux (232GB partition on nvme0n1p4)
- **Secondary OS:** Fedora 42 KDE (265GB partition on nvme0n1p7, resized from 443GB)
- **Shared:** EFI partition (nvme0n1p1, 360M)
- **Bootloader:** GRUB with Catppuccin theme
- **Boot time:** ~5 seconds from GRUB to SDDM

---

## Architecture & Core Decisions

### System Architecture ✅
| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Distribution** | Arch Linux | Rolling release, full control, learn everything |
| **Filesystem** | btrfs | Snapshots for safety, familiar from Fedora |
| **Subvolumes** | @, @home, @snapshots, @cache, @log | Separate snapshots, exclude cache/logs from backups |
| **Snapshots** | Snapper + snap-pac + grub-btrfs | Automatic snapshots on pacman operations, bootable from GRUB |
| **Bootloader** | GRUB | Dual-boot friendly, themeable, auto-detects Fedora |
| **AUR Helper** | paru | Faster (Rust-based), more modern than yay |
| **Init System** | systemd | Default, no reason to change |

### Desktop Environment ✅
| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Window Manager (Primary)** | MangoWC (latest) | Scrolling layout feature, modern Wayland compositor |
| **Window Manager (Backup)** | Hyprland 0.52.1 | Fallback option, well-established compositor |
| **Display Manager** | SDDM | Best for Wayland compositors, Catppuccin themes available |
| **Status Bar** | Waybar 0.14.0 | CSS+JSON config, huge community, themeable |
| **App Launcher** | rofi-wayland | Most features, extensible |
| **Notifications** | dunst | Lightweight, themeable, simple config |
| **Wallpaper** | awww + wallpaper-set.sh | Animated transitions; custom script handles Arch logo overlay (note: package was renamed from swww → awww) |
| **Wallpaper Picker** | rofi (thumbnail grid) | scripts/wallpaper-picker.sh — 3-col grid, logos row 1, wallpapers below, vertical scroll |
| **Lock Screen** | swaylock (MangoWC) / hyprlock (Hyprland) | Compositor-specific lock screens |
| **Idle Manager** | swayidle (MangoWC) / hypridle (Hyprland) | Pairs with lock screens |

### Core Applications ✅
| Type | Application | Notes |
|------|-------------|-------|
| **Terminal** | kitty 0.44.0 | GPU-accelerated, FiraCode Nerd Font (11pt) |
| **Shell** | fish 4.2.1 | Friendly, already familiar |
| **Prompt** | starship 1.24.1 | Beautiful cross-shell prompt |
| **Browser** | zen-browser | Firefox-based, privacy-focused |
| **Editor** | VSCode | All extensions synced |
| **File Manager (GUI)** | thunar | 90% of Dolphin features, 30% of weight |
| **File Manager (TUI)** | yazi | Modern (Rust), beautiful, image preview |
| **Notes** | obsidian | Markdown-based knowledge management |
| **Image Viewer** | imv | Wayland native, lightweight |
| **PDF Viewer** | zathura | Vim-like keybinds, minimal |
| **Video Player** | mpv | Best Linux video player |
| **Archive Manager** | file-roller | GUI for zip/tar/etc |

### Development Tools ✅
| Tool | Version | Purpose |
|------|---------|---------|
| **Git** | Latest | Version control, configured with SSH keys |
| **AWS CLI** | 1.43.2 | AWS management, SSO configured |
| **Terraform** | 1.14.0 | Infrastructure as code |
| **Python** | 3.13.7 | Primary development language |
| **pip** | 25.3 | Python package manager |
| **Docker** | 29.0.4 | Containerization |
| **docker-compose** | Latest | Multi-container apps |

### Theme System ✅
| Component | Theme/Value | Notes |
|-----------|-------------|-------|
| **Color Scheme** | Catppuccin Macchiato | Soothing pastel, warmer than Mocha |
| **Accent Color** | Mauve (#c6a0f6) | Primary accent throughout |
| **GTK Theme** | catppuccin-macchiato-mauve-standard+default | For thunar, settings apps |
| **Icon Theme** | Papirus-Dark | Good Catppuccin support |
| **Cursor Theme** | catppuccin-macchiato-dark-cursors | Consistent theming |
| **Font (UI)** | Noto Sans | System UI |
| **Font (Terminal)** | FiraCode Nerd Font 11pt | With ligatures |
| **Font (Monospace)** | FiraCode Nerd Font | For code editors |

---

## User Context & Workflow

### Professional Context
- **Role:** Backend Software Developer + Cloud Architect Engineer
- **Primary Stack:** Python, Terraform, AWS
- **Daily Tools:** VSCode, Terminal (fish), AWS Console, GitLab, Teams
- **Work Style:** Multi-monitor, frequent context switching between projects

### Keyboard Layouts
- **Primary:** AZERTY (French - laptop built-in keyboard)
- **Secondary:** QWERTY (external mechanical keyboard at work)
- **Switching:** Alt+Shift (both in Hyprland and SDDM)
- **Keybinds:** Layout-aware (resolve_binds_by_sym = true)

### Workflow Needs
- Quick context switching between projects
- AWS profile management and quick console access
- Terraform workspace indicators
- Git branch visibility
- VPN status monitoring
- Multi-monitor dock/undock handling (work ↔ home)
- Screenshot and clipboard management

---

## Project Philosophy & Principles

### Core Principles
1. **Build from Scratch** - No pre-made configs (use Hyde/Caelestia for inspiration only)
2. **Understand Everything** - Every line of config should be comprehensible
3. **Reproducible** - Everything in git, deployable via scripts
4. **Incremental** - Add features one at a time, test thoroughly
5. **Documented** - Comment configs, write README, track decisions
6. **Work-First** - Productivity > aesthetics (but both are goals)

### What to Steal (Inspiration Sources)
- **Caelestia-dots:** Dynamic color extraction, Material 3 palettes, widget concepts
- **Hyde (hyprdots):** Theme switching system, multiple layouts, visual selector
- **end-4:** Clean animations, modern aesthetic, AGS widget ideas
- **Adnan's dotfiles:** Minimalist Catppuccin implementation, clean structure

### What NOT to Use
- ❌ Pre-built dotfiles wholesale (defeats learning purpose)
- ❌ Overly complex systems
- ❌ Unmaintained packages
- ❌ Anything not understood

---

## 🎯 NEXT MAJOR PROJECT: Unified Control System

### Vision

Turn this setup into something that makes Mac/Windows users jealous — a cohesive, beautiful, instantly accessible control layer over the whole system. Everything reachable in 1–2 keystrokes. Everything looks like it belongs together. Easy to extend.

The two pillars:
1. **SwayNC** ✅ DONE — replaces dunst. Notification history panel with DND toggle. Keybind to open/close.
2. **Rofi Settings Hub** — a single keybind opens a beautiful rofi menu giving access to every settings area: display profiles, wallpaper, appearance, audio, power, system tools.

Everything themed Catppuccin Macchiato, cohesive with the existing waybar/rofi style.

---

### Phase 1 — SwayNC ✅ COMPLETE

**What was built:**
- swaync installed, replaces dunst entirely
- Catppuccin Macchiato CSS — glass panel matching waybar aesthetic
- Notification history + DND toggle only (quick-toggle buttons were tried and abandoned — swaync's toggle buttons don't properly reflect real state, and waybar already covers volume/network/bluetooth)
- Waybar bell icon (󰂜) showing unread count, click to open panel, right-click to toggle DND
- `Super+;` keybind to toggle panel
- battery-alert.sh updated to use `notify-send` instead of `dunstify`
- `blur_layer=0` and `layer_shadows=0` in mango config to prevent compositor blur/shadow bleeding onto the panel

**Lessons learned:**
- swaync's `buttons-grid` toggle type does NOT reliably reflect real system state — `update-command` is not called on panel open, only on a timer. Don't use it for stateful toggles.
- MangoWC `layerrule=noblur/noshadow` for layer-shell surfaces didn't work — had to disable `blur_layer` and `layer_shadows` globally instead
- `mmsg reload` does NOT reliably reapply `monitorrule` — always log out/in for monitor config changes
- swww was renamed to awww after `pacman -Syu` — updated all references in mango config and wallpaper-set.sh
- swaync has no click-outside-to-close — Escape key closes it

**Config files:**
- `config/.config/swaync/config.json` — widgets: title, dnd, notifications only
- `config/.config/swaync/style.css` — Catppuccin Macchiato glass theme
- `config/.config/waybar/config-mango` — added `custom/notifications` module
- `config/.config/waybar/style-mango.css` — bell icon styles
- `config/.config/mango/config.conf` — swapped dunst→swaync in autostart, added Super+; keybind, blur_layer=0, layer_shadows=0, awww-daemon

---

### Phase 2 — Rofi Settings Hub

**Goal:** One keybind (`Super+,` or `Super+S`) opens a rofi menu that is the "Settings" of this system. Every setting reachable in max 2 clicks.

**Menu structure (planned):**

```
⚙  Settings
├── 🖥  Display          → opens wdisplays (drag-and-drop monitor layout)
├── 🎨  Appearance       → opens nwg-look (GTK theme, icons, cursor, fonts)
├── 🔊  Audio            → opens pavucontrol
├── 📡  Network          → opens nm-connection-editor
├── 🎵  Media            → opens playerctl / spotify
├── 🖼  Wallpaper        → runs wallpaper-picker.sh (existing rofi picker)
├── ⚡  Power            → opens power profile submenu (balanced/performance/saver)
├── 💾  Disk             → opens gnome-disk-utility
├── 🔵  Bluetooth        → opens blueman-manager
└── 🔒  Lock             → runs swaylock
```

**Design:**
- Same glass Catppuccin Macchiato style as the wallpaper picker
- Icons via Papirus-Dark (already installed)
- Each entry either: launches a GUI app, calls a script, or opens a sub-menu
- Submenus for things like Power (with profile choices) and Display (profiles vs wdisplays)

**Implementation steps:**
1. `paru -S wdisplays nwg-look wlsunset mission-center gnome-disk-utility`
2. Write `scripts/settings-hub.sh` — rofi dmenu script with icons, each line maps to a command
3. Write `scripts/assets/settings-hub.rasi` — rofi theme matching wallpaper-picker glass style
4. Wire `Super+,` keybind in mango config
5. Add "Settings" button to waybar (gear icon, right side)

---

### Phase 3 — Display Profiles (kanshi)

**Goal:** Never think about monitors again. Plug in any screen, it just works correctly.

**Profiles planned:**
- `desk` — 3 monitors: eDP-1 (laptop left), HDMI-A-1 (landscape middle), DP-3 (portrait right, Iiyama)
- `home` — 2 monitors: eDP-1 + any single external in landscape
- `solo` — laptop only
- `present` — eDP-1 + any external, both mirrored or extended landscape (for meetings/TV)

**Key insight from earlier work:** Need to identify Iiyama by EDID make/model, not port name. Must verify exact strings MangoWC uses via `mmsg` with a screen connected.

**Implementation steps:**
1. `paru -S kanshi`
2. Connect each monitor setup, run `mmsg -O` to confirm output names
3. Write `config/.config/kanshi/config` with named profiles
4. Add kanshi to mango autostart
5. Add "Display" entry in settings hub that offers: [Open wdisplays] [Desk profile] [Home profile] [Present profile] [Solo]
6. Keybind `Super+F1/F2/F3` for instant profile switching as a power-user shortcut

---

### Phase 4 — Polish & Cohesion

**Goal:** Everything feels like one system, not a collection of scripts.

- [ ] Waybar bell icon showing swaync unread count
- [ ] Waybar gear icon opening settings hub
- [ ] Consistent animation timing across rofi menus, swaync panel, waybar
- [ ] All rofi menus use same `.rasi` base theme (one source of truth for colors/radius/blur)
- [ ] swaync CSS matches waybar glass pill aesthetic exactly
- [ ] Keyboard shortcuts documented in a cheatsheet accessible via keybind
- [ ] `Super+?` → rofi keybinds cheatsheet

---

### Keybind Plan (new additions)

| Keybind | Action |
|---|---|
| `Super+;` | Toggle swaync notification panel ✅ |
| `Super+,` | Open settings hub (rofi) — TODO |
| `Super+F1` | Display profile: desk (3 monitors) — TODO |
| `Super+F2` | Display profile: present (laptop + external landscape) — TODO |
| `Super+F3` | Display profile: solo (laptop only) — TODO |
| `Super+?` | Keybinds cheatsheet — TODO |

---

### Packages to Install

```bash
paru -S swaync wdisplays kanshi nwg-look wlsunset mission-center gnome-disk-utility
```

---

### Design Rules for This System

1. **One color palette** — Catppuccin Macchiato everywhere. No exceptions.
2. **One rasi base** — all rofi menus import a shared `base.rasi` for colors/radius/font
3. **Glass aesthetic** — blur + transparency consistent with waybar pill style
4. **Icons everywhere** — Papirus-Dark icons in all menus, no text-only entries
5. **Max 2 keystrokes** to reach any setting from anywhere
6. **No fake toggles** — swaync button-grid toggles don't reflect real state reliably; use launcher buttons that open the right tool instead
7. **Nothing hardcoded** — colors in one place, easy to switch flavor (Mocha/Macchiato)

---

## Current Implementation Status

### ✅ COMPLETED (100%)

#### System Installation
- [x] Base Arch installation
- [x] Partitioning (dual-boot with Fedora preserved)
- [x] Btrfs with subvolumes configured
- [x] GRUB bootloader with dual-boot detection
- [x] User account created (corvus)
- [x] NetworkManager configured
- [x] Intel microcode installed
- [x] All work files and configs migrated from Fedora

#### Wayland Compositors & Desktop
- [x] MangoWC (primary) - with scrolling layout configured
- [x] Hyprland 0.52.1 (backup) - fully functional fallback
- [x] SDDM with Catppuccin Macchiato theme (sddm-catppuccin-git)
- [x] Multi-monitor configuration (3 screens, one portrait)
- [x] Workspace per monitor assignments (1-3 laptop, 4-6 ext1, 7-9 ext2)
- [x] Animations, blur, shadows, rounded corners configured
- [x] Waybar with clickable modules (works on both compositors) - macOS-style floating glass pill bar
- [x] Rofi launcher styled
- [x] SwayNC notifications — replaces dunst, Catppuccin glass panel, DND toggle, notification history, waybar bell icon
- [x] Swww wallpaper daemon with wallpaper collection in wallpapers/
- [x] Rofi wallpaper picker with thumbnail grid (Super+W) - 3-col glass grid, logos on row 1, vertical scroll, Catppuccin Macchiato themed
- [x] Waypaper installed as backup picker (configured with custom_command = wallpaper-set.sh)
- [x] Multi-logo overlay system (wallpaper-set.sh) - Arch Linux, Rebel Alliance, Imperial Aquila logos; adaptive color from wallpaper, toggle Super+Shift+W, remembers last active logo; portrait screen support (DP-3), area-normalized sizing, shape-hugging drop shadow, SVG cropping for imperial
- [x] Window rules for floating windows (waypaper, pavucontrol, bitwarden, file dialogs, calculator, browser popups)
- [x] swaylock (MangoWC) and hyprlock (Hyprland) configured
- [x] swayidle (MangoWC) and hypridle (Hyprland) auto-lock
- [x] All keybindings configured (see docs/KEYBINDS-MANGO.md and docs/KEYBINDS.md)
- [x] xdg-desktop-portal configured for screen sharing (Teams, Zoom, etc.)

#### Audio & Hardware
- [x] PipeWire audio stack installed
- [x] SOF firmware installed (was missing, caused no audio)
- [x] Speakers working
- [x] Microphone working
- [x] Media keys configured (volume, brightness, play/pause)
- [x] Bluetooth configured (blueman)

#### Terminal & Shell
- [x] Kitty terminal themed Catppuccin Macchiato
- [x] Fish shell set as default
- [x] Starship prompt configured
- [x] Zoxide (smart cd) integrated
- [x] Thefuck (command corrector) installed
- [x] Eza, bat, btop, fastfetch utilities
- [x] Navi (CLI cheatsheets)
- [x] Atuin (shell history with sync capabilities)
- [x] Gping (ping with graph visualization)
- [x] Tealdeer (Rust tldr replacement)

#### Development Environment
- [x] Git configured with restored SSH keys
- [x] AWS CLI with SSO authentication working
- [x] Granted (AWS account switcher & console launcher)
- [x] Terraform installed and working
- [x] Python + pip configured
- [x] Docker + docker-compose installed
- [x] VSCode with all extensions synced (including Vim extension)
- [x] Lazygit (TUI git client)
- [x] All work repositories accessible

#### Theming
- [x] Catppuccin Macchiato applied system-wide
- [x] GTK theme (catppuccin-macchiato-mauve)
- [x] Icon theme (Papirus-Dark)
- [x] Cursor theme (catppuccin-macchiato-dark)
- [x] Kitty fully themed
- [x] Waybar styled with Catppuccin
- [x] Rofi dark theme
- [x] SDDM login screen (Catppuccin Macchiato theme applied)
- [x] Notifications themed — replaced dunst with swaync, Catppuccin Macchiato glass CSS
- [x] GRUB Catppuccin Macchiato boot menu

#### Utilities & Tools
- [x] Screenshot tools (grim + slurp) with keybinds
- [x] Color picker (wl-color-picker - compositor-agnostic)
- [x] Clipboard history (cliphist) with rofi integration
- [x] Power menu (wlogout) in waybar
- [x] Bluetooth applet (blueman-applet)
- [x] Network applet (nm-applet)
- [x] Volume control (pavucontrol)
- [x] Brightness control (brightnessctl)
- [x] Media control (playerctl)
- [x] Image viewer (imv)
- [x] PDF viewer (zathura)
- [x] Archive tools (file-roller, unzip, unrar, p7zip)
- [x] Snapshot management (snapper + snap-pac + grub-btrfs + snapper-gui)
- [x] Battery alert script (dunst notifications at 20%/10%/5%, auto-suspend at 3%) - running as systemd user service (battery-alert.service)

### ⏸️ NOT YET DONE

#### Productivity Tools (High Priority - Quick Wins)
- [ ] Frog (OCR - copy text from images)
- [ ] Mdcat (markdown preview in terminal)
- [ ] Espanso (text expander/keyword replacer)
- [ ] Mission Center (modern system monitoring GUI)
- [ ] SwayNC: volume/brightness OSD notifications (show a popup when media keys pressed)

#### Development Tools & Learning (Medium Priority)
- [ ] Learn Vim motions (vim-be-good game, practice with VSCode extension)
- [ ] LazyVim/Neovim setup exploration
- [ ] Kickstart.nvim configuration

#### Desktop Enhancement (Medium Priority)
- [ ] Kanata (caps lock rebinding & advanced key remapping)
- [ ] Walker vs Rofi comparison/testing
- [ ] Dropdown/magic terminal for MangoWC (similar to Hyprland scratchpad)
- [ ] Rofi settings menu (Bluetooth, WiFi, system settings)
- [ ] Context menu with tools (color picker, screenshot, etc.)

#### Multimedia & Content (Low-Medium Priority)
- [ ] Ncspot (TUI Spotify client)
- [ ] Style Spotify with Catppuccin themes
- [ ] Stylus + Catppuccin themes for Zen browser
- [ ] Explore RSS feeds integration
- [ ] YouTube app/client exploration

#### Communication & Productivity Apps (Medium Priority)
- [ ] Thunderbird/Betterbird (email outside browser)
- [ ] Teams outside browser (research if possible)
- [ ] Excalidraw (drawing/whiteboard tool)

#### Research & Exploration (Low Priority)
- [ ] LM Studio (local LLM exploration)
- [ ] Obsidian/Appflowy + Claude AI integration
- [ ] Reading setup for technical books (SICP, Computer Systems, Designing Data-Intensive Applications)

#### Advanced Features (Low Priority)
- [ ] Caps Lock indicator in waybar (module not detecting, low priority)
- [ ] Touchpad gestures (workspace swipe - not working in current Hyprland version)
- [ ] Gaming mode (disable compositor for performance)
- [ ] Focus mode (hide waybar, minimal distractions)
- [ ] Hex animation open/close effects (like KDE/GNOME animations)

#### Workflow Enhancements (Medium Priority)
- [ ] Custom rofi scripts
  - [ ] AWS profile switcher / console launcher
  - [ ] Terraform commands (plan/apply/destroy)
  - [ ] SSH quick connect to saved hosts
- [ ] Custom waybar modules
  - [ ] Git branch indicator (for current project directory)
  - [ ] VPN status indicator
  - [ ] AWS profile indicator
  - [ ] Docker container status
  - [ ] Terraform workspace indicator
- [ ] Advanced window rules
  - [ ] VSCode always on workspace 2
  - [ ] Browser always on workspace 3
  - [ ] Floating window exceptions (calculator, file pickers)
  - [ ] Per-app workspace assignments
- [ ] Multi-monitor hotplug scripts
  - [x] Fallback monitorrule for unknown displays (TV, home monitors) — landscape, preferred res, x:1920
  - [ ] Auto-detect dock/undock (workspace reconfiguration)
  - [ ] Workspace migration scripts

#### Theme System Expansion (Low Priority)
- [ ] Theme switcher script (Mocha ↔ Macchiato)
- [ ] Catppuccin Mocha configuration
- [ ] Per-workspace wallpapers
- [ ] Theme preview with rofi
- [ ] Smooth theme transition animations

#### Dotfiles & Reproducibility (High Priority)
- [x] Git repository structure (stow-based, fully tracked)
- [x] Install script (scripts/install.sh — stow deploy + local scripts + systemd services)
- [ ] Backup script (automated config snapshots)
- [ ] Restore script (deploy configs to new machine)
- [x] Documentation
  - [x] Full installation guide (docs/INSTALLATION.md)
  - [x] Keybindings reference (docs/KEYBINDS-MANGO.md, docs/KEYBINDS.md)
  - [ ] Troubleshooting guide
  - [ ] Package list with explanations

---

## File Structure

### Current Config Locations
```
~/.config/
├── hypr/
│   ├── hyprland.conf           # Main config (monitors, workspaces, keybinds, etc.)
│   ├── hyprlock.conf           # Lock screen config
│   └── hypridle.conf           # Idle management config
├── waybar/
│   ├── config                  # Waybar layout (JSON)
│   ├── style.css               # Waybar styling (Catppuccin Macchiato)
│   └── catppuccin-macchiato.css # Catppuccin color variables
├── rofi/
│   ├── config.rasi             # Rofi main config
│   └── theme.rasi              # Rofi theme (dark)
├── kitty/
│   └── kitty.conf              # Terminal config with Catppuccin Macchiato colors
├── fish/
│   ├── config.fish             # Fish shell config
│   └── conf.d/                 # Auto-sourced configs
├── starship.toml               # Starship prompt config
├── btop/                       # System monitor config
├── gtk-3.0/                    # GTK3 theme settings
├── gtk-4.0/                    # GTK4 theme settings
└── yazi/                       # Terminal file manager config

~/Projects/archeotech-dotfiles/wallpapers/
└── *.jpg / *.png               # Wallpaper collection (auto-detected by picker)

/etc/sddm.conf                  # Display manager config
/usr/share/sddm/scripts/Xsetup  # SDDM keyboard layout script
/etc/default/grub               # GRUB bootloader config
```

### Actual Dotfiles Repository Structure (Stow-based)
```
~/Projects/archeotech-dotfiles/
├── .claude/
│   ├── claude.md               # This file - main project knowledge
│   ├── DECISIONS.md            # Log of all technical decisions made
│   ├── TROUBLESHOOTING.md      # Known issues and solutions
│   └── sessions/               # Session summaries
│       └── YYYY-MM-DD-session-name.md
├── config/                     # Stow package for .config
│   └── .config/
│       ├── hypr/               # Hyprland configs (MASTER COPY)
│       ├── waybar/             # Waybar configs (MASTER COPY)
│       ├── kitty/              # Kitty configs (MASTER COPY)
│       ├── rofi/               # Rofi configs (MASTER COPY)
│       ├── fish/               # Fish shell configs (MASTER COPY)
│       ├── mango/              # MangoWC configs (MASTER COPY)
│       ├── systemd/user/       # Systemd user services (battery-alert.service)
│       ├── swaync/             # Notification center (config.json + style.css)
│       ├── waypaper/           # Waypaper config (backend=custom, points to wallpaper-set.sh)
│       ├── starship.toml       # Starship prompt config
│       ├── btop/               # System monitor config
│       ├── yazi/               # File manager config
│       ├── gtk-3.0/            # GTK3 theme
│       ├── gtk-4.0/            # GTK4 theme
│       └── dunst/              # Notifications config
├── system/                     # System-level configs (requires root)
│   ├── etc/
│   │   └── snapper/
│   │       └── configs/
│   │           └── root        # Snapper snapshot configuration
│   └── README.md               # System config deployment guide
├── scripts/
│   ├── install.sh              # Deploy dotfiles with GNU Stow
│   ├── uninstall.sh            # Remove symlinks
│   ├── setup-snapper.sh        # Automated Snapper setup
│   ├── wallpaper-set.sh        # Wallpaper setter with Arch logo overlay system
│   ├── wallpaper-picker.sh     # Rofi thumbnail grid wallpaper picker
│   ├── battery-alert.sh        # Battery monitor daemon (dunst alerts at 20/10/5%, suspend at 3%)
│   └── assets/
│       ├── arch-logo.svg       # Arch crystal logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       ├── rebel-logo.svg      # Rebel Alliance logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       ├── imperial-logo.svg   # Imperial Aquila logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       └── wallpaper-picker.rasi  # Rofi theme for wallpaper picker (Catppuccin glass, 3-col grid)
├── wallpapers/                 # Wallpaper collection (tracked in git)
├── docs/
│   ├── INSTALLATION.md         # Step-by-step install guide
│   ├── KEYBINDS.md             # Hyprland keybindings reference
│   ├── KEYBINDS-MANGO.md       # MangoWC keybindings reference (primary)
│   ├── PACKAGES.md             # Package list with explanations
│   └── TOOLS.md                # Tool configurations and usage guide
└── README.md                   # Project overview
```

### **IMPORTANT: GNU Stow Workflow**

**How It Works:**
- All config files live ONLY in `~/Projects/archeotech-dotfiles/config/.config/`
- GNU Stow creates symlinks from `~/.config/` TO the repo
- Editing `~/.config/hypr/hyprland.conf` edits the repo file directly
- Changes are automatically tracked by git

**Symlink Structure:**
```
~/.config/hypr/ -> ../Projects/archeotech-dotfiles/config/.config/hypr/
~/.config/waybar/ -> ../Projects/archeotech-dotfiles/config/.config/waybar/
~/.config/mango/ -> ../Projects/archeotech-dotfiles/config/.config/mango/
~/.config/waypaper/ -> ../Projects/archeotech-dotfiles/config/.config/waypaper/
... (all config dirs are symlinks)

# Script symlinks (manual, managed by install.sh):
~/.local/bin/wallpaper-set.sh -> ~/Projects/archeotech-dotfiles/scripts/wallpaper-set.sh
~/.local/bin/wallpaper-picker.sh -> ~/Projects/archeotech-dotfiles/scripts/wallpaper-picker.sh
~/.local/bin/battery-alert.sh -> ~/Projects/archeotech-dotfiles/scripts/battery-alert.sh

# Systemd service (manual symlink — stow can't merge into existing systemd dir):
~/.config/systemd/user/battery-alert.service -> ~/Projects/archeotech-dotfiles/config/.config/systemd/user/battery-alert.service
```

**Adding New Config Directories:**
1. Create directory in repo: `mkdir -p ~/Projects/archeotech-dotfiles/config/.config/newapp/`
2. Add config files to repo directory
3. Create symlink: `ln -s ../Projects/archeotech-dotfiles/config/.config/newapp ~/.config/newapp`
4. OR use stow: `cd ~/Projects/archeotech-dotfiles && stow -R config`
5. Update `scripts/install.sh` to include the new directory in CONFIGS array
---

## Documentation Structure

This project maintains comprehensive documentation across multiple files:

### Main Documentation Files
- **[README.md](../README.md)** - Project overview and quick start guide
- **[docs/KEYBINDS-MANGO.md](../docs/KEYBINDS-MANGO.md)** - Complete keybindings reference for MangoWC (primary)
- **[docs/KEYBINDS.md](../docs/KEYBINDS.md)** - Complete keybindings reference for Hyprland (backup)
- **[docs/PACKAGES.md](../docs/PACKAGES.md)** - Full package list with explanations
- **[docs/INSTALLATION.md](../docs/INSTALLATION.md)** - Step-by-step installation guide
- **[docs/TOOLS.md](../docs/TOOLS.md)** - Detailed tool configurations and usage

### Claude Code Documentation (.claude/)
- **[.claude/claude.md](claude.md)** - This file - comprehensive project knowledge base
- **[.claude/STYLE_GUIDE.md](STYLE_GUIDE.md)** - Theme style guide (Catppuccin colors, design patterns)
- **[.claude/DECISIONS.md](DECISIONS.md)** - Log of all technical decisions made
- **[.claude/TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Known issues and solutions
- **[.claude/sessions/](sessions/)** - Session summaries for major work periods

### System Configuration
- **[system/README.md](../system/README.md)** - System-level configuration deployment guide

---

## Common Tasks & How-To

### Connecting to WiFi
```bash
# List available networks
nmcli device wifi list

# Connect to network
nmcli device wifi connect "SSID" password "PASSWORD"

# Connect with prompt for password
nmcli --ask device wifi connect SSID

# View saved connections
nmcli connection show

# Auto-connect is enabled by default for known networks
```

### Managing Themes
```bash
# Restart waybar after config changes
pkill waybar
waybar &

# Reload Hyprland config
hyprctl reload

# Check Hyprland config for errors
hyprctl reload 2>&1 | grep -i error
```

### Managing Wallpapers
```bash
# Open rofi wallpaper picker (thumbnail grid)
# Keybind: Super+W
~/.local/bin/wallpaper-picker.sh

# Set wallpaper directly (respects logo toggle state)
~/.local/bin/wallpaper-set.sh ~/Projects/archeotech-dotfiles/wallpapers/image.jpg

# Toggle logo overlay on/off (cycles: last active logo ↔ off)
# Keybind: Super+Shift+W
~/.local/bin/wallpaper-set.sh --toggle-logo

# Activate a specific logo (arch | rebel | imperial)
~/.local/bin/wallpaper-set.sh --toggle-logo arch
~/.local/bin/wallpaper-set.sh --toggle-logo rebel
~/.local/bin/wallpaper-set.sh --toggle-logo imperial

# Re-apply last wallpaper (e.g. after reboot — called by MangoWC startup)
~/.local/bin/wallpaper-set.sh --restore

# Check current wallpaper and logo state
~/.local/bin/wallpaper-set.sh --status

# Scripts live in repo at scripts/ and are symlinked to ~/.local/bin/
# Wallpapers stored in wallpapers/ (tracked in git)
# Cache: ~/.cache/wallpaper/ (composed.png, thumbs/, last-wallpaper, etc.)
```

### Package Management
```bash
# Update system
sudo pacman -Syu

# Install package
sudo pacman -S package-name

# Install from AUR
paru -S package-name

# Search for package
pacman -Ss search-term
paru -Ss search-term

# Remove package
sudo pacman -Rs package-name

# List installed packages
pacman -Qe  # Explicitly installed
pacman -Qq  # All packages
```

### Git Workflow
```bash
# All SSH keys are already configured
# AWS credentials are in ~/.aws/

# Clone with SSH
git clone git@github.com:username/repo.git

# Check git status
git status

# AWS SSO login
aws sso login --profile profile-name

# AWS identity check
aws sts get-caller-identity --profile profile-name
```

### Monitor Management
```bash
# Check current monitors
hyprctl monitors

# Force reload monitor config
hyprctl reload

# Monitors are auto-detected on dock/undock
# Workspaces are assigned per monitor in hyprland.conf
```

### Taking Screenshots
```bash
# Use keybinds (preferred):
# Super+S = region
# Super+P = fullscreen

# Manual commands:
grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png  # Full
grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png  # Region

# Screenshots are saved to ~/Pictures/Screenshots/
# And automatically copied to clipboard
```

### Audio Troubleshooting
```bash
# Check audio devices
pactl list sinks short
pactl list sources short

# Restart audio stack
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check if audio hardware is detected
aplay -l
arecord -l

# Volume control GUI
pavucontrol
```

### Lock Screen & Idle
```bash
# Manual lock
hyprlock

# Idle management settings in ~/.config/hypr/hypridle.conf
# Default: 5min = dim, 10min = lock, 15min = screen off

# Test idle config
hypridle
```

### Managing Snapshots
```bash
# List all snapshots
sudo snapper list

# Create manual snapshot
sudo snapper create -d "Before system changes"

# Compare two snapshots (see what changed)
sudo snapper status 1..2

# Show file differences between snapshots
sudo snapper diff 1..2

# Rollback to a snapshot (careful!)
sudo snapper rollback <snapshot_number>
# Then reboot to apply

# Delete a snapshot
sudo snapper delete <snapshot_number>

# GUI interface (Wayland-compatible)
pkexec snapper-gui

# View snapshot in filesystem
ls /.snapshots/<number>/snapshot/

# Boot into snapshot (no system changes)
# 1. Reboot
# 2. In GRUB menu, go to "Arch Linux snapshots"
# 3. Select snapshot to boot
# 4. System boots read-only from that snapshot
# 5. Can verify system state before committing rollback

# Automatic snapshots happen:
# - Before/after every pacman operation (snap-pac)
# - Hourly (timeline snapshots)
# - GRUB menu auto-updates with new snapshots (grub-btrfsd)
```

---

## Known Issues & Solutions

### Issue: Fedora Won't Boot from GRUB (Partially Fixed)
**Status:** ⚠️ Partially working - boots but login environment incorrect

**Progress Made:**
1. ✅ Fixed GRUB entry - kernel loads successfully from shared `/boot`
2. ✅ Fixed Fedora's `/etc/fstab` - updated `/boot` UUID to shared partition
3. ✅ Fixed Fedora's `/etc/fstab` - updated `/boot/efi` UUID to shared EFI partition
4. ⚠️ Boots but shows plain SDDM instead of Fedora's themed KDE environment

**Current Workaround:** Boot Fedora from BIOS boot menu (works perfectly)

**Diagnostic Scripts Created:**
- `scripts/diagnose-fedora-boot.sh` - Check btrfs subvolumes and fstab
- `scripts/fix-fedora-fstab.sh` - Fix `/boot` UUID
- `scripts/fix-fedora-efi.sh` - Fix `/boot/efi` UUID

**Custom GRUB Entries:**
- `system/etc/grub.d/40_custom` - Manual Fedora boot entries (Fedora 43 and 42)

**What's Working:**
- Fedora kernel loads from GRUB
- Root filesystem mounts correctly
- `/boot` and `/boot/efi` mount successfully
- Login screen appears and accepts password

**What's Not Working:**
- Gets wrong desktop environment (Arch's plain SDDM vs Fedora's KDE)
- After login, returns to login screen

**Next Steps to Try (Future Session):**
1. Check if issue is with display manager initialization order
2. Verify Fedora's systemd services are starting correctly
3. May need to investigate systemd-boot as alternative to GRUB for Fedora
4. Consider keeping BIOS boot as primary Fedora boot method

### Issue: No Audio / No Microphone
**Symptom:** `pactl list sinks` shows only `auto_null`
**Cause:** Missing SOF firmware for Intel audio
**Solution:**
```bash
sudo pacman -S sof-firmware
reboot
# Audio should work after reboot
```

### Issue: SDDM Shows Wrong Keyboard Layout
**Symptom:** Login screen defaults to US instead of FR
**Cause:** Xsetup script needs to set FR as default
**Solution:**
```bash
sudo nano /usr/share/sddm/scripts/Xsetup
# Set to: setxkbmap fr
sudo chmod +x /usr/share/sddm/scripts/Xsetup
```

### Issue: Hyprland Keybinds Don't Follow Keyboard Layout
**Symptom:** Super+Q opens terminal on AZERTY 'A' key instead of 'Q' key
**Cause:** Hyprland uses keycodes by default, not keysyms
**Solution:**
Add to `~/.config/hypr/hyprland.conf`:
```conf
input {
    resolve_binds_by_sym = true
}
```

### Issue: Clipboard History Empty
**Symptom:** Super+V shows no clipboard history
**Cause:** cliphist daemon not running
**Solution:**
Add to `~/.config/hypr/hyprland.conf`:
```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

### Issue: Bluetooth Icon Not Showing in Waybar
**Symptom:** Waybar bluetooth module doesn't display
**Cause:** Bluetooth service not enabled
**Solution:**
```bash
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
pkill waybar
waybar &
```

### Issue: Window Doesn't Float (pavucontrol, etc.)
**Symptom:** Expected floating window opens tiled
**Cause:** Missing window rule
**Solution:**
Add to `~/.config/hypr/hyprland.conf`:
```conf
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = center, class:^(pavucontrol)$
windowrulev2 = size 800 600, class:^(pavucontrol)$
```

---

## Coding Standards & Best Practices

### Configuration Files
- **Comment everything:** Explain why, not just what
- **Organize by section:** Use clear headers with separators
- **One feature per commit:** Makes debugging easier
- **Test before committing:** Always verify changes work
- **Keep backups:** Before major config changes

### Shell Scripts
```bash
#!/bin/bash
# Always include shebang
# Always include description comment at top
# Use meaningful variable names
# Check for errors with set -e
# Provide usage information

set -e  # Exit on error

# Good variable names
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d)"

# Check for required commands
command -v git >/dev/null 2>&1 || { echo "git required"; exit 1; }

# Usage function
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help    Show this help message"
    exit 0
}
```

### Hyprland Config Style
```conf
################################################################################
# SECTION NAME (ALL CAPS)
################################################################################

# Subsection description
setting = value  # Inline comment explaining this specific value

# Multi-line explanation when needed
# to describe complex behavior or rationale
# for specific settings

another_setting = value
```

### Waybar Config Style
```json
{
    "module-name": {
        "property": "value",
        "another-property": "value"
    },
    
    "another-module": {
        "property": "value"
    }
}
```

### Git Commit Messages

**Format:** Conventional Commits with scope (title only, no description)

**Structure:**
```
type[SCOPE]: brief description (50 chars max)
```

**Types (keep it simple):**
- `new` - New features, additions, implementations
- `chg` - Changes to existing features, updates, modifications
- `fix` - Bug fixes, corrections

**Scopes (technology/component-based):**
- `[DOTFILES]` - General dotfiles/config changes
- `[HYPR]` - Hyprland configuration
- `[MANGOWC]` - MangoWC configuration
- `[WAYBAR]` - Waybar configuration
- `[KITTY]` - Kitty terminal configuration
- `[FISH]` - Fish shell configuration
- `[ROFI]` - Rofi launcher configuration
- `[BASH]` - Shell scripts
- `[MD]` - Documentation (Markdown)
- `[REPO]` - Repository structure changes

**Rules:**
- Always include scope in square brackets
- Title only, no body/description
- Keep under 50 characters total
- Start description with lowercase
- No period at the end

**Examples:**
```
new[MANGOWC]: add parallel compositor with complete config
chg[HYPR]: update keybindings for azerty layout
fix[BASH]: resolve stow symlink creation issue
new[DOTFILES]: add gnu stow installation script
chg[WAYBAR]: update modules for multi-monitor setup
new[MD]: add installation guide and keybinds reference
```

---

## Session Management

### Starting a New Session
1. **Pull latest changes** (if using git)
2. **Review current status** (check this file's "Current Status" section)
3. **Set session goal** (what do you want to accomplish?)
4. **Document as you go** (update DECISIONS.md, TROUBLESHOOTING.md)

### Ending a Session

**CRITICAL: Before ending ANY session, Claude Code MUST update ALL documentation files.**

#### Step 1: Update Documentation Files

**A. Update .claude/claude.md (THIS FILE)**
- [ ] Move completed tasks from "NOT YET DONE" to "COMPLETED" sections
- [ ] Update package versions if any were installed/updated
- [ ] Add new tools to appropriate sections (Terminal & Shell, Development Environment, etc.)
- [ ] Update "Recent Additions" line at bottom
- [ ] Update "Last Updated" date to current date (YYYY-MM-DD format)
- [ ] Verify all compositor references (MangoWC primary, Hyprland backup)
- [ ] Check that theming status is accurate (what's themed, what's not)

**B. Update docs/PACKAGES.md**
- [ ] Add any newly installed packages to appropriate categories
- [ ] Include package name, purpose, and notes
- [ ] Update version numbers if packages were upgraded
- [ ] Update "Last Updated" date
- [ ] Verify package count approximation is still accurate
- [ ] Ensure compositor info is correct (MangoWC primary, Hyprland backup)

**C. Update docs/KEYBINDS.md and docs/KEYBINDS-MANGO.md**
- [ ] Add any new keybindings created during session
- [ ] Update keybindings that were modified
- [ ] Remove deprecated keybindings
- [ ] Ensure consistency between both files where applicable
- [ ] Add notes about compositor-specific bindings

**D. Update docs/TOOLS.md**
- [ ] Add configuration details for newly installed tools
- [ ] Document usage examples for new tools
- [ ] Update existing tool configurations if changed
- [ ] Add troubleshooting tips if discovered during session

**E. Update .claude/DECISIONS.md**
- [ ] Document ALL technical decisions made during session
- [ ] Include rationale for choices (why X over Y)
- [ ] Note any trade-offs or compromises
- [ ] Reference related commits or issues
- [ ] Date each decision entry

**F. Update .claude/TROUBLESHOOTING.md**
- [ ] Add any new issues encountered and their solutions
- [ ] Update existing entries if better solutions found
- [ ] Include error messages for searchability
- [ ] Add steps to reproduce and fix
- [ ] Cross-reference with DECISIONS.md if relevant

**G. Update README.md (if needed)**
- [ ] Update project description if scope changed
- [ ] Add new features to feature list
- [ ] Update screenshots/examples if visual changes made
- [ ] Ensure installation instructions are current

#### Step 2: Create Session Summary
- [ ] Create new file in `.claude/sessions/YYYY-MM-DD-session-name.md`
- [ ] Use session-summary-template.md as guide
- [ ] Document what was accomplished
- [ ] List all files modified
- [ ] Note any outstanding issues or TODOs
- [ ] Include relevant commands or code snippets

#### Step 3: Verify Documentation Consistency
- [ ] All documentation files reference correct compositor (MangoWC primary)
- [ ] Package lists match across PACKAGES.md and claude.md
- [ ] Dates are updated (use format: YYYY-MM-DD)
- [ ] All new packages are documented
- [ ] All new keybindings are documented
- [ ] All decisions are logged
- [ ] All issues/solutions are documented

#### Step 4: Prepare Commit Message
- [ ] Review all changes: `git status` and `git diff`
- [ ] Draft commit message following the format in "Git Commit Messages" section below
  - Example: `chg[MD]: update all documentation after tool installation session`
- [ ] Present commit message to user - DO NOT commit automatically
- [ ] User will stage, commit, and push manually
- [ ] DO NOT include "Co-Authored-By: Claude" or any AI attribution in commit messages

#### Step 5: Final Verification
- [ ] Read through claude.md "Current Status" - is it accurate?
- [ ] Check "NOT YET DONE" section - reflects remaining work?
- [ ] Verify "Recent Additions" includes everything from this session
- [ ] Confirm all dates are current
- [ ] Ensure no placeholder text or TODOs left in docs

### Session Summary Template
See `session-summary-template.md` in this directory for the format to use when documenting sessions.

### Documentation Update Checklist Quick Reference

Every session end MUST update:
1. ✅ `.claude/claude.md` - Main project knowledge base
2. ✅ `docs/PACKAGES.md` - Package list
3. ✅ `docs/KEYBINDS.md` & `docs/KEYBINDS-MANGO.md` - Keybindings
4. ✅ `docs/TOOLS.md` - Tool configurations
5. ✅ `.claude/DECISIONS.md` - Technical decisions
6. ✅ `.claude/TROUBLESHOOTING.md` - Issues and solutions
7. ✅ `.claude/sessions/DATE-session.md` - Session summary
8. ✅ `README.md` - If needed

**Remember: Documentation is not optional. If it's not documented, it didn't happen.**

---

## Important Reminders for Claude Code

### When Working on Configs
1. **Always backup before major changes:** Copy file to `.bak` extension
2. **Test incrementally:** Make small changes, test, then continue
3. **Check syntax:** Use appropriate validators (shellcheck for bash, etc.)
4. **Verify permissions:** Some files need specific permissions (e.g., 755 for scripts)
5. **Reload services:** Many changes require reloading (hyprctl reload, pkill waybar, etc.)
6. **Use official Catppuccin themes:** Always fetch official themes from https://github.com/catppuccin/ repositories, never create custom color schemes

### When Installing Packages
1. **Check if already installed:** `pacman -Q package-name`
2. **Understand what it does:** Don't install blindly
3. **Note dependencies:** Some packages pull in many deps
4. **Update package list:** Keep docs/PACKAGES.md updated
5. **Test after install:** Ensure it works as expected

### When Troubleshooting
1. **Check logs first:** `journalctl`, `dmesg`, service logs
2. **Search known issues:** Check TROUBLESHOOTING.md
3. **Test in isolation:** Disable other factors when debugging
4. **Document solution:** Add to TROUBLESHOOTING.md when fixed
5. **Understand root cause:** Don't just apply fixes blindly

### When Creating Scripts
1. **Make executable:** `chmod +x script.sh`
2. **Test thoroughly:** Try edge cases and error conditions
3. **Add error handling:** Check for failures, provide useful messages
4. **Document usage:** Add help text and examples
5. **Follow standards:** Use coding style guide above

### Project Context Preservation
- **This file (claude.md) is the source of truth** for project status
- **Update this file after every significant change**
- **Keep "Current Status" section accurate** (move tasks as completed)
- **Log all decisions in DECISIONS.md**
- **Document all issues in TROUBLESHOOTING.md**
- **Create session summaries** for major work sessions

---

## Next Steps & Priorities

### Immediate (High Priority) - Quick Wins
1. **Install productivity tools** (Frog, Mdcat, Espanso, Mission Center)
2. **Learn Vim motions** (practice with VSCode extension, try vim-be-good game)
3. **Complete keybindings documentation** in KEYBINDS.md
4. **Document all packages** with explanations in PACKAGES.md
5. **Configure Thunar** file manager settings

### Short Term (Medium Priority) - Dotfiles & Workflow
1. **Write backup script** to snapshot current working config
2. **Create install script** for reproducible deployment
3. **Build custom rofi scripts** (AWS, Terraform, SSH, settings menu)
4. **Add custom waybar modules** (git branch, AWS profile, VPN status)
5. **Create advanced window rules** for work apps
6. **Write comprehensive installation guide**

### Medium Term (Medium Priority) - Enhancement & Learning
1. **Explore LazyVim/Neovim** setup (Kickstart.nvim)
2. **Kanata setup** for caps lock rebinding
3. **Walker vs Rofi** comparison and testing
4. **MangoWC dropdown terminal** implementation
5. **Implement theme switcher** (Mocha ↔ Macchiato)
6. **Zen browser deep configuration** and Stylus themes
7. **Waybar icons** - ensure all working with click actions

### Long Term (Low Priority) - Advanced Features
1. **Multimedia setup** (Ncspot, Spotify styling, YouTube client)
2. **Communication tools** (Thunderbird/Betterbird, Teams alternatives)
3. **Technical reading setup** (SICP, Computer Systems, Designing Data-Intensive Applications)
4. **LM Studio** local LLM exploration
5. **Obsidian/Appflowy + Claude AI** integration
6. **Deploy to personal Windows PC** (dual-boot)
7. **Add per-workspace wallpapers**
8. **Implement gaming mode**
9. **Build project workspace switcher**
10. **Hex animation effects** (like KDE/GNOME)

---

## References & Resources

### Official Documentation
- [Arch Wiki](https://wiki.archlinux.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Catppuccin](https://github.com/catppuccin/catppuccin)

### Inspiration Sources
- [Adnan's Dotfiles](https://github.com/Adnan-Malik-26/dotfiles)
- [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
- [caelestia-dots/shell](https://github.com/caelestia-dots/shell)

### Communities
- r/unixporn - Eye candy and inspiration
- r/hyprland - Hyprland-specific help
- r/archlinux - Arch support
- Hyprland Discord - Real-time help

---

## Project History

**2025-11-28:** Initial system installation and setup
- Installed Arch Linux alongside Fedora
- Set up Hyprland with full desktop environment
- Applied Catppuccin Macchiato theming
- Migrated all work files and development tools
- System fully operational as daily driver

**2025-11-28 (Later):** Project documentation and Claude Code setup
- Created comprehensive project knowledge base
- Organized all decisions and current status
- Prepared for dotfiles repository creation
- Ready for iterative improvements and automation

---

## Success Criteria

By the end of this project, the following should be true:

✅ **Functional**
- System boots reliably (Arch and Fedora dual-boot)
- All work tools operational (VSCode, AWS, Terraform, Docker)
- Audio, video, networking all working
- Multi-monitor setup works seamlessly

✅ **Documented**
- Every config file commented and explained
- Complete installation guide exists
- Troubleshooting guide covers common issues
- All decisions documented with rationale

✅ **Reproducible**
- Install script can deploy to fresh Arch in <1 hour
- Dotfiles repository contains everything needed
- Backup/restore scripts work reliably
- Can migrate to new machine easily

✅ **Maintainable**
- Clear organization of configs and scripts
- Version controlled with meaningful commits
- Session summaries track progress
- Easy to update and modify

✅ **Beautiful**
- Consistent Catppuccin theming throughout
- Smooth animations and transitions
- Professional appearance
- Personal touches (wallpaper, etc.)

✅ **Productive**
- Keybindings are intuitive and efficient
- Quick access to common tasks
- Work-specific integrations (AWS, etc.)
- Minimal friction in daily use

---

**Last Updated:** 2026-03-11
**System Status:** ✅ Fully Functional
**Daily Driver Ready:** Yes (MangoWC primary, Hyprland backup)
**Dotfiles Repository:** ✅ Complete with Stow
**Primary Compositor:** MangoWC (scrolling layouts) with Hyprland as fallback
**Recent Additions:** Wallpaper/logo overlay system improvements — portrait screen support (separate composed-portrait.png routed to DP-3 via swww --outputs), awk-based accent color extraction (saturation+contrast scoring), area-normalized logo sizing (sqrt(w×h)=render_px gives equal visual weight across all aspect ratios), shape-hugging drop shadow (blur alpha first then colorize), SVG viewBox crop for imperial aquila (0 620 2000 780), inner margin to prevent shadow edge clipping, rofi picker tile margins (60% fit), keybinds helper updated with wallpaper section
**Documentation:** See docs/ folder and .claude/ folder for complete references
