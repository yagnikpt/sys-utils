#!/bin/sh

# Paths
ICON_DIR="$HOME/.config/mako/icons"
NOTIFY="notify-send --app-name=osd -h string:x-canonical-private-synchronous:brightness -h int:transient:1 -t 1000"

# Get current brightness percentage
MAX=$(brightnessctl max)
CUR=$(brightnessctl get)
PERC=$((CUR * 100 / MAX))

# Handle action
case "$1" in
  up)
    brightnessctl set +5%
    PERC=$((($(brightnessctl get) * 100) / MAX))
    ;;
  down)
    brightnessctl set 5%-
    PERC=$((($(brightnessctl get) * 100) / MAX))
    ;;
  *)
    echo "Usage: $0 {up|down}"
    exit 1
    ;;
esac

# Pick icon based on brightness
if [ "$PERC" -gt 66 ]; then
  ICON="$ICON_DIR/sun.png"
elif [ "$PERC" -gt 33 ]; then
  ICON="$ICON_DIR/sun-medium.png"
else
  ICON="$ICON_DIR/sun-dim.png"
fi

# Send notification
$NOTIFY -h int:value:"$PERC" "$PERC" --icon="$ICON"
