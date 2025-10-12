#!/usr/bin/env bash

# run_on_ws <workspace> <command...>
# examples:
#   run_on_ws 5 kitty
#   run_on_ws special:scratch "code ~/scratchpad"
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: $0 <workspace|special:name> <command...>" >&2
  exit 1
fi

TARGET_WS="$1"
shift
CMD="$*"

# switch to target
if [[ "$TARGET_WS" =~ ^special: ]]; then
  hyprctl dispatch togglespecialworkspace "${TARGET_WS#special:}"
else
  hyprctl dispatch workspace "$TARGET_WS"
fi

# launch on the now-current workspace
hyprctl dispatch exec "$CMD"

