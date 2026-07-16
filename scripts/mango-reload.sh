#!/bin/bash
# mango-reload.sh — Full shell + compositor reload (Super+Shift+R)
#
# Restarts Quickshell AND reloads the MangoWC config, re-applying the monitor
# layout (MangoWC's reload resets monitor modes). A full shell restart (not just
# QML hot-reload) is what makes this a real "reload to test" — it re-runs
# singletons and one-time scans that a live hot-reload won't pick up.
#
# Order matters: kill first, reload config, fix monitors, then relaunch the
# shell LAST — so it lays out its layer-shell panels against the FINAL display
# scale (relaunching before wlr-randr caused pixelated/janky panels). The
# relaunch matches the exec-once launcher (`-c archeotech`, no decorations).
#
# Usage: mango-reload.sh    Keybind: Super+Shift+R

set -e

# Stop the shell first. Kill by config name — robust whether it was launched as
# `qs` or `quickshell` (their process names differ, so `pkill -x quickshell`
# alone misses a `qs`-started instance).
qs -c archeotech kill 2>/dev/null || pkill -x quickshell 2>/dev/null || pkill -x qs 2>/dev/null || true

# Reload MangoWC config
mmsg -s -d reload_config

# Give MangoWC a moment to re-initialize outputs after reload
sleep 0.5

# Re-apply monitor layout (best-effort — must never abort the relaunch below).
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

# Relaunch the shell LAST — only after the monitor layout is final.
sleep 0.3
env QT_WAYLAND_DECORATION=none quickshell -c archeotech &
