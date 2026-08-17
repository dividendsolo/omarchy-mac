#!/usr/bin/env bash
# Static Bluetooth indicator. macOS Tahoe gates Bluetooth API behind a privacy
# permission that sketchybar (as a launchd background service) can't trigger,
# so we just show the icon and rely on click-to-open-settings.
source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" \
  icon="󰂯" \
  icon.color="$BLUE" \
  label.drawing=off
