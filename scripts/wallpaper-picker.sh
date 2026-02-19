#!/bin/bash
# wallpaper-picker.sh - Rofi wallpaper picker with thumbnail previews and logo selector

WALLPAPER_DIR="$HOME/Projects/archeotech-dotfiles/wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper/thumbs"
WALLPAPER_SET="$HOME/.local/bin/wallpaper-set.sh"
LOGO_STATE="$HOME/.cache/wallpaper/logo-active"
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/assets/wallpaper-picker.rasi"
THUMB_W=260
THUMB_H=260  # square
# Catppuccin Mauve — used for logo preview icons in the picker
LOGO_PREVIEW_COLOR="#c6a0f6"
LOGO_PREVIEW_OPACITY="0.90"

# ── Logo definitions (name : display label) ───────────────────────────────────
# Order determines order in picker. Add new logos here.
# Icons are auto-generated preview PNGs stored in THUMB_DIR.
LOGO_NAMES=("arch" "rebel" "imperial")
LOGO_LABELS=("Arch Linux" "Rebel Alliance" "Imperial Aquila")

mkdir -p "$THUMB_DIR"

make_thumb() {
    local src="$1"
    local thumb="$THUMB_DIR/$(basename "$src").jpg"
    if [ ! -f "$thumb" ]; then
        magick "$src" \
            -resize "${THUMB_W}x${THUMB_H}^" \
            -gravity Center -extent "${THUMB_W}x${THUMB_H}" \
            -quality 85 "$thumb" 2>/dev/null
    fi
    echo "$thumb"
}

# Generate a preview PNG for a logo (Catppuccin Mauve on dark bg tile, cached)
make_logo_preview() {
    local name="$1"
    local preview="$THUMB_DIR/logo-preview-${name}.png"
    if [ ! -f "$preview" ]; then
        sed \
            -e "s/LOGO_COLOR/$LOGO_PREVIEW_COLOR/g" \
            -e "s/LOGO_OPACITY/$LOGO_PREVIEW_OPACITY/g" \
            "$SCRIPT_DIR/assets/${name}-logo.svg" \
            > "/tmp/logo-preview-${name}.svg"
        # Render SVG then composite onto dark surface tile (same size as wallpaper thumbs)
        rsvg-convert -w 180 -h 180 --keep-aspect-ratio \
            "/tmp/logo-preview-${name}.svg" -o "$preview" 2>/dev/null
    fi
    echo "$preview"
}

# Get currently active logo name (empty if none)
active_logo() {
    if [ -f "$LOGO_STATE" ]; then
        cat "$LOGO_STATE"
    else
        echo ""
    fi
}

# Build sorted wallpaper list
WALLS=()
while IFS= read -r w; do
    WALLS+=("$w")
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o \
    -iname "*.png" -o -iname "*.webp" \) | sort)

# Count logo entries so we can map rofi index → action
NUM_LOGOS=${#LOGO_NAMES[@]}

# Build rofi input: logos first, then wallpapers
build_entries() {
    local current
    current=$(active_logo)

    for i in "${!LOGO_NAMES[@]}"; do
        local name="${LOGO_NAMES[$i]}"
        local label="${LOGO_LABELS[$i]}"
        local icon
        icon=$(make_logo_preview "$name")
        printf '%s\0icon\x1f%s\n' "$label" "$icon"
    done

    for wall in "${WALLS[@]}"; do
        local thumb
        thumb=$(make_thumb "$wall")
        local name
        name=$(basename "$wall" | sed 's/\.[^.]*$//' | tr '_' ' ')
        printf '%s\0icon\x1f%s\n' "$name" "$thumb"
    done
}

# Build -urgent list: active logo index + active wallpaper index (if any)
URGENT_INDICES=()
CURRENT_LOGO=$(active_logo)
LAST_WALL_FILE="$HOME/.cache/wallpaper/last-wallpaper"

# Active logo → urgent
for i in "${!LOGO_NAMES[@]}"; do
    if [ "${LOGO_NAMES[$i]}" = "$CURRENT_LOGO" ]; then
        URGENT_INDICES+=("$i")
    fi
done

# Active wallpaper → urgent
if [ -f "$LAST_WALL_FILE" ]; then
    LAST_WALL=$(cat "$LAST_WALL_FILE")
    for i in "${!WALLS[@]}"; do
        if [ "${WALLS[$i]}" = "$LAST_WALL" ]; then
            URGENT_INDICES+=("$(( i + NUM_LOGOS ))")
        fi
    done
fi

URGENT_ARG=""
if [ ${#URGENT_INDICES[@]} -gt 0 ]; then
    URGENT_ARG=$(IFS=,; echo "${URGENT_INDICES[*]}")
fi

# Run rofi, get index of selected item
IDX=$(build_entries | rofi \
    -dmenu \
    -i \
    -p "" \
    -theme "$ROFI_THEME" \
    -show-icons \
    -format "i" \
    ${URGENT_ARG:+-a "$URGENT_ARG"} \
    2>/dev/null)

# Dismissed
[ -z "$IDX" ] && exit 0

# Index 0..NUM_LOGOS-1 = logo toggles
if [ "$IDX" -lt "$NUM_LOGOS" ]; then
    LOGO_NAME="${LOGO_NAMES[$IDX]}"
    "$WALLPAPER_SET" --toggle-logo "$LOGO_NAME"
    exit 0
fi

# Index NUM_LOGOS..N = wallpapers (WALLS array is 0-based)
WALL_IDX=$(( IDX - NUM_LOGOS ))
WALL="${WALLS[$WALL_IDX]}"
[ -f "$WALL" ] && "$WALLPAPER_SET" "$WALL"
