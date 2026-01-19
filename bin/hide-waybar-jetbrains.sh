#!/usr/bin/env bash

echo "Starting"
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

socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
echo "Listening $socket_path"

[[ ! -S "$socket_path" ]] && {
    echo "Error: Hyprland socket not found. Is Hyprland running?"
    exit 1
}

socat -u "UNIX-CONNECT:$socket_path" STDOUT | while read -r event; do
    case "$event" in
        "workspace>>$hidden_on_workspace") hide ;;
        "workspace>>"*) show ;;
    esac
done
