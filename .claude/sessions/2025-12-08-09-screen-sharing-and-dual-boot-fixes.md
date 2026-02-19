# Session Summary: Screen Sharing & Dual-Boot Fixes

**Date:** 2025-12-08 to 2025-12-09
**Duration:** ~6 hours across 2 days
**Status:** ✅ Screen sharing complete, ⚠️ Fedora boot partially working

---

## Goals

1. Fix screen sharing for Microsoft Teams on MangoWC
2. Apply Catppuccin theme to SDDM login screen
3. Fix Fedora dual-boot from GRUB

---

## Accomplishments

### 1. ✅ Screen Sharing Configuration (Complete)

**Problem:** Teams/Zoom couldn't share screen on MangoWC

**Solution:** Configured xdg-desktop-portal with wlroots backend

**Files Created/Modified:**
- `config/.config/xdg-desktop-portal/mangowc-portals.conf` - MangoWC portal configuration
- `config/.config/xdg-desktop-portal/portals.conf` - Default portal configuration
- `config/.config/mango/autostart.sh` - Added portal autostart

**Packages Installed:**
- `xdg-desktop-portal` - Base portal functionality
- `xdg-desktop-portal-wlr` - wlroots backend for MangoWC screen sharing

**Configuration Details:**
```ini
[preferred]
default=wlr;gtk

# Screen capture - critical for Teams
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr

# File pickers
org.freedesktop.impl.portal.FileChooser=gtk

# Notifications (routes to dunst)
org.freedesktop.impl.portal.Notification=gtk
```

**Key Learning:** MangoWC uses wlroots, so needs `xdg-desktop-portal-wlr`, not `xdg-desktop-portal-hyprland`

**Result:** Screen sharing now works in Teams, Zoom, Discord on MangoWC

---

### 2. ✅ SDDM Catppuccin Theme (Complete)

**Problem:** SDDM using default theme, not Catppuccin

**Solution:**
1. Installed `sddm-catppuccin-git` from AUR
2. Created proper SDDM config in dotfiles
3. Fixed theme name mismatch (`catppuccin` vs `catppuccin-macchiato`)

**Files Created:**
- `system/etc/sddm.conf` - SDDM configuration with Catppuccin theme

**Configuration:**
```ini
[Theme]
Current=catppuccin
CursorTheme=catppuccin-macchiato-dark-cursors

[General]
Numlock=on
```

**Key Learning:** The theme folder is named `catppuccin` but uses Macchiato flavor via its background image setting

**Scripts Updated:**
- `scripts/update-system-configs.sh` - Now deploys SDDM config

**Documentation Updated:**
- `system/README.md` - Added SDDM theme documentation

**Result:** Beautiful Catppuccin Macchiato theme on login screen with mauve accents

---

### 3. ⚠️ Fedora Dual-Boot from GRUB (Partially Working)

**Problem:** Fedora wouldn't boot from Arch's GRUB menu

**Root Causes Found:**
1. ❌ GRUB auto-detection tried to load kernel from Fedora btrfs partition (wrong location)
2. ❌ Fedora's `/etc/fstab` referenced non-existent `/boot` partition (UUID mismatch)
3. ❌ Fedora's `/etc/fstab` referenced non-existent `/boot/efi` partition (UUID mismatch)

**Solutions Implemented:**

**A. Created Custom GRUB Entry**
- File: `system/etc/grub.d/40_custom`
- Loads Fedora kernel from shared `/boot` (nvme0n1p3)
- Passes correct root and rootflags to kernel
- Two entries: Fedora 43 and Fedora 42 (backup)

**B. Fixed Fedora's fstab**
- Fixed `/boot` UUID: `ea89ad85...` → `031889ca...` (shared `/boot`)
- Fixed `/boot/efi` UUID: `3020-44F9` → `1788-AEB3` (shared EFI)

**Diagnostic Scripts Created:**
- `scripts/diagnose-fedora-boot.sh` - Check btrfs subvolumes and fstab
- `scripts/fix-fedora-fstab.sh` - Fix `/boot` UUID in Fedora's fstab
- `scripts/fix-fedora-efi.sh` - Fix `/boot/efi` UUID in Fedora's fstab

**Current Status:**
- ✅ Fedora kernel loads from GRUB successfully
- ✅ Root filesystem mounts correctly
- ✅ `/boot` and `/boot/efi` mount successfully
- ✅ Login screen appears, password accepted
- ❌ Shows plain SDDM instead of Fedora's KDE environment
- ❌ Returns to login screen after login (desktop environment fails to start)

**Workaround:** Boot Fedora from BIOS boot menu (works perfectly)

**Next Steps to Investigate:**
1. Why Arch's SDDM is used instead of Fedora's display manager
2. Check systemd service initialization order
3. May need to use systemd-boot instead of GRUB for Fedora
4. Or keep BIOS boot as primary Fedora boot method

---

## Files Modified

