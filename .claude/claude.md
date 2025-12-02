# Arch + Hyprland Dotfiles Project

## Project Overview

This is a comprehensive Arch Linux + Hyprland desktop environment built from scratch. Every component is understood, documented, and reproducible. This project serves as both a daily driver system and a learning journey into Linux customization.

**Project Goals:**
1. Build a fully functional, beautiful Arch + Hyprland system
2. Understand every component and configuration decision
3. Create reproducible dotfiles that can be deployed to any machine
4. Document everything for future reference and learning
5. Eventually deploy to personal Windows PC (dual-boot or full switch)

**Current Status:** ✅ **FULLY FUNCTIONAL - Daily Driver Ready**
- System installation complete
- Development environment working
- Theming applied (Catppuccin Macchiato)
- All core features operational

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
- One ultrawide 1080p monitor

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
| **Bootloader** | GRUB | Dual-boot friendly, themeable, auto-detects Fedora |
| **AUR Helper** | paru | Faster (Rust-based), more modern than yay |
| **Init System** | systemd | Default, no reason to change |

### Desktop Environment ✅
| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Window Manager (Primary)** | Hyprland 0.52.1 | Modern Wayland compositor, smooth animations, tiling |
| **Window Manager (Testing)** | MangoWC (latest) | Testing scrolling layout feature, parallel install |
| **Display Manager** | SDDM | Best for Wayland compositors, Catppuccin themes available |
| **Status Bar** | Waybar 0.14.0 | CSS+JSON config, huge community, themeable |
| **App Launcher** | rofi-wayland | Most features, extensible |
| **Notifications** | dunst | Lightweight, themeable, simple config |
| **Wallpaper** | swww | Animated transitions between wallpapers |
| **Lock Screen** | hyprlock (Hyprland) / swaylock (MangoWC planned) | Official Hyprland locker, themeable |
| **Idle Manager** | hypridle (Hyprland) / swayidle (MangoWC planned) | Pairs with lock screens |

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

#### Hyprland Core
- [x] Hyprland 0.52.1 installed
- [x] SDDM with Catppuccin theme
- [x] Multi-monitor configuration (3 screens, one portrait)
- [x] Workspace per monitor assignments (1-3 laptop, 4-6 ext1, 7-9 ext2)
- [x] Animations, blur, shadows, rounded corners configured
- [x] Waybar with clickable modules
- [x] Rofi launcher styled
- [x] Dunst notifications
- [x] Swww wallpaper daemon (Arasaka wallpaper set)
- [x] Hyprlock screen lock configured
- [x] Hypridle auto-lock (10min idle)
- [x] All keybindings configured

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

#### Development Environment
- [x] Git configured with restored SSH keys
- [x] AWS CLI with SSO authentication working
- [x] Terraform installed and working
- [x] Python + pip configured
- [x] Docker + docker-compose installed
- [x] VSCode with all extensions synced
- [x] All work repositories accessible

#### Theming
- [x] Catppuccin Macchiato applied system-wide
- [x] GTK theme (catppuccin-macchiato-mauve)
- [x] Icon theme (Papirus-Dark)
- [x] Cursor theme (catppuccin-macchiato-dark)
- [x] Kitty fully themed
- [x] Waybar styled with Catppuccin
- [x] Rofi dark theme
- [x] SDDM Catppuccin login screen
- [x] GRUB Catppuccin boot menu

#### Utilities & Tools
- [x] Screenshot tools (grim + slurp) with keybinds
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

### ⏸️ NOT YET DONE

#### Advanced Features (Low Priority)
- [ ] Caps Lock indicator in waybar (module not detecting, low priority)
- [ ] Touchpad gestures (workspace swipe - not working in current Hyprland version)
- [ ] Gaming mode (disable compositor for performance)
- [ ] Focus mode (hide waybar, minimal distractions)

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
  - [ ] Auto-detect dock/undock
  - [ ] Reconfigure workspaces on monitor change
  - [ ] Workspace migration scripts

#### Theme System Expansion (Low Priority)
- [ ] Theme switcher script (Mocha ↔ Macchiato)
- [ ] Catppuccin Mocha configuration
- [ ] Per-workspace wallpapers
- [ ] Theme preview with rofi
- [ ] Smooth theme transition animations

#### Dotfiles & Reproducibility (High Priority)
- [ ] Git repository structure
- [ ] Install script (fresh Arch to working system in <1 hour)
- [ ] Backup script (automated config snapshots)
- [ ] Restore script (deploy configs to new machine)
- [ ] Documentation
  - [ ] Full installation guide
  - [ ] Keybindings reference
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

~/Pictures/Wallpapers/
└── arasaka.png                 # Current wallpaper (cyberpunk themed)

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
│       ├── starship.toml       # Starship prompt config
│       ├── btop/               # System monitor config
│       ├── yazi/               # File manager config
│       ├── gtk-3.0/            # GTK3 theme
│       ├── gtk-4.0/            # GTK4 theme
│       └── dunst/              # Notifications config
├── scripts/
│   ├── install.sh              # Deploy dotfiles with GNU Stow
│   └── uninstall.sh            # Remove symlinks
├── docs/
│   ├── INSTALLATION.md         # Step-by-step install guide
│   ├── KEYBINDS.md             # All keybindings reference
│   └── PACKAGES.md             # Package list with explanations
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
... (all config dirs are symlinks)
```

**Adding New Config Directories:**
1. Create directory in repo: `mkdir -p ~/Projects/archeotech-dotfiles/config/.config/newapp/`
2. Add config files to repo directory
3. Create symlink: `ln -s ../Projects/archeotech-dotfiles/config/.config/newapp ~/.config/newapp`
4. OR use stow: `cd ~/Projects/archeotech-dotfiles && stow -R config`
5. Update `scripts/install.sh` to include the new directory in CONFIGS array
---

## Keybindings Reference

### Application Launchers
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Q` | Open terminal (kitty) | Primary terminal |
| `Super + R` | Open app launcher (rofi) | Search all installed apps |
| `Super + B` | Open browser (zen-browser) | |
| `Super + E` | Open editor (VSCode) | |
| `Super + N` | Open notes (Obsidian) | |
| `Super + D` | Open file manager (thunar) | GUI file browser |

