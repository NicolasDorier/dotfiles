#!/usr/bin/env bash
set -euo pipefail

scanner_list="$(scanimage -L 2>/dev/null || true)"

fujitsu_device=""
default_device=""

while IFS= read -r line; do
  if [[ "$line" == "device \`"*"' is a FUJITSU "* ]]; then
    fujitsu_device="${line#device \`}"
    fujitsu_device="${fujitsu_device%%\'*}"
  elif [[ "$line" == "default device is \`"* ]]; then
    default_device="${line#default device is \`}"
    default_device="${default_device%%\'*}"
  fi
done <<< "$scanner_list"

if [[ -z "$fujitsu_device" ]]; then
  exit 0
fi

if [[ "$default_device" == "$fujitsu_device" ]]; then
  exit 0
fi

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  printf 'export SANE_DEFAULT_DEVICE=%q\n' "$fujitsu_device"
else
  export SANE_DEFAULT_DEVICE="$fujitsu_device"
fi
