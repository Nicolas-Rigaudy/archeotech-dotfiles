#!/bin/bash
# shell-reload.sh — compositor-agnostic "reload config + restart shell".
#
# One command bound to Super+Shift+R under BOTH compositors (AC3 of the Hyprland
# port). It detects the active compositor and does the right thing:
#   • MangoWC  → delegate to mango-reload.sh (its full mmsg reload + monitor +
#                keyboard-layout restore logic, unchanged).
#   • Hyprland → restart the shell, then `hyprctl reload` to re-read hyprland.conf.
#
# Detection uses HYPRLAND_INSTANCE_SIGNATURE, which Hyprland exports into every
# client's environment; MangoWC does not set it.
#
# Usage: shell-reload.sh     Keybind: Super+Shift+R (both compositors)

set -e

HERE="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

restart_shell() {
    # Stop the shell first — run every kill method unconditionally so a survivor
    # never gets a second bar stacked on top (same rationale as mango-reload.sh).
    qs -c archeotech kill 2>/dev/null || true
    pkill -x quickshell 2>/dev/null || true
    pkill -x qs 2>/dev/null || true
    for _ in $(seq 1 20); do
        pgrep -x quickshell >/dev/null 2>&1 || pgrep -x qs >/dev/null 2>&1 || break
        sleep 0.1
    done
}

if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    # ── Hyprland ────────────────────────────────────────────────────────────────
    hyprctl reload                          # re-read hyprland.conf (rules, binds, blur)
    restart_shell
    # Relaunch the shell LAST, matching the exec-once launcher (no decorations).
    env QT_WAYLAND_DECORATION=none quickshell -c archeotech >/dev/null 2>&1 &
    disown
    exit 0
fi

# ── MangoWC (default) ────────────────────────────────────────────────────────
# Delegate to the full mango reload (monitor re-apply + keyboard-layout restore).
if command -v mango-reload.sh >/dev/null 2>&1; then
    exec mango-reload.sh
elif [ -x "$HERE/mango-reload.sh" ]; then
    exec "$HERE/mango-reload.sh"
else
    echo "shell-reload.sh: mango-reload.sh not found on PATH or beside this script" >&2
    exit 1
fi
