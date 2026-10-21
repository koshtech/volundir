#!/usr/bin/env bash
# Volundir Installer Script

# KOSHTECH_REPO_URL="https://github.com/koshtech/koshtech-base.git"
KOSHTECH_HOME="${KOSHTECH_HOME:-$HOME/.koshtech}"

VOLUNDIR_REPO_BASE_URL="https://github.com/koshtech/"
VOLUNDIR_REPO_LIST="koshtech-base volundir volundir-bash volundir-help-base volundir-ruby volundir-ruby-server"
VOLUNDIR_ROOT="${VOLUNDIR_ROOT:-$HOME/.koshtech/volundir}"

INGOTS_ROOT="${KOSHTECH_HOME:-$HOME/.koshtech/ingots}"

echo "==> Verifying system dependencies..."

# Checks operating system dependencies
for cmd in git ruby curl tar; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: The required command '$cmd' was not found."
    echo "Please install it using your system's package manager (apt, brew, yum)."
    exit 1
  fi
done

echo "==> Dependencies verified successfully."

# Creates the local structure
mkdir -p "$KOSHTECH_HOME"
mkdir -p "$INGOTS_ROOT"

for repo in $VOLUNDIR_REPO_LIST; do
  if [ -d "$INGOTS_ROOT/$repo" ]; then
    echo "==> [:$repo] already installed at $INGOTS_ROOT/$repo. Updating..."
    cd "$INGOTS_ROOT/$repo" && git pull
  else
    echo "==> Downloading [:$repo] to $INGOTS_ROOT/$repo..."
    git clone "$VOLUNDIR_REPO_BASE_URL/$repo.git" "$INGOTS_ROOT/$repo"
  fi
done

# Transitions to the Ruby installation script
cd "$KOSHTECH_HOME"

if [ -f "bin/setup" ]; then
  echo "==> Handing over to Ruby installer script..."
  bundle install
  ruby bin/setup
else
  echo "==> Volundir installed successfully!"
  echo "Add 'export PATH=\"\$HOME/.koshtech/bin:\$PATH\"'' to your .bashrc / .zshrc"
fi
