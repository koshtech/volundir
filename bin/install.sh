#!/usr/bin/env bash
# Volundir Installer Script

INSTALL_PROFILE="$1"

echo "

 [:Volundir][:PWA] Welcome!

 The Installer Script is now starting...

 Thanks for choosing our love software.

"
echo " [:Installer][:Dependencies] Verifying system dependencies..."

# Checks operating system dependencies
for cmd in git ruby curl tar; do
  echo -n "  checking for $cmd ..."
  if ! command -v "$cmd" &> /dev/null; then
    echo -n ": Not found"
    echo ""
    echo "   Error: The required command '$cmd' was not found."
    echo "   Please install it using your system's package manager (apt, brew, yum)."
    echo ""
    echo " [:Installer][:Dependencies] Dependency not found $cmd."
    exit 1
  fi
  echo ": Present"
done

echo " [:Installer][:Dependencies] Dependencies verified successfully."

echo " [:Installer][:Downloader] Downloading '$INSTALL_PROFILE' install profile..."

mkdir -p "$HOME/tmp"

curl -sSL https://raw.githubusercontent.com/koshtech/volundir/refs/heads/main/config/setup/$INSTALL_PROFILE_provile.env -o "$HOME/tmp/$INSTALL_PROFILE_profile.env"

echo -n " Done."
echo " [:Installer][:Environment] Loading '$INSTALL_PROFILE' profile..."

source "$HOME/tmp/${INSTALL_PROFILE}_profile.env"

export BASE_URL\
  INGOTS\
  KOSHTECH_HOME\
  VOLUNDIR_ROOT\
  INGOTS_ROOT

# Creates the local structure
mkdir -p "$KOSHTECH_HOME"
mkdir -p "$INGOTS_ROOT"

for repo in $INGOTS; do
  if [ -d "$INGOTS_ROOT/$repo" ]; then
    echo "==> [:$repo] already installed at $INGOTS_ROOT/$repo. Updating..."
    cd "$INGOTS_ROOT/$repo" && git pull
  else
    echo "==> Downloading [:$repo] to $INGOTS_ROOT/$repo..."
    git clone "$BASE_URL/$repo.git" "$INGOTS_ROOT/$repo"
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
