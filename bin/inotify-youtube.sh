#!/usr/bin/env bash

YOUTUBE_DIR="$HOME/Videos/Youtube"
OUTPUT_DIR="$HOME/Videos"

mkdir -p "$YOUTUBE_DIR"
inotifywait -m $YOUTUBE_DIR -e create -e moved_to |
while read path action file; do
    [[ "$file" != *.mp4 && "$file" != *.mkv ]] && continue
    notify-send "🎬 Encoding for YouTube…" "$file"
    dir=$(dirname -- "$file")
    base=$(basename -- "$file") 
    name="${base%.*}"
    ext="${base##*.}"
    fileoutput="$OUTPUT_DIR/$name-youtube.$ext"
    rm -f $fileoutput
    if ~/.local/bin/encode-youtube.sh -i "$path$file" -o "$fileoutput"; then
      notify-send "✅ Encoding finished" "$fileoutput"
      mv "$path$file" "$OUTPUT_DIR/$file"
    else
      notify-send "❌ Failed to encode" "$file"
    fi
done
