#!/bin/bash
################################################################################
# SWAYIDLE CONFIGURATION
# Idle management for MangoWC - Ported from hypridle setup
################################################################################
#
# This script configures swayidle with the same behavior as hypridle:
# - 5 minutes: Dim screen to 10%
# - 10 minutes: Lock screen
# - 15 minutes: Turn off displays
#
# Usage: Run this script to start swayidle (usually from autostart)
#
################################################################################

swayidle -w \
    timeout 300 'brightnessctl -s set 10' \
        resume 'brightnessctl -r' \
    timeout 600 'swaylock' \
    timeout 900 'wlopm --off \*' \
        resume 'wlopm --on \*' \
    before-sleep 'swaylock'
