#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(pwd)"
HUB_DIR="$ROOT_DIR/lib/hubs"

# =========================
# Entry
# =========================

processor() {
  local file="$1"

  local type
  type=$(detect "$file")

  local hub
  hub=$(readhub "$type")

  local contents
  contents=$(cat "$file")

  contents=$(process_defaults "$contents" "$hub")
  contents=$(process_imports  "$contents" "$hub")

  echo "$contents"
}

# =========================
# Detect type
# =========================

detect() {
  local file="$1"
  local filename="${1##*/}"
  filename="${filename%.js}"
  echo "[processor][detect] filename: ${filename}"
  local type="${filename##*_}"
  echo "[processor][detect] type: ${type}"
  local hub_file="$HUB_DIR/${type}_hub.json"
  echo "[processor][detect] hub_file: ${hub_file}"
  if [[ -f "$hub_file" ]]; then
    echo "$type"
  else
    echo "unknown"
  fi
}


# =========================
# Read hub
# =========================

readhub() {
  local type="$1"
  local hub_file="$HUB_DIR/${type}_hub.json"

  if [[ ! -f "$hub_file" ]]; then
    echo "Hub not found for type: $type" >&2
    exit 1
  fi

  cat "$hub_file"
}

# =========================
# Process defaults
# =========================

process_defaults() {
  local contents="$1"
  local hub="$2"

  echo "$hub" | jq -c '.defaults[]?' | while read -r item; do
    local key
    local value

    key=$(echo "$item" | jq -r 'keys[0]')
    value=$(echo "$item" | jq -r '.[keys[0]]')

    # substitui this.key = qualquercoisa por this.key = value
    contents=$(echo "$contents" | \
      sed -E "s/(this\.${key}[[:space:]]*=[[:space:]]*).*/\1${value};/")

    # substitui #key = qualquercoisa por #key = value
    contents=$(echo "$contents" | \
      sed -E "s/(#${key}[[:space:]]*=[[:space:]]*).*/\1${value};/")
  done

  echo "$contents"
}

# =========================
# Process imports
# =========================

process_imports() {
  local contents="$1"
  local hub="$2"

  local imports
  imports=$(echo "$hub" | jq -c '.imports[]?')

  while read -r import_block; do

    for section in modules controllers; do
      local items
      items=$(echo "$import_block" | jq -r ".${section}[]?")

      for item in $items; do

        if [[ "$item" == *"*" ]]; then
          local prefix="${item%\*}"
          local dir
          dir=$(resolve_dir "$section")

          for file in "$dir"/${prefix}*.js; do
            [[ -e "$file" ]] || continue
            contents=$(append_import "$contents" "$file")
          done
        else
          local dir
          dir=$(resolve_dir "$section")

          local file="$dir/${item}.js"
          if [[ -f "$file" ]]; then
            contents=$(append_import "$contents" "$file")
          fi
        fi

      done
    done

  done <<< "$imports"

  echo "$contents"
}

# =========================
# Resolve directories
# =========================

resolve_dir() {
  local section="$1"

  case "$section" in
    modules)
      echo "$ROOT_DIR/lib"
      ;;
    controllers)
      echo "$ROOT_DIR/app/controllers"
      ;;
    *)
      echo "$ROOT_DIR"
      ;;
  esac
}

# =========================
# Append import
# =========================

append_import() {
  local contents="$1"
  local file="$2"

  local rel
  rel=$(realpath --relative-to="$ROOT_DIR" "$file")

  local import_line="import './${rel}';"

  if ! grep -qF "$import_line" <<< "$contents"; then
    contents="$import_line"$'\n'"$contents"
  fi

  echo "$contents"
}

# =========================
# CLI
# =========================

if [[ "${1:-}" != "" ]]; then
  processor "$1"
fi



# processor(file)

#   type = detect(file) => file = user_module.js => type = module
#   hub = readhub(type) => a json with some default values, imports and permissions

#   contents = readFile(file)

#   processedFile = processFile(contents, hub)


#   return processedFile


# readhub(type)

#   hub = readJson(hub_type_file)

#   return hub


#  processFile(contents, hub)

#   processedContents = applyHub(contents, hub)  based on hub => see hub map bellow

#   return processedContents



# hubMap = [
#   {
#     name: 'module_hub',
#     defaults: [
#       { resolved: = false },
#       { ready:    = false },
#       { isLoaded: = false },
#     ]
#     imports: [
#       {
#         modules: [
#           'base*',  => imports all base files in /lib/base
#           'render'  => import only render module
#         ],
#        controllers: [
#         'home'      => import only home controller
#         'admin*'    => imports all controllers in /app/controllers/admin
#        ]
#       }
#     ]
#   }
# ]


# applyHub(contents, hub)

# loop on hub object
# when defaults
#   finds for var name and value in #loaded = false and this.isLoaded = true formats and change it for denined ones
# when
#   imports
#     1 - loop on it keys
#     2 - Append a JS import code for designed file. => home_controller.js
#     3 - If the item key ends in *, like admin*:
#       3.1 - The script must find the correspondent folder and list
#             all files matching import key => controllers
#       3.2 - Append a JS import code for all returned file. => home_controller.js, users_controler.js

# return processedContents
