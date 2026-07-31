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

# Stop the shell first. Run EVERY kill method unconditionally — the old
# `A || B || C` chain stopped at the first that returned success, so if the IPC
# kill "succeeded" but left another instance alive, the pkill fallbacks never
# ran and each reload relaunched on top of a survivor → duplicate bars stacking.
qs -c archeotech kill 2>/dev/null || true
pkill -x quickshell 2>/dev/null || true
pkill -x qs 2>/dev/null || true

# Wait until every instance is actually gone (cap ~2s) so we never relaunch onto
# a survivor. Breaks as soon as neither process name is running.
for _ in $(seq 1 20); do
    pgrep -x quickshell >/dev/null 2>&1 || pgrep -x qs >/dev/null 2>&1 || break
    sleep 0.1
done

# Remember the active keyboard layout — reload_config re-reads xkb config and
# resets it to the default (first in xkb_rules_layout), silently switching it
# out from under you mid-session. Restored after the reload settles (below).
# mmsg IPC rewrote flags → subcommands in mangowm 0.15 (get/watch/dispatch, JSON out).
PREV_KB=$(mmsg get keyboardlayout 2>/dev/null | jq -r '.layout // empty' 2>/dev/null)

# NB: tiling layout is NOT captured/restored here. It used to be (reload re-applied
# the scroller tagrules and reset it), but those tagrules were dropped from
# config.conf, so reload now preserves the live layout on its own — no restore
# needed, and no reset-then-snap-back stretch.

# Reload MangoWC config
mmsg dispatch reload_config

# Give MangoWC a moment to re-initialize outputs after reload
sleep 0.5

# Re-apply monitor layout (best-effort — must never abort the relaunch below).
set +e

# Detect which outputs are connected and apply rules accordingly. `get all-monitors`
# also lists configured-but-disconnected monitors (active:false), so filter by .active
# — a bare name grep would false-positive on an unplugged monitor.
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

# Restore the keyboard layout from before the reload. MangoWC has no "set layout
# by name", so cycle switch_keyboard_layout until the active one matches again —
# order-independent, and a no-op if the reload didn't change it. Capped so a
# never-matching name (e.g. config edit) can't loop forever.
if [ -n "$PREV_KB" ]; then
    for _ in $(seq 1 8); do
        [ "$(mmsg get keyboardlayout 2>/dev/null | jq -r '.layout // empty' 2>/dev/null)" = "$PREV_KB" ] && break
        mmsg dispatch switch_keyboard_layout 2>/dev/null
        sleep 0.1
    done
fi

# Relaunch the shell LAST — only after the monitor layout is final.
sleep 0.3
env QT_WAYLAND_DECORATION=none quickshell -c archeotech &
