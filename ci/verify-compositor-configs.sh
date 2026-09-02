#!/bin/bash
################################################################################
# verify-compositor-configs.sh — lint the compositor configs in a throwaway
# Arch container, fully isolated from your live session.
#
# WHY a container: validating a Wayland compositor config means running the
# compositor binary (`Hyprland --verify-config`). Doing that on the host risks
# the live session (a stray full boot once crashed the session to SDDM and even
# knocked out Bluetooth audio). A container gives the compositor its OWN
# XDG_RUNTIME_DIR, D-Bus, and user — it physically cannot touch your session.
# This is also the exact gate CI runs (see .github/workflows), so "works in the
# container" == "passes CI".
#
# What it checks today:
#   • hyprland.conf via `Hyprland --verify-config` on the pinned Arch Hyprland.
# HARD failures (exit 1): "invalid field …" — a directive the compositor cannot
# parse. Deprecation notices are reported as warnings but do NOT fail the run.
#
# Usage:
#   ci/verify-compositor-configs.sh            # verify all compositor configs
#   HYPR_IMAGE=archlinux:latest ci/verify-compositor-configs.sh
#
# Requires: docker with working `--network host` (bridge networking is often
# unavailable in sandboxes; host networking lets pacman reach the mirrors).
################################################################################
set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
IMAGE="${HYPR_IMAGE:-archlinux:latest}"
HYPR_CONF="$REPO/config/.config/hypr/hyprland.conf"

red(){ printf '\033[0;31m%s\033[0m\n' "$1"; }
grn(){ printf '\033[0;32m%s\033[0m\n' "$1"; }
ylw(){ printf '\033[1;33m%s\033[0m\n' "$1"; }

command -v docker >/dev/null || { red "docker not found"; exit 2; }
[ -f "$HYPR_CONF" ] || { red "missing $HYPR_CONF"; exit 2; }

echo ":: verifying compositor configs in an isolated $IMAGE container"

# Install Hyprland in the container, then run the SHARED native checker (same
# script CI runs) against the mounted config. The container gives the compositor
# its own XDG_RUNTIME_DIR / user, isolated from the host session.
docker run --rm --network host \
    -v "$HYPR_CONF:/cfg/hyprland.conf:ro" \
    -v "$REPO/ci/hyprland-verify-native.sh:/ci/hyprland-verify-native.sh:ro" \
    "$IMAGE" bash -c '
        pacman -Sy --noconfirm --needed hyprland >/dev/null 2>&1
        bash /ci/hyprland-verify-native.sh /cfg/hyprland.conf
    '
