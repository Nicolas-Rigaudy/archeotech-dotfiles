#!/bin/bash
# settings-hub.sh — Rofi settings launcher (Super+,)
# One keybind to reach every system setting.
#
# Structure:
#   Main menu → flat list of entries, each launches a tool or opens a submenu
#   Submenus  → Night Light temperatures, Power Profiles
#   Back navigation → submenus return to main menu on Escape or "← Back"
#
# Dependencies: rofi, wlr-randr, wdisplays, pavucontrol, nm-connection-editor,
#               blueman-manager, wlsunset, power-profiles-daemon (powerprofilesctl),
#               wlogout-launch.sh, swaylock-launch.sh, kitty

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/assets/settings-hub.rasi"

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

# ── Display submenu ──────────────────────────────────────────────────────────
# Uses wlr-randr to apply layouts. External monitors are positioned to the right
# of the laptop (eDP-1 always at 0,0). Mirror uses 1920x1080 as common resolution.
# "unknown" external = whatever is currently connected that isn't eDP-1.

display_get_externals() {
    wlr-randr 2>/dev/null | grep "^[^ ]" | grep -v "^eDP-1" | awk '{print $1}'
}

submenu_display() {
    local externals
    externals=$(display_get_externals)
    local ext_count
    ext_count=$(echo "$externals" | grep -c . 2>/dev/null || echo 0)

    local choice
    choice=$(printf '← Back\0icon\x1fgo-previous\n'\
'Extend  (laptop left, external right)\0icon\x1fpreferences-desktop-display\n'\
'Mirror  (same image on all)\0icon\x1fview-fullscreen\n'\
'Laptop only\0icon\x1fcomputer-laptop\n'\
'External only\0icon\x1fvideo-display\n'\
'Adjust…\0icon\x1fpreferences-system\n' \
        | rofi -dmenu \
            -p "Display (${ext_count} external)" \
            -theme "$ROFI_THEME" \
            -show-icons \
            2>/dev/null)

    case "$choice" in
        "← Back") show_main_menu; return ;;
        "Extend  (laptop left, external right)")
            # Laptop at 0,0 — external(s) to the right at x:1920
            wlr-randr --output eDP-1 --on --pos 0,0
            for ext in $externals; do
                wlr-randr --output "$ext" --on --pos 1920,0
            done
            ;;
        "Mirror  (same image on all)")
            # Both outputs at same position, laptop scaled to 1920x1080
            wlr-randr --output eDP-1 --on --mode 1920x1200 --pos 0,0
            for ext in $externals; do
                wlr-randr --output "$ext" --on --pos 0,0
            done
            ;;
        "Laptop only")
            wlr-randr --output eDP-1 --on
            for ext in $externals; do
                wlr-randr --output "$ext" --off
            done
            ;;
        "External only")
            wlr-randr --output eDP-1 --off
            for ext in $externals; do
                wlr-randr --output "$ext" --on --pos 0,0
            done
            ;;
        "Adjust…") wdisplays & ;;
        "") show_main_menu; return ;;  # Escape → back
    esac
}

# ── Night light submenu ───────────────────────────────────────────────────────
submenu_night_light() {
    local status_label="Off"
    night_light_running && status_label="On"

    local choice
    choice=$(printf '← Back\0icon\x1fgo-previous\n'\
'Off\0icon\x1fstock_weather-night-clear\n'\
'Evening  (4500K)\0icon\x1fstock_weather-night-clear\n'\
'Warm     (3500K)\0icon\x1fstock_weather-night-clear\n'\
'Very Warm (2700K)\0icon\x1fstock_weather-night-clear\n' \
        | rofi -dmenu \
            -p "Night Light (${status_label})" \
            -theme "$ROFI_THEME" \
            -show-icons \
            2>/dev/null)

    case "$choice" in
        "← Back")           show_main_menu; return ;;
        "Off")              night_light_stop ;;
        "Evening  (4500K)") night_light_start 4500 ;;
        "Warm     (3500K)") night_light_start 3500 ;;
        "Very Warm (2700K)") night_light_start 2700 ;;
        "")                 show_main_menu; return ;;  # Escape → back
    esac
}

