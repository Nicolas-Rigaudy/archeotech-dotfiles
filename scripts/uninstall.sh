#!/bin/bash
################################################################################
# uninstall.sh - Remove dotfiles symlinks
################################################################################
#
# This script removes symlinks created by install.sh (using GNU Stow).
# It does NOT delete your configs from the repo, only removes the symlinks.
#
# Usage:
#   ./scripts/uninstall.sh          # Remove all symlinks
#   ./scripts/uninstall.sh --dry-run # Show what would be done
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
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_requirements() {
    print_header "Checking Requirements"

    # Check if stow is installed
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow is not installed"
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

unstow_configs() {
    print_header "Removing Symlinks"

    cd "$DOTFILES_DIR"

    if [[ "$1" == "--dry-run" ]]; then
        print_info "DRY RUN - Showing what would be done:"
        stow -D -n -v -t ~ config
    else
        stow -D -v -t ~ config
        print_success "Symlinks removed successfully"
    fi
}

show_completion() {
    print_header "Uninstall Complete"

    echo ""
    echo "Symlinks have been removed."
    echo ""
    echo "Your configs from the repo are still intact at:"
    echo "  $DOTFILES_DIR/config/.config/"
    echo ""
    echo "If you want to restore them, run:"
    echo "  ./scripts/install.sh"
    echo ""
}

################################################################################
# Main
################################################################################

print_header "Archeotech Dotfiles - Uninstall"
echo ""

# Parse arguments
DRY_RUN=""
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
    print_warning "DRY RUN MODE - No changes will be made"
    echo ""
fi

check_requirements
unstow_configs "$DRY_RUN"

if [[ -z "$DRY_RUN" ]]; then
    show_completion
fi

print_success "Done!"
