#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage:
  vid2gif [-i INPUT] [-o OUTPUT] [-r FPS] [-w WIDTH] [-F FORMAT]
  echo ... | vid2gif              # stdin -> stdout
  vid2gif -i in.mp4 -o out.gif    # file -> file

Options:
  -i FILE    Input video file (default: stdin)
  -o FILE    Output GIF file (default: stdout)
  -r FPS     Frames per second (default: 10)
  -w WIDTH   Output width (keep aspect; default: 1080)
  -F FORMAT  Input container when reading from stdin (e.g. mp4, mov, webm)
  -h         Help
EOF
}

infile=""
outfile=""
fps="10"
width="1080"
informat=""

while getopts ":i:o:r:w:F:h" opt; do
  case "$opt" in
    i) infile="$OPTARG" ;;
    o) outfile="$OPTARG" ;;
    r) fps="$OPTARG" ;;
    w) width="$OPTARG" ;;
    F) informat="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage; exit 2 ;;
    :)  echo "Missing arg for -$OPTARG" >&2; usage; exit 2 ;;
  esac
done

# Input args
if [[ -n "$infile" ]]; then
  in_args=(-i "$infile")
else
  if [ -t 0 ]; then
    echo "No input. Pipe video data to stdin or use -i FILE." >&2; exit 2
  fi
  # Help ffmpeg probe piped input
  if [[ -n "$informat" ]]; then
    in_args=(-f "$informat" -i -)
  else
    # Increase probe budget for picky inputs over pipes
    in_args=(-probesize 10M -analyzeduration 200M -i -)
  fi
fi

# Output args
if [[ -n "$outfile" ]]; then
  out_target="$outfile"; out_args=()
else
  out_target="-"            # stdout
  out_args=(-f gif)
fi

# Filters
filter="[0:v]fps=${fps},scale=${width}:-2:flags=lanczos,split[s0][s1];\
[s0]palettegen=stats_mode=single[p];\
[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"

exec ffmpeg -hide_banner -loglevel error -y \
  "${in_args[@]}" \
  -filter_complex "$filter" \
  "${out_args[@]}" \
  "$out_target"

