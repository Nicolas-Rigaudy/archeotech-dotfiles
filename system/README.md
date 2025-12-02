# System Configuration Files

This directory contains system-level configuration files that require root permissions to deploy.

**Note:** Unlike user configs in `config/`, these files **cannot** be managed with GNU Stow because they live in `/etc/` (system directories) and require root permissions.

## Contents

### Snapper Configuration
- `etc/snapper/configs/root` - Snapper snapshot configuration for root filesystem

## Deployment

### Manual Deployment
```bash
# Deploy Snapper config
sudo cp system/etc/snapper/configs/root /etc/snapper/configs/root
sudo chmod 640 /etc/snapper/configs/root
sudo chown root:root /etc/snapper/configs/root
```

### Using Setup Script
```bash
sudo ./scripts/setup-snapper.sh
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

## Prerequisites

Before deploying, ensure:
1. Btrfs filesystem with proper subvolume layout (`@`, `@home`, `@snapshots`, etc.)
2. Packages installed: `snapper`, `snap-pac`, `grub-btrfs`, `inotify-tools`
3. User added to `snapper` group
4. `/.snapshots` mounted to `@snapshots` subvolume

See `scripts/setup-snapper.sh` for complete setup automation.
