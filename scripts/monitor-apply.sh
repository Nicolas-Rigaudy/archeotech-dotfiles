#!/bin/bash
# monitor-apply.sh — Detect connected outputs and apply the matching layout.
#
# Single source of truth for "which monitors are plugged in → what wlr-randr
# layout to use". Called by:
#   - mango-reload.sh          (after a manual config reload)
#   - monitor-hotplug.sh       (automatically, on every output change)
#
# Detection uses `wlr-randr`, which lists exactly the CONNECTED outputs,
# independent of focus. NB: do NOT use `mmsg get all-monitors | select(.active)`
# — in MangoWC `.active` means the *focused* monitor, not connected, so focusing
# the portrait screen looked like a "DP-3 only" topology and mis-applied the
# landscape layout to it (flipping it out of portrait). wlr-randr lists a
# connected output whether or not it is focused, and drops it when unplugged.
#
# Idempotent and best-effort: safe to run repeatedly; never aborts a caller.
#
# Usage: monitor-apply.sh          Apply layout for the currently-connected outputs.

set +e  # best-effort — a wlr-randr hiccup must never abort a caller mid-reload

CONNECTED=$(wlr-randr 2>/dev/null | awk '/^[^[:space:]]/{print $1}')

HAS_HDMI=$(echo "$CONNECTED" | grep -qx "HDMI-A-1" && echo "yes" || echo "no")
HAS_DP3=$(echo "$CONNECTED" | grep -qx "DP-3" && echo "yes" || echo "no")

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
