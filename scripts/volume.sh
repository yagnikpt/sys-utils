#!/bin/sh

# Paths
ICON_DIR="$HOME/.config/mako/icons"
NOTIFY="notify-send --app-name=osd -h string:x-canonical-private-synchronous:volume -h int:transient:1 -t 1000"

# Get current volume and mute status
VOL=$(pamixer --get-volume)
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "muted" || echo "unmuted")

# Handle action
case "$1" in
  up)
    if [ "$MUTED" = "muted" ]; then
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit=1.0
    else
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
      wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit=1.0
    fi
    VOL=$(pamixer --get-volume)
    MUTED="unmuted"
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    VOL=$(pamixer --get-volume)
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "muted" || echo "unmuted")
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "muted" || echo "unmuted")
    [ "$MUTED" = "muted" ] && VOL=0
    ;;
  *)
    echo "Usage: $0 {up|down|mute}"
    exit 1
    ;;
esac

# Pick icon based on volume
if [ "$MUTED" = "muted" ] || [ "$VOL" -eq 0 ]; then
  ICON="$ICON_DIR/volume-x.png"
elif [ "$VOL" -gt 66 ]; then
  ICON="$ICON_DIR/volume-2.png"
elif [ "$VOL" -gt 33 ]; then
  ICON="$ICON_DIR/volume-1.png"
else
  ICON="$ICON_DIR/volume.png"
fi

# Send notification
[ "$MUTED" = "muted" ] && $NOTIFY -h int:value:0 "Muted" --icon="$ICON" || $NOTIFY -h int:value:"$VOL" "$VOL%" --icon="$ICON"
