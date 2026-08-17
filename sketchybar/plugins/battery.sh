#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
CHARGING="$(pmset -g batt | grep -c 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

if [ "$CHARGING" -gt 0 ]; then
  ICON="󰂄"
  COLOR="$GREEN"
else
  case "$PERCENTAGE" in
    100|9[0-9]) ICON="󰁹"; COLOR="$GREEN" ;;
    [7-8][0-9]) ICON="󰂀"; COLOR="$GREEN" ;;
    [4-6][0-9]) ICON="󰁾"; COLOR="$YELLOW" ;;
    [2-3][0-9]) ICON="󰁼"; COLOR="$ORANGE" ;;
    *)          ICON="󰂃"; COLOR="$RED" ;;
  esac
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  label="${PERCENTAGE}%"
