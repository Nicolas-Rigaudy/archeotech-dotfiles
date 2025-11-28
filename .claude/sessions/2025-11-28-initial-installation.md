# Session Summary - Initial Installation

**Date:** 2025-11-28
**Duration:** ~8 hours
**Goal:** Install Arch Linux + Hyprland from scratch and get fully work-ready system

---

## What Was Done

### System Installation ✅
- Installed Arch Linux alongside Fedora (dual-boot configuration)
- Created 232GB partition for Arch (nvme0n1p4)
- Resized Fedora from 443GB to 265GB (nvme0n1p7)
- Deleted Windows recovery partitions (p4, p5, p6) to free 33GB
- Configured btrfs with subvolumes: @, @home, @snapshots, @cache, @log
- Installed GRUB bootloader with Catppuccin theme
- Fixed Fedora detection in GRUB (btrfs device size mismatch issue)

### Desktop Environment ✅
- Installed Hyprland 0.52.1 with full configuration
- Configured SDDM display manager with Catppuccin Macchiato theme
- Set up 3-monitor configuration (laptop + 2 external, one portrait)
- Configured per-monitor workspace assignments
- Installed and themed waybar with clickable modules
- Installed rofi-wayland with dark theme
- Configured dunst notifications
- Set up swww wallpaper daemon (Arasaka wallpaper)
- Configured hyprlock screen lock with wallpaper
- Set up hypridle auto-lock (10min idle)

### Core Applications ✅
- Kitty terminal with Catppuccin Macchiato theme
- Fish shell set as default with starship prompt
- Zoxide (smart cd), thefuck (command corrector)
- VSCode with all extensions synced
- Zen browser with sync configured
- Thunar (GUI) and yazi (TUI) file managers
- Obsidian for notes
- Image viewer (imv), PDF viewer (zathura), video player (mpv)
- Archive tools (file-roller, unzip, unrar, p7zip)

### Development Environment ✅
- Git configured with SSH keys restored from Fedora
- AWS CLI with SSO authentication working
- Terraform 1.14.0 installed
- Python 3.13.7 + pip configured
- Docker 29.0.4 + docker-compose installed
- All work repositories and files migrated from Fedora

### Theming ✅
- Applied Catppuccin Macchiato throughout system
- GTK theme: catppuccin-macchiato-mauve-standard+default
- Icon theme: Papirus-Dark  
- Cursor theme: catppuccin-macchiato-dark-cursors
- Kitty fully themed with official Catppuccin Macchiato colors
- Waybar styled with Catppuccin colors from official repo
- Rofi dark theme applied
- SDDM Catppuccin login screen
- GRUB Catppuccin boot menu

### Utilities & Integrations ✅
- Screenshot tools: grim + slurp with keybinds (Super+S, Super+P)
- Clipboard history: cliphist with rofi integration (Super+V)
- Power menu: wlogout in waybar
- System tray applets: nm-applet (network), blueman-applet (bluetooth)
- Volume control: pavucontrol (GUI) + media keys
- Brightness control: brightnessctl + media keys
- Media control: playerctl + media keys

### All Keybindings Configured ✅
- Application launchers (Q=terminal, B=browser, E=VSCode, N=Obsidian, D=files)
- Window management (focus, move, resize with arrows and vim keys)
- Workspace navigation (1-9 direct, Tab to cycle)
- Screenshots (Super+S region, Super+P fullscreen, both save + clipboard)
- System controls (L=lock, volume, brightness, media keys)
- Keyboard layout switching (Alt+Shift US⟷FR, layout-aware)
- Mouse bindings (Super+drag to move/resize)

---

## Issues Encountered & Solved

### Issue 1: Fedora Partition Won't Mount After Resize
**Symptoms:** Mount failed with "device total_bytes should be at most X but found Y"  
**Cause:** btrfs filesystem thought it was 443GB but partition was resized to 265GB  
**Solution:** `sudo btrfs rescue fix-device-size /dev/nvme0n1p7`  
**Prevention:** Always resize btrfs filesystem before resizing partition

### Issue 2: GRUB Not Detecting Fedora
**Symptoms:** GRUB menu only showed Arch, not Fedora  
**Cause:** btrfs mount issue prevented os-prober from detecting Fedora  
**Solution:** Fixed btrfs, mounted Fedora, regenerated GRUB config  
**Verification:** Both OSes now appear in GRUB menu

### Issue 3: No Audio / Microphone Not Working
**Symptoms:** `pactl list sinks` showed only `auto_null`, no soundcards found  
**Cause:** Missing Intel SOF (Sound Open Firmware) firmware package  
**Solution:** `sudo pacman -S sof-firmware` then reboot  
**Verification:** Speakers and microphone working, Teams calls functional

### Issue 4: SDDM Keyboard Layout Defaulting to US
**Symptoms:** Login screen showed US keyboard, couldn't type AZERTY password  
**Cause:** Xsetup script not configured for FR layout  
**Solution:** Created `/usr/share/sddm/scripts/Xsetup` with `setxkbmap fr,us`  
**Verification:** SDDM now shows both layouts, defaults to FR

