#!/bin/bash
################################################################################
# install.sh - Deploy dotfiles using GNU Stow
################################################################################
#
# This script uses GNU Stow to create symlinks from ~/.config to the dotfiles
# repository. This means:
#   - Editing ~/.config/hypr/hyprland.conf edits the repo file directly
#   - Changes are automatically tracked by git
#   - Single source of truth (the repo)
#
# Usage:
#   ./scripts/install.sh          # Deploy all configs
#   ./scripts/install.sh --dry-run # Show what would be done
#
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory and dotfiles root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

################################################################################
# Functions
################################################################################

print_header() {
    echo -e "${BLUE}${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}${NC}"
}

print_success() {
    echo -e "${GREEN}${NC} $1"
}

print_error() {
    echo -e "${RED}${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}�${NC} $1"
}

print_info() {
    echo -e "${BLUE}9${NC} $1"
}

check_requirements() {
    print_header "Checking Requirements"

    # Check if stow is installed
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow is not installed"
        echo ""
        echo "Please install it with:"
        echo "  sudo pacman -S stow"
        exit 1
    fi
    print_success "GNU Stow is installed"

    # Check if we're in the right directory
    if [[ ! -d "$DOTFILES_DIR/config" ]]; then
        print_error "Config directory not found at $DOTFILES_DIR/config"
        exit 1
    fi
    print_success "Dotfiles directory structure is valid"
}

backup_existing_configs() {
    print_header "Backing Up Existing Configs"

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

    # List of directories/files to backup
    CONFIGS=(
        "hypr"
        "waybar"
        "kitty"
        "rofi"
        "fish"
        "starship.toml"
        "btop"
        "yazi"
        "gtk-3.0"
        "gtk-4.0"
        "dunst"
        "mango"
    )

    BACKED_UP=0

    for config in "${CONFIGS[@]}"; do
        if [[ -e "$HOME/.config/$config" ]] && [[ ! -L "$HOME/.config/$config" ]]; then
            # Only backup if it exists and is NOT already a symlink
            mkdir -p "$BACKUP_DIR"
            mv "$HOME/.config/$config" "$BACKUP_DIR/"
            print_success "Backed up: $config"
            BACKED_UP=1
        fi
    done

    if [[ $BACKED_UP -eq 1 ]]; then
        print_info "Backup saved to: $BACKUP_DIR"
    else
        print_info "No configs to backup (already using symlinks or don't exist)"
    fi
}

deploy_with_stow() {
    print_header "Deploying Configs with Stow"

    cd "$DOTFILES_DIR"

    if [[ "$1" == "--dry-run" ]]; then
        print_info "DRY RUN - Showing what would be done:"
        stow -n -v -t ~ config
    else
        stow -v -t ~ config
        print_success "Symlinks created successfully"
    fi
}

verify_deployment() {
    print_header "Verifying Deployment"

    # Check some critical symlinks
    CRITICAL_CONFIGS=(
        "hypr"
        "waybar"
        "kitty"
        "fish"
        "mango"
    )

    ALL_OK=1
    for config in "${CRITICAL_CONFIGS[@]}"; do
        if [[ -L "$HOME/.config/$config" ]]; then
            TARGET=$(readlink "$HOME/.config/$config")
            print_success "$config � $(basename "$TARGET")"
        else
            print_error "$config is not a symlink!"
            ALL_OK=0
        fi
    done

    if [[ $ALL_OK -eq 1 ]]; then
        echo ""
        print_success "All critical configs are properly symlinked!"
    else
        echo ""
        print_error "Some configs are not properly symlinked"
        exit 1
    fi
}

show_usage() {
    print_header "Dotfiles Deployed Successfully!"

    echo ""
    echo "Your configs are now managed by this repository."
    echo ""
    echo "Key points:"
    echo "  " Editing ~/.config/hypr/hyprland.conf edits the repo file"
    echo "  " Changes are automatically tracked by git"
    echo "  " Commit changes: cd $DOTFILES_DIR && git add . && git commit"
    echo ""
    echo "To uninstall (remove symlinks):"
    echo "  ./scripts/uninstall.sh"
    echo ""
}

################################################################################
# Main
################################################################################

print_header "Archeotech Dotfiles - Installation"
echo ""

# Parse arguments
DRY_RUN=""
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
    print_warning "DRY RUN MODE - No changes will be made"
    echo ""
fi

check_requirements

if [[ -z "$DRY_RUN" ]]; then
    backup_existing_configs
fi

deploy_with_stow "$DRY_RUN"

if [[ -z "$DRY_RUN" ]]; then
    verify_deployment
    show_usage
fi

print_success "Done!"
