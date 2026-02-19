#!/bin/bash
# wallpaper-set.sh - Set wallpaper with optional logo overlay
#
# Usage:
#   wallpaper-set.sh <image>                Set wallpaper (respects active logo state)
#   wallpaper-set.sh --toggle-logo <name>   Activate logo by name, or turn off if already active
#   wallpaper-set.sh --toggle-logo          Turn off active logo (legacy toggle for keybind)
#   wallpaper-set.sh --restore              Reapply last wallpaper (used at startup)
#   wallpaper-set.sh --status              Show current wallpaper and logo state
#
# Logo names (defined in LOGOS array below):
#   arch     - Arch Linux crystal (adaptive color)
#   rebel    - Rebel Alliance symbol (adaptive color)
#   imperial - Imperial Aquila (adaptive color, PNG source)

set -e

# ── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
CACHE_DIR="$HOME/.cache/wallpaper"
COMPOSED_IMG="$CACHE_DIR/composed.png"
COMPOSED_CACHE="$CACHE_DIR/composed-for"   # stores "<logo>:<wallpaper>" for cache key
LOGO_STATE="$CACHE_DIR/logo-active"        # contains active logo name, or empty/absent = no logo
LAST_LOGO="$CACHE_DIR/logo-last"           # remembers last active logo for keybind restore
LAST_WALL="$CACHE_DIR/last-wallpaper"
LAST_COLOR="$CACHE_DIR/last-color"
LAST_COLOR_FOR="$CACHE_DIR/last-color-for"

# ── Logo definitions ─────────────────────────────────────────────────────────
# Format: "name:path:type"   type = svg | png
declare -A LOGO_PATH LOGO_TYPE
LOGO_PATH[arch]="$SCRIPT_DIR/assets/arch-logo.svg"
LOGO_TYPE[arch]="svg"
LOGO_PATH[rebel]="$SCRIPT_DIR/assets/rebel-logo.svg"
LOGO_TYPE[rebel]="svg"
LOGO_PATH[imperial]="$SCRIPT_DIR/assets/imperial-logo.svg"
LOGO_TYPE[imperial]="svg"

# ── Appearance ────────────────────────────────────────────────────────────────
LOGO_SIZE_PERCENT=40    # % of wallpaper height
LOGO_OPACITY=60         # 0-100

# ── swww transition settings ─────────────────────────────────────────────────
TRANSITION="grow"
TRANSITION_POS="center"
TRANSITION_FPS=60
TRANSITION_DURATION=1.5

# ── Setup ────────────────────────────────────────────────────────────────────
mkdir -p "$CACHE_DIR"

# ── Helper: get active logo name (empty string if none) ──────────────────────
active_logo() {
    if [ -f "$LOGO_STATE" ]; then
        cat "$LOGO_STATE"
    else
        echo ""
    fi
}

