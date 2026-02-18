
#!/bin/sh

OUT="/tmp/outwindow"
IN="/tmp/inwindow"

# read stored window address
ADDR="$(cat "$OUT" 2>/dev/null)"

# stop if empty
[ -z "$ADDR" ] && exit 0

# focus the stored window
hyprctl dispatch focuswindow "address:$ADDR"

# swap files
TMP=$(mktemp)
cp "$OUT" "$TMP" 2>/dev/null
cp "$IN" "$OUT" 2>/dev/null
cp "$TMP" "$IN" 2>/dev/null
rm -f "$TMP"
