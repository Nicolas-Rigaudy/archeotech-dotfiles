#!/bin/bash
################################################################################
# Diagnose Fedora Boot Issue - Check Btrfs Subvolume Layout
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Fedora Btrfs Diagnostics${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Mount Fedora partition
echo -e "${BLUE}→${NC} Mounting Fedora partition (nvme0n1p7)..."
sudo mkdir -p /mnt/fedora
sudo mount /dev/nvme0n1p7 /mnt/fedora

echo ""
echo -e "${GREEN}✓${NC} Mounted successfully"
echo ""

# List btrfs subvolumes
echo -e "${BLUE}→${NC} Btrfs subvolume layout:"
echo ""
sudo btrfs subvolume list /mnt/fedora

echo ""
echo -e "${BLUE}================================${NC}"
echo ""

# Check for common Fedora subvolume names
echo -e "${BLUE}→${NC} Checking for Fedora root subvolume..."
echo ""

if sudo ls /mnt/fedora/root/ &>/dev/null; then
    echo -e "${GREEN}✓${NC} Found 'root' subvolume"
    echo "  Contents:"
    sudo ls -la /mnt/fedora/root/ | head -20
elif sudo ls /mnt/fedora/home/ &>/dev/null; then
    echo -e "${YELLOW}!${NC} No 'root' subvolume, checking top-level..."
    echo "  Top-level contents:"
    sudo ls -la /mnt/fedora/ | head -20
fi

echo ""
echo -e "${BLUE}================================${NC}"
echo ""

# Check Fedora's fstab
echo -e "${BLUE}→${NC} Checking Fedora's /etc/fstab for subvolume info..."
echo ""

if [ -f /mnt/fedora/root/etc/fstab ]; then
    echo "Reading from /mnt/fedora/root/etc/fstab:"
    sudo cat /mnt/fedora/root/etc/fstab | grep -v "^#" | grep -v "^$"
elif [ -f /mnt/fedora/etc/fstab ]; then
    echo "Reading from /mnt/fedora/etc/fstab:"
    sudo cat /mnt/fedora/etc/fstab | grep -v "^#" | grep -v "^$"
else
    echo -e "${RED}✗${NC} Could not find fstab"
fi

echo ""
echo -e "${BLUE}================================${NC}"
echo ""

# Unmount
echo -e "${BLUE}→${NC} Unmounting..."
sudo umount /mnt/fedora

echo ""
echo -e "${GREEN}✓${NC} Done! Check the output above for:"
echo "  1. Subvolume names (especially the root subvolume)"
echo "  2. The fstab entry showing correct subvolume options"
echo ""
