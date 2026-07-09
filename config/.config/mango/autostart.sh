#!/bin/bash
################################################################################
# MANGOWC AUTOSTART SCRIPT
################################################################################

# Wait for compositor to fully initialize
sleep 1

################################################################################
# XDG Desktop Portal (screen sharing — Teams, Zoom, etc.)
################################################################################
killall -q xdg-desktop-portal-wlr xdg-desktop-portal
sleep 1
/usr/lib/xdg-desktop-portal-wlr &
sleep 0.5
/usr/lib/xdg-desktop-portal &

################################################################################
# Shell (bar + control center + OSD — single Quickshell process)
################################################################################
# Launched by `exec-once` in config.conf (the authoritative launcher). Kept here
# only as a reference — do NOT re-enable: Quickshell doesn't dedupe per-config,
# so two launch points = doubled bars + doubled exclusion zones on login.
# qs -c archeotech &

################################################################################
# Keyring
################################################################################
gnome-keyring-daemon --start --components=secrets &

################################################################################
# Wallpaper daemon + restore last wallpaper
################################################################################
awww-daemon &
sleep 1
~/.local/bin/wallpaper-set.sh --restore &

################################################################################
# Clipboard history manager
################################################################################
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

################################################################################
# Idle manager (auto-lock, screen-off — config in ~/.config/swayidle/)
################################################################################
~/.config/swayidle/config.sh &

################################################################################
# Battery monitor (swaync notifications at 20/10/5%, auto-suspend at 3%)
################################################################################
~/.local/bin/battery-alert.sh &

################################################################################
# Network + Bluetooth system tray applets
################################################################################
nm-applet --indicator &
blueman-applet &
