#!/bin/bash
# mango-reload.sh — Safe MangoWC config reload
#
# MangoWC's built-in reload resets monitor state (positions, rotation, mirroring).
# This script reloads config then immediately re-applies the correct monitor layout
# via wlr-randr so displays snap back to their proper configuration.
#
# Quickshell is intentionally NOT killed/relaunched here. It is a layer-shell
# client that survives a MangoWC config reload and hot-reloads its own QML on
# file change, so a restart is unnecessary — and restarting it from this keybind
# path has caused vanished/degraded shells (the old relaunch even pointed at a
# non-existent ~/.config/quickshell/shell.qml). If a manual restart is ever
# needed: `qs -c archeotech kill; env QT_WAYLAND_DECORATION=none qs -c archeotech &`
#
# Usage: mango-reload.sh
# Keybind: Super+Shift+R (replaces raw reload_config)

set -e

# Reload MangoWC config
mmsg -s -d reload_config

# Give MangoWC a moment to re-initialize outputs after reload
sleep 0.5

# Re-apply monitor layout (best-effort — never abort on a missing output).
set +e

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
