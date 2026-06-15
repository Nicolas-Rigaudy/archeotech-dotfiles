#!/bin/bash
################################################################################
# SWAYLOCK LAUNCH SCRIPT
# Locks the screen using the current wallpaper from the wallpaper cache.
# Falls back to plain color if cache is unavailable.
################################################################################

CACHE_FILE="$HOME/.cache/wallpaper/last-wallpaper"

# Trigger label passed by the caller (swayidle passes "idle-timeout" /
# "before-sleep"; the Super+L keybind passes nothing → "keybind").
TRIGGER="${1:-keybind}"

# ── Trigger diagnostics (temporary) ──────────────────────────────────────────
# Records who/why on every lock so a "random" lock is diagnosable from one
# occurrence. Read with: cat ~/.cache/swaylock-trigger.log
#
# Caller chain tells the source apart:
#   parent "swayidle" → idle timeout OR before-sleep (check the suspend line)
#   parent "mango"    → Super+L keybind (possible stuck Super from MX dongle)
# The battery/lid/suspend lines disambiguate a swayidle hit (idle vs sleep).
# Backgrounded (&) so the journalctl scan etc. never delay the lock — swaylock
# launches immediately while this writes the log asynchronously.
{
    echo "── $(date '+%Y-%m-%d %H:%M:%S') ──"
    echo "trigger: $TRIGGER"
    echo "caller chain (pid/ppid/cmd, walking up from this script):"
    pid=$PPID
    for _ in 1 2 3 4 5; do
        [[ "$pid" -le 1 ]] && break
        read -r ppid comm < <(ps -o ppid=,comm= -p "$pid" 2>/dev/null)
        printf '  %s\t%s\n' "$pid" "$comm"
        pid=$ppid
    done
    bat="/sys/class/power_supply/BAT0"
    echo "battery: $(cat "$bat/status" 2>/dev/null) $(cat "$bat/capacity" 2>/dev/null)%"
    for lid in /proc/acpi/button/lid/*/state; do
        [[ -r "$lid" ]] && echo "lid: $(cat "$lid")"
    done
    # Did logind signal a suspend in the last ~2 min? (best-effort; needs
    # journal read access — silently empty if unavailable)
    susp=$(journalctl -b --since "-2 min" 2>/dev/null \
        | grep -iE "PrepareForSleep|Suspending system|Reached target.*[Ss]leep" | tail -1)
    echo "recent-suspend: ${susp:-none}"
} >> "$HOME/.cache/swaylock-trigger.log" 2>&1 &

if [[ -f "$CACHE_FILE" ]]; then
    WALLPAPER=$(cat "$CACHE_FILE")
else
    WALLPAPER=""
fi

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    exec swaylock --image "$WALLPAPER"
else
    exec swaylock
fi
