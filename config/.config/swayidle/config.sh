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

# ── Idle-reset canary (temporary diagnostic) ─────────────────────────────────
# A short 90s idle timeout that ONLY logs — never dims/locks. If "idle-90s"
# lines appear in the canary log while you're actively using the machine, the
# compositor is NOT resetting swayidle's idle timer on input (root cause of the
# "random lock while working"). If the timer resets correctly, you'll only ever
# see it after a genuine 90s pause. Read: cat ~/.cache/swayidle-canary.log
ARGS+=(timeout 90 'printf "%s  idle-90s\n" "$(date "+%F %T")" >> "$HOME/.cache/swayidle-canary.log"'
       resume 'printf "%s  resumed\n"  "$(date "+%F %T")" >> "$HOME/.cache/swayidle-canary.log"')

if [ "$DIM_ENABLED" = "true" ]; then
    ARGS+=(timeout "$DIM_TIMEOUT" 'brightnessctl -s set 10'
           resume 'brightnessctl -r')
fi

if [ "$LOCK_ENABLED" = "true" ]; then
    ARGS+=(timeout "$LOCK_TIMEOUT" 'swaylock-launch.sh idle-timeout')
fi

if [ "$SLEEP_ENABLED" = "true" ]; then
    ARGS+=(timeout "$SLEEP_TIMEOUT" 'wlopm --off \*'
           resume 'wlopm --on \*')
fi

ARGS+=(before-sleep 'swaylock-launch.sh before-sleep')

exec swayidle "${ARGS[@]}"
