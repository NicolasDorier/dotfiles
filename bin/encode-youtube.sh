#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage:
  encode-youtube [-i INPUT] [-o OUTPUT]
  echo ... | ytenc > out.mp4
  encode-youtube -i in.mov -o out.mp4
EOF
}

infile=""
outfile=""

while getopts ":i:o:h" opt; do
  case "$opt" in
    i) infile="$OPTARG" ;;
    o) outfile="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) echo "unknown -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "missing arg for -$OPTARG" >&2; usage; exit 2 ;;
  esac
done

# input
if [[ -n "$infile" ]]; then
  in_args=(-i "$infile")
else
  if [ -t 0 ]; then echo "no input" >&2; exit 2; fi
  in_args=(-probesize 10M -analyzeduration 200M -i -)
fi

# output
if [[ -n "$outfile" ]]; then
  out_target="$outfile"; out_args=()
else
  out_target="-"; out_args=(-f mp4)
fi

exec ffmpeg -hide_banner -nostdin -progress -y \
  -vaapi_device /dev/dri/renderD128 \
  "${in_args[@]}" \
  -map 0:v:0 -map 0:a? \
  -vf 'format=nv12,hwupload' \
  -c:v h264_vaapi -profile:v high \
  -preset slow \
  -crf 18 -g 30 -bf 2 \
  -c:a aac -profile:a aac_low -b:a 384k \
  -movflags faststart \
  "${out_args[@]}" \
  "$out_target"