### Issue 5: Hyprland Keybinds Not Following Keyboard Layout
**Symptoms:** On AZERTY, Super+Q opened terminal when pressing 'A' key  
**Cause:** Hyprland uses keycodes by default, not keysyms  
**Solution:** Added `resolve_binds_by_sym = true` to input config  
**Verification:** Super+Q now works on actual Q key in both layouts

### Issue 6: Clipboard History Not Recording
**Symptoms:** Super+V showed empty list  
**Cause:** cliphist watcher daemons not running  
**Solution:** Added `wl-paste --watch cliphist store` to exec-once  
**Verification:** Clipboard history now working

### Issue 7: Bluetooth Icon Not Showing in Waybar
**Symptoms:** Waybar bluetooth module didn't display  
**Cause:** Bluetooth service not enabled  
**Solution:** `sudo systemctl enable bluetooth && systemctl start bluetooth`  
**Verification:** Bluetooth icon now visible, blueman-manager accessible

### Issue 8: Pavucontrol Opening Fullscreen Instead of Floating
**Symptoms:** Volume control opened tiled instead of floating  
**Cause:** Missing window rule  
**Solution:** Added `windowrulev2 = float, class:^(pavucontrol)$`  
**Verification:** Pavucontrol now opens centered as floating window

---

## Decisions Made

### Filesystem Choice: btrfs
**Rationale:** Snapshots for safety, compression, already familiar from Fedora  
**Alternative:** ext4 (simpler but no snapshots)

### Bootloader: GRUB over systemd-boot
**Rationale:** Auto-detects OSes, themeable, more documentation  
**Alternative:** systemd-boot (simpler but manual dual-boot)

### Theme: Catppuccin Macchiato with Mauve Accent
**Rationale:** Warmer tones better for long work sessions, distinctive accent  
**Alternative:** Catppuccin Mocha (more popular but cooler/darker)

### Keybind Philosophy: Layout-Aware
**Rationale:** More intuitive, Q key does Q action regardless of layout  
**Alternative:** Position-based (consistent muscle memory but illogical labeling)

### Delete Windows Recovery Partitions
**Rationale:** Freed 33GB, Windows recoverable via HP Cloud Recovery or fresh install  
**Alternative:** Keep partitions (but rarely needed, limited space gain)

All decisions documented in `.claude/DECISIONS.md` with full rationale.

---

## Testing & Verification

### Tested & Working ✅
- Dual-boot (both Arch and Fedora boot successfully)
- Multi-monitor setup (3 screens including portrait)
- Audio playback and recording (tested with YouTube and microphone test)
- Keyboard layout switching (Alt+Shift works in Hyprland and SDDM)
- All keybindings (tested terminal, launcher, screenshots, etc.)
- Git with SSH keys (cloned and accessed work repos)
- AWS CLI with SSO (successfully authenticated)
- Terraform (version check passed)
- Docker (service running, tested docker ps)
- VSCode (opened with all extensions loaded)
- Screenshots (both region and fullscreen, save + clipboard)
- Clipboard history (copy text and images, recall with Super+V)
- Lock screen (Super+L locks, unlocks with password)
- Idle management (screen dims at 5min, locks at 10min)
- Power menu (wlogout accessible from waybar)
- Volume/brightness/media controls (all media keys functional)
- Theme consistency (Catppuccin Macchiato across all apps)

### Known Issues (Low Priority) ⚠️
- Caps Lock indicator in waybar not working (module not detecting state)
- Touchpad gestures not implemented (not critical, workspace switching works via keys)

---

## Files Modified/Created

### Main Configurations
```
~/.config/hypr/hyprland.conf          # Main Hyprland config (350+ lines)
~/.config/hypr/hyprlock.conf          # Lock screen config
~/.config/hypr/hypridle.conf          # Idle management
~/.config/waybar/config               # Waybar layout (JSON)
~/.config/waybar/style.css            # Waybar styling (Catppuccin)
~/.config/waybar/catppuccin-macchiato.css  # Color variables
~/.config/rofi/config.rasi            # Rofi main config
~/.config/rofi/theme.rasi             # Rofi dark theme
~/.config/kitty/kitty.conf            # Terminal with Catppuccin colors
~/.config/fish/config.fish            # Fish shell config
/etc/sddm.conf                        # Display manager config
/usr/share/sddm/scripts/Xsetup        # SDDM keyboard layout script
/etc/default/grub                     # GRUB config
```

### Packages Installed
**System (pacman):**
- Core: base, base-devel, linux, linux-firmware, intel-ucode, networkmanager
- Hyprland: hyprland, xdg-desktop-portal-hyprland, qt5-wayland, qt6-wayland, polkit-kde-agent
- Display: sddm, waybar, rofi-wayland, dunst, swww, hyprlock, hypridle
- Audio: pipewire, pipewire-pulse, pipewire-alsa, pipewire-jack, wireplumber, pavucontrol, sof-firmware
- Terminal: kitty, fish, starship
- Files: thunar + plugins, yazi, gvfs, tumbler
- Utils: btop, fastfetch, fzf, ripgrep, fd, bat, eza, brightnessctl, playerctl
- Media: grim, slurp, wl-clipboard, cliphist, imv, zathura, mpv, file-roller
- Dev: git, python, python-pip, terraform, docker, docker-compose, aws-cli
- Fonts: ttf-firacode-nerd, noto-fonts, noto-fonts-emoji, ttf-liberation, ttf-dejavu

