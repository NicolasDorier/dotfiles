#!/usr/bin/env bash

hidden_on_workspace=10

hide() {
    pkill -SIGUSR1 waybar && touch /tmp/waybar_is_hidden
}

show() {
    [[ -f /tmp/waybar_is_hidden ]] && {
        pkill -SIGUSR1 waybar
        rm -f /tmp/waybar_is_hidden
    }
}

sleep 1

current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
(( hidden_on_workspace == current_workspace )) && hide

socket_path="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

[[ ! -S "$socket_path" ]] && {
    echo "Error: Hyprland socket not found. Is Hyprland running?"
    exit 1
}

socat -u "UNIX-CONNECT:$socket_path" STDOUT | while read -r event; do
    case $event in
        workspace>>$hidden_on_workspace) hide ;;
        workspace>>*) show ;;
    esac
done
