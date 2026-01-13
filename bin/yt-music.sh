#!/usr/bin/env bash


docker run --rm -ti -v "$(pwd):/workdir:rw" mikenye/youtube-dl --external-downloader aria2c --extract-audio --audio-format best -o "/workdir/%(title)s.%(ext)s" "https://www.youtube.com/watch?v=z3YMxM1_S48"
