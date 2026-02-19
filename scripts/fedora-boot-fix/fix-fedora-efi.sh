#!/bin/bash
################################################################################
# Fix Fedora's /boot/efi UUID in /etc/fstab
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Fixing Fedora /boot/efi UUID${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Mount Fedora root
echo -e "${BLUE}→${NC} Mounting Fedora partition..."
sudo mkdir -p /mnt/fedora
sudo mount -o subvol=root /dev/nvme0n1p7 /mnt/fedora
echo -e "${GREEN}✓${NC} Mounted Fedora root"
echo ""

# Backup fstab if not already backed up today
BACKUP_FILE="/mnt/fedora/etc/fstab.backup-efi-$(date +%Y%m%d-%H%M%S)"
echo -e "${BLUE}→${NC} Backing up fstab..."
sudo cp /mnt/fedora/etc/fstab "$BACKUP_FILE"
echo -e "${GREEN}✓${NC} Backup: $BACKUP_FILE"
echo ""

# Show current fstab
echo -e "${BLUE}→${NC} Current /boot/efi entry:"
sudo grep "/boot/efi" /mnt/fedora/etc/fstab
echo ""

# Fix the EFI UUID
echo -e "${BLUE}→${NC} Fixing /boot/efi UUID..."
echo -e "${YELLOW}!${NC} Replacing UUID=3020-44F9"
echo -e "${YELLOW}!${NC} With UUID=1788-AEB3 (actual EFI partition)"

sudo sed -i 's|UUID=3020-44F9|UUID=1788-AEB3|g' /mnt/fedora/etc/fstab

echo -e "${GREEN}✓${NC} Updated fstab"
echo ""

# Show updated fstab
echo -e "${BLUE}→${NC} Updated /boot/efi entry:"
sudo grep "/boot/efi" /mnt/fedora/etc/fstab
echo ""

# Show full fstab
echo -e "${BLUE}→${NC} Complete updated fstab:"
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
echo -e "${GREEN}Next step:${NC} Reboot and try Fedora from GRUB!"
echo -e "This should fix the 'failed dependency' error."
echo ""
