#!/bin/bash
# Update system-level configs from dotfiles repo
# Use this to deploy changes after editing files in system/
# Run directly — will re-exec with sudo if needed (one password prompt).

set -e

# Re-exec as root if not already
if [ "$EUID" -ne 0 ]; then
    exec sudo DOTFILES_REAL_USER="$USER" "$0" "$@"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Updating system configs from dotfiles..."

# Snapper config
if [ -f "$DOTFILES_DIR/system/etc/snapper/configs/root" ]; then
    echo "  → /etc/snapper/configs/root"
    cp "$DOTFILES_DIR/system/etc/snapper/configs/root" /etc/snapper/configs/root
    chmod 640 /etc/snapper/configs/root
    chown root:root /etc/snapper/configs/root
fi

# SDDM config (login screen theme)
if [ -f "$DOTFILES_DIR/system/etc/sddm.conf" ]; then
    echo "  → /etc/sddm.conf"
    cp "$DOTFILES_DIR/system/etc/sddm.conf" /etc/sddm.conf
    chmod 644 /etc/sddm.conf
    chown root:root /etc/sddm.conf
fi

# GRUB custom entries (Fedora dual-boot)
if [ -f "$DOTFILES_DIR/system/etc/grub.d/40_custom" ]; then
    echo "  → /etc/grub.d/40_custom"
    cp "$DOTFILES_DIR/system/etc/grub.d/40_custom" /etc/grub.d/40_custom
    chmod 755 /etc/grub.d/40_custom
    chown root:root /etc/grub.d/40_custom
    echo "  → Regenerating GRUB config..."
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# SDDM Catppuccin theme - Arch logo background
SDDM_THEME_DIR="/usr/share/sddm/themes/catppuccin"
SDDM_BG="$SDDM_THEME_DIR/backgrounds/flatppuccin_macchiato.png"
ARCH_SVG="$DOTFILES_DIR/scripts/assets/arch-logo.svg"
if [ -f "$ARCH_SVG" ] && [ -d "$SDDM_THEME_DIR" ]; then
    echo "  → Generating SDDM Arch logo background..."
    TMPDIR=$(mktemp -d)
    sed 's/LOGO_COLOR/#c6a0f6/g; s/LOGO_OPACITY/1.0/g' "$ARCH_SVG" \
        | rsvg-convert -w 800 -h 800 -o "$TMPDIR/arch-logo-rendered.png"
    python3 - "$TMPDIR" <<'PYEOF'
import sys
from PIL import Image
tmpdir = sys.argv[1]
bg = Image.new("RGB", (3840, 2160), (36, 39, 58))
logo = Image.open(f"{tmpdir}/arch-logo-rendered.png").convert("RGBA")
x = (3840 - logo.width) // 2
y = (2160 - logo.height) // 2
bg.paste(logo, (x, y), logo)
bg.save(f"{tmpdir}/arch-sddm-bg.png")
PYEOF
    [ -f "$SDDM_BG" ] && cp "$SDDM_BG" "${SDDM_BG}.bak"
    cp "$TMPDIR/arch-sddm-bg.png" "$SDDM_BG"
    rm -rf "$TMPDIR"
    chmod 644 "$SDDM_BG"
    echo "  → $SDDM_BG"
fi

# SDDM Catppuccin theme - disable password character reveal
PASSWD_QML="$SDDM_THEME_DIR/components/PasswordPanel.qml"
if [ -f "$PASSWD_QML" ]; then
    echo "  → Disabling password character reveal in SDDM theme..."
    sed -i 's/passwordMaskDelay: [0-9]*/passwordMaskDelay: 0/' "$PASSWD_QML"
    echo "  → $PASSWD_QML"
fi

echo "Done!"
