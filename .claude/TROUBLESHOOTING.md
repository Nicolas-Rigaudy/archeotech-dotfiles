# Troubleshooting Guide

This document contains all known issues, their symptoms, causes, and solutions. Update this whenever you encounter and solve a problem.

---

## Table of Contents

- [Boot & System Issues](#boot--system-issues)
- [Audio Problems](#audio-problems)
- [Display & Monitor Issues](#display--monitor-issues)
- [Keyboard & Input Issues](#keyboard--input-issues)
- [Hyprland Issues](#hyprland-issues)
- [Waybar Issues](#waybar-issues)
- [Network Issues](#network-issues)
- [Package Management Issues](#package-management-issues)
- [General Troubleshooting Steps](#general-troubleshooting-steps)

---

## Boot & System Issues

### Fedora Won't Boot After Arch Install

**Symptoms:**
- GRUB doesn't show Fedora option
- Only Arch and "Advanced options for Arch" appear
- Fedora partition exists but isn't detected

**Cause:**
- btrfs filesystem size mismatch after partition resize
- The filesystem thinks it's larger than the actual partition
- Error: "device total_bytes should be at most X but found Y"

**Solution:**
```bash
# From Arch (live USB or installed)
sudo mount /dev/nvme0n1p7 /mnt/fedora  # Will fail with error

# Fix the device size
sudo btrfs rescue fix-device-size /dev/nvme0n1p7

# Now mount should work
sudo mount /dev/nvme0n1p7 /mnt/fedora

# Regenerate GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Prevention:**
- Always resize btrfs filesystem BEFORE resizing partition
- Or resize filesystem immediately after resizing partition

---

### GRUB Shows Only Arch, Not Fedora

**Symptoms:**
- GRUB menu only shows Arch entries
- Fedora is bootable via F9 EFI menu but not in GRUB

**Cause:**
- os-prober didn't detect Fedora
- GRUB_DISABLE_OS_PROBER might be true
- Fedora partition might not be mounted when generating GRUB config

**Solution:**
```bash
# Ensure os-prober is installed
sudo pacman -S os-prober

# Enable os-prober in GRUB config
sudo nano /etc/default/grub
# Uncomment or add: GRUB_DISABLE_OS_PROBER=false

# Mount Fedora partition (important!)
sudo mount /dev/nvme0n1p7 /mnt/fedora

# Regenerate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Verify Fedora was detected (should see "Found Fedora" in output)
```

**Manual Fallback:**
If os-prober still doesn't detect Fedora, add manually to `/etc/grub.d/40_custom`:

```bash
menuentry "Fedora Linux" {
    insmod part_gpt
    insmod btrfs
    search --no-floppy --fs-uuid --set=root d7796a39-d288-45e1-beca-144156304cb8
    linux /vmlinuz-6.17.8-300.fc43.x86_64 root=UUID=d7796a39-d288-45e1-beca-144156304cb8 ro rootflags=subvol=root
    initrd /initramfs-6.17.8-300.fc43.x86_64.img
}
```

Then regenerate GRUB config.

---

## Audio Problems

### No Audio / No Soundcards Found

**Symptoms:**
- `aplay -l` shows "no soundcards found"
- `pactl list sinks` only shows `auto_null`
- PipeWire is running but no audio devices detected

**Cause:**
- Missing Intel SOF (Sound Open Firmware) firmware
- Common on modern Intel laptops (11th gen+)

**Solution:**
```bash
# Install SOF firmware
sudo pacman -S sof-firmware

# Reboot (important - firmware loads at boot)
reboot

# After reboot, verify
aplay -l
pactl list sinks short
```

**Verification:**
Should see output like:
```
card 0: sofhdadsp [sof-hda-dsp], device 0: HDA Analog (*)
```

---

### Microphone Not Working

**Symptoms:**
- Speakers work but mic doesn't
- Teams/video calls can't detect microphone
- `arecord -l` shows no capture devices

**Cause:**
- Usually same as above (missing SOF firmware)
- Or mic not set as default input device

**Solution:**
```bash
# Install SOF firmware (if not already done)
sudo pacman -S sof-firmware
reboot

# Check if mic is detected
arecord -l

# Test microphone
arecord -d 5 test.wav
aplay test.wav

# Set default input in pavucontrol
pavucontrol  # Go to Input Devices tab
```

---

### PipeWire Services Not Running

**Symptoms:**
- No audio at all
- systemctl shows pipewire as inactive

**Cause:**
- PipeWire services not enabled for user session

**Solution:**
```bash
# Enable PipeWire services
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Verify they're running
systemctl --user status pipewire pipewire-pulse wireplumber
```

---

## Display & Monitor Issues

### External Monitor Not Detected

**Symptoms:**
- `hyprctl monitors` only shows laptop screen
- Monitor is connected but not showing up

**Cause:**
- Cable not fully connected
- Monitor not powered on
- Hyprland needs manual reload

**Solution:**
```bash
# Check what kernel sees
ls /sys/class/drm/

# Force Hyprland to reload
hyprctl reload

# Or restart Hyprland
# (Logout and login via SDDM)
```

---

### Portrait Monitor Shows Upside Down

**Symptoms:**
- Portrait monitor displays inverted
- Waybar appears at bottom instead of top

**Cause:**
- Wrong transform value in Hyprland config

**Solution:**
Edit `~/.config/hypr/hyprland.conf`:

```conf
# Try different transform values:
# 0 = normal (landscape)
# 1 = 90° clockwise
# 2 = 180° (upside down)
# 3 = 270° clockwise (or 90° counter-clockwise)

monitor=DP-3,1920x1080@60,3840x0,1,transform,3  # Adjust transform value
```

Then: `hyprctl reload`

---

### Workspaces Not Staying on Assigned Monitors

**Symptoms:**
- Workspaces jump between monitors
- Workspace 1-3 appear on wrong monitor

**Cause:**
- Workspace assignments in config might be incorrect
- Or monitors not properly named

**Solution:**
```bash
# Check actual monitor names
hyprctl monitors

# Update workspace assignments in hyprland.conf
workspace=1,monitor:eDP-1,default:true  # Use correct monitor name
```

---

## Keyboard & Input Issues

### Keybindings Don't Follow Keyboard Layout

**Symptoms:**
- On AZERTY keyboard, Super+Q opens terminal when pressing 'A' key
- Keybinds follow physical position, not letter

**Cause:**
- Hyprland uses keycodes by default, not keysyms

**Solution:**
Add to `~/.config/hypr/hyprland.conf`:

```conf
input {
    kb_layout = us,fr
    kb_options = grp:alt_shift_toggle
    resolve_binds_by_sym = true  # This fixes it
}
```

Then: `hyprctl reload`

---

### SDDM Login Shows Wrong Keyboard Layout

**Symptoms:**
- SDDM defaults to US layout
- Can't type password correctly on AZERTY keyboard

**Cause:**
- Xsetup script not configuring keyboard layout

**Solution:**
```bash
# Edit Xsetup script
sudo nano /usr/share/sddm/scripts/Xsetup

# Set to:
#!/bin/sh
setxkbmap fr,us -option grp:alt_shift_toggle

# Make executable
sudo chmod +x /usr/share/sddm/scripts/Xsetup

# Update SDDM config
sudo nano /etc/sddm.conf

# Ensure it has:
[X11]
DisplayCommand=/usr/share/sddm/scripts/Xsetup
```

---

### Keyboard Layout Not Switching with Alt+Shift

**Symptoms:**
- Alt+Shift doesn't toggle between US and FR
- Stuck on one layout

**Cause:**
- Keyboard options not configured in Hyprland

**Solution:**
Check `~/.config/hypr/hyprland.conf`:

```conf
input {
    kb_layout = us,fr  # Both layouts
    kb_options = grp:alt_shift_toggle  # Toggle keybind
}
```

Then: `hyprctl reload`

---

## Hyprland Issues

### Hyprland Won't Start / Crashes on Launch

**Symptoms:**
- SDDM login succeeds but screen goes black
- Returns to SDDM or TTY
- journalctl shows Hyprland errors

**Cause:**
- Syntax error in hyprland.conf
- Missing dependencies
- Graphics driver issue

**Solution:**
```bash
# Check logs
journalctl -xeu display-manager

# Try running Hyprland from TTY (Ctrl+Alt+F2)
Hyprland

# Check config for errors
hyprctl reload 2>&1 | grep -i error

# Verify dependencies
pacman -Q xdg-desktop-portal-hyprland qt5-wayland qt6-wayland
```

---

### Animations Laggy / Performance Issues

**Symptoms:**
- Window animations stutter
- System feels slow despite good hardware

**Cause:**
- Too many animation passes
- Blur settings too high

**Solution:**
Edit `~/.config/hypr/hyprland.conf`:

```conf
decoration {
    blur {
        passes = 1  # Reduce from 2-3
        size = 3    # Reduce from 5-7
    }
}

animations {
    # Reduce animation speed
    animation = windows, 1, 5, default  # Reduce from 7
}
```

---

## Waybar Issues

### Waybar Not Showing / Crashes on Launch

**Symptoms:**
- No status bar visible
- `pkill waybar && waybar &` shows errors

**Cause:**
- Syntax error in config or style.css
- Missing modules
- Bluetooth/network modules failing

**Solution:**
```bash
# Run waybar in foreground to see errors
waybar

# Check config syntax
cat ~/.config/waybar/config | jq .  # If JSON

# Common issues:
# - Missing comma in JSON
# - Wrong module name
# - Bluetooth not enabled
```

---

### Waybar Module Not Showing

**Symptoms:**
- Specific module (bluetooth, keyboard-state) doesn't appear
- Other modules work fine

**Cause:**
- Service not running (bluetooth)
- Module not supported in waybar version
- Incorrect module configuration

**Solution:**
```bash
# For bluetooth module:
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# For keyboard-state module:
# Some versions don't support capslock indicator
# Try different waybar version or remove module

# Check waybar version
waybar --version
```

---

### Waybar Colors Wrong After Theme Change

**Symptoms:**
- Waybar shows old colors
- Theme variables not applied

**Cause:**
- Waybar not reloaded after config change
- CSS @import path incorrect

**Solution:**
```bash
# Kill and restart waybar
pkill waybar
waybar &

# Verify @import path
cat ~/.config/waybar/style.css | grep @import
# Should be: @import "catppuccin-macchiato.css";

# Check file exists
ls ~/.config/waybar/catppuccin-macchiato.css
```

---

## Network Issues

### WiFi Not Connecting on Boot

**Symptoms:**
- No internet connection after boot
- Must manually connect each time

**Cause:**
- NetworkManager not enabled
- Auto-connect disabled for network

**Solution:**
```bash
# Enable NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Enable auto-connect for network
nmcli connection modify "SSID" connection.autoconnect yes
```

---

### Can't Connect to Hidden WiFi Network

**Symptoms:**
- Network not showing in `nmcli device wifi list`
- Connection fails

**Solution:**
```bash
# Connect to hidden network
nmcli device wifi connect "SSID" password "PASSWORD" hidden yes
```

---

## Package Management Issues

### AUR Package Build Fails

**Symptoms:**
- `paru -S package` fails to build
- Compilation errors

**Cause:**
- Missing build dependencies
- Outdated package PKGBUILD

**Solution:**
```bash
# Check build dependencies
paru -Si package-name

# Install base-devel if not already
sudo pacman -S base-devel

# Try cleaning build cache
paru -Scc

# Manual build to see full error
cd ~/.cache/paru/clone/package-name
makepkg -si
```

---

### "Package Not Found" for Known Package

**Symptoms:**
- `pacman -S package` says "target not found"
- Package exists on Arch website

**Cause:**
- Package database not synced
- Package might be in AUR, not official repos

**Solution:**
```bash
# Sync package database
sudo pacman -Sy

# If still not found, try AUR
paru -Ss package-name

# Or search explicitly in AUR
paru -S package-name
```

---

## General Troubleshooting Steps

### Debugging Checklist

When something doesn't work:

1. **Check if it's running:**
   ```bash
   pgrep -a program-name
   ps aux | grep program-name
   ```

2. **Check logs:**
   ```bash
   journalctl -xeu service-name
   journalctl -b  # Boot logs
   dmesg | tail -50
   ```

3. **Check config syntax:**
   ```bash
   # For Hyprland
   hyprctl reload 2>&1 | grep -i error
   
   # For JSON files
   cat file.json | jq .
   ```

4. **Test in isolation:**
   - Disable other components
   - Run program manually in foreground
   - Check with minimal config

5. **Verify dependencies:**
   ```bash
   pacman -Qi package-name  # Shows dependencies
   ldd /usr/bin/program     # Shows library dependencies
   ```

6. **Check permissions:**
   ```bash
   ls -la ~/.config/program/
   # Configs should be owned by your user
   # Scripts should be executable (chmod +x)
   ```

---

### Getting Help

**Before asking for help, gather info:**

```bash
# System info
uname -a
cat /etc/os-release

# Package versions
pacman -Q | grep relevant-package

# Config file
cat ~/.config/program/config

# Error messages
journalctl -xeu service-name | tail -50
```

**Where to ask:**
- Hyprland Discord (real-time help)
- r/hyprland (Reddit)
- r/archlinux (for Arch-specific issues)
- Arch Wiki (comprehensive documentation)

---

## Issue Template

When documenting new issues, use this format:

```markdown
### Issue Name

**Symptoms:**
- What you observed
- Error messages

**Cause:**
- Root cause if identified
- Or theories about cause

**Solution:**
\`\`\`bash
# Commands that fixed it
\`\`\`

**Verification:**
- How to confirm it's fixed

**Prevention:**
- How to avoid in future
```

---

**Last Updated:** 2025-11-28
