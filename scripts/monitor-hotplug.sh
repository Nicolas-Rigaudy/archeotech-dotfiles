#!/bin/bash
# monitor-hotplug.sh — Auto-apply the monitor layout when outputs change.
#
# MangoWC applies `monitorrule=` entries when it first sees an output, but it
# does NOT re-run the full wlr-randr positioning/transform layout on hotplug —
# so docking/undocking mid-session left monitors mispositioned until a manual
# Super+Shift+R. This daemon closes that gap: it streams `mmsg watch
# all-monitors` and re-applies the layout (via monitor-apply.sh, the same logic
# mango-reload.sh uses) every time the active-output set changes.
#
# Started once from the MangoWC autostart (exec-once). Idempotent and
# self-guarding: a second instance exits immediately.
#
# Usage: monitor-hotplug.sh        (normally launched by exec-once, not by hand)

set -u

# ---- single-instance guard -------------------------------------------------
# flock on a per-user lock file: if the daemon is already running, this instance
# exits 0 rather than double-applying on every event.
LOCK="${XDG_RUNTIME_DIR:-/tmp}/mango-monitor-hotplug.lock"
exec 9>"$LOCK"
if ! flock -n 9; then
    echo "monitor-hotplug: already running, exiting" >&2
    exit 0
fi

# Settle window (seconds): a single dock/undock emits a burst of monitor events
# (add, mode, geometry). We coalesce the burst and apply the layout ONCE after
# the stream goes quiet for this long, instead of thrashing wlr-randr per event.
SETTLE=0.4

# Track the CONNECTED-output set so we only act on real topology changes, not on
# every focus event that `watch all-monitors` also emits. Uses wlr-randr (focus-
# independent) — NOT `mmsg select(.active)`, whose `.active` means *focused*, so
# every monitor focus-switch looked like a topology change and re-applied the
# layout (which flipped the portrait screen to landscape on focus).
active_set() {
    wlr-randr 2>/dev/null | awk '/^[^[:space:]]/{print $1}' | sort | paste -sd, -
}

apply() {
    local now
    now=$(active_set)
    if [ "$now" = "$LAST_SET" ]; then
        return  # topology unchanged (e.g. mode tweak only) — nothing to do
    fi
    echo "monitor-hotplug: outputs [$LAST_SET] -> [$now], applying layout" >&2
    LAST_SET="$now"
    ~/.local/bin/monitor-apply.sh
}

LAST_SET=$(active_set)
echo "monitor-hotplug: watching (initial outputs [$LAST_SET])" >&2

# Debounced stream reader: block on the first event, then keep draining with a
# short read timeout; once the stream is quiet for $SETTLE, apply once. This
# coalesces the hotplug event burst without a fixed sleep that could miss late
# events.
dirty=0
while true; do
    if [ "$dirty" -eq 0 ]; then
        # Block indefinitely for the next event.
        if ! IFS= read -r _line; then
            echo "monitor-hotplug: watch stream ended, exiting" >&2
            break
        fi
        dirty=1
    else
        # An event is pending; wait up to $SETTLE for more before applying.
        if IFS= read -r -t "$SETTLE" _line; then
            :  # more events in the burst — keep draining
        else
            apply
            dirty=0
        fi
    fi
done < <(mmsg watch all-monitors 2>/dev/null)

# If we fell out of the loop with a pending change, flush it.
[ "$dirty" -eq 1 ] && apply
