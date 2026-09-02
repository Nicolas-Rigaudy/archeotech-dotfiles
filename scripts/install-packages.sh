#!/bin/bash
################################################################################
# install-packages.sh — install the Arch packages this setup needs, split into
# REQUIRED (the compositor + Quickshell shell won't run / core widgets break
# without them) and OPTIONAL (nice-to-have apps, dev tooling, eye-candy).
#
# Usage:
#   ./scripts/install-packages.sh                 # required, then PROMPT for optional
#   ./scripts/install-packages.sh --profile minimal   # required only, no prompt
#   ./scripts/install-packages.sh --profile full      # required + optional, no prompt
#   ./scripts/install-packages.sh --yes               # non-interactive (assume yes)
#   ./scripts/install-packages.sh --dry-run           # print the package sets only
#   ./scripts/install-packages.sh --list              # alias for --dry-run
#
# Profiles:
#   recommended (default) — install required, then ask about optional
#   minimal               — required only
#   full                  — required + optional
#
# Uses paru (AUR helper) so AUR packages (mangowc-git, quickshell-git, …) resolve
# alongside repo packages. Install paru first: see docs/INSTALLATION.md.
################################################################################
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()  { echo -e "${BLUE}::${NC} $1"; }
ok()    { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}!!${NC} $1"; }
err()   { echo -e "${RED}xx${NC} $1" >&2; }

# ── Package sets ─────────────────────────────────────────────────────────────
# REQUIRED: the desktop comes up and the shell's core widgets work. Grouped by
# concern so the split stays legible and easy to re-tune.
REQUIRED=(
    # Compositor + Wayland core
    mangowc-git wayland wayland-protocols wl-clipboard wlr-randr
    # Quickshell shell runtime
    quickshell-git qt6-wayland qt5-wayland qt6ct qt5ct
    # Display manager
    sddm
    # Desktop portals (screen share, file pickers)
    xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    # Launcher + terminal + shell/prompt
    rofi-wayland kitty fish starship
    # Audio (volume OSD + sound)
    pipewire pipewire-pulse pipewire-alsa wireplumber playerctl pavucontrol
    # Network widget
    networkmanager nm-applet
    # Wallpaper daemon
    swww
    # Fonts + icons (design rule: icons everywhere)
    ttf-firacode-nerd noto-fonts noto-fonts-emoji papirus-icon-theme
    # Widget backends (brightness OSD, screenshots)
    brightnessctl grim slurp
    # Lock + idle
    swaylock swayidle
    # Bluetooth widget
    bluez bluez-utils blueman
)

# OPTIONAL: everything that makes the machine nicer but the shell runs without.
OPTIONAL=(
    # Hyprland fallback stack (selectable at SDDM)
    hyprland hyprlock hypridle xdg-desktop-portal-hyprland waybar swaync
    # Clipboard history + colour picker
    cliphist wl-color-picker
    # GUI apps
    zen-browser code obsidian appflowy mpv imv mission-center
    thunar thunar-archive-plugin thunar-volman file-roller gvfs
    zathura zathura-pdf-mupdf
    # Dev tooling
    git github-cli lazygit neovim docker docker-compose
    aws-cli-v2 terraform granted frog
    # Terminal utilities
    bat eza zoxide atuin navi tealdeer thefuck fastfetch btop yazi ncspot
    imagemagick mdcat checkupdates pacman-contrib p7zip unrar unzip
    # Eye-candy / screensavers
    asciiquarium cbonsai cmatrix pipes.sh espanso
    # Extra theming
    catppuccin-gtk-theme-macchiato catppuccin-cursors-macchiato kvantum
    gtk3 gtk4 librsvg sddm-catppuccin-git
    # Btrfs snapshots
    snapper snap-pac grub-btrfs snapper-gui-git
    # Input remap (kanata layers, Logitech HID++)
    kanata logiops
)

# ── Args ─────────────────────────────────────────────────────────────────────
PROFILE="recommended"
DRY_RUN=0
ASSUME_YES=0

while [ $# -gt 0 ]; do
    case "$1" in
        --profile) PROFILE="$2"; shift 2 ;;
        --minimal) PROFILE="minimal"; shift ;;
        --full)    PROFILE="full"; shift ;;
        -y|--yes)  ASSUME_YES=1; shift ;;
        --dry-run|--list) DRY_RUN=1; shift ;;
        -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
        *) err "unknown flag: $1"; exit 2 ;;
    esac
done

case "$PROFILE" in
    minimal|recommended|full) ;;
    *) err "unknown --profile: $PROFILE (want minimal|recommended|full)"; exit 2 ;;
esac

# ── Dry run: just show the sets ──────────────────────────────────────────────
if [ "$DRY_RUN" -eq 1 ]; then
    info "REQUIRED (${#REQUIRED[@]}):"; printf '   %s\n' "${REQUIRED[@]}"
    echo
    info "OPTIONAL (${#OPTIONAL[@]}):"; printf '   %s\n' "${OPTIONAL[@]}"
    echo
    info "profile=$PROFILE would install: required$([ "$PROFILE" = minimal ] || echo ' + optional (full, or if you accept the prompt)')"
    exit 0
fi

# ── Prereq: paru ─────────────────────────────────────────────────────────────
if ! command -v paru &>/dev/null; then
    err "paru (AUR helper) is not installed — it is required for AUR packages."
    echo "   Install it first (see docs/INSTALLATION.md), e.g.:"
    echo "     sudo pacman -S --needed base-devel git"
    echo "     git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si"
    exit 1
fi

# --needed skips already-installed packages so re-runs are cheap and idempotent.
install_set() {
    local title="$1"; shift
    ok "Installing $title (${#} packages)…"
    paru -S --needed "$@"
}

# ── Required (always) ────────────────────────────────────────────────────────
install_set "REQUIRED packages" "${REQUIRED[@]}"

# ── Optional (by profile / prompt) ───────────────────────────────────────────
install_optional=0
case "$PROFILE" in
    minimal)     install_optional=0 ;;
    full)        install_optional=1 ;;
    recommended)
        if [ "$ASSUME_YES" -eq 1 ]; then
            install_optional=1
        else
            echo
            info "Optional packages (${#OPTIONAL[@]}): Hyprland fallback, apps, dev tools, eye-candy."
            read -r -p "$(echo -e "${YELLOW}??${NC}") Install optional packages too? [y/N] " reply
            [[ "$reply" =~ ^[Yy]$ ]] && install_optional=1
        fi
        ;;
esac

if [ "$install_optional" -eq 1 ]; then
    install_set "OPTIONAL packages" "${OPTIONAL[@]}"
else
    info "Skipping optional packages (profile=$PROFILE). Re-run with --profile full to add them."
fi

ok "Package installation complete (profile=$PROFILE)."
