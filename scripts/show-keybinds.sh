#!/usr/bin/env bash
################################################################################
# SHOW KEYBINDS SCRIPT
# Displays all keybinds for the current compositor (Hyprland or MangoWC)
################################################################################

set -euo pipefail

# Detect which compositor is running
if pgrep -x "Hyprland" > /dev/null; then
    COMPOSITOR="hyprland"
    CONFIG_FILE="$HOME/.config/hypr/hyprland.conf"
elif pgrep -x "mango" > /dev/null || pgrep -x "mangowc" > /dev/null; then
    COMPOSITOR="mango"
    CONFIG_FILE="$HOME/.config/mango/config.conf"
else
    notify-send "Keybinds" "No supported compositor detected (Hyprland or MangoWC)" -u critical
    exit 1
fi

# Create temporary file with formatted keybinds
TEMP_FILE=$(mktemp)
TEMP_RAW=$(mktemp)

# Column width for alignment (increase to add more spacing between keybind and description)
COLUMN_WIDTH=25

# Icons/text for modifier keys
SUPER="󰘳"     # Super key icon
ALT="Alt"     # Alt as text
CTRL="Ctrl"   # Ctrl as text
SHIFT="󰜷"     # Shift icon

# Helper function - use delimiter that column will process
add_bind() {
    echo "  $1|$2" >> "$TEMP_RAW"
}

# Parse keybinds from config file
if [ "$COMPOSITOR" = "hyprland" ]; then
    # Extract Hyprland keybinds
    echo "━━━━━━━━━━━━━━━━━━ HYPRLAND KEYBINDS ━━━━━━━━━━━━━━━━━━" > "$TEMP_RAW"
    echo "" >> "$TEMP_RAW"
    echo "━━━━━━━━━━━━━━━ 󰀻 APPLICATION LAUNCHERS ━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Q" "Terminal (kitty)"
    add_bind "$SUPER + R" "App launcher (rofi)"
    add_bind "$SUPER + B" "Browser (zen-browser)"
    add_bind "$SUPER + E" "Editor (VSCode)"
    add_bind "$SUPER + N" "Notes (Obsidian)"
    add_bind "$SUPER + D" "Directory/File Explorer"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━ 󱂬 WINDOW CONTROLS ━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + C" "Close window"
    add_bind "$SUPER + M" "Exit Hyprland"
    add_bind "$SUPER + F" "Fullscreen"
    add_bind "$SUPER + $SHIFT + Space" "Toggle floating"
    add_bind "$SUPER + T" "Toggle split direction"
    add_bind "$SUPER + $SHIFT + P" "Pseudotile (dwindle)"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━ FOCUS & MOVE ━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Arrows" "Move focus"
    add_bind "$SUPER + $SHIFT + Arrows" "Move window"
    add_bind "$SUPER + $CTRL + Arrows" "Resize window"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━ 󱂪 WORKSPACES ━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + 1-9" "Switch to workspace"
    add_bind "$SUPER + $SHIFT + 1-9" "Move window to workspace"
    add_bind "$SUPER + Tab" "Next workspace"
    add_bind "$SUPER + $SHIFT + Tab" "Previous workspace"
    add_bind "$SUPER + \`" "Toggle scratchpad"
    add_bind "$SUPER + $SHIFT + \`" "Move to scratchpad"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━ 󰹑 SCREENSHOTS & CLIPBOARD ━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + S" "Region screenshot"
    add_bind "$SUPER + P" "Full screenshot"
    add_bind "Print" "Full screenshot"
    add_bind "$SUPER + V" "Clipboard history"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━ SYSTEM & BRIGHTNESS 󰃟 ━━━━━━━━━━━━━━━━"  >> "$TEMP_RAW"
    add_bind "$SUPER + L" "Lock screen"
    add_bind "$SUPER + K" "Show keybinds (this menu)"
    add_bind "Brightness Up/Down" "Adjust screen brightness"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━ 󰕾 AUDIO & MEDIA ━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "Volume Up/Down" "Adjust volume"
    add_bind "Mute" "Toggle mute"
    add_bind "Mic Mute" "Toggle microphone"
    add_bind "Play/Pause" "Play/Pause media"
    add_bind "Next/Previous" "Next/Previous track"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━ Mouse ━━━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Left Click" "Move window"
    add_bind "$SUPER + Right Click" "Resize window"
    add_bind "$SUPER + Scroll" "Switch workspaces"