### New Files Created
```
config/.config/xdg-desktop-portal/
├── mangowc-portals.conf
└── portals.conf

system/etc/
├── sddm.conf
└── grub.d/
    └── 40_custom

scripts/
├── diagnose-fedora-boot.sh
├── fix-fedora-fstab.sh
└── fix-fedora-efi.sh

docs/
├── MANGOWC-SETUP.md
└── DUAL-BOOT-FIX.md (rejected by user)
```

### Modified Files
```
config/.config/mango/autostart.sh
scripts/update-system-configs.sh
scripts/install.sh
docs/PACKAGES.md
docs/INSTALLATION.md
system/README.md
README.md
.claude/claude.md
```

---

## Technical Decisions

### 1. Portal Configuration Location
**Decision:** Use `~/.config/xdg-desktop-portal/` instead of `/etc/xdg-desktop-portal/`
**Rationale:** User-level configuration, managed by stow, tracked in git

### 2. Portal Backend Choice
**Decision:** Use `xdg-desktop-portal-wlr` for MangoWC
**Rationale:** MangoWC is wlroots-based, needs wlr backend not Hyprland backend

### 3. SDDM Config Storage
**Decision:** Store in `system/etc/sddm.conf` instead of `config/`
**Rationale:** System-level config requiring root, can't be symlinked with stow. Consistent with snapper config location.

### 4. GRUB Custom Entry Approach
**Decision:** Manual GRUB entry in `40_custom` instead of relying on os-prober
**Rationale:** os-prober can't handle shared `/boot` with separate root partitions. Manual entry gives full control.

### 5. Fedora Boot Scripts
**Decision:** Keep diagnostic scripts for documentation
**Rationale:** Document the troubleshooting process, may help others with similar setups

---

## Packages Added

### Official Repositories
- `xdg-desktop-portal` - Base desktop portal
- `xdg-desktop-portal-wlr` - wlroots backend for screen sharing

### AUR
- `sddm-catppuccin-git` - Catppuccin theme for SDDM

---

## Commands Reference

### Deploy Screen Sharing Config
```bash
# Configs are already symlinked via stow
# Restart portals:
killall xdg-desktop-portal-wlr xdg-desktop-portal
/usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal &

# Or reboot (portals autostart on login)
```

### Deploy SDDM Theme
```bash
./scripts/update-system-configs.sh
# Or manually:
sudo cp system/etc/sddm.conf /etc/sddm.conf
reboot
```

### Deploy Fedora GRUB Entry
```bash
./scripts/update-system-configs.sh
# Or manually:
sudo cp system/etc/grub.d/40_custom /etc/grub.d/40_custom
sudo chmod 755 /etc/grub.d/40_custom
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Fix Fedora fstab (if needed again)
```bash
./scripts/fix-fedora-fstab.sh
./scripts/fix-fedora-efi.sh
```

---

## Troubleshooting Notes

### Screen Sharing Not Working
1. Check portals running: `ps aux | grep xdg-desktop-portal`
2. Check portal config: `cat ~/.config/xdg-desktop-portal/mangowc-portals.conf`
3. Check logs: `journalctl --user -u xdg-desktop-portal -f`
4. Restart portals (see commands above)

### SDDM Theme Not Applying
1. Check theme installed: `ls /usr/share/sddm/themes/catppuccin/`
2. Check config: `cat /etc/sddm.conf`
3. Verify theme name is `catppuccin` not `catppuccin-macchiato`
4. Reboot to apply

### Fedora Boot Issues
1. Boot from BIOS menu works perfectly (use this)
2. GRUB entry loads kernel but wrong environment
3. Scripts available for diagnosing: `scripts/diagnose-fedora-boot.sh`

---

## Lessons Learned

1. **Portal Configuration:** wlroots compositors need `xdg-desktop-portal-wlr`, not `-hyprland`
2. **Shared /boot Complexity:** Dual-boot with shared `/boot` is tricky, especially with btrfs
3. **SDDM Theme Names:** Theme folder name != configured flavor (check theme.conf)
4. **Stow Limitations:** System-level configs (`/etc/`) can't be symlinked, need separate workflow
5. **GRUB Custom Entries:** Manual entries better than os-prober for complex setups
6. **UUID Importance:** UUIDs in fstab must match actual partitions, not old partition layouts

---

## Next Session Priorities

### High Priority - Quick Wins
1. Apply Catppuccin theme to Dunst notifications
2. Install productivity tools (Frog, Mdcat, Espanso, Mission Center)
3. Learn Vim motions (practice with VSCode extension)

### Medium Priority - Enhancements
4. Custom rofi scripts (AWS profile switcher, Terraform commands)
5. Custom waybar modules (git branch, VPN status, AWS profile)
6. Explore Walker vs Rofi
7. Kanata setup for caps lock rebinding

### Low Priority - Optional
8. Continue investigating Fedora GRUB boot issue
9. Theme switcher (Mocha ↔ Macchiato)
10. Gaming mode / focus mode

---

## Outstanding Issues

1. **Fedora Boot from GRUB** - Partially working, wrong environment after login
2. **Dunst Theming** - Not yet applied (next session)
3. **Fedora Fix Scripts** - Decide whether to keep or archive

---

**Session completed:** 2025-12-09
**Next session:** Ready for new features and configuration
