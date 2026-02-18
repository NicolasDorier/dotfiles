
#!/bin/sh

OUT="/tmp/outwindow"
IN="/tmp/inwindow"

case "$1" in
  focusactivetolast)
    hyprctl dispatch focuscurrentorlast
    ;;
  switch)
    notify-send "Switch mode on"
    hyprctl activewindow -j | jq -r ".address" > /tmp/outwindow
    hyprctl -j activewindow | jq -e '.fullscreen == 1' >/dev/null && hyprctl dispatch fullscreen 1
    rm -f /tmp/inwindow
    ;;
  select)
    notify-send "Switch mode off"
    hyprctl activewindow -j | jq -r ".address" > /tmp/inwindow
    OUT_ADDR="$(cat "$OUT" 2>/dev/null)"
    IN_ADDR="$(cat "$IN" 2>/dev/null)"
    [ -n "$OUT_ADDR" ] && hyprctl dispatch focuswindow "address:$OUT_ADDR"
    [ -n "$IN_ADDR" ] && hyprctl dispatch focuswindow "address:$IN_ADDR"
    hyprctl dispatch fullscreen 1
    ;;
  *)
    exit 1
    ;;
esac
