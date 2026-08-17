#!/usr/bin/env bash
source "$CONFIG_DIR/colors.sh"

LABEL="$(date '+%a  %-I:%M %p')"
ICON="󰥔"
THEME="$(cat "$HOME/.config/theme-switcher/current" 2>/dev/null || echo "?")"

# The built-in display has a notch, so centered items are lost behind it. Rather
# than switching the whole bar to one layout or the other, pin each variant to
# the displays it suits: centered on the externals, right-side (in front of the
# battery) on the built-in. Both can be drawn at once, on different screens.
#
# sketchybar's associated_display takes arrangement ids, so map the built-in's
# DirectDisplayID (per CoreGraphics, the authority on which panel is built-in)
# through `sketchybar --query displays` to get its arrangement id.
read -r BUILTIN OTHERS <<<"$(
  sketchybar --query displays 2>/dev/null | python3 -c '
import ctypes, ctypes.util, json, sys

cg = ctypes.CDLL(ctypes.util.find_library("CoreGraphics"))
count = ctypes.c_uint32()
ids = (ctypes.c_uint32 * 16)()
cg.CGGetActiveDisplayList(16, ids, ctypes.byref(count))
builtin_ddids = {ids[i] for i in range(count.value) if cg.CGDisplayIsBuiltin(ids[i])}

builtin, others = [], []
for d in json.load(sys.stdin):
    arrangement = str(d["arrangement-id"])
    (builtin if d["DirectDisplayID"] in builtin_ddids else others).append(arrangement)

print(",".join(builtin) or "-", ",".join(others) or "-")
' 2>/dev/null
)"
# If anything above failed, fall back to the plain centered layout everywhere.
[ -n "$BUILTIN" ] || { BUILTIN="-"; OTHERS="0"; }

if [ "$BUILTIN" != "-" ]; then
  sketchybar --set clock_right drawing=on associated_display="$BUILTIN" \
                   icon="$ICON" icon.color="$MAGENTA" label="$LABEL" label.color="$FG" \
             --set theme_name_right drawing=on associated_display="$BUILTIN" \
                   label="$THEME" label.color="$FG"
else
  sketchybar --set clock_right drawing=off --set theme_name_right drawing=off
fi

if [ "$OTHERS" != "-" ]; then
  sketchybar --set clock drawing=on associated_display="$OTHERS" \
                   icon="$ICON" icon.color="$MAGENTA" label="$LABEL" label.color="$FG" \
             --set theme_name drawing=on associated_display="$OTHERS" \
                   label="$THEME" label.color="$FG"
else
  sketchybar --set clock drawing=off --set theme_name drawing=off
fi
