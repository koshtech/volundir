
if command -v ruby >/dev/null 2>&1; then
  EXECUTOR="ruby"
  SERVER=""
elif command -v php >/dev/null 2>&1; then
  EXECUTOR="php"
else
  echo "No executor found."
  exit 1
fi
