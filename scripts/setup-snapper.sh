#!/bin/bash
# Snapper Snapshot System Setup Script
# Sets up Btrfs snapshots with Snapper, snap-pac, and grub-btrfs integration
# 
# This script:
# 1. Installs required packages
# 2. Configures Snapper for root filesystem
# 3. Sets up automatic snapshots (timeline + pacman hooks)
# 4. Enables GRUB boot menu integration
# 5. Configures user permissions

set -e  # Exit on error

echo "=================================="
echo "Snapper Snapshot System Setup"
echo "=================================="
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Error: This script must be run as root (use sudo)"
    exit 1
fi

# Check if on Btrfs
if ! findmnt -n -o FSTYPE / | grep -q btrfs; then
    echo "Error: Root filesystem is not Btrfs"
    exit 1
fi

# Get the actual user (not root when using sudo)
ACTUAL_USER="${SUDO_USER:-$USER}"
if [ "$ACTUAL_USER" = "root" ]; then
    echo "Error: Cannot determine actual user. Don't run as root, use sudo."
    exit 1
fi

echo "Installing packages..."
pacman -S --needed --noconfirm snapper snap-pac grub-btrfs inotify-tools

echo
echo "Configuring Snapper for root filesystem..."

# Unmount existing .snapshots if mounted
if mountpoint -q /.snapshots; then
    echo "Unmounting existing /.snapshots..."
    umount /.snapshots
fi

# Remove directory if exists
if [ -d /.snapshots ]; then
    rmdir /.snapshots || true
fi

# Create Snapper config
echo "Creating Snapper config..."
snapper -c root create-config /

# Delete Snapper's auto-created subvolume (we use our own @snapshots)
if btrfs subvolume show /.snapshots &>/dev/null; then
    echo "Removing Snapper's auto-created subvolume..."
    btrfs subvolume delete /.snapshots
fi

# Recreate mount point
mkdir -p /.snapshots

# Remount from fstab (should mount @snapshots subvolume)
echo "Remounting /.snapshots from fstab..."
mount /.snapshots

# Copy our configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

if [ -f "$DOTFILES_DIR/system/etc/snapper/configs/root" ]; then
    echo "Deploying Snapper configuration..."
    cp "$DOTFILES_DIR/system/etc/snapper/configs/root" /etc/snapper/configs/root
    chmod 640 /etc/snapper/configs/root
    chown root:root /etc/snapper/configs/root
else
    echo "Warning: Snapper config not found in dotfiles, using defaults"
fi

# Create and configure snapper group
echo "Setting up snapper group..."
groupadd snapper 2>/dev/null || true
usermod -aG snapper "$ACTUAL_USER"
chown :snapper /.snapshots
chmod 750 /.snapshots

# Enable systemd services
echo "Enabling Snapper services..."
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer
systemctl enable --now grub-btrfsd.service

# Update GRUB to include snapshots
echo "Updating GRUB configuration..."
grub-mkconfig -o /boot/grub/grub.cfg

echo
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo
echo "What was configured:"
echo "  ✓ Snapper installed and configured for root filesystem"
echo "  ✓ snap-pac will create pre/post snapshots for pacman operations"
echo "  ✓ Timeline snapshots enabled (hourly/daily/monthly)"
echo "  ✓ GRUB menu will show bootable snapshots"
echo "  ✓ User '$ACTUAL_USER' added to snapper group"
echo
echo "Snapshot retention policy:"
echo "  - Hourly: 10 snapshots"
echo "  - Daily: 10 snapshots"
echo "  - Monthly: 10 snapshots"
echo "  - Yearly: 10 snapshots"
echo
echo "Usage:"
echo "  sudo snapper list                    # List snapshots"
echo "  sudo snapper create -d 'description' # Create manual snapshot"
echo "  sudo snapper status 1..2             # Compare snapshots"
echo "  sudo snapper rollback <number>       # Rollback to snapshot"
echo "  pkexec snapper-gui                   # GUI (if installed)"
echo
echo "Note: Logout and login for group membership to take effect"
echo "      (or run 'newgrp snapper' in current shell)"
