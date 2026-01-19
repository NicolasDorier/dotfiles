#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: yt-music.sh [-u YOUTUBE_URL] [-o OUTPUT_DIR] [-h]
  -u    YouTube video URL (required)
  -o    Output directory (default: current directory)
  -h    Show help
EOF
}

youtube_url=""
output_dir="."

while getopts ":u:o:h" opt; do
  case "$opt" in
    u) youtube_url="$OPTARG" ;;
    o) output_dir="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) echo "unknown -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "missing arg for -$OPTARG" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$youtube_url" ]]; then
  echo "YouTube URL is required" >&2
  usage
  exit 2
fi

if [[ ! -d "$output_dir" ]]; then
  echo "Output directory does not exist: $output_dir" >&2
  exit 2
fi

resolved_output_dir=$(realpath "$output_dir")

docker run --rm -ti -v "$resolved_output_dir:/workdir:rw" mikenye/youtube-dl --external-downloader aria2c --extract-audio --audio-format best -o "/workdir/%(title)s.%(ext)s" "$youtube_url"
