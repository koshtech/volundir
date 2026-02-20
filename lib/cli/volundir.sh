#!/usr/bin/env bash

set -euo pipefail

BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"
export BASE_PATH

HUB_DIR="$BASE_PATH/hubs"
# LOCALE=${LOCALE:-pt_BR}
LOCALE=${LANGUAGE:-pt_BR}
# ----------------------------------------------------------
# Load Environment
# ----------------------------------------------------------

if [[ -f "$BASE_PATH/.env" ]]; then
  export $(grep -v '^#' "$BASE_PATH/.env" | xargs)
fi


# ----------------------------------------------------------
# Help Loader
# ----------------------------------------------------------

show_help() {
  local help_file_json="$BASE_PATH/lib/locales/volundir.sh.${LOCALE}.json"
  local help_file_txt="$BASE_PATH/lib/locales/volundir.sh.${LOCALE}.txt"

  if [[ -f "$help_file_json" ]]; then
    jq -r '.help' "$help_file_json"
  elif [[ -f "$help_file_txt" ]]; then
    cat "$help_file_txt"
  else
    echo "Help not available for locale: $LOCALE"
  fi
}

# ----------------------------------------------------------
# Command Router
# ----------------------------------------------------------

command="${1:-}"

case "$command" in
  server|s)
    # ----------------------------------------------------------
    # Load Module
    # ----------------------------------------------------------
    source "$BASE_PATH/lib/server/server.sh"

    start_server
    ;;
  process|p)
    [[ -z "${2:-}" ]] && { echo "Missing file"; exit 1; }
    # ----------------------------------------------------------
    # Load Module
    # ----------------------------------------------------------
    source "$BASE_PATH/lib/cli/processor.sh"

    processor "$2"
    ;;
  build|b)
    [[ -z "${2:-}" ]] && { echo "Missing file"; exit 1; }
    # ----------------------------------------------------------
    # Load Module
    # ----------------------------------------------------------
    echo "[volundir][build] $3: ${3}"
    source "$BASE_PATH/lib/cli/processor.sh"
    source "$BASE_PATH/lib/builder/build.sh"

    build_file "$3"
    ;;
  --help|-h|"")
    show_help
    ;;
  *)
    echo "Unknown command: $command"
    show_help
    exit 1
    ;;
esac
