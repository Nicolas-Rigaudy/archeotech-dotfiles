#!/bin/bash
################################################################################
# SWAYIDLE CONFIGURATION
# Idle management for MangoWC
################################################################################
#
# Reads ~/.cache/swayidle.conf for per-action enable/timeout settings.
# Defaults (used when no config file exists):
#   DIM:   enabled, 10 min
#   LOCK:  enabled, 20 min
#   SLEEP: enabled, 30 min
#
# before-sleep always locks regardless of LOCK_ENABLED.
# Called by MangoWC autostart and by the Quickshell control center on changes.
#
################################################################################

# Load user config or apply defaults
DIM_ENABLED=true
DIM_TIMEOUT=600
LOCK_ENABLED=true
LOCK_TIMEOUT=1200
SLEEP_ENABLED=true
SLEEP_TIMEOUT=1800

CONFIG="$HOME/.cache/swayidle.conf"
[ -f "$CONFIG" ] && source "$CONFIG"

# Kill any existing swayidle so we can restart cleanly
pkill -x swayidle 2>/dev/null || true
sleep 0.2

# Build args array conditionally
ARGS=(-w)

if [ "$DIM_ENABLED" = "true" ]; then
    ARGS+=(timeout "$DIM_TIMEOUT" 'brightnessctl -s set 10'
           resume 'brightnessctl -r')
fi

if [ "$LOCK_ENABLED" = "true" ]; then
    ARGS+=(timeout "$LOCK_TIMEOUT" 'swaylock-launch.sh')
fi

if [ "$SLEEP_ENABLED" = "true" ]; then
    ARGS+=(timeout "$SLEEP_TIMEOUT" 'wlopm --off \*'
           resume 'wlopm --on \*')
fi

ARGS+=(before-sleep 'swaylock-launch.sh')

exec swayidle "${ARGS[@]}"
