#!/usr/bin/env bash

start_server() {

  BACKEND=${BACKEND:-ruby}
  PORT=${PORT:-3020}

  echo "Starting Volundir development server..."
  echo "Backend: $BACKEND"
  echo "Port: $PORT"

  case "$BACKEND" in
    ruby)
      ruby "$BASE_PATH/ingots/volundir-$EXECUTOR/lib/server/$EXECUTOR/server.rb"
      ;;
    *)
      echo "Unknown backend: $BACKEND"
      exit 1
      ;;
  esac
}
