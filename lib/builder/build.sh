#!/usr/bin/env bash

build_file() {
  local file="$1"
  echo "[build_file] file: ${file}"
  local type
  type=$(detect "$file")
  echo "[build_file] type: ${type}"

  local hub
  hub=$(readhub "$type")
  echo "[build_file] hub: ${hub}"

  local output_dir
  output_dir=$(echo "$hub" | jq -r '.build_path // empty')
  echo "[build_file] output_dir: ${output_dir}"

  if [[ -z "$output_dir" ]]; then
    echo "No build_path defined in ${type}_hub.json"
    exit 1
  fi

  mkdir -p "$BASE_PATH/$output_dir"

  local output_file="$BASE_PATH/$output_dir/$(basename "$file")"
  echo "[build_file] output_file: ${output_file}"

  processor "$file" > "$output_file"

  echo "Built: $output_file"
}
