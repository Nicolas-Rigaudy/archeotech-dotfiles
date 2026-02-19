# MangoWC Setup Guide

Complete guide to install and configure MangoWC (Mango Wayland Compositor) with screen sharing support.

---

## Table of Contents

- [What is MangoWC?](#what-is-mangowc)
- [Installation](#installation)
- [Screen Sharing Setup](#screen-sharing-setup)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

---

## What is MangoWC?

MangoWC is a wlroots-based Wayland compositor with a unique scrolling layout system (similar to Niri). It offers:

- **Scrolling Layouts**: Horizontal and vertical scrolling window arrangements
- **Multiple Layout Modes**: Scroller, tile, grid, monocle, deck, and more
- **Tag-based Workspaces**: Like dwm, more flexible than traditional workspaces
- **SceneFX Effects**: Beautiful blur and shadow effects
- **Touchpad Gestures**: Native 3-finger and 4-finger gesture support

---

## Installation

### 1. Install MangoWC and Core Components

```bash
# Install from AUR
paru -S mangowc-git

# Install desktop portal packages (critical for screen sharing!)
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk

# Install lock screen and idle management
sudo pacman -S swaylock swayidle

# Install Wayland utilities
sudo pacman -S wayland wayland-protocols wl-clipboard
```

### 2. Install Desktop Components

```bash
sudo pacman -S waybar rofi-wayland dunst \
    swww wlogout cliphist \
    grim slurp wl-color-picker \
    brightnessctl playerctl pavucontrol \
    bluez bluez-utils blueman \
    networkmanager nm-applet
```

### 3. Deploy Dotfiles

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/archeotech-dotfiles.git ~/Projects/archeotech-dotfiles

# Deploy configs using GNU Stow
cd ~/Projects/archeotech-dotfiles
./scripts/install.sh
```

---

## Screen Sharing Setup

### Why is this needed?

MangoWC is a wlroots-based compositor, so it uses `xdg-desktop-portal-wlr` for screen sharing instead of `xdg-desktop-portal-hyprland`. This is critical for applications like Microsoft Teams, Zoom, Discord, etc.

### What's Configured

The dotfiles include portal configuration files that tell the system to use the correct backend:

**[~/.config/xdg-desktop-portal/mangowc-portals.conf](../config/.config/xdg-desktop-portal/mangowc-portals.conf)**
```ini
[preferred]
# Screen sharing, screenshots, screen casting - use wlr backend
default=wlr;gtk

# Screen capture and remote desktop - critical for Teams screen sharing
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
```

**[~/.config/xdg-desktop-portal/portals.conf](../config/.config/xdg-desktop-portal/portals.conf)**
```ini
[preferred]
# Default portal configuration
default=wlr;gtk
```

### Autostart Configuration

The [autostart.sh](../config/.config/mango/autostart.sh) script automatically starts the desktop portals:

```bash
# Desktop portal for screen sharing (Teams, Zoom, etc.)
killall -q xdg-desktop-portal-wlr
killall -q xdg-desktop-portal
sleep 1
export XDG_CURRENT_DESKTOP=mangowc
/usr/lib/xdg-desktop-portal-wlr &
sleep 1
/usr/lib/xdg-desktop-portal &
```

### Testing Screen Sharing

1. **Start MangoWC** (log out and select MangoWC from SDDM)

2. **Verify portals are running:**
   ```bash
   ps aux | grep xdg-desktop-portal
   ```
   You should see both `xdg-desktop-portal-wlr` and `xdg-desktop-portal` running.

3. **Test in Teams/Zoom:**
   - Open Microsoft Teams or Zoom
   - Start a meeting or test call
   - Try to share your screen
   - You should see a portal picker showing your screens and windows

4. **Check portal logs (if issues occur):**
   ```bash
   journalctl --user -u xdg-desktop-portal -f
   journalctl --user -u xdg-desktop-portal-wlr -f
   ```

---

## Configuration

### Key Files

- **[~/.config/mango/config.conf](../config/.config/mango/config.conf)** - Main MangoWC configuration
- **[~/.config/mango/autostart.sh](../config/.config/mango/autostart.sh)** - Startup applications
- **[~/.config/waybar/config-mango](../config/.config/waybar/config-mango)** - Waybar configuration
- **[~/.config/waybar/style-mango.css](../config/.config/waybar/style-mango.css)** - Waybar styling
- **[~/.config/swaylock/config](../config/.config/swaylock/config)** - Lock screen
- **[~/.config/swayidle/config.sh](../config/.config/swayidle/config.sh)** - Idle management

### Keybinds

See [KEYBINDS-MANGO.md](KEYBINDS-MANGO.md) for complete keybind reference.

Quick reference:
- `Super + Q` - Terminal
- `Super + R` - App launcher
- `Super + C` - Close window
- `Super + Space` - Switch to scroller layout
- `Super + L` - Lock screen
- `Super + K` - Show keybinds

### Switching Between Layouts

MangoWC supports multiple layout modes:
- `Super + Space` - Scroller (horizontal scrolling)
- `Super + Alt + Space` - Tile (master-stack)
- `Super + Alt + G` - Grid (auto-tiling)
- `Super + Alt + M` - Monocle (fullscreen)
- `Super + Alt + V` - Vertical scroller

---

## Troubleshooting

### Screen Sharing Not Working

**Problem:** Teams/Zoom can't share screen

**Solution:**
```bash
# Check if portals are running
ps aux | grep xdg-desktop-portal

# If not running, restart MangoWC or manually start them
killall xdg-desktop-portal-wlr xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal &

# Verify portal configuration
cat ~/.config/xdg-desktop-portal/mangowc-portals.conf
```

### Portal Picker Not Showing

**Problem:** No window/screen selection dialog appears

**Solution:**
```bash
# Check XDG_CURRENT_DESKTOP is set
echo $XDG_CURRENT_DESKTOP  # Should show: mangowc

# If not, add to your shell config or restart MangoWC
export XDG_CURRENT_DESKTOP=mangowc
```

### Multiple Portal Backends Conflicting

**Problem:** Wrong portal backend is being used

**Solution:**
```bash
# Remove conflicting portal configs
rm -f ~/.config/xdg-desktop-portal/hyprland-portals.conf

# Ensure only mangowc-portals.conf and portals.conf exist
ls ~/.config/xdg-desktop-portal/
```

### Teams Still Not Working

**Problem:** Microsoft Teams specifically not working

**Solutions:**
1. **Use Teams PWA instead of Electron app:**
   - Open Teams in Zen Browser or Chrome
   - Install as PWA (More → Install)
   - PWAs often have better portal support

2. **Check Teams is using Wayland:**
   ```bash
   # Launch Teams with Wayland flags
   teams --enable-features=UseOzonePlatform --ozone-platform=wayland
   ```

3. **Check browser flags (for Teams PWA):**
   - Chrome/Zen: `chrome://flags`
   - Enable: "Preferred Ozone platform" → "Wayland"
   - Enable: "WebRTC PipeWire support"

### Waybar Not Showing

**Problem:** Status bar not visible

**Solution:**
```bash
# Check if waybar is running
ps aux | grep waybar

# Restart waybar with MangoWC config
killall waybar
waybar -c ~/.config/waybar/config-mango -s ~/.config/waybar/style-mango.css &
```

### MangoWC Crashes on Start

**Problem:** Compositor crashes immediately

**Solution:**
```bash
# Check logs
journalctl -b | grep mangowc

# Verify config syntax
cat ~/.config/mango/config.conf

# Try starting MangoWC from terminal to see errors
mangowc
```

---

## Additional Resources

- **MangoWC GitHub:** [https://github.com/dov-vai/MaGoWC](https://github.com/dov-vai/MaGoWC)
- **wlroots Portal Docs:** [https://github.com/emersion/xdg-desktop-portal-wlr](https://github.com/emersion/xdg-desktop-portal-wlr)
- **Arch Wiki Wayland:** [https://wiki.archlinux.org/title/Wayland](https://wiki.archlinux.org/title/Wayland)

---

**Last Updated:** 2025-12-08
**For:** archeotech-dotfiles
**Compositor:** MangoWC (wlroots-based)