# ── Power profile submenu ─────────────────────────────────────────────────────
submenu_power_profile() {
    local current
    current=$(powerprofilesctl get 2>/dev/null || echo "unknown")

    local choice
    choice=$(printf '← Back\0icon\x1fgo-previous\n'\
'Balanced\0icon\x1fbattery-100-profile-balanced\n'\
'Performance\0icon\x1fbattery-100-profile-performance\n'\
'Power Saver\0icon\x1fbattery-100-profile-powersave\n' \
        | rofi -dmenu \
            -p "Power Profile (${current})" \
            -theme "$ROFI_THEME" \
            -show-icons \
            2>/dev/null)

    case "$choice" in
        "← Back")       show_main_menu; return ;;
        "Balanced")     powerprofilesctl set balanced ;;
        "Performance")  powerprofilesctl set performance ;;
        "Power Saver")  powerprofilesctl set power-saver ;;
        "")             show_main_menu; return ;;  # Escape → back
    esac
}

# ── Focus mode (unfocused monitor dimming) ────────────────────────────────────
# Toggles unfocused_opacity in mango.conf between 0.5 (dim) and 1.0 (full).
# State is read directly from the config file — no separate state file needed.
MANGO_CONF="$HOME/.config/mango/config.conf"

focus_mode_is_on() {
    # "on" means dimming is active (unfocused_opacity < 1.0)
    local val
    val=$(grep -m1 "^unfocused_opacity=" "$MANGO_CONF" | cut -d= -f2)
    [ "$(echo "$val < 1.0" | bc -l)" = "1" ]
}

toggle_focus_mode() {
    if focus_mode_is_on; then
        sed -i 's/^unfocused_opacity=.*/unfocused_opacity=1.0/' "$MANGO_CONF"
    else
        sed -i 's/^unfocused_opacity=.*/unfocused_opacity=0.5/' "$MANGO_CONF"
    fi
    ~/.local/bin/mango-reload.sh
}

# ── Main menu ─────────────────────────────────────────────────────────────────
# Format: "Label\0icon\x1fICON_NAME\n"
# Icons are looked up from the active icon theme (Papirus-Dark)

show_main_menu() {
    local focus_label
    focus_mode_is_on && focus_label="On" || focus_label="Off"

    local choice
    choice=$(printf \
'Display\0icon\x1fpreferences-desktop-display\n'\
'Audio\0icon\x1faudio-volume-high\n'\
'Network\0icon\x1fnetwork-wireless\n'\
'Bluetooth\0icon\x1fbluetooth\n'\
'Wallpaper\0icon\x1fpreferences-desktop-wallpaper\n'\
'Night Light\0icon\x1fstock_weather-night-clear\n'\
'Power Profile\0icon\x1fbattery-100-profile-balanced\n'\
"Focus Mode  (${focus_label})\0icon\x1fview-focus\n"\
'Disk\0icon\x1fdrive-harddisk\n'\
'Power\0icon\x1fsystem-shutdown\n'\
'Lock\0icon\x1fsystem-lock-screen\n' \
        | rofi \
            -dmenu \
            -i \
            -p "⚙" \
            -theme "$ROFI_THEME" \
            -show-icons \
            -format "s" \
            2>/dev/null)

    [ -z "$choice" ] && return

    case "$choice" in
        "Display")        submenu_display ;;
        "Audio")          pavucontrol & ;;
        "Network")        nm-connection-editor & ;;
        "Bluetooth")      blueman-manager & ;;
        "Wallpaper")      ~/.local/bin/wallpaper-picker.sh & ;;
        "Night Light")    submenu_night_light ;;
        "Power Profile")  submenu_power_profile ;;
        "Focus Mode  (On)"|"Focus Mode  (Off)") toggle_focus_mode ;;
        "Disk")           kitty --title "Disk Usage" -e duf & ;;
        "Power")          ~/.local/bin/wlogout-launch.sh & ;;
        "Lock")           ~/.local/bin/swaylock-launch.sh & ;;
    esac
}

# ── Entry point ───────────────────────────────────────────────────────────────
show_main_menu
