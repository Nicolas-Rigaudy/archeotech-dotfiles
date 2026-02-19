#!/bin/bash
# battery-alert.sh - Monitor battery and send dunst notifications
# Thresholds: 20% warning, 10% urgent, 5% critical (repeating), 3% auto-suspend

BATTERY="/sys/class/power_supply/BAT0"
CAPACITY_FILE="$BATTERY/capacity"
STATUS_FILE="$BATTERY/status"

# Track which notifications have already been sent (reset when plugged in)
NOTIFIED_20=false
NOTIFIED_10=false
NOTIFIED_5=false

# Catppuccin Macchiato urgency colors are handled by dunst config
# Using dunst urgency levels: normal, critical

send_notification() {
    local urgency="$1"
    local title="$2"
    local message="$3"
    local icon="$4"
    dunstify -u "$urgency" -t 0 -i "$icon" -h string:x-dunst-stack-tag:battery "$title" "$message"
}

while true; do
    CAPACITY=$(cat "$CAPACITY_FILE" 2>/dev/null)
    STATUS=$(cat "$STATUS_FILE" 2>/dev/null)

    # Reset notification flags when plugged in
    if [[ "$STATUS" == "Charging" || "$STATUS" == "Full" ]]; then
        NOTIFIED_20=false
        NOTIFIED_10=false
        NOTIFIED_5=false
        # Dismiss any existing battery notification
        dunstify -C 9999 2>/dev/null || true
        sleep 30
        continue
    fi

    # Only alert when discharging
    if [[ "$STATUS" == "Discharging" ]]; then
        if [[ "$CAPACITY" -le 3 ]]; then
            send_notification "critical" "Battery Critical: ${CAPACITY}%" "Suspending system now to protect your work." "battery-caution"
            sleep 5
            systemctl suspend
        elif [[ "$CAPACITY" -le 5 && "$NOTIFIED_5" == false ]]; then
            NOTIFIED_5=true
            send_notification "critical" "Battery Critical: ${CAPACITY}%" "Plug in NOW or your system will suspend soon." "battery-caution"
        elif [[ "$CAPACITY" -le 10 && "$NOTIFIED_10" == false ]]; then
            NOTIFIED_10=true
            send_notification "critical" "Battery Low: ${CAPACITY}%" "Connect your charger soon." "battery-low"
        elif [[ "$CAPACITY" -le 20 && "$NOTIFIED_20" == false ]]; then
            NOTIFIED_20=true
            send_notification "normal" "Battery Low: ${CAPACITY}%" "Consider plugging in your charger." "battery-low"
        fi
    fi

    sleep 60
done