**AUR (paru):**
- visual-studio-code-bin, zen-browser-bin, wlogout
- catppuccin-gtk-theme-macchiato, papirus-icon-theme, catppuccin-cursors-macchiato
- thefuck, zoxide

---

## Next Session Goals

### High Priority (Dotfiles Setup)
- [ ] Create dotfiles git repository structure
- [ ] Write backup script to snapshot current configs
- [ ] Create install script for reproducible deployment
- [ ] Document all packages with explanations
- [ ] Complete comprehensive installation guide

### Medium Priority (Workflow Enhancement)
- [ ] Build custom rofi scripts (AWS profile switcher, Terraform menu, SSH quick connect)
- [ ] Add custom waybar modules (git branch indicator, AWS profile, VPN status)
- [ ] Implement theme switcher (Macchiato ↔ Mocha with smooth transitions)
- [ ] Create advanced window rules for work apps (VSCode → ws2, browser → ws3)
- [ ] Set up multi-monitor hotplug detection scripts

### Low Priority (Polish & Extras)
- [ ] Fix caps lock indicator in waybar (or find alternative)
- [ ] Add per-workspace wallpapers
- [ ] Create scratchpad terminal (dropdown terminal)
- [ ] Implement gaming mode (disable compositor)
- [ ] Explore Quickshell as waybar alternative

---

## Time Breakdown

- Planning/Research: 45 mins
- Base Arch Installation: 2 hours
- Partition resizing & Fedora recovery: 1 hour  
- Hyprland & Desktop Environment: 2 hours
- Development Environment & Migrations: 1.5 hours
- Theming & Customization: 2 hours
- Troubleshooting Audio: 30 mins
- Documentation & Testing: 30 mins

**Total:** ~8 hours

---

## Notes & Observations

### What Went Well
- Dual-boot setup worked perfectly after fixing btrfs issue
- Theming was straightforward with official Catppuccin repos
- Migration from Fedora was smooth (all configs and files preserved)
- Hardware support excellent (audio, wifi, bluetooth all working)
- Hyprland surprisingly stable and performant

### What Was Challenging
- btrfs device size mismatch after partition resize (unexpected)
- Missing SOF firmware not immediately obvious (common issue for Intel audio)
- SDDM keyboard layout configuration required custom script
- Understanding difference between keycodes and keysyms for layout-aware binds

### Lessons Learned
- Always resize filesystem BEFORE resizing partition (or immediately after)
- Check for firmware packages when hardware isn't detected (sof-firmware, linux-firmware, etc.)
- Read Hyprland wiki thoroughly before configuring (saved time on keybinds)
- Official theme repos are gold (Catppuccin organization on GitHub)
- Taking time to understand each component pays off (no cargo-culting configs)

### Things to Remember
- Document decisions as you make them (rationale gets forgotten quickly)
- Test each feature immediately after configuring (catch issues early)
- Keep Fedora as safety net until fully confident in Arch (smart decision)
- System is fully work-ready but customization is never "done" (continuous improvement)

---

## Commands Reference

Useful commands discovered this session:

```bash
# Fix btrfs device size mismatch
sudo btrfs rescue fix-device-size /dev/nvme0n1p7

# Reload Hyprland config
hyprctl reload

# Restart waybar
pkill waybar && waybar &

# Check audio devices
pactl list sinks short
aplay -l

# Test microphone
arecord -d 5 test.wav && aplay test.wav

# Enable services
sudo systemctl enable service-name
systemctl --user enable service-name  # For user services

# AWS SSO login
aws sso login --profile profile-name

# Generate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Check Hyprland monitors
hyprctl monitors

# List installed packages
pacman -Qe  # Explicitly installed
```

---

## Links & References

**Documentation Used:**
- [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin GitHub](https://github.com/catppuccin)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [btrfs Wiki](https://btrfs.wiki.kernel.org/)

**Inspiration:**
- Catppuccin theme repos (SDDM, waybar, rofi)
- Various r/unixporn posts for Hyprland configs
- Hyprland Discord for troubleshooting help

---

## Statistics

**System State:**
- Disk Usage: Arch 23.45GB / 216.17GB (11%)
- RAM Usage: ~3GB / 31GB at idle
- Packages Installed: 627 total
- Uptime: Tested with multiple reboots, boots in ~5 seconds
- Boot Order: GRUB → SDDM → Hyprland (~10 seconds total from power-on)

**Achievement Unlocked:** 🎉
- ✅ Fully functional Arch + Hyprland system
- ✅ Complete work environment (can deploy infrastructure from this laptop)
- ✅ Beautiful Catppuccin Macchiato theming
- ✅ All productivity features working
- ✅ Dual-boot preserved for safety
- ✅ Daily driver ready!

---

**Session End:** 2025-11-28 23:59
**Status:** ✅ System Complete & Operational
**Next Session:** Focus on dotfiles repository and automation scripts
