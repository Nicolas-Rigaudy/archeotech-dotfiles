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

### Storage Configuration
- **Primary OS:** Arch Linux (232GB partition on nvme0n1p4)
- **Games storage:** nvme0n1p7 (265GB — previously Fedora 42 KDE, wiped 2026-04-20, now dedicated game storage)
  - Diablo 4 installed
  - System is no longer dual-boot — Arch Linux only
- **Shared:** EFI partition (nvme0n1p1, 360M)
- **Bootloader:** GRUB with Catppuccin theme (fully clean — Fedora EFI entries and kernels removed 2026-04-22)
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
- [x] swaylock (MangoWC) and hyprlock (Hyprland) configured — swaylock uses dynamic wallpaper via swaylock-launch.sh
- [x] SDDM login screen customized — Arch logo background (replaces cat), password masking immediate (no character reveal)
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
- [x] Power menu (wlogout) in waybar — Catppuccin themed, icon-only, full-span overlay; launched via `wlogout-launch.sh` for adaptive per-monitor margins
- [x] Bluetooth applet (blueman-applet)
- [x] Network applet (nm-applet)
- [x] Volume control (pavucontrol)
- [x] Brightness control (brightnessctl)
- [x] Media control (playerctl)
- [x] Image viewer (imv)
- [x] PDF viewer (zathura)
- [x] Archive tools (file-roller, unzip, unrar, p7zip)
- [x] Snapshot management (snapper + snap-pac + grub-btrfs + snapper-gui)
- [x] Battery alert script (swaync notifications at 20%/10%/5%, auto-suspend at 3%) - running as systemd user service (battery-alert.service)
- [x] Settings hub (Super+,) — rofi menu: display submenu (extend/mirror/laptop-only/external-only/adjust), audio, network, bluetooth, wallpaper, night light, power profile, disk, power, lock; back navigation in all submenus
- [x] Display layout switching via wlr-randr — extend/mirror/laptop-only/external-only from settings hub
- [x] Cursor theme — catppuccin-macchiato-mauve-cursors set in mango.conf + environment.d/cursor.conf
- [x] power-profiles-daemon — balanced/performance/power-saver switchable from settings hub
- [x] wlsunset night light — off/4500K/3500K/2700K switchable from settings hub
- [x] Project jump (`Super+Ctrl+P`) — rofi launcher scanning ~/Projects (personal 󱍽) and ~/Documents/repos (work 󰃖); opens VSCode + kitty terminal in selected repo
- [x] Monitor window rules — VSCode → HDMI-A-1, kitty → DP-3 on open (scratchpad excluded); rules ignored when monitors absent
- [x] logiops (AUR) — MX Master 3S For Business: DPI 1000, SmartShift threshold 13, gesture button (0xc3) with tap=rofi launcher / swipe gestures for workspace+monitor management, forward button (0xc4) with tap=toggle SmartShift; config at system/etc/logid.cfg → /etc/logid.cfg; wiggle mouse on service start (Bolt dongle quirk)


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
│   └── STYLE_GUIDE.md          # Creative direction and aesthetic intent
├── config/                     # Stow package for .config
│   └── .config/
│       ├── hypr/               # Hyprland configs (MASTER COPY)
│       ├── waybar/             # Waybar configs (MASTER COPY)
│       ├── kitty/              # Kitty configs (MASTER COPY)
│       ├── rofi/               # Rofi configs (MASTER COPY)
│       ├── fish/               # Fish shell configs (MASTER COPY)
│       ├── mango/              # MangoWC configs (MASTER COPY)
│       ├── systemd/user/       # Systemd user services (battery-alert.service)
│       ├── quickshell/         # Quickshell control center (shell.qml + controls/)
│       ├── swaync/             # Notification center (config.json + style.css)
│       ├── wlogout/            # Power menu config (layout, style.css, icons/)
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
│   ├── battery-alert.sh        # Battery monitor daemon (alerts at 20/10/5%, suspend at 3%)
│   ├── wlogout-launch.sh       # wlogout with adaptive per-monitor margins (via xrandr + mmsg)
│   ├── swaylock-launch.sh      # swaylock wrapper — reads ~/.cache/wallpaper/last-wallpaper for dynamic bg
│   ├── mango-reload.sh         # Safe MangoWC reload — reloads config then re-applies monitor layout via wlr-randr
│   ├── project-jump.sh         # Rofi project launcher — scans ~/Projects + ~/Documents/repos, opens VSCode + kitty
│   └── assets/
│       ├── arch-logo.svg       # Arch crystal logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       ├── rebel-logo.svg      # Rebel Alliance logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       ├── imperial-logo.svg   # Imperial Aquila logo (LOGO_COLOR/LOGO_OPACITY placeholders)
│       ├── wallpaper-picker.rasi  # Rofi theme for wallpaper picker (Catppuccin glass, 3-col grid)
│       └── panel.rasi          # Rofi theme for project-jump (Catppuccin glass, vertical list)
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
~/.local/bin/swaylock-launch.sh -> ~/Projects/archeotech-dotfiles/scripts/swaylock-launch.sh
~/.local/bin/mango-reload.sh -> ~/Projects/archeotech-dotfiles/scripts/mango-reload.sh

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

