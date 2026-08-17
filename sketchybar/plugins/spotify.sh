#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

# Hide both the marquee and the next button together.
hide() { sketchybar --set spotify drawing=off --set spotify_next drawing=off; exit 0; }

# Don't let osascript launch Spotify: only query if it's already running.
pgrep -x Spotify >/dev/null 2>&1 || hide

STATE="$(osascript -e 'tell application "Spotify" to player state' 2>/dev/null)"
[ "$STATE" = "playing" ] || [ "$STATE" = "paused" ] || hide

TRACK="$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)"
ARTIST="$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)"
[ -n "$TRACK" ] || hide

if [ -n "$ARTIST" ]; then
  TEXT="$ARTIST - $TRACK"
else
  TEXT="$TRACK"
fi

# Bright + green when playing, dimmed when paused.
if [ "$STATE" = "playing" ]; then
  ICON_COLOR="$GREEN"; LABEL_COLOR="$FG"
else
  ICON_COLOR="$COMMENT"; LABEL_COLOR="$COMMENT"
fi

sketchybar --set spotify drawing=on icon="" icon.color="$ICON_COLOR" \
                         label="$TEXT" label.color="$LABEL_COLOR" \
           --set spotify_next drawing=on icon.color="$LABEL_COLOR"
