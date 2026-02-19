#!/bin/bash
# Update system-level configs from dotfiles repo
# Use this to deploy changes after editing files in system/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Updating system configs from dotfiles..."

# Snapper config
if [ -f "$DOTFILES_DIR/system/etc/snapper/configs/root" ]; then
    echo "  → /etc/snapper/configs/root"
    sudo cp "$DOTFILES_DIR/system/etc/snapper/configs/root" /etc/snapper/configs/root
    sudo chmod 640 /etc/snapper/configs/root
    sudo chown root:root /etc/snapper/configs/root
fi

# SDDM config (login screen theme)
if [ -f "$DOTFILES_DIR/system/etc/sddm.conf" ]; then
    echo "  → /etc/sddm.conf (Catppuccin theme)"
    sudo cp "$DOTFILES_DIR/system/etc/sddm.conf" /etc/sddm.conf
    sudo chmod 644 /etc/sddm.conf
    sudo chown root:root /etc/sddm.conf
fi

# GRUB custom entries (Fedora dual-boot)
if [ -f "$DOTFILES_DIR/system/etc/grub.d/40_custom" ]; then
    echo "  → /etc/grub.d/40_custom (Fedora boot entries)"
    sudo cp "$DOTFILES_DIR/system/etc/grub.d/40_custom" /etc/grub.d/40_custom
    sudo chmod 755 /etc/grub.d/40_custom
    sudo chown root:root /etc/grub.d/40_custom
    echo "  → Regenerating GRUB config..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Done!"
