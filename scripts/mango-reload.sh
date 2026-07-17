#!/bin/bash
# mango-reload.sh — Full shell + compositor reload (Super+Shift+R)
#
# Restarts Quickshell AND reloads the MangoWC config, re-applying the monitor
# layout and keyboard layout (MangoWC's reload resets both). A full shell restart
# (not just QML hot-reload) is what makes this a real "reload to test" — it
# re-runs singletons and one-time scans that a live hot-reload won't pick up.
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

# Remember the active keyboard layout — reload_config re-reads xkb config and
# resets it to the default (first in xkb_rules_layout), silently switching it
# out from under you mid-session. Restored after the reload settles (below).
PREV_KB=$(mmsg -g -k 2>/dev/null | head -1 | awk '{print $3}')

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

# Restore the keyboard layout from before the reload. MangoWC has no "set layout
# by name", so cycle switch_keyboard_layout until the active one matches again —
# order-independent, and a no-op if the reload didn't change it. Capped so a
# never-matching name (e.g. config edit) can't loop forever.
if [ -n "$PREV_KB" ]; then
    for _ in $(seq 1 8); do
        [ "$(mmsg -g -k 2>/dev/null | head -1 | awk '{print $3}')" = "$PREV_KB" ] && break
        mmsg -s -d switch_keyboard_layout 2>/dev/null
        sleep 0.1
    done
fi

# Relaunch the shell LAST — only after the monitor layout is final.
sleep 0.3
env QT_WAYLAND_DECORATION=none quickshell -c archeotech &