### Window Management
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + C` | Close active window | Kill focused window |
| `Super + M` | Exit Hyprland | Logout menu |
| `Super + F` | Toggle fullscreen | Current window |
| `Super + Shift + Space` | Toggle floating | Tile ↔ Float |
| `Super + T` | Toggle split | Dwindle layout |
| `Super + Arrow Keys` | Move focus | Between windows |
| `Super + H/J/K/L` | Move focus (vim keys) | Same as arrows |
| `Super + Shift + Arrows` | Move window | In current workspace |
| `Super + Shift + H/J/K/L` | Move window (vim keys) | Same as shift+arrows |
| `Super + Ctrl + Arrows` | Resize window | ±20px |
| `Super + Ctrl + H/J/K/L` | Resize window (vim keys) | Same as ctrl+arrows |

### Workspace Navigation
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + [1-9]` | Switch to workspace N | Direct workspace switch |
| `Super + Shift + [1-9]` | Move window to workspace N | Send window to workspace |
| `Super + Tab` | Next workspace | Cycles through workspaces |
| `Super + Shift + Tab` | Previous workspace | Reverse cycle |
| `Super + Mouse Scroll` | Scroll through workspaces | While holding Super |

### Screenshots & Media
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + S` | Screenshot region | Select area, save + clipboard |
| `Super + P` | Screenshot fullscreen | Save + clipboard |
| `Print` | Screenshot fullscreen (laptop) | Save + clipboard |
| `Super + Print` | Screenshot region (laptop) | Select area, save + clipboard |
| `Super + V` | Clipboard history | Rofi selector |

### System Controls
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + L` | Lock screen | Hyprlock with Arasaka wallpaper |
| `Alt + Shift` | Toggle keyboard layout | US ↔ FR |
| `XF86AudioRaiseVolume` | Volume up | +5% |
| `XF86AudioLowerVolume` | Volume down | -5% |
| `XF86AudioMute` | Toggle mute | Audio |
| `XF86AudioMicMute` | Toggle mic mute | Microphone |
| `XF86MonBrightnessUp` | Brightness up | +5% |
| `XF86MonBrightnessDown` | Brightness down | -5% |
| `XF86AudioPlay` | Play/Pause | Media control |
| `XF86AudioNext` | Next track | Media control |
| `XF86AudioPrev` | Previous track | Media control |

### Mouse Bindings
| Keybind | Action | Notes |
|---------|--------|-------|
| `Super + Left Click Drag` | Move window | Drag to reposition |
| `Super + Right Click Drag` | Resize window | Drag to resize |

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

# Set new wallpaper
swww img ~/Pictures/Wallpapers/new-wallpaper.png
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

---

## Known Issues & Solutions

### Issue: Fedora Won't Boot After Arch Install
**Symptom:** GRUB doesn't show Fedora in boot menu
**Cause:** btrfs device size mismatch after partition resize
**Solution:**
```bash
# Boot from Arch
sudo mount /dev/nvme0n1p7 /mnt/fedora  # Will fail if mismatch
sudo btrfs rescue fix-device-size /dev/nvme0n1p7
sudo mount /dev/nvme0n1p7 /mnt/fedora  # Should work now
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

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
1. **Run session summary script** (`./scripts/session-finish.sh`)
2. **Update status sections** (move tasks from "Not Done" to "Done")
3. **Commit all changes** with descriptive message
4. **Push to remote** (if using git)
5. **Create session summary** in `.claude/sessions/`

### Session Summary Template
See `session-summary-template.md` in this directory for the format to use when documenting sessions.

---

## Important Reminders for Claude Code

### When Working on Configs
1. **Always backup before major changes:** Copy file to `.bak` extension
2. **Test incrementally:** Make small changes, test, then continue
3. **Check syntax:** Use appropriate validators (shellcheck for bash, etc.)
4. **Verify permissions:** Some files need specific permissions (e.g., 755 for scripts)
5. **Reload services:** Many changes require reloading (hyprctl reload, pkill waybar, etc.)

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

### Immediate (High Priority)
1. **Create dotfiles git repository structure**
2. **Write backup script** to snapshot current working config
3. **Create install script** for reproducible deployment
4. **Document all packages** with explanations in PACKAGES.md
5. **Complete keybindings documentation** in KEYBINDS.md

### Short Term (Medium Priority)
1. **Build custom rofi scripts** (AWS, Terraform, SSH)
2. **Add custom waybar modules** (git branch, AWS profile)
3. **Implement theme switcher** (Mocha ↔ Macchiato)
4. **Create advanced window rules** for work apps
5. **Write comprehensive installation guide**

### Long Term (Low Priority)
1. **Deploy to personal Windows PC** (dual-boot)
2. **Explore Quickshell** as Waybar alternative
3. **Add per-workspace wallpapers**
4. **Implement gaming mode**
5. **Build project workspace switcher**

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

**Last Updated:** 2025-12-02
**System Status:** ✅ Fully Functional
**Daily Driver Ready:** Yes (Hyprland stable, MangoWC testing)
**Dotfiles Repository:** ✅ Complete with Stow
**Compositors Available:** Hyprland (primary), MangoWC (testing scrolling layouts)
