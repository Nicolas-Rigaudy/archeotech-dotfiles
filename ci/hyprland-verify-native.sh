#!/bin/bash
################################################################################
# hyprland-verify-native.sh — run `Hyprland --verify-config` on a config file,
# assuming Hyprland is already installed (an Arch container, or a real machine).
#
# Shared by both entry points so the check is identical everywhere:
#   • ci/verify-compositor-configs.sh  — wraps this in a local Docker container
#   • .github/workflows/compositor-config.yml — runs this in an Arch CI container
#
# Exit 1 on HARD errors ("invalid field …": a directive the compositor cannot
# parse). Deprecation notices are printed but do not fail (the directive still
# works). Handles the two Hyprland footguns: it refuses to run as root, and it
# needs XDG_RUNTIME_DIR set even just to verify.
#
# Usage: hyprland-verify-native.sh <path-to-hyprland.conf>
################################################################################
set -euo pipefail

CONF="${1:?usage: hyprland-verify-native.sh <hyprland.conf>}"
[ -f "$CONF" ] || { echo "xx missing config: $CONF" >&2; exit 2; }
command -v Hyprland >/dev/null || { echo "xx Hyprland not installed" >&2; exit 2; }

# Hyprland won't run as root; drop to a throwaway user if we are.
run_verify() {
    local rt; rt="$(mktemp -d)"; chmod 700 "$rt"
    XDG_RUNTIME_DIR="$rt" HOME="${HOME:-/tmp}" Hyprland --verify-config -c "$CONF" 2>&1
}
if [ "$(id -u)" -eq 0 ]; then
    id -u hyprtest >/dev/null 2>&1 || useradd -m hyprtest
    RT=/run/hyprtest-xdg; install -d -o hyprtest -g hyprtest -m 700 "$RT"
    OUT="$(su hyprtest -c "XDG_RUNTIME_DIR=$RT HOME=/home/hyprtest Hyprland --verify-config -c '$CONF' 2>&1" || true)"
else
    OUT="$(run_verify || true)"
fi

# Strip ANSI, keep real config diagnostics (drop xkb keysym/modifier noise).
DIAG="$(printf '%s\n' "$OUT" | sed -E 's/\x1b\[[0-9;]*m//g' \
        | grep -iE 'config error|invalid field' \
        | grep -viE 'keysym|modifier|xkb|ScrollLock|Virtual modifier' || true)"
HARD="$(printf '%s\n' "$DIAG" | grep -ic 'invalid field' || true)"
DEPR="$(printf '%s\n' "$DIAG" | grep -ic 'deprecated' || true)"

echo ":: $(basename "$CONF"): $HARD hard error(s), $DEPR deprecation notice(s)"
[ "$DEPR" -gt 0 ] && printf '%s\n' "$DIAG" | grep -i 'deprecated' | sed 's/^/  [warn] /'
if [ "$HARD" -gt 0 ]; then
    printf '%s\n' "$DIAG" | grep -i 'invalid field' | sed 's/^/  [FAIL] /'
    exit 1
fi
echo ":: OK — no hard config errors"
