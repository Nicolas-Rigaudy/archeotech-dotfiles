#!/bin/bash
################################################################################
# MANGOWC AUTOSTART SCRIPT
# Ported from Hyprland exec-once commands
################################################################################

# Wait a moment for compositor to fully start
sleep 1

# Desktop portal for screen sharing (Teams, Zoom, etc.)
# Kill any existing instances first to avoid conflicts
killall -q xdg-desktop-portal-wlr xdg-desktop-portal
# Brief pause to allow clean shutdown
sleep 1
# Start portals (wlr must start before main portal)
/usr/lib/xdg-desktop-portal-wlr &
sleep 0.5
/usr/lib/xdg-desktop-portal &

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

# Battery monitor (notifications at 20%, 10%, 5% - auto-suspend at 3%)
~/Projects/archeotech-dotfiles/scripts/battery-alert.sh &