### Human-readable docs (`docs/`)
- **[docs/KEYBINDS-MANGO.md](../docs/KEYBINDS-MANGO.md)** - Keybindings reference for MangoWC (primary)
- **[docs/KEYBINDS.md](../docs/KEYBINDS.md)** - Keybindings reference for Hyprland (backup)
- **[docs/PACKAGES.md](../docs/PACKAGES.md)** - Full package list with explanations
- **[docs/TOOLS.md](../docs/TOOLS.md)** - Tool configurations and usage guide
- **[docs/INSTALLATION.md](../docs/INSTALLATION.md)** - Step-by-step installation guide
- **[docs/MANGOWC-SETUP.md](../docs/MANGOWC-SETUP.md)** - MangoWC setup, screen sharing, wallpaper system

### Claude context (`.claude/`)
- **[claude.md](claude.md)** - This file — system state, architecture, how things work
- **[ROADMAP.md](ROADMAP.md)** - Everything planned, in-progress, and ideas
- **[DECISIONS.md](DECISIONS.md)** - Technical decisions with rationale
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Known issues and solutions
- **[STYLE_GUIDE.md](STYLE_GUIDE.md)** - Creative direction and aesthetic intent (Corvus persona)

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
- `[QML]` - Quickshell / QML components
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

## End of Session — Documentation Checklist

After any significant work, update these files before committing:

1. **`.claude/claude.md`** — move completed tasks, update "Recent Additions" and "Last Updated"
2. **`docs/PACKAGES.md`** — add newly installed packages
3. **`docs/KEYBINDS-MANGO.md`** / **`docs/KEYBINDS.md`** — add/update keybindings
4. **`docs/TOOLS.md`** — document new tool configs/usage
5. **`.claude/ROADMAP.md`** — update in-progress/done items if scope changed
6. **`docs/MANGOWC-SETUP.md`** — update if MangoWC setup steps changed
7. **`.claude/DECISIONS.md`** — log any technical choices made (why X over Y)
8. **`.claude/TROUBLESHOOTING.md`** — add any issues encountered and solved

Then prepare a commit message following the Git Commit Messages format. Present it to the user — do not commit automatically. Do NOT include "Co-Authored-By: Claude" in commit messages.

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

---

---

**Last Updated:** 2026-04-22
**System Status:** ✅ Fully Functional — Daily Driver
**Primary Compositor:** MangoWC (scrolling layouts), Hyprland as fallback
**Next major work:** Quickshell migration — Phase 1 (control center). See `.claude/ROADMAP.md`.
**Roadmap:** See `.claude/ROADMAP.md` for all planned work and ideas
