# Troubleshooting Guide

This document contains all known issues, their symptoms, causes, and solutions. Update this whenever you encounter and solve a problem.

---

## Table of Contents

- [Boot & System Issues](#boot--system-issues)
- [Audio Problems](#audio-problems)
- [Display & Monitor Issues](#display--monitor-issues)
- [Keyboard & Input Issues](#keyboard--input-issues)
- [MangoWC Issues](#mangowc-issues)
- [Quickshell / QML Issues](#quickshell--qml-issues)
- [Hyprland Issues](#hyprland-issues)
- [Waybar Issues](#waybar-issues)
- [wlogout Issues](#wlogout-issues)
- [Network Issues](#network-issues)
- [Package Management Issues](#package-management-issues)
- [General Troubleshooting Steps](#general-troubleshooting-steps)

---

## Boot & System Issues

> **Note:** Fedora entries below are archived. System is Arch-only since ~2026-04-20 (Fedora partition removed). Kept for historical reference only.

### [ARCHIVED] Fedora Won't Boot After Arch Install

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

### [ARCHIVED] Fedora Boots to Wrong Environment from GRUB (Known Partial Issue)

**Symptoms:**
- Fedora kernel loads from GRUB successfully
- Login screen appears, password accepted
- Shows Arch's SDDM instead of Fedora's KDE — desktop environment fails to start, returns to login screen

**Cause:**
- Arch's SDDM is used instead of Fedora's display manager (systemd service init ordering issue)

**Current Status:** Unresolved. Workaround: boot Fedora via BIOS boot menu (F9) — works perfectly.

**Diagnosis scripts available:**
```bash
scripts/diagnose-fedora-boot.sh   # Check btrfs subvolumes and fstab
scripts/fix-fedora-fstab.sh       # Fix /boot UUID in Fedora's fstab
scripts/fix-fedora-efi.sh         # Fix /boot/efi UUID in Fedora's fstab
```

---

### [ARCHIVED] GRUB Shows Only Arch, Not Fedora

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
- Monitor is connected but not showing up

**Cause:**
- Cable not fully connected
- Monitor not powered on
- Compositor needs reload

**Solution (MangoWC — primary):**
```bash
# Check what kernel sees
ls /sys/class/drm/

# MangoWC: reload config (monitor rules may not apply — log out/in if needed)
mmsg reload

# Or log out and log back in via SDDM for monitor rules to take effect
```

**Solution (Hyprland — fallback):**
```bash
hyprctl reload
```

---

### Portrait Monitor Shows Upside Down

**Symptoms:**
- Portrait monitor displays inverted

**Cause:**
- Wrong transform value in compositor config

**Solution (MangoWC — primary):**
Edit `~/.config/mango/config.conf`:
```conf
# MangoWC uses monitorrule with transform
monitorrule=DP-3,1920x1080@60,3840x0,1,transform,3
```
Then log out/in (mmsg reload doesn't reliably reapply monitor rules).

**Solution (Hyprland — fallback):**
Edit `~/.config/hypr/hyprland.conf`:
```conf
# 0=normal 1=90°CW 2=180° 3=270°CW
monitor=DP-3,1920x1080@60,3840x0,1,transform,3
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

### logiops Not Detecting MX Master 3S on Boot (Bolt Dongle)

**Symptoms:**
- `journalctl -u logid` shows "Config file does not exist" or device times out
- Gestures and button remaps don't work after reboot

**Cause:**
- The MX Master 3S Bolt dongle requires mouse movement to initialize HID++ communication
- logiops starts before the mouse sends its first event, causing a timeout

**Solution:**
After restarting the service, wiggle the mouse immediately:
```bash
sudo systemctl restart logid
# wiggle mouse right after
```

For suspend/wake issues, a systemd-sleep hook can auto-restart logid:
```bash
sudo nano /lib/systemd/system-sleep/logid
# paste: #!/bin/sh / case "$1" in / post) systemctl restart logid ;; / esac
sudo chmod +x /lib/systemd/system-sleep/logid
```

**Other gotchas:**
- Config file must be `/etc/logid.cfg` (not `.conf`)
- Device name must be exactly `"MX Master 3S For Business"` (not `"MX Master 3S"`)
- `pointer_speed` is not a valid MangoWC config key — use logiops `dpi` instead

---

### Keybindings Don't Follow Keyboard Layout

**Symptoms:**
- On AZERTY keyboard, Super+Q opens terminal when pressing 'A' key
- Keybinds follow physical position, not letter

> **Note:** This section applies to Hyprland (fallback). MangoWC uses `keybindsym` in `mango/config.conf` for layout-aware binds.

**Cause (Hyprland):**
- Hyprland uses keycodes by default, not keysyms

**Solution (Hyprland — fallback):**
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

> **Note:** Hyprland-specific config below. MangoWC uses `kb_options` in its own input block in `mango/config.conf`.

**Cause:**
- Keyboard options not configured in compositor

**Solution (Hyprland — fallback):**
Check `~/.config/hypr/hyprland.conf`:

```conf
input {
    kb_layout = us,fr  # Both layouts
    kb_options = grp:alt_shift_toggle  # Toggle keybind
}
```

Then: `hyprctl reload`

---

## MangoWC Issues

### XF86 Media Keys Don't Work (Volume, Brightness, Media)

**Symptoms:**
- Volume up/down keys do nothing in MangoWC
- Media play/pause/next/prev have no effect
- Brightness keys unresponsive

**Cause:**
- MangoWC requires `NONE` as explicit modifier for XF86 keys — empty modifier doesn't work

**Solution:**
```conf
# Wrong:
bind=,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

# Correct:
bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
```

Apply to all XF86 keys: volume, mic mute, brightness, media playback, print screen.

---

### Touchpad Two-Finger Scroll Not Working

**Symptoms:**
- Trackpad scroll does nothing or behaves erratically

**Cause:**
- Wrong parameter names — MangoWC uses different names than Hyprland

**Solution:**
```conf
# Wrong:
natural_scrolling=1
scroll_method=2fg

# Correct:
trackpad_natural_scrolling=1
scroll_method=1   # 1=two-finger, 2=edge, 4=button
```

---

### Script Keybind Silently Fails (swww socket, $HOME not found)

**Symptoms:**
- Keybind runs but script does nothing
- Script works fine from terminal, not from MangoWC keybind

**Cause:**
- `spawn` runs without a shell environment — no `$HOME`, no `$XDG_RUNTIME_DIR`, swww socket unreachable

**Solution:**
Use `spawn_shell` instead of `spawn` for any script that uses environment variables:
```conf
bind=SUPER,W,spawn_shell,~/.local/bin/wallpaper-picker.sh
```

---

### mmsg reload Doesn't Apply Monitor Rules

**Symptoms:**
- `mmsg reload` runs but monitor layout changes don't take effect

**Cause:**
- Known MangoWC limitation: `mmsg reload` does not reliably reapply `monitorrule`

**Solution:**
Log out and log back in (via SDDM) for monitor config changes to apply.

---

### Screen Sharing Doesn't Work in Teams/Zoom/Discord

**Symptoms:**
- Can't share screen in video call apps
- Screen share option grayed out or black screen

**Cause:**
- Missing xdg-desktop-portal-wlr (MangoWC is wlroots-based, needs wlr backend — not `-hyprland`)

**Solution:**
```bash
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-wlr
```

Config at `~/.config/xdg-desktop-portal/mangowc-portals.conf`:
```ini
[preferred]
default=wlr;gtk
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
org.freedesktop.impl.portal.FileChooser=gtk
org.freedesktop.impl.portal.Notification=gtk
```

Portals autostart on login. To restart manually:
```bash
killall xdg-desktop-portal-wlr xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal &
```

---

### swaync Panel Has Compositor Blur/Shadow Bleeding

**Symptoms:**
- MangoWC blur or shadow effect bleeds through the swaync notification panel
- Panel looks wrong / has extra visual artifacts

**Cause:**
- `layerrule=noblur/noshadow` for layer-shell surfaces doesn't work in MangoWC

**Solution:**
Disable globally in mango config:
```conf
blur_layer=0
layer_shadows=0
```

---

## Quickshell / QML Issues

> **Before solving a Quickshell problem:** Check the reference projects first — they've solved most common issues.
> - MangoWC-specific: https://github.com/noctalia-dev/noctalia-shell
> - Animations/state: https://github.com/end-4/dots-hyprland
> - Component patterns: https://github.com/caelestia-dots/shell
> See `DECISIONS.md` source-checking rule and `ANALYSIS.md §2` for the full reference catalog.

---

### Glass Panel Shows Halo / White Glow Artifact (SceneFX)

**Symptoms:**
- Glass panel (ControlCenter, bar popup) has a white or colored halo around it
- Artifact appears only when MangoWC blur (`blur_layer=1`) is enabled

**Cause:**
- SceneFX blur interacts with translucent QML panels — the compositor samples pixels behind the panel's edges, creating a bleed effect

**Confirmed solution (current):**
- Set `blur_layer=0` in `mango/config.conf` — disables blur on layer-shell surfaces
- Raise panel opacity slightly to compensate (glass color alpha ~0.96 in `Appearance.qml`)

**Potential better solution (check Noctalia):**
- Noctalia Shell has MangoWC support and glass panels without this issue
- Their approach may use a specific `WlrLayershell.exclusionZone` or compositor hint
- Check: https://github.com/noctalia-dev/noctalia-shell — look at how they set up glass panels under MangoWC

---

### Quickshell Bar Popup Shows as Grey Block

**Symptoms:**
- Hover popup from bar icon appears as a solid grey rectangle instead of a glass card

**Cause:**
- Using a standard `Item` or `Rectangle` in the same `PanelWindow` as the bar — it gets compositor-composited wrong

**Solution:**
- Popup must be a **separate Wayland surface** — use `Quickshell.Wayland.PopupWindow` as a child of the bar's `PanelWindow`
- The popup `parentWindow` must reference the bar's window, not the root
- This is why we use a `Loader`-created `PopupWindow` — avoids the artifact entirely

---

### ControlCenter State Desyncs With External Changes

**Symptoms:**
- User changes power profile in terminal (`powerprofilesctl set performance`) — ControlCenter still shows "Balanced"
- DND state in ControlCenter doesn't match actual swaync state

**Cause:**
- ControlCenter reads state once in `Component.onCompleted` and never again

**Current solution:**
- State re-reads on `onVisibleChanged` for power profile and night light
- DND: resolved — swaync replaced by native Quickshell notifications (Sprint 6), DND is now a direct QML property
- Remaining: power profile and night light still use `onVisibleChanged` re-read; a 2s poll timer while CC is visible would be cleaner but isn't critical

---

### Quickshell Process Dies Silently

**Symptoms:**
- Bar disappears
- No visible error

**Diagnosis:**
```bash
journalctl --user -u quickshell -n 50
# or run directly to see stderr:
quickshell 2>&1 | head -50
```

**Common causes:**
- QML syntax error after editing (check the file you last touched)
- Service singleton crash (Audio/Network most common — check if pactl/nmcli is available)
- Wrong property binding (undefined reference to a singleton property)

---

### mmsg Watch Mode Stops Updating Bar Tags

**Symptoms:**
- Bar tag dots stop responding to workspace switches
- Happened after system suspend/resume or compositor reload

**Cause:**
- The `mmsg -w` process in `MangoWC.qml` exited and wasn't restarted

**Solution:**
- `MangoWC.qml` should have an `onExited` handler that restarts the process
- Check that `Process { onExited: start() }` is present in the mmsg `Process` component
- Workaround: `pkill quickshell && quickshell &`

---

### QML Component Not Updating When Property Changes

**Symptoms:**
- A binding should update but doesn't
- Property change in a service singleton isn't reflected in the UI

**Cause:**
- QML reactivity requires properties to be declared as `property type name` — plain JS assignments don't trigger bindings
- Or: value is assigned to a plain object property (not a QML property), so Qt's signal system doesn't fire

**Solution:**
- Ensure all reactive state uses `property` declaration, not `var`
- For objects (like the `outputs` map in MangoWC.qml): force reactivity by reassigning the whole object (`outputs = Object.assign({}, outputs)`) — expensive but works
- Better pattern (from end-4): use a `ListModel` for collections instead of plain JS objects

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

> **Note:** Waybar is used only with Hyprland (fallback compositor). Primary shell is Quickshell. These entries apply only when running Hyprland.

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

## wlogout Issues

### wlogout Layout Ignored / Wrong Buttons Shown

**Symptoms:**
- 6 default buttons appear instead of custom layout
- Custom icons not showing

**Cause:**
- Flag collision: `-l` (layout) and `-L` (margin-left) — short flags silently conflict

**Solution:**
Always use long-form flags: `--layout`, `--css`, `--margin-left` etc. Never `-l` or `-L`.

### wlogout Icons Black / Not Showing

**Symptoms:**
- Icons are black or invisible
- `background-image: none` in a `*` selector overrides all icon URLs

**Solution:**
- Never put `background-image: none` in a `*` selector — it silently overrides `#lock`, `#logout` etc.
- SVGs need explicit `fill` attribute — copy system icons and inject `fill="#cad3f5"` via sed.

### wlogout Button Shapes Inconsistent Across Monitors

**Symptoms:**
- Buttons are square on one monitor, tall rectangles on another

**Cause:**
- GTK stretches buttons to fill available height — a wlogout/GTK3 limitation.
- `max-height` in CSS also breaks transparency.

**Workaround:**
- Use `--margin-top` / `--margin-bottom` computed from the focused monitor height to constrain vertical space. See `scripts/wlogout-launch.sh`.
- Button shapes will still vary slightly — no clean fix without switching to a different tool.

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

## Clipboard / Waybar / Window Rules

### Clipboard History Empty

**Symptoms:**
- `Super+V` shows no clipboard history
- cliphist returns nothing

**Cause:**
- cliphist daemon not running

**Solution:**
Add to Hyprland or MangoWC autostart:
```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

---

### Bluetooth Icon Not Showing in Waybar

**Symptoms:**
- Waybar bluetooth module missing or blank

**Cause:**
- Bluetooth service not enabled

**Solution:**
```bash
sudo systemctl enable --now bluetooth
pkill waybar && waybar &
```

---

### Window Doesn't Float (pavucontrol, file dialogs, etc.)

**Symptoms:**
- Expected floating window opens tiled

**Cause:**
- Missing window rule in compositor config

**Solution (Hyprland):**
```conf
windowrulev2 = float, class:^(pavucontrol)$
windowrulev2 = center, class:^(pavucontrol)$
windowrulev2 = size 800 600, class:^(pavucontrol)$
```

**Solution (MangoWC):**
```conf
windowrule=app_id:pavucontrol,float
windowrule=app_id:pavucontrol,center
```

---

## Battery Alert Service

### battery-alert.service Inactive (Dead) — Never Starts

**Symptoms:**
- `systemctl --user status battery-alert.service` shows `inactive (dead)`
- Logs show `ConditionResult=no`
- No battery notifications at any charge level

**Cause:**
- Service was `WantedBy=graphical-session.target` — MangoWC never activates this target, so the service never starts

**Solution:**
Change the service to use `default.target` instead:
```ini
[Unit]
Description=Battery low alert notifications

[Service]
Type=simple
ExecStart=%h/.local/bin/battery-alert.sh
Restart=on-failure
RestartSec=10
ExecStartPre=/bin/sleep 5

[Install]
WantedBy=default.target
```

The 5s `ExecStartPre` sleep ensures D-Bus is ready for `notify-send` at startup.

```bash
systemctl --user daemon-reload
systemctl --user enable --now battery-alert.service
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

---

## Quickshell Issues

### BarPopup not appearing / "Cannot assign to non-existent property leftMargin"

**Symptom:** Bar loads but no hover popups appear. Console shows `Cannot assign to non-existent property "leftMargin"`.

**Cause:** `WlrLayershell` does not have `leftMargin`/`topMargin` properties. Only `namespace`, `layer`, `keyboardFocus` exist on `WlrLayershell`.

**Fix:** Use `PopupWindow` from `Quickshell._Window` instead of `PanelWindow` for floating popups. Set `anchor.item` to the hovered QML item, `anchor.edges: Edges.Bottom`, `anchor.gravity: Edges.Bottom`. The popup positions itself automatically relative to the item.

---

### PopupWindow deprecation warnings (parentWindow / relativeX / relativeY)

**Symptom:** Console shows `PopupWindow.parentWindow is deprecated. Use PopupWindow.anchor.window.`

**Cause:** The old `parentWindow`/`relativeX`/`relativeY` API was replaced by the `anchor` group object (`PopupAnchor`) in a newer Quickshell version.

**Fix:** Use `anchor.item` (anchors to a QML Item directly), `anchor.window` (anchors to a window), `anchor.rect` (Box with x/y/w/h), `anchor.edges`, `anchor.gravity`. The `anchor` property is read-only (non-creatable `PopupAnchor` type) — set its sub-properties directly.

---

### Quickshell bar disappears / stale QML cache after file changes

**Symptom:** Changes to QML files don't take effect, or old warnings persist after fixing them.

**Cause:** Quickshell caches compiled `.qmlc` files. Hot-reload may serve the cached version.

**Fix:** `find ~/.cache -name "*.qmlc" -delete && pkill -f qs` then restart. Also check `/run/user/1000/quickshell/by-id/<latest>/log.log` for actual errors — the log file is always fresh.

---

### Network.qml "Cannot assign to non-existent property" after refactor

**Symptom:** `@services/Network.qml: Error: Cannot assign to non-existent property "ipAddress"` in logs.

**Cause:** Property was renamed/removed from the singleton but the running instance had it cached. The stdout parser was assigning to the old property name.

**Fix:** Clear QML cache (see above) and do a full restart. Hot-reload doesn't always pick up singleton property removals.

---

**Last Updated:** 2026-04-29
- Added Quickshell section (PopupWindow, BarPopup positioning, QML cache, singleton property changes)

---

## Quickshell Issues

### OSD appears on wrong screen / all screens

**Symptom:** Volume/brightness OSD shows on laptop screen instead of the focused monitor, or on all screens.

**Cause 1:** `MangoWC.qml` selmon parser was broken — set `entry.focused = (parts[2] !== undefined)` which is always true, so every output overwrote `focusedOutput`.
**Fix 1:** Parse correctly: `entry.focused = parts[2] === "1"`.

**Cause 2:** `osdVariants.instances` iteration to find focused screen didn't work reliably.
**Fix 2:** Put the filter in `Osd.qml` itself: `visible: shown && screen.name === Services.MangoWC.focusedOutput`. Call `show()` on all instances — only the one matching focused output becomes visible.

---

### White halo / pixelated border around bar, popups, OSD

**Symptom:** Bright white fringe around rounded-corner panels on landscape/laptop monitors. Portrait monitor unaffected.

**Cause:** SceneFX `blur_layer=1` blurs the full rectangular surface bounding box. Rounded-corner rectangles clip their content but the blurred pixels outside the corners remain visible as a white fringe. Layerrule `noblur` per-surface is unreliable.

**Fix:** Set `blur_layer=0` in mango.conf. Compensate by raising `glassBg` opacity (0.96) and `glassBgLight` (0.93) so panels are readable without blur-behind.

---

### Bar disappears after mango-reload.sh

**Symptom:** Running `mango-reload.sh` (Super+Shift+R) kills the bar and it never comes back.

**Cause:** `mango-reload.sh` kills quickshell before reloading MangoWC (to avoid duplicate instances on exec-once). But `exec-once` doesn't re-run on config reload, so quickshell was never relaunched.

**Fix:** Added relaunch at end of `mango-reload.sh`: `sleep 0.3 && env QT_WAYLAND_DECORATION=none quickshell -p ~/.config/quickshell &`

---

### Qt 6.11.0 → 6.11.1 system update breaks Quickshell: "Type X unavailable" cascade

**Symptom (2026-06-02, mid-Sprint 19):** After `pacman -Syu` brought Qt to 6.11.1, Quickshell logs:

```
WARN: Quickshell was built against Qt 6.11.0 but the system has updated to Qt 6.11.1 without rebuilding the package.
ERROR: Failed to load configuration
ERROR:   caused by @shell.qml[167:5]: Type Shell.ShellSurface unavailable
ERROR:   caused by @Modules/Shell/ShellSurface.qml[97:9]: Type Sides.SideLoader unavailable
ERROR:   caused by @Modules/Shell/Sides/SideLoader.qml[35:9]: Type Strip unavailable
ERROR:   caused by @Modules/Shell/Sides/Strip.qml[282:1]: Expected token `}'
```

Bar comes back after fixing Strip.qml's brace, but strip popups stay empty:

```
WARN scene: @Widgets/Strip/CcIcon.qml[4:1]: StripIconBase is not a type
WARN scene: @Modules/Shell/Sides/BarWidgetLoader.qml[26:5]: Required property widgetId was not initialized
```

**Cause:** Qt 6.11.1 became stricter on two latent issues that 6.11.0 silently tolerated:
1. `Strip.qml` was missing the closing `}` for its `Shape { id: card }` block — never caught by the older parser.
2. ListModel role auto-binding no longer fills *inherited* required properties on a delegate. Bar.qml's pattern `delegate: BarWidgetLoader { required property string widgetId }` (re-declaring the inherited `widgetId`) used to work in 6.11.0; in 6.11.1 the re-declared property shadows the inherited one and only the inherited slot ends up set, so `widgetId` reads empty.
3. Files loaded dynamically via `Loader.setSource()` (StripWidgetLoader does this for the strip icons) no longer auto-import their own directory. Sprint 18 deleted `qmldir` files relying on directory-as-module resolution, which still worked for static imports. Dynamic-load lost it.

**Fixes:**
1. Strip.qml: add the missing `}` to close `Shape { id: card }` (between iconArea's close and the outer Item's close).
2. Bar.qml: change all three Repeater delegates from `required property string widgetId` to `required property var model` + explicit `widgetId: model.widgetId`. Now the inherited slot is set directly via binding.
3. Restore `Widgets/Strip/qmldir` with `StripIconBase 1.0 StripIconBase.qml` so dynamically-loaded sibling types resolve.
4. **Also recommended:** `paru -S quickshell` to rebuild the package against current Qt — eliminates the version-mismatch warning at the top of the log.

**Generalised lesson:** Qt point releases (e.g. 6.x.0 → 6.x.1) can tighten QML parsing rules. When you see a cascade of "Type X unavailable" errors, the root cause is usually the *last* line in the cascade — a parse error in a leaf file. Always also rebuild Quickshell against the new Qt version (`paru -S quickshell`); the explicit "must be rebuilt" warning is real.

---

**Last Updated:** 2026-06-02