# ── Helper: extract accent color from image, with caching ────────────────────
get_wallpaper_color() {
    local img="$1"

    if [ -f "$LAST_COLOR" ] && [ -f "$LAST_COLOR_FOR" ]; then
        if [ "$(cat "$LAST_COLOR_FOR")" = "$img" ]; then
            cat "$LAST_COLOR"
            return
        fi
    fi

    # Use the existing thumb if available (already small = fast), else scale inline
    local thumb="$HOME/.cache/wallpaper/thumbs/$(basename "$img").jpg"
    local src="${thumb:-$img}"

    local color
    color=$(magick "$src" \
        -resize 50x50! \
        +dither -colors 8 \
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

# ── Helper: render logo PNG for a given logo name, color, and dimensions ─────
render_logo() {
    local logo_name="$1"
    local color="$2"
    local wall_w="$3"
    local wall_h="$4"

    local logo_px=$(( wall_h * LOGO_SIZE_PERCENT / 100 ))
    local logo_type="${LOGO_TYPE[$logo_name]}"
    local logo_src="${LOGO_PATH[$logo_name]}"
    local logo_out="$CACHE_DIR/logo-rendered.png"

    local opacity_decimal
    opacity_decimal=$(awk "BEGIN {printf \"%.2f\", $LOGO_OPACITY/100}")

    local logo_raw="$CACHE_DIR/logo-raw.png"

    if [ "$logo_type" = "svg" ]; then
        # Inject color/opacity placeholders and rasterize
        sed \
            -e "s/LOGO_COLOR/$color/g" \
            -e "s/LOGO_OPACITY/$opacity_decimal/g" \
            "$logo_src" > "$CACHE_DIR/logo-colored.svg"

        rsvg-convert \
            -w "$logo_px" -h "$logo_px" \
            --keep-aspect-ratio \
            "$CACHE_DIR/logo-colored.svg" \
            -o "$logo_raw"

    elif [ "$logo_type" = "png" ]; then
        # Colorize greyscale PNG: tint with extracted color, apply opacity
        local r g b
        r=$(printf "%d" "0x${color:1:2}")
        g=$(printf "%d" "0x${color:3:2}")
        b=$(printf "%d" "0x${color:5:2}")

        magick "$logo_src" \
            -resize "${logo_px}x${logo_px}" \
            -alpha set \
            \( +clone -alpha extract \) \
            -channel RGB \
            -level 0%,100% \
            +channel \
            -fill "$color" \
            -colorize 100 \
            \( -clone 0 -alpha extract \) \
            -compose CopyOpacity -composite \
            -channel Alpha -evaluate multiply "$opacity_decimal" +channel \
            "$logo_raw"
    fi

    # Add shape-hugging drop-shadow (blur only, no dilate — avoids square edges)
    local shadow_blur=$(( logo_px / 20 ))
    magick "$logo_raw" \
        \( +clone \
           -fill black -colorize 100 \
           -channel Alpha -blur 0x${shadow_blur} -evaluate multiply 0.40 +channel \) \
        -reverse -composite \
        "$logo_out"

    echo "$logo_out"
}

# ── Helper: composite logo onto wallpaper (cached per logo+wallpaper combo) ──
composite_logo() {
    local wallpaper="$1"
    local logo_name="$2"

    local cache_key="${logo_name}:${wallpaper}"
    if [ -f "$COMPOSED_IMG" ] && [ -f "$COMPOSED_CACHE" ]; then
        if [ "$(cat "$COMPOSED_CACHE")" = "$cache_key" ]; then
            echo "  Using cached composite" >&2
            return
        fi
    fi

    # Always compose at 1920x1080 — swww scales to screen, and this is ~5x faster
    # than compositing onto multi-megapixel source images
    local wall_w=1920
    local wall_h=1080

    local color
    color=$(get_wallpaper_color "$wallpaper")
    echo "  Logo color: $color" >&2

    local logo_png
    logo_png=$(render_logo "$logo_name" "$color" "$wall_w" "$wall_h")

    magick \
        \( "$wallpaper" -resize "${wall_w}x${wall_h}^" -gravity Center -extent "${wall_w}x${wall_h}" \) \
        \( "$logo_png" \) \
        -gravity Center -composite \
        "$COMPOSED_IMG"

    echo "$cache_key" > "$COMPOSED_CACHE"
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
        # Arg 2: logo name. No arg = toggle last active (on if off, off if on).
        REQUESTED="${2:-}"

        if [ ! -f "$LAST_WALL" ]; then
            echo "No wallpaper set yet." >&2
            exit 1
        fi
        ORIGINAL="$(cat "$LAST_WALL")"
        if [ ! -f "$ORIGINAL" ]; then
            echo "Wallpaper file not found: $ORIGINAL" >&2
            exit 1
        fi

        CURRENT="$(active_logo)"

        if [ -n "$REQUESTED" ] && [ "${LOGO_PATH[$REQUESTED]+set}" != "set" ]; then
            echo "Unknown logo: $REQUESTED" >&2
            echo "Available: ${!LOGO_PATH[*]}" >&2
            exit 1
        fi

        # No arg: if a logo is on → turn off; if off → restore last used logo
        if [ -z "$REQUESTED" ]; then
            if [ -n "$CURRENT" ]; then
                REQUESTED=""  # fall through to turn-off branch below
            elif [ -f "$LAST_LOGO" ]; then
                REQUESTED="$(cat "$LAST_LOGO")"
            fi
        fi

        if [ -z "$REQUESTED" ] || [ "$CURRENT" = "$REQUESTED" ]; then
            # Turn off
            rm -f "$LOGO_STATE"
            echo "Logo: OFF" >&2
            apply_wallpaper "$ORIGINAL"
        else
            # Activate logo, remember it as last used
            echo "$REQUESTED" > "$LOGO_STATE"
            echo "$REQUESTED" > "$LAST_LOGO"
            echo "Logo: $REQUESTED ON" >&2
            composite_logo "$ORIGINAL" "$REQUESTED"
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
        CURRENT="$(active_logo)"
        if [ -n "$CURRENT" ]; then
            echo "logo=$CURRENT"
        else
            echo "logo=off"
        fi
        [ -f "$LAST_WALL" ] && echo "wallpaper=$(cat "$LAST_WALL")"
        ;;

    "")
        echo "Usage: wallpaper-set.sh <image>"
        echo "       wallpaper-set.sh --toggle-logo [arch|rebel|imperial]"
        echo "       wallpaper-set.sh --restore"
        echo "       wallpaper-set.sh --status"
        exit 1
        ;;

    *)
        WALLPAPER="$1"

        if [ ! -f "$WALLPAPER" ]; then
            echo "Error: file not found: $WALLPAPER" >&2
            exit 1
        fi

        echo "$WALLPAPER" > "$LAST_WALL"

        CURRENT="$(active_logo)"
        if [ -n "$CURRENT" ]; then
            composite_logo "$WALLPAPER" "$CURRENT"
            apply_wallpaper "$COMPOSED_IMG"
        else
            apply_wallpaper "$WALLPAPER"
        fi
        ;;
esac
