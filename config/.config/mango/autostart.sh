#!/bin/bash
################################################################################
# MANGOWC AUTOSTART SCRIPT
# Ported from Hyprland exec-once commands
################################################################################

# Wait a moment for compositor to fully start
sleep 1

# Status bar
waybar &

# Notifications
dunst &

# System tray applets
nm-applet --indicator &    # WiFi icon
blueman-applet &           # Bluetooth icon

# Keyring (for password management)
gnome-keyring-daemon --start --components=secrets &

# Wallpaper daemon
swww-daemon &
sleep 1
swww img ~/Pictures/Wallpapers/arasaka.png &

# Clipboard history manager
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Idle manager (will use swayidle once configured)
# swayidle will be configured separately
# swayidle &

# Keyboard layout setup (US/FR switching with Alt+Shift)
# Note: MangoWC might handle this differently than Hyprland
# Testing needed to see if this works or needs compositor-level config
