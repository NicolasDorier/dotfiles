#!/usr/bin/env bash

# Nautilus provides selected files here:
# - $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS (newline-separated, full paths)
# - $NAUTILUS_SCRIPT_SELECTED_URIS

LOG="$HOME/.cache/nautilus-encode-youtube.log"
mkdir -p "$(dirname "$LOG")"
echo "Encode-Youtube" > "$LOG"
exec >>"$LOG" 2>&1

while IFS= read -r file; do
    echo "Selected file: $file"
    # If file is /tmp/file.mp4
    # fileoutput is /tmp/file-youtube.mp4

    dir=$(dirname -- "$file")
    base=$(basename -- "$file") 
    name="${base%.*}"
    ext="${base##*.}"
    fileoutput="$dir/$name-youtube.$ext"

    notify-send "🎬 Encoding for YouTube…" "$file"
    ~/dotfiles/bin/encode-youtube.sh -i "$file" -o "$fileoutput" || notify-send "❌ Encoding failed" "Check logs:\n$LOG" 
    notify-send "✅ Encoding finished" "$fileoutput"
done <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
