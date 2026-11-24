#!/bin/bash
# presentation-mode.sh — Programs open fully opaque (no wallpaper showing
# through them) while presenting / screen-sharing, then back to glass.
#
# MangoWC copies focused_opacity / unfocused_opacity (and window_rule opacity)
# into each window when it MAPS and never re-applies them: reload_config and
# setoption only reach windows opened afterwards (mango.c client init;
# reset_option has no window-rule reapply). So this mode affects programs you
# open (or reopen) after turning it on. It is also why zen-opacity-toggle.sh
# never had a visible effect on the open Zen window.
#
# Live, no config file edited:
#   - mango focused/unfocused_opacity -> 1.0: every program opened from now on
#     maps opaque (LibreOffice, browsers, ...).
#   - kitty -> background_opacity 1 on every instance, including open ones
#     (kitty draws its own transparency and switches live over its socket).
# OFF restores mango's values from mango/config.conf and kitty's from
# kitty/current-theme.conf (no hardcoded defaults). Windows opened while the
# mode was on stay opaque until reopened.
#
# Usage:
#   presentation-mode.sh            Toggle (default)
#   presentation-mode.sh on|off     Force a state
#   presentation-mode.sh status     Print current mode
#
# Keybind: Super+Shift+O

set -u

MANGO_CONF="$HOME/.config/mango/config.conf"
KITTY_THEME="$HOME/.config/kitty/current-theme.conf"
STATE="${XDG_RUNTIME_DIR:-/tmp}/presentation-mode.state"
RT="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

conf_value() {   # first uncommented `key=value` in mango config.conf
    grep -E "^$1=" "$MANGO_CONF" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '[:space:]'
}

set_opt() { mmsg dispatch "setoption,$1,$2" >/dev/null 2>&1; }

kitty_opacity() {
    local sock
    for sock in "$RT"/kitty-*; do
        [ -S "$sock" ] || continue
        timeout 3 kitty @ --to "unix:$sock" set-background-opacity --all "$1" >/dev/null 2>&1 || true
    done
}

kitty_default_opacity() {
    local v
    v=$(grep -E '^background_opacity' "$KITTY_THEME" 2>/dev/null | head -1 | awk '{print $2}')
    echo "${v:-1}"
}

notify() {
    command -v notify-send >/dev/null 2>&1 &&
        notify-send -a "Presentation" -t 2000 "$1" "$2" 2>/dev/null
    return 0
}

present_on() {
    kitty_opacity 1
    set_opt focused_opacity 1.0
    set_opt unfocused_opacity 1.0
    echo "on" > "$STATE"
    notify "󰐯 Presentation mode ON" "Programs you open now are opaque (reopen open ones)"
}

present_off() {
    kitty_opacity "$(kitty_default_opacity)"
    set_opt focused_opacity "$(conf_value focused_opacity)"
    set_opt unfocused_opacity "$(conf_value unfocused_opacity)"
    echo "off" > "$STATE"
    notify "󰐯 Presentation mode OFF" "New programs open with glass again"
}

current_mode() { [ -f "$STATE" ] && cat "$STATE" || echo "off"; }

case "${1:-toggle}" in
    on)     present_on ;;
    off)    present_off ;;
    status) current_mode ;;
    toggle) if [ "$(current_mode)" = "on" ]; then present_off; else present_on; fi ;;
    *)      echo "usage: presentation-mode.sh [on|off|toggle|status]" >&2; exit 2 ;;
esac
