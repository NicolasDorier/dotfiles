#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage:
  scan-to-ocr-pdf.sh [options]

Scans multi-page documents with scanimage, builds a PDF, then runs OCR.

Options:
  -o FILE     Output PDF path (default: ~/Documents/scan-YYYYMMDD-HHMMSS.pdf)
  -d DEVICE   scanimage device name
  -m MODE     scanimage mode (e.g. Color, Gray)
  -r DPI      scanimage resolution (dpi)
  -a ARG      Extra scanimage argument (repeatable)
  -p          Prompt between pages (flatbed)
  -h          Show this help

Examples:
  scan-to-ocr-pdf.sh -p
  scan-to-ocr-pdf.sh -d "epson2:libusb:001:004" -r 300 -m Gray
  scan-to-ocr-pdf.sh -a "--source ADF Duplex" -a "--mode Gray"
EOF
}

output=""
device=""
mode=""
resolution=""
prompt="false"
extra_scan_args=()

while getopts ":o:d:m:r:a:ph" opt; do
  case "$opt" in
    o) output="$OPTARG" ;;
    d) device="$OPTARG" ;;
    m) mode="$OPTARG" ;;
    r) resolution="$OPTARG" ;;
    a) extra_scan_args+=("$OPTARG") ;;
    p) prompt="true" ;;
    h) usage; exit 0 ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage; exit 2 ;;
    :) echo "Missing arg for -$OPTARG" >&2; usage; exit 2 ;;
  esac
 done

shift $((OPTIND - 1))

if [[ -n "${1:-}" ]]; then
  echo "Unexpected argument: $1" >&2
  usage
  exit 2
fi

timestamp=$(date +%Y%m%d-%H%M%S)

if [[ -n "$output" ]]; then
  output_dir=$(dirname "$output")
  base_name=$(basename "$output")
  base_name=${base_name%.pdf}
else
  output_dir="$HOME/Documents"
  base_name="scan-$timestamp"
  output="$output_dir/$base_name.pdf"
fi

workdir="$output_dir/$base_name"
raw_pdf="$workdir/${base_name}-raw.pdf"

mkdir -p "$workdir"

scan_args=(--batch --batch-start=1 --format=tiff --batch=page-%03d.tif)

if [[ "$prompt" == "true" ]]; then
  scan_args+=(--batch-prompt)
fi

if [[ -n "$device" ]]; then
  scan_args+=(--device-name "$device")
fi

if [[ -n "$mode" ]]; then
  scan_args+=(--mode "$mode")
fi

if [[ -n "$resolution" ]]; then
  scan_args+=(--resolution "$resolution")
fi

if [[ ${#extra_scan_args[@]} -gt 0 ]]; then
  scan_args+=("${extra_scan_args[@]}")
fi

# By default SANE_DEFAULT_DEVICE is used, that we setup in .bashrc
(
  cd "$workdir"
  scanimage "${scan_args[@]}"
)

shopt -s nullglob
pages=("$workdir"/page-*.tif)
if (( ${#pages[@]} == 0 )); then
  echo "No pages scanned; check scanner settings." >&2
  exit 1
fi

img2pdf "${pages[@]}" -o "$raw_pdf"

notify-send "Starting OCR: $output"

ocrmypdf \
  -l eng+jpn \
  --deskew \
  --clean \
  --rotate-pages \
  --optimize 3 \
  --tesseract-oem 1 \
  --force-ocr \
  "$raw_pdf" \
  "$output"

notify-send "Saved OCR PDF: $output"
