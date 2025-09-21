#!/bin/bash

BATTERY_PATH="/org/freedesktop/UPower/devices/battery_BAT0"
CHECK_INTERVAL=60
NOTIFIED=0

while true; do
    # Get battery percentage and state
    PERCENTAGE=$(upower -i $(upower -e | grep BAT) | grep "percentage" | awk '{print $2}' | tr -d '%')
    STATE=$(upower -i $BATTERY_PATH | grep state | awk '{print $2}')

    # Check if battery is at or below 20% and not charging
    if [ "$PERCENTAGE" -le 20 ] && [ "$STATE" != "charging" ] && [ "$STATE" != "fully-charged" ]; then
        if [ "$NOTIFIED" -eq 0 ]; then
            notify-send -u critical "Low Battery Alert" "Battery at ${PERCENTAGE}%! Plug in your charger."
            NOTIFIED=1
        fi
    else
        NOTIFIED=0
    fi

    sleep $CHECK_INTERVAL
done
