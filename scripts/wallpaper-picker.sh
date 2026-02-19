#!/bin/bash
# wallpaper-picker.sh - Rofi wallpaper picker with thumbnail previews

WALLPAPER_DIR="$HOME/Projects/archeotech-dotfiles/wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper/thumbs"
WALLPAPER_SET="$HOME/.local/bin/wallpaper-set.sh"
LOGO_STATE="$HOME/.cache/wallpaper/logo-enabled"
SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/assets/wallpaper-picker.rasi"
THUMB_SIZE=300

mkdir -p "$THUMB_DIR"

make_thumb() {
    local src="$1"
    local thumb="$THUMB_DIR/$(basename "$src").jpg"
    if [ ! -f "$thumb" ]; then
        magick "$src" \
            -resize "${THUMB_SIZE}x${THUMB_SIZE}^" \
            -gravity Center -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
            -quality 85 "$thumb" 2>/dev/null
    fi
    echo "$thumb"
}

# Build sorted wallpaper list once — index 0 = logo toggle, 1..N = wallpapers
WALLS=()
while IFS= read -r w; do
    WALLS+=("$w")
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o \
    -iname "*.png" -o -iname "*.webp" \) | sort)

# Build rofi input: logo toggle first, then wallpapers
build_entries() {
    if [ -f "$LOGO_STATE" ]; then
        printf 'Arch Logo  [ON]\0icon\x1f%s\n' "$SCRIPT_DIR/assets/arch-logo.svg"
    else
        printf 'Arch Logo  [OFF]\0icon\x1f%s\n' "$SCRIPT_DIR/assets/arch-logo.svg"
    fi

    for wall in "${WALLS[@]}"; do
        local thumb
        thumb=$(make_thumb "$wall")
        local name
        name=$(basename "$wall" | sed 's/\.[^.]*$//' | tr '_' ' ')
        printf '%s\0icon\x1f%s\n' "$name" "$thumb"
    done
}

# Run rofi, get index of selected item
IDX=$(build_entries | rofi \
    -dmenu \
    -i \
    -p "" \
    -theme "$ROFI_THEME" \
    -show-icons \
    -format "i" \
    2>/dev/null)

# Dismissed
[ -z "$IDX" ] && exit 0

# Index 0 = logo toggle
if [ "$IDX" -eq 0 ]; then
    "$WALLPAPER_SET" --toggle-logo
    exit 0
fi

# Index 1..N = wallpaper (WALLS array is 0-based, rofi index 1 = WALLS[0])
WALL="${WALLS[$((IDX - 1))]}"
[ -f "$WALL" ] && "$WALLPAPER_SET" "$WALL"
