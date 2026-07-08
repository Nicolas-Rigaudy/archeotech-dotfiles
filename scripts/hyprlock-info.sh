#!/bin/bash
################################################################################
# HYPRLOCK INFO — small string providers for hyprlock.conf cmd[update:N] labels.
# Kept as a script (not inline in hyprlock.conf) because hyprlang mangles
# $(...) / # inside label commands. Usage: hyprlock-info.sh {greeting|status}
################################################################################

case "$1" in
    greeting)
        h=$(date +%H)
        if   [ "$h" -lt 5 ];  then echo "Good night"
        elif [ "$h" -lt 12 ]; then echo "Good morning"
        elif [ "$h" -lt 18 ]; then echo "Good afternoon"
        else                       echo "Good evening"
        fi
        ;;
    status)
        bat=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        up=$(uptime -p 2>/dev/null | sed 's/^up //')
        out=""
        [ -n "$bat" ] && out="󰁹 ${bat}%"
        [ -n "$up" ]  && out="${out:+$out    }󰅐 ${up}"
        echo "$out"
        ;;
    *)
        echo ""
        ;;
esac
