#!/bin/bash
################################################################################
# Fix GRUB Fedora Boot + Install Catppuccin SDDM Theme
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

################################################################################
# Part 1: Fix GRUB Fedora Boot
################################################################################

fix_grub() {
    print_header "Fixing GRUB Fedora Boot Entry"

    print_info "Mounting Fedora partition to check if it's accessible..."

    # Create mount point
    sudo mkdir -p /mnt/fedora

    # Try to mount Fedora partition
    if sudo mount /dev/nvme0n1p7 /mnt/fedora 2>/dev/null; then
        print_success "Fedora partition mounted successfully"
        sudo umount /mnt/fedora
    else
        print_error "Fedora partition has btrfs device size mismatch"
        print_info "Fixing btrfs device size..."
        sudo btrfs rescue fix-device-size /dev/nvme0n1p7
        print_success "Fixed btrfs device size"
    fi

    print_info "Regenerating GRUB configuration..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    print_success "GRUB configuration updated"
    echo ""
    print_info "Check the output above for 'Found Fedora' to confirm detection"
}

################################################################################
# Part 2: Install Catppuccin SDDM Theme
################################################################################

install_sddm_theme() {
    print_header "Installing Catppuccin SDDM Theme"

    # Check if already installed
    if pacman -Q sddm-catppuccin-git &>/dev/null; then
        print_info "sddm-catppuccin-git already installed"
    else
        print_info "Installing sddm-catppuccin-git from AUR..."
        paru -S --noconfirm sddm-catppuccin-git
        print_success "Installed sddm-catppuccin-git"
    fi

    # List available themes
    print_info "Available Catppuccin SDDM themes:"
    ls -1 /usr/share/sddm/themes/ | grep -i catppuccin || echo "No themes found yet"
}

configure_sddm() {
    print_header "Configuring SDDM with Catppuccin Macchiato"

    print_info "Current SDDM config:"
    cat /etc/sddm.conf 2>/dev/null || echo "No config file found"
    echo ""

    print_info "Creating SDDM configuration..."

    # Backup existing config
    if [ -f /etc/sddm.conf ]; then
        sudo cp /etc/sddm.conf /etc/sddm.conf.backup
        print_success "Backed up existing config to /etc/sddm.conf.backup"
    fi

    # Create new config
    sudo tee /etc/sddm.conf > /dev/null <<EOF
[Theme]
Current=catppuccin-macchiato
CursorTheme=catppuccin-macchiato-dark-cursors

[General]
Numlock=on
EOF

    print_success "SDDM configured with Catppuccin Macchiato theme"
    print_info "Theme will apply on next reboot"
}

################################################################################
# Main
################################################################################

print_header "GRUB + SDDM Fix Script"
echo ""

# Ask user what to fix
echo "What would you like to fix?"
echo "  1) GRUB Fedora boot issue"
echo "  2) Install Catppuccin SDDM theme"
echo "  3) Both"
echo ""
read -p "Choose option (1/2/3): " choice

case $choice in
    1)
        fix_grub
        ;;
    2)
        install_sddm_theme
        configure_sddm
        ;;
    3)
        fix_grub
        echo ""
        install_sddm_theme
        configure_sddm
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
print_header "Done!"
echo ""
print_info "Next steps:"
if [[ $choice == 1 ]] || [[ $choice == 3 ]]; then
    echo "  • Reboot and test Fedora boot from GRUB menu"
fi
if [[ $choice == 2 ]] || [[ $choice == 3 ]]; then
    echo "  • Reboot to see the new SDDM theme"
fi
