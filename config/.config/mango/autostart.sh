#!/bin/bash
################################################################################
# MANGOWC AUTOSTART SCRIPT
# Ported from Hyprland exec-once commands
################################################################################

# Wait a moment for compositor to fully start
sleep 1

# Status bar (using MangoWC-compatible config and styling)
waybar -c ~/.config/waybar/config-mango -s ~/.config/waybar/style-mango.css &

# Notifications
dunst &

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
