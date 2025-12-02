#!/bin/bash
################################################################################
# MANGOWC AUTOSTART SCRIPT
# Ported from Hyprland exec-once commands
################################################################################

# Wait a moment for compositor to fully start
sleep 1

# Status bar (using MangoWC-compatible config)
waybar -c ~/.config/waybar/config-mango &

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

# Idle manager (auto-lock after 10 minutes, dim at 5 minutes, screen off at 15 minutes)
~/.config/swayidle/config.sh &
