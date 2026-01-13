#!/usr/bin/env bash


rclone mount aois:public /mnt/aois-public \
  --vfs-cache-mode writes \
  --dir-cache-time 1h \
  --poll-interval 1m \
  --daemon

notify-send "󱋌  /mnt/aois-public is mounted"
