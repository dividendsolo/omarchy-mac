#!/usr/bin/env bash
# WiFi indicator. Click opens Wi-Fi settings.
source "$CONFIG_DIR/colors.sh"

# Find the Wi-Fi interface name dynamically (usually en0)
DEV=$(networksetup -listallhardwareports 2>/dev/null \
  | awk '/Hardware Port: Wi-Fi/ {getline; print $2; exit}')
DEV=${DEV:-en0}

POWER=$(networksetup -getairportpower "$DEV" 2>/dev/null | awk '{print $NF}')

if [ "$POWER" = "On" ]; then
  ICON="󰖩"
  COLOR="$CYAN"
else
  ICON="󰖪"
  COLOR="$COMMENT"
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  label.drawing=off
