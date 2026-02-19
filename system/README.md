# System Configuration Files

This directory contains system-level configuration files that require root permissions to deploy.

**Note:** Unlike user configs in `config/`, these files **cannot** be managed with GNU Stow because they live in `/etc/` (system directories) and require root permissions.

## Contents

### Snapper Configuration
- `etc/snapper/configs/root` - Snapper snapshot configuration for root filesystem

### SDDM Configuration
- `etc/sddm.conf` - SDDM login screen with Catppuccin Macchiato theme

### GRUB Configuration
- `etc/grub.d/40_custom` - Custom GRUB entries for Fedora dual-boot

## Deployment

### Automated Deployment (Recommended)
```bash
# Deploy all system configs at once
./scripts/update-system-configs.sh
```

### Manual Deployment
```bash
# Deploy Snapper config
sudo cp system/etc/snapper/configs/root /etc/snapper/configs/root
sudo chmod 640 /etc/snapper/configs/root
sudo chown root:root /etc/snapper/configs/root

# Deploy SDDM config
sudo cp system/etc/sddm.conf /etc/sddm.conf
sudo chmod 644 /etc/sddm.conf
sudo chown root:root /etc/sddm.conf

# Deploy GRUB custom entries and regenerate config
sudo cp system/etc/grub.d/40_custom /etc/grub.d/40_custom
sudo chmod 755 /etc/grub.d/40_custom
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Using Setup Scripts
```bash
# Setup snapper from scratch
sudo ./scripts/setup-snapper.sh

# Update system configs after editing
./scripts/update-system-configs.sh
```

## What Gets Deployed

### Snapper Snapshot System
- **Configuration:** `/etc/snapper/configs/root`
- **Retention Policy:**
  - Hourly snapshots: 10 kept
  - Daily snapshots: 10 kept
  - Monthly snapshots: 10 kept
  - Yearly snapshots: 10 kept
  - Pre/post snapshots: 50 total, 10 important
- **Permissions:** `snapper` group can manage snapshots without sudo
- **Services:** `snapper-timeline.timer`, `snapper-cleanup.timer`, `grub-btrfsd.service`

### SDDM Login Screen
- **Configuration:** `/etc/sddm.conf`
- **Theme:** Catppuccin (via `sddm-catppuccin-git` from AUR)
- **Flavor:** Macchiato (configured in theme's background)
- **Features:**
  - Numlock enabled by default
  - Catppuccin Macchiato cursor theme
  - Beautiful gradient background with mauve accents

### GRUB Dual-Boot
- **Configuration:** `/etc/grub.d/40_custom`
- **Purpose:** Custom boot entries for Fedora dual-boot
- **Issue Fixed:** Fedora kernels are in shared `/boot` (nvme0n1p3) but root is on separate btrfs partition (nvme0n1p7)
- **Entries:**
  - Fedora Linux 43 (kernel 6.17.8-300)
  - Fedora Linux 42 (kernel 6.17.8-200, backup)

## Prerequisites

### For Snapper
1. Btrfs filesystem with proper subvolume layout (`@`, `@home`, `@snapshots`, etc.)
2. Packages installed: `snapper`, `snap-pac`, `grub-btrfs`, `inotify-tools`
3. User added to `snapper` group
4. `/.snapshots` mounted to `@snapshots` subvolume

See `scripts/setup-snapper.sh` for complete setup automation.

### For SDDM Theme
1. SDDM installed: `pacman -S sddm`
2. Catppuccin theme installed: `paru -S sddm-catppuccin-git`
3. Cursor theme installed: `paru -S catppuccin-cursors-macchiato`

After deploying the config, reboot to see the theme.

### For GRUB Dual-Boot
1. GRUB installed: `pacman -S grub os-prober`
2. Shared `/boot` partition between Arch and Fedora (nvme0n1p3)
3. Fedora root on separate btrfs partition (nvme0n1p7)

After deploying, the custom Fedora entries will appear in GRUB menu.
