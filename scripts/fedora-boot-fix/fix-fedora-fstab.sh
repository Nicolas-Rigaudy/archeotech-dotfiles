#!/bin/bash
################################################################################
# Fix Fedora's /etc/fstab to use shared /boot partition
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Fixing Fedora /etc/fstab${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Mount Fedora root
echo -e "${BLUE}→${NC} Mounting Fedora partition..."
sudo mkdir -p /mnt/fedora
sudo mount -o subvol=root /dev/nvme0n1p7 /mnt/fedora
echo -e "${GREEN}✓${NC} Mounted Fedora root"
echo ""

# Backup original fstab
echo -e "${BLUE}→${NC} Backing up original fstab..."
sudo cp /mnt/fedora/etc/fstab /mnt/fedora/etc/fstab.backup-$(date +%Y%m%d-%H%M%S)
echo -e "${GREEN}✓${NC} Backup created"
echo ""

# Show current fstab
echo -e "${BLUE}→${NC} Current Fedora fstab:"
sudo cat /mnt/fedora/etc/fstab
echo ""

# Update fstab - replace the wrong /boot UUID with the correct shared one
echo -e "${BLUE}→${NC} Updating /boot entry in fstab..."
echo -e "${YELLOW}!${NC} Replacing UUID=ea89ad85-270e-449f-a247-bb66bf8ecbb6"
echo -e "${YELLOW}!${NC} With UUID=031889ca-f0fe-4714-8aca-bae2cda42b5d (shared /boot)"

sudo sed -i 's|UUID=ea89ad85-270e-449f-a247-bb66bf8ecbb6|UUID=031889ca-f0fe-4714-8aca-bae2cda42b5d|g' /mnt/fedora/etc/fstab

echo -e "${GREEN}✓${NC} Updated fstab"
echo ""

# Show updated fstab
echo -e "${BLUE}→${NC} Updated Fedora fstab:"
sudo cat /mnt/fedora/etc/fstab
echo ""

# Unmount
echo -e "${BLUE}→${NC} Unmounting..."
sudo umount /mnt/fedora
echo ""

echo -e "${GREEN}✓${NC} Done!"
echo ""
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${GREEN}Next step:${NC} Reboot and try Fedora again!"
echo ""
