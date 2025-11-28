# Package List

Complete list of all packages used in this Arch + Hyprland setup, organized by category with explanations.

---

## Table of Contents

- [System Base](#system-base)
- [Hyprland & Wayland](#hyprland--wayland)
- [Desktop Environment](#desktop-environment)
- [Terminal & Shell](#terminal--shell)
- [Applications](#applications)
- [Development Tools](#development-tools)
- [Utilities](#utilities)
- [Theming](#theming)
- [Audio](#audio)
- [Fonts](#fonts)

---

## System Base

### Core System

| Package | Purpose | Notes |
|---------|---------|-------|
| `base` | Arch Linux base system | Minimal Arch installation |
| `base-devel` | Development tools | gcc, make, etc. Required for AUR |
| `linux` | Linux kernel | Latest stable kernel |
| `linux-firmware` | Hardware firmware | Includes WiFi, Bluetooth drivers |
| `intel-ucode` | Intel microcode | CPU microcode updates for Intel |
| `btrfs-progs` | Btrfs utilities | Filesystem management tools |

### Boot & Init

| Package | Purpose | Notes |
|---------|---------|-------|
| `grub` | Bootloader | Dual-boot with Fedora |
| `os-prober` | Detect other OSes | For dual-boot setup |
| `systemd` | Init system | Default, systemd-boot alternative |
| `efibootmgr` | EFI boot manager | Manage UEFI boot entries |

### AUR Helper

| Package | Purpose | Notes |
|---------|---------|-------|
| `paru` | AUR helper | Rust-based, faster than yay |

---

## Hyprland & Wayland

### Compositor

| Package | Purpose | Notes |
|---------|---------|-------|
| `hyprland` | Wayland compositor | v0.52.1 - Tiling window manager |
| `xdg-desktop-portal-hyprland` | Desktop portal | Screen sharing, file pickers |
| `xdg-desktop-portal-gtk` | GTK portal | Fallback for GTK apps |

### Wayland Utilities

| Package | Purpose | Notes |
|---------|---------|-------|
| `wayland` | Wayland protocol | Core Wayland libraries |
| `wayland-protocols` | Protocol extensions | Additional protocols |
| `wl-clipboard` | Clipboard utilities | wl-copy, wl-paste |
| `cliphist` | Clipboard manager | History with rofi integration |

---

## Desktop Environment

### Display Manager

| Package | Purpose | Notes |
|---------|---------|-------|
| `sddm` | Login screen | Qt-based, Wayland support |
| `sddm-catppuccin-git` (AUR) | SDDM theme | Catppuccin Macchiato theme |

### Status Bar

| Package | Purpose | Notes |
|---------|---------|-------|
| `waybar` | Status bar | v0.14.0 - CSS/JSON configured |

### Application Launcher

| Package | Purpose | Notes |
|---------|---------|-------|
| `rofi-wayland` | App launcher | Wayland fork of rofi |

### Notifications

| Package | Purpose | Notes |
|---------|---------|-------|
| `dunst` | Notification daemon | Lightweight, themeable |

### Wallpaper

| Package | Purpose | Notes |
|---------|---------|-------|
| `swww` | Wallpaper daemon | Animated transitions |

### Lock Screen & Idle

| Package | Purpose | Notes |
|---------|---------|-------|
| `hyprlock` | Screen locker | Official Hyprland locker |
| `hypridle` | Idle manager | Auto-lock, screen off |

### Power Menu

| Package | Purpose | Notes |
|---------|---------|-------|
| `wlogout` | Logout menu | Graphical power menu |

---

## Terminal & Shell

### Terminal Emulator

| Package | Purpose | Notes |
|---------|---------|-------|
| `kitty` | Terminal emulator | v0.44.0 - GPU accelerated |

### Shell

| Package | Purpose | Notes |
|---------|---------|-------|
| `fish` | Shell | v4.2.1 - Friendly interactive shell |
| `starship` | Shell prompt | v1.24.1 - Cross-shell prompt |

### Terminal Utilities

| Package | Purpose | Notes |
|---------|---------|-------|
| `eza` | Modern ls | Rust-based, colorful output |
| `bat` | Modern cat | Syntax highlighting |
| `btop` | System monitor | Beautiful resource monitor |
| `fastfetch` | System info | Fast neofetch alternative |
| `zoxide` | Smart cd | Jump to frequent directories |
| `thefuck` | Command corrector | Fix typos in commands |
| `yazi` | File manager (TUI) | Modern, Rust-based, image preview |

---

## Applications

### Web Browser

| Package | Purpose | Notes |
|---------|---------|-------|
| `zen-browser` (AUR) | Web browser | Firefox-based, privacy-focused |

### Code Editor

| Package | Purpose | Notes |
|---------|---------|-------|
| `code` | Visual Studio Code | Microsoft's code editor |

### File Managers

| Package | Purpose | Notes |
|---------|---------|-------|
| `thunar` | GUI file manager | Lightweight, XFCE file manager |
| `thunar-volman` | Volume manager | Auto-mount USB drives |
| `gvfs` | Virtual filesystem | Trash, network shares support |
| `thunar-archive-plugin` | Archive support | Extract/create archives in Thunar |

### Note Taking

| Package | Purpose | Notes |
|---------|---------|-------|
| `obsidian` (AUR) | Note taking | Markdown-based knowledge base |

### Media Viewers

| Package | Purpose | Notes |
|---------|---------|-------|
| `imv` | Image viewer | Wayland-native, lightweight |
| `zathura` | PDF viewer | Vim-like keybinds |
| `zathura-pdf-mupdf` | PDF backend | MuPDF rendering |
| `mpv` | Video player | Best Linux video player |

### Archive Tools

| Package | Purpose | Notes |
|---------|---------|-------|
| `file-roller` | Archive manager | GUI for zip/tar/etc |
| `unzip` | Unzip utility | Extract .zip files |
| `unrar` | Unrar utility | Extract .rar files |
| `p7zip` | 7z utility | 7zip archive support |

---

## Development Tools

### Version Control

| Package | Purpose | Notes |
|---------|---------|-------|
| `git` | Version control | Distributed VCS |
| `github-cli` | GitHub CLI | gh command-line tool |

### Cloud & Infrastructure

| Package | Purpose | Notes |
|---------|---------|-------|
| `aws-cli-v2` (AUR) | AWS CLI | v1.43.2 - AWS management |
| `terraform` | Infrastructure as Code | v1.14.0 - IaC tool |

### Programming Languages

| Package | Purpose | Notes |
|---------|---------|-------|
| `python` | Python interpreter | v3.13.7 - Primary dev language |
| `python-pip` | Python package manager | v25.3 - pip installer |

### Containerization

| Package | Purpose | Notes |
|---------|---------|-------|
| `docker` | Container runtime | v29.0.4 - Containerization |
| `docker-compose` | Multi-container tool | Compose orchestration |

---

## Utilities

### Screenshots

| Package | Purpose | Notes |
|---------|---------|-------|
| `grim` | Screenshot tool | Wayland screenshot utility |
| `slurp` | Region selector | Select screen regions |

### Network

| Package | Purpose | Notes |
|---------|---------|-------|
| `networkmanager` | Network manager | WiFi, Ethernet management |
| `nm-applet` | Network applet | System tray network icon |

### Bluetooth

| Package | Purpose | Notes |
|---------|---------|-------|
| `bluez` | Bluetooth stack | Core bluetooth support |
| `bluez-utils` | Bluetooth utilities | bluetoothctl command |
| `blueman` | Bluetooth manager | GUI bluetooth manager |

### System Tools

| Package | Purpose | Notes |
|---------|---------|-------|
| `brightnessctl` | Brightness control | Screen brightness management |
| `playerctl` | Media control | Media player controls |
| `pavucontrol` | Audio control | PulseAudio/PipeWire volume GUI |

---

## Theming

### GTK Themes

| Package | Purpose | Notes |
|---------|---------|-------|
| `catppuccin-gtk-theme-macchiato` (AUR) | GTK theme | Catppuccin Macchiato for GTK apps |
| `gtk3` | GTK3 toolkit | GTK3 applications |
| `gtk4` | GTK4 toolkit | GTK4 applications |

### Icon Theme

| Package | Purpose | Notes |
|---------|---------|-------|
| `papirus-icon-theme` | Icon theme | Papirus-Dark variant |

### Cursor Theme

| Package | Purpose | Notes |
|---------|---------|-------|
| `catppuccin-cursors-macchiato` (AUR) | Cursor theme | Catppuccin cursors |

### Qt Theming

| Package | Purpose | Notes |
|---------|---------|-------|
| `qt5-wayland` | Qt5 Wayland | Qt5 apps on Wayland |
| `qt6-wayland` | Qt6 Wayland | Qt6 apps on Wayland |
| `qt5ct` | Qt5 config tool | Theme Qt5 apps |
| `kvantum` | Qt theme engine | Advanced Qt theming |

---

## Audio

### Audio Stack

| Package | Purpose | Notes |
|---------|---------|-------|
| `pipewire` | Audio server | Modern audio system |
| `pipewire-pulse` | PulseAudio compat | PulseAudio compatibility |
| `pipewire-alsa` | ALSA support | ALSA plugin for PipeWire |
| `wireplumber` | Session manager | PipeWire session/policy manager |
| `sof-firmware` | Audio firmware | Sound Open Firmware (Intel) |

---

## Fonts

### System Fonts

| Package | Purpose | Notes |
|---------|---------|-------|
| `ttf-firacode-nerd` | Monospace font | FiraCode with Nerd Font icons |
| `noto-fonts` | UI font | Noto Sans for system UI |
| `noto-fonts-emoji` | Emoji font | Emoji support |

---

## Package Management Commands

### Install Package

```bash
# From official repos
sudo pacman -S package-name

# From AUR
paru -S package-name
```

### Update System

```bash
# Update all packages
sudo pacman -Syu

# Update AUR packages too
paru -Syu
```

### Search Packages

```bash
# Search official repos
pacman -Ss search-term

# Search AUR
paru -Ss search-term
```

### Remove Package

```bash
# Remove package and unused dependencies
sudo pacman -Rs package-name
```

### List Installed Packages

```bash
# List explicitly installed packages
pacman -Qe

# List all packages
pacman -Qq

# Count packages
pacman -Qq | wc -l
```

---

## Package Count

As of last update, this system uses approximately:
- **Official repos:** ~200 packages
- **AUR:** ~15 packages
- **Total:** ~215 packages

This is a minimal, focused installation optimized for development work and daily driving.

---

**Last Updated:** 2025-11-28
**For:** archeotech-dotfiles
