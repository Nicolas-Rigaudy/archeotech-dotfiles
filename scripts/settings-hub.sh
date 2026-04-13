#!/bin/bash
# settings-hub.sh — Rofi settings launcher (Super+,)
# One keybind to reach every system setting.
#
# Structure:
#   Main menu → flat list of entries, each launches a tool or opens a submenu
#   Submenus  → Night Light temperatures, Power Profiles
#
# Dependencies: rofi, wdisplays, nwg-look, pavucontrol, nm-connection-editor,
#               blueman-manager, wlsunset, power-profiles-daemon (powerprofilesctl),
#               wlogout, swaylock, kitty

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/assets/settings-hub.rasi"

WLOGOUT_CMD="wlogout -b 5 -c 20 -r 10 -m 20 -L ~/.config/wlogout/layout -C ~/.config/wlogout/style.css"

# ── Night light state ─────────────────────────────────────────────────────────
# wlsunset doesn't have a daemon check built-in; we track it with a pidfile
WLSUNSET_PID="$HOME/.cache/wlsunset.pid"

night_light_running() {
    [ -f "$WLSUNSET_PID" ] && kill -0 "$(cat "$WLSUNSET_PID")" 2>/dev/null
}

night_light_stop() {
    if [ -f "$WLSUNSET_PID" ]; then
        kill "$(cat "$WLSUNSET_PID")" 2>/dev/null
        rm -f "$WLSUNSET_PID"
    fi
    pkill -x wlsunset 2>/dev/null || true
}

night_light_start() {
    local temp="$1"   # e.g. 4500
    night_light_stop
    wlsunset -T "$temp" -t "$temp" &
    echo $! > "$WLSUNSET_PID"
}

# ── Night light submenu ───────────────────────────────────────────────────────
submenu_night_light() {
    local current_label="Off"
    night_light_running && current_label="On"

    local choice
    choice=$(printf "Off\nEvening  (4500K)\nWarm     (3500K)\nVery Warm (2700K)" \
        | rofi -dmenu \
            -p "Night Light" \
            -theme "$ROFI_THEME" \
            -no-show-icons \
            2>/dev/null)

    case "$choice" in
        "Off")              night_light_stop ;;
        "Evening  (4500K)") night_light_start 4500 ;;
        "Warm     (3500K)") night_light_start 3500 ;;
        "Very Warm (2700K)") night_light_start 2700 ;;
    esac
}

# ── Power profile submenu ─────────────────────────────────────────────────────
submenu_power_profile() {
    local current
    current=$(powerprofilesctl get 2>/dev/null || echo "unknown")

    local choice
    choice=$(printf "Balanced\nPerformance\nPower Saver" \
        | rofi -dmenu \
            -p "Power Profile  (current: $current)" \
            -theme "$ROFI_THEME" \
            -no-show-icons \
            2>/dev/null)

    case "$choice" in
        "Balanced")     powerprofilesctl set balanced ;;
        "Performance")  powerprofilesctl set performance ;;
        "Power Saver")  powerprofilesctl set power-saver ;;
    esac
}

# ── Main menu entries ─────────────────────────────────────────────────────────
# Format: "Label\0icon\x1fICON_NAME\n"
# Icons are looked up from the active icon theme (Papirus-Dark)

build_main_menu() {
    printf 'Display\0icon\x1fpreferences-desktop-display\n'
    printf 'Appearance\0icon\x1fpreferences-desktop-theme\n'
    printf 'Audio\0icon\x1faudio-volume-high\n'
    printf 'Network\0icon\x1fnetwork-wireless\n'
    printf 'Bluetooth\0icon\x1fbluetooth\n'
    printf 'Wallpaper\0icon\x1fpreferences-desktop-wallpaper\n'
    printf 'Night Light\0icon\x1fcs-nightlight\n'
    printf 'Power Profile\0icon\x1fdisplay-brightness\n'
    printf 'Disk\0icon\x1fdrive-harddisk\n'
    printf 'Power\0icon\x1fsystem-shutdown\n'
    printf 'Lock\0icon\x1fsystem-lock-screen\n'
}

# ── Main ──────────────────────────────────────────────────────────────────────
CHOICE=$(build_main_menu | rofi \
    -dmenu \
    -i \
    -p "⚙" \
    -theme "$ROFI_THEME" \
    -show-icons \
    -format "s" \
    2>/dev/null)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    "Display")        wdisplays & ;;
    "Appearance")     nwg-look & ;;
    "Audio")          pavucontrol & ;;
    "Network")        nm-connection-editor & ;;
    "Bluetooth")      blueman-manager & ;;
    "Wallpaper")      ~/.local/bin/wallpaper-picker.sh & ;;
    "Night Light")    submenu_night_light ;;
    "Power Profile")  submenu_power_profile ;;
    "Disk")           kitty --title "Disk Usage" -e duf & ;;
    "Power")          eval "$WLOGOUT_CMD" & ;;
    "Lock")           swaylock & ;;
esac
