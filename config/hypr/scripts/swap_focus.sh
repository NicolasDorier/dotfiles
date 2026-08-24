#!/bin/sh

OUT="/tmp/outwindow"
IN="/tmp/inwindow"

dispatch() {
  hyprctl dispatch "$1"
}

case "$1" in
  focusactivetolast)
    dispatch 'hl.dsp.focus({ last = true })'
    ;;
  switch)
    notify-send "Switch mode on"
    hyprctl activewindow -j | jq -r ".address" > "$OUT"
    hyprctl -j activewindow | jq -e '.fullscreen == 1' >/dev/null && dispatch 'hl.dsp.window.fullscreen({ mode = "maximized" })'
    rm -f "$IN"
    ;;
  select)
    notify-send "Switch mode off"
    hyprctl activewindow -j | jq -r ".address" > "$IN"
    OUT_ADDR="$(cat "$OUT" 2>/dev/null)"
    IN_ADDR="$(cat "$IN" 2>/dev/null)"
    [ -n "$OUT_ADDR" ] && dispatch "hl.dsp.focus({ window = \"address:$OUT_ADDR\" })"
    [ -n "$IN_ADDR" ] && dispatch "hl.dsp.focus({ window = \"address:$IN_ADDR\" })"
    dispatch 'hl.dsp.window.fullscreen({ mode = "maximized" })'
    ;;
  *)
    exit 1
    ;;
esac
