#!/usr/bin/env bash
# Highlight the focused AeroSpace workspace.
# Workspace id is derived from $NAME (e.g. "space.3" → "3").
# $FOCUSED_WORKSPACE is set by the aerospace_workspace_change trigger.

source "$CONFIG_DIR/colors.sh"

SID="${NAME#space.}"
FOCUSED="${FOCUSED_WORKSPACE:-$(/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$BLUE" \
    icon.color="$BG"
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$FG"
fi
