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

echo "Done!"
