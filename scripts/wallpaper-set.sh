#!/bin/bash
# wallpaper-set.sh - Set wallpaper with optional Arch logo overlay
#
# Usage:
#   wallpaper-set.sh <image>          Set wallpaper (respects logo toggle state)
#   wallpaper-set.sh --toggle-logo    Toggle Arch logo on/off and reapply current wallpaper
#   wallpaper-set.sh --restore        Reapply last wallpaper (used at startup)

set -e

# ── Paths ────────────────────────────────────────────────────────────────────
# Resolve real path even if invoked through a symlink
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
LOGO_SVG="$SCRIPT_DIR/assets/arch-logo.svg"
CACHE_DIR="$HOME/.cache/wallpaper"
COMPOSED_IMG="$CACHE_DIR/composed.png"     # always the latest composed image
COMPOSED_CACHE="$CACHE_DIR/composed-for"  # stores which wallpaper composed.png was built from
LOGO_PNG="$CACHE_DIR/arch-logo.png"
LOGO_STATE="$CACHE_DIR/logo-enabled"   # file exists = logo on
LAST_WALL="$CACHE_DIR/last-wallpaper"  # always the ORIGINAL image path, never composed.png
LAST_COLOR="$CACHE_DIR/last-color"     # cached extracted color
LAST_COLOR_FOR="$CACHE_DIR/last-color-for"  # which wallpaper that color was extracted from

# Logo appearance
LOGO_SIZE_PERCENT=40    # % of wallpaper height
LOGO_OPACITY=60         # 0-100, fill opacity for the logo

# swww transition settings
TRANSITION="grow"
TRANSITION_POS="center"
TRANSITION_FPS=60
TRANSITION_DURATION=1.5

# ── Setup ────────────────────────────────────────────────────────────────────
mkdir -p "$CACHE_DIR"

# ── Helper: extract accent color from image, with caching ────────────────────
get_wallpaper_color() {
    local img="$1"

    # Return cached color if we already extracted it for this exact image
    if [ -f "$LAST_COLOR" ] && [ -f "$LAST_COLOR_FOR" ]; then
        if [ "$(cat "$LAST_COLOR_FOR")" = "$img" ]; then
            cat "$LAST_COLOR"
            return
        fi
    fi

    local color
    color=$(magick "$img" \
        -resize 200x200! \
        +dither -colors 16 \
        -format "%c" histogram:info:- 2>/dev/null \
        | grep -oP '\d+:.*#[0-9A-Fa-f]{6}' \
        | sort -rn \
        | grep -oP '#[0-9A-Fa-f]{6}' \
        | while read -r hex; do
            r=$(printf "%d" "0x${hex:1:2}")
            g=$(printf "%d" "0x${hex:3:2}")
            b=$(printf "%d" "0x${hex:5:2}")
            brightness=$(( (r + g + b) / 3 ))
            if [ "$brightness" -gt 40 ] && [ "$brightness" -lt 210 ]; then
                echo "$hex"
                break
            fi
        done)

    color="${color:-#1793d1}"
    echo "$color" > "$LAST_COLOR"
    echo "$img" > "$LAST_COLOR_FOR"
    echo "$color"
}

# ── Helper: render logo PNG with given color and wallpaper dimensions ─────────
render_logo() {
    local color="$1"
    local wall_w="$2"
    local wall_h="$3"

    local logo_px=$(( wall_h * LOGO_SIZE_PERCENT / 100 ))

    local opacity_decimal
    opacity_decimal=$(awk "BEGIN {printf \"%.2f\", $LOGO_OPACITY/100}")

    sed \
        -e "s/ARCH_COLOR/$color/g" \
        -e "s/ARCH_OPACITY/$opacity_decimal/g" \
        "$LOGO_SVG" > "$CACHE_DIR/arch-logo-colored.svg"

    rsvg-convert \
        -w "$logo_px" -h "$logo_px" \
        --keep-aspect-ratio \
        "$CACHE_DIR/arch-logo-colored.svg" \
        -o "$LOGO_PNG"
}

# ── Helper: composite logo onto wallpaper (cached per wallpaper) ──────────────
composite_logo() {
    local wallpaper="$1"

    # Skip recompositing if composed.png was already built for this exact wallpaper
    if [ -f "$COMPOSED_IMG" ] && [ -f "$COMPOSED_CACHE" ]; then
        if [ "$(cat "$COMPOSED_CACHE")" = "$wallpaper" ]; then
            echo "  Using cached composite" >&2
            return
        fi
    fi

    local dims
    dims=$(magick identify -format "%wx%h" "$wallpaper" 2>/dev/null)
    local wall_w="${dims%x*}"
    local wall_h="${dims#*x}"

    local color
    color=$(get_wallpaper_color "$wallpaper")
    echo "  Logo color: $color" >&2

    render_logo "$color" "$wall_w" "$wall_h"

    magick "$wallpaper" \
        "$LOGO_PNG" \
        -gravity Center \
        -composite \
        "$COMPOSED_IMG"

    echo "$wallpaper" > "$COMPOSED_CACHE"
}

# ── Helper: apply wallpaper via swww ─────────────────────────────────────────
apply_wallpaper() {
    local img="$1"
    swww img "$img" \
        --transition-type "$TRANSITION" \
        --transition-pos "$TRANSITION_POS" \
        --transition-fps "$TRANSITION_FPS" \
        --transition-duration "$TRANSITION_DURATION"
}

# ── Main logic ────────────────────────────────────────────────────────────────

case "${1:-}" in

    --toggle-logo)
        # LAST_WALL always holds the original image — never composed.png
        # This is the only reliable source; swww query would return composed.png when logo is on
        if [ ! -f "$LAST_WALL" ]; then
            echo "No wallpaper set yet." >&2
            exit 1
        fi
        ORIGINAL="$(cat "$LAST_WALL")"
        if [ ! -f "$ORIGINAL" ]; then
            echo "Wallpaper file not found: $ORIGINAL" >&2
            exit 1
        fi

        if [ -f "$LOGO_STATE" ]; then
            rm "$LOGO_STATE"
            echo "Arch logo: OFF" >&2
            apply_wallpaper "$ORIGINAL"
        else
            touch "$LOGO_STATE"
            echo "Arch logo: ON" >&2
            composite_logo "$ORIGINAL"
            apply_wallpaper "$COMPOSED_IMG"
        fi
        ;;

    --restore)
        if [ -f "$LAST_WALL" ]; then
            exec "$0" "$(cat "$LAST_WALL")"
        else
            echo "No previous wallpaper saved." >&2
            exit 1
        fi
        ;;

    --status)
        if [ -f "$LOGO_STATE" ]; then
            echo "logo=on"
        else
            echo "logo=off"
        fi
        [ -f "$LAST_WALL" ] && echo "wallpaper=$(cat "$LAST_WALL")"
        ;;

    "")
        echo "Usage: wallpaper-set.sh <image>"
        echo "       wallpaper-set.sh --toggle-logo"
        echo "       wallpaper-set.sh --restore"
        exit 1
        ;;

    *)
        WALLPAPER="$1"

        if [ ! -f "$WALLPAPER" ]; then
            echo "Error: file not found: $WALLPAPER" >&2
            exit 1
        fi

        # Save original path — must happen BEFORE get_wallpaper_color cache check
        echo "$WALLPAPER" > "$LAST_WALL"

        if [ -f "$LOGO_STATE" ]; then
            composite_logo "$WALLPAPER"
            apply_wallpaper "$COMPOSED_IMG"
        else
            apply_wallpaper "$WALLPAPER"
        fi
        ;;
esac
