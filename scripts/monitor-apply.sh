#!/bin/bash
# monitor-apply.sh — Detect connected outputs and apply the matching layout.
#
# Single source of truth for "which monitors are plugged in → what wlr-randr
# layout to use". Called by:
#   - mango-reload.sh          (after a manual config reload)
#   - monitor-hotplug.sh       (automatically, on every output change)
#
# Detection uses MangoWC IPC: `mmsg get all-monitors` lists configured monitors
# including disconnected ones (active:false), so we filter by .active — a bare
# name grep would false-positive on an unplugged-but-configured monitor.
#
# Idempotent and best-effort: safe to run repeatedly; never aborts a caller.
#
# Usage: monitor-apply.sh          Apply layout for the currently-active outputs.

set +e  # best-effort — a wlr-randr hiccup must never abort a caller mid-reload

ACTIVE_OUTPUTS=$(mmsg get all-monitors 2>/dev/null | jq -r '.monitors[] | select(.active) | .name' 2>/dev/null)

HAS_HDMI=$(echo "$ACTIVE_OUTPUTS" | grep -qx "HDMI-A-1" && echo "yes" || echo "no")
HAS_DP3=$(echo "$ACTIVE_OUTPUTS" | grep -qx "DP-3" && echo "yes" || echo "no")

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
