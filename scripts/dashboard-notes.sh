#!/usr/bin/env bash
# Outputs key:value lines for the System Notes dashboard panel

# Last snapper snapshot date
last_snap=$(snapper -c root list --output-columns number,date 2>/dev/null \
    | grep -v "^#\|^Number\|^---" | tail -1 | awk '{print $2}')
echo "snap:${last_snap:-N/A}"

# Pending AUR/repo updates (pacman-contrib)
updates=$(checkupdates 2>/dev/null | wc -l | tr -d ' ')
echo "updates:${updates:-0}"

# Active VPN connection name (nmcli)
vpn_name=$(nmcli con show --active 2>/dev/null | awk '/vpn/{print $1; exit}')
if [ -n "$vpn_name" ]; then
    echo "vpn:$vpn_name"
else
    echo "vpn:inactive"
fi

# AWS profile from environment
echo "aws:${AWS_PROFILE:-unset}"