elif [ "$COMPOSITOR" = "mango" ]; then
    # Extract MangoWC keybinds
    echo "━━━━━━━━━━━━━━━━━━━ MANGOWC KEYBINDS ━━━━━━━━━━━━━━━━━━" > "$TEMP_RAW"
    echo "" >> "$TEMP_RAW"
    echo "━━━━━━━━━━━━━━━ 󰀻 APPLICATION LAUNCHERS ━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Q" "Terminal (kitty)"
    add_bind "$SUPER + R" "App launcher (rofi)"
    add_bind "$SUPER + B" "Browser (zen-browser)"
    add_bind "$SUPER + E" "Editor (VSCode)"
    add_bind "$SUPER + N" "Notes (Obsidian)"
    add_bind "$SUPER + D" "Directory/File Explorer"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━ 󱂬 WINDOW CONTROLS ━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + C" "Close window"
    add_bind "$SUPER + M" "Exit MangoWC"
    add_bind "$SUPER + F" "Fullscreen"
    add_bind "$SUPER + $SHIFT + Space" "Toggle floating"
    add_bind "$SUPER + T" "Toggle split direction"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━ FOCUS & MOVE ━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Arrows" "Move focus"
    add_bind "$SUPER + $SHIFT + Arrows" "Swap window"
    add_bind "$SUPER + $CTRL + Arrows" "Resize window"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━ 󰍹 MONITOR CONTROL ━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + $CTRL + , / ." "Focus monitor left/right"
    add_bind "$SUPER + $CTRL + $SHIFT + Arrows" "Move window to monitor"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━ 󰓹 TAG CONTROL ━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + 1-9" "Switch to tag"
    add_bind "$SUPER + $SHIFT + 1-9" "Move window to tag"
    add_bind "$SUPER + Tab" "Next tag"
    add_bind "$SUPER + $SHIFT + Tab" "Previous tag"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━━━ 󰕰 LAYOUTS ━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Space" "Scroller (horizontal scroll)"
    add_bind "$SUPER + $ALT + Space" "Tile (master-stack)"
    add_bind "$SUPER + $ALT + G" "Grid (auto-tiling)"
    add_bind "$SUPER + $ALT + M" "Monocle (fullscreen)"
    add_bind "$SUPER + $ALT + V" "Vertical scroller"
    add_bind "$SUPER + $ALT + D" "Deck (master + stacked)"
    add_bind "$SUPER + $ALT + S" "Spiral"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━ 󱗜 GAPS ━━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + =" "Increase gaps"
    add_bind "$SUPER + -" "Decrease gaps"
    add_bind "$SUPER + 0" "Toggle gaps"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━ 󰹑 SCREENSHOTS & CLIPBOARD ━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + S" "Region screenshot"
    add_bind "$SUPER + P" "Full screenshot"
    add_bind "Print" "Full screenshot"
    add_bind "$SUPER + V" "Clipboard history"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━ SYSTEM & BRIGHTNESS 󰃟 ━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + L" "Lock screen"
    add_bind "$SUPER + K" "Show keybinds (this menu)"
    add_bind "$SUPER + $SHIFT + R" "Reload config"
    add_bind "Brightness Up/Down" "Adjust screen brightness"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━ 󰕾 AUDIO & MEDIA ━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "Volume Up/Down" "Adjust volume"
    add_bind "Mute" "Toggle mute"
    add_bind "Mic Mute" "Toggle microphone"
    add_bind "Play/Pause" "Play/Pause media"
    add_bind "Next/Previous" "Next/Previous track"
    echo "" >> "$TEMP_RAW"

    echo "━━━━━━━━━━━━━━━━━━━━━━━━ Mouse ━━━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
    add_bind "$SUPER + Left Click" "Move window"
    add_bind "$SUPER + Right Click" "Resize window"
fi

echo "" >> "$TEMP_RAW"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"
echo "  Keyboard Layouts: US/FR ($ALT + $SHIFT to switch)" >> "$TEMP_RAW"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$TEMP_RAW"

# Use awk to align with controlled spacing
awk -F'|' -v width="$COLUMN_WIDTH" '{if (NF == 2) printf "%-"width"s %s\n", $1, $2; else print}' "$TEMP_RAW" > "$TEMP_FILE"

# Display using rofi
rofi -dmenu \
    -p "Keybinds" \
    -mesg "Press Esc to close" \
    -no-cycle \
    -theme-str 'window {width: 630px; height: 750px;}' \
    -theme-str 'listview {lines: 40; scrollbar: true;}' \
    < "$TEMP_FILE"

# Clean up
rm -f "$TEMP_FILE" "$TEMP_RAW"
