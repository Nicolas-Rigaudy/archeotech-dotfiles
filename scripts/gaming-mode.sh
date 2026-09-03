#!/bin/bash
# gaming-mode.sh — Toggle a low-overhead "gaming mode" on MangoWC.
#
# Turns OFF the SceneFX eye-candy that costs GPU/latency — blur, shadows, and
# all window/layer animations — for full-screen games, then restores them.
#
# Mechanism: MangoWC's `setoption` dispatcher writes any config key LIVE, with
# no `reload_config` — so this is instant and has none of the reload
# side-effects (keyboard-layout reset, monitor re-layout). See
#   mmsg dispatch setoption,<key>,<value>
#
# No fake toggle: gaming-ON forces the effect keys to 0; gaming-OFF restores
# each key to the value in config.conf (the single source of truth), so a
# changed default is respected instead of a hardcoded "1". Current mode is
# tracked in a runtime state file since these options are not IPC-readable back.
#
# Usage:
#   gaming-mode.sh            Toggle (default)
#   gaming-mode.sh on         Force gaming mode ON  (effects off)
#   gaming-mode.sh off        Force gaming mode OFF (effects restored)
#   gaming-mode.sh status     Print current mode and exit
#
# Keybind: Super+Shift+G

set -u

CONFIG="$HOME/.config/mango/config.conf"
STATE="${XDG_RUNTIME_DIR:-/tmp}/mango-gaming-mode.state"

# Effect keys we manage. Restore reads each one's default straight from the
# config file, so we never hardcode "the normal value".
KEYS=(blur shadows layer_shadows animations layer_animations)

config_default() {
    # First non-commented `key=value` for $1 in config.conf; empty if absent.
    grep -E "^$1=" "$CONFIG" 2>/dev/null | head -1 | cut -d= -f2- | tr -d '[:space:]'
}

set_opt() { mmsg dispatch "setoption,$1,$2" >/dev/null 2>&1; }

notify() {
    command -v notify-send >/dev/null 2>&1 &&
        notify-send -a "Gaming Mode" -t 2000 "$1" "$2" 2>/dev/null
    return 0
}

gaming_on() {
    for k in "${KEYS[@]}"; do set_opt "$k" 0; done
    echo "on" > "$STATE"
    echo "gaming-mode: ON — blur/shadows/animations disabled" >&2
    notify "󰊴 Gaming mode ON" "Effects disabled for performance"
}

gaming_off() {
    for k in "${KEYS[@]}"; do
        d=$(config_default "$k")
        # Fall back to 1 only if the key is somehow missing from config.
        set_opt "$k" "${d:-1}"
    done
    echo "off" > "$STATE"
    echo "gaming-mode: OFF — effects restored from config.conf" >&2
    notify "󰊴 Gaming mode OFF" "Effects restored"
}

current_mode() { [ -f "$STATE" ] && cat "$STATE" || echo "off"; }

case "${1:-toggle}" in
    on)     gaming_on ;;
    off)    gaming_off ;;
    status) current_mode; exit 0 ;;
    toggle)
        [ "$(current_mode)" = "on" ] && gaming_off || gaming_on ;;
    *)
        echo "usage: gaming-mode.sh [on|off|toggle|status]" >&2; exit 2 ;;
esac
