#!/usr/bin/env bash

current_mode="$(makoctl mode)"

if [ "$current_mode" = "do-not-disturb" ]; then
    new_mode="default"
    message="󰒳"
else
    new_mode="do-not-disturb"
    message="󰒲"
fi

makoctl mode -s $new_mode
makoctl reload

icon='󰒲'
notify-send "$message"
