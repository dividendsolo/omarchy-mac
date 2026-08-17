#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Volume comes from event $INFO on volume_change, otherwise query system
if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)"
fi

[ -z "$VOLUME" ] && exit 0

# Current default output device. Treat anything that isn't built-in speakers /
# a display / TV as headphones. This catches Bluetooth headphones whose names
# don't contain the word "headphone" (e.g. "soundcore Life Q30", "AirPods").
DEVICE="$(SwitchAudioSource -c 2>/dev/null)"

case "$DEVICE" in
  ""|*[Ss]peaker*|*MacBook*|*[Bb]uilt-in*|*Display*|*Monitor*|*TV*|*HDMI*|*HomePod*)
    case "$VOLUME" in
      100|[6-9][0-9])   ICON="󰕾" ;;
      [3-5][0-9])       ICON="󰖀" ;;
      [1-9]|[1-2][0-9]) ICON="󰕿" ;;
      *)                ICON="󰝟" ;;
    esac
    ;;
  *)
    ICON=""   # headphones
    ;;
esac

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$CYAN" \
  label="${VOLUME}%"
