#!/bin/bash
################################################################################
# SWAYLOCK LAUNCH SCRIPT
# Locks the screen using the current wallpaper from the wallpaper cache.
# Falls back to plain color if cache is unavailable.
################################################################################

CACHE_FILE="$HOME/.cache/wallpaper/last-wallpaper"

if [[ -f "$CACHE_FILE" ]]; then
    WALLPAPER=$(cat "$CACHE_FILE")
else
    WALLPAPER=""
fi

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    exec swaylock --image "$WALLPAPER"
else
    exec swaylock
fi
