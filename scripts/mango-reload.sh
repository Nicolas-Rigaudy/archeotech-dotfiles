#!/bin/bash
# mango-reload.sh — Safe MangoWC config reload
#
# MangoWC's built-in reload resets monitor state (positions, rotation, mirroring).
# This script reloads config then immediately re-applies the correct monitor layout
# via wlr-randr so displays snap back to their proper configuration.
#
# Usage: mango-reload.sh
# Keybind: Super+Shift+R (replaces raw reload_config)

set -e

# Kill quickshell before reload so exec-once doesn't spawn a second instance
pkill -x quickshell || true

# Reload MangoWC config
mmsg -s -d reload_config

# Give MangoWC a moment to re-initialize outputs after reload
sleep 0.5

# Re-apply monitor layout
# Detect which outputs are connected and apply rules accordingly
OUTPUTS=$(mmsg -O 2>/dev/null)

HAS_HDMI=$(echo "$OUTPUTS" | grep -q "HDMI-A-1" && echo "yes" || echo "no")
HAS_DP3=$(echo "$OUTPUTS" | grep -q "DP-3" && echo "yes" || echo "no")

if [ "$HAS_HDMI" = "yes" ] && [ "$HAS_DP3" = "yes" ]; then
    # Work desk: 3-monitor layout
    # eDP-1: laptop (left), HDMI-A-1: landscape (middle), DP-3: portrait (right)
    wlr-randr \
        --output eDP-1    --mode 1920x1200 --pos 0,0     --transform normal \
        --output HDMI-A-1 --mode 1920x1080 --pos 1920,60 --transform normal \
        --output DP-3     --mode 1920x1080 --pos 3840,0  --transform 270
elif [ "$HAS_HDMI" = "yes" ]; then
    # Home: laptop + one external landscape
    wlr-randr \
        --output eDP-1    --mode 1920x1200 --pos 0,0     --transform normal \
        --output HDMI-A-1 --mode 1920x1080 --pos 1920,60 --transform normal
elif [ "$HAS_DP3" = "yes" ]; then
    # DP-* fallback (unknown external, landscape)
    wlr-randr \
        --output eDP-1 --mode 1920x1200 --pos 0,0     --transform normal \
        --output DP-3  --mode 1920x1080 --pos 1920,60 --transform normal
else
    # Solo: laptop only
    wlr-randr \
        --output eDP-1 --mode 1920x1200 --pos 0,0 --transform normal
fi
