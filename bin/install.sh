#!/usr/bin/env bash
# Volundir Installer Script

INSTALL_PROFILE="$1"

echo -e "\n [:Volundir][:PWA] Welcome!

 Thanks for choosing our loved software!

 The Installer Script is now starting...\n"
echo -e " [:Installer][:Dependencies] Verifying system dependencies...\n"

# Checks operating system dependencies
for cmd in git ruby curl tar; do
  echo -n "  checking for $cmd ..."
  if ! command -v "$cmd" &> /dev/null; then
    echo -n ": Not found"
    echo -e "\n   Error: The required command '$cmd' was not found."
    echo -e "   Please install it using your system's package manager (apt, brew, yum).\n"
    echo -e " [:Installer][:Dependencies] Dependency not found $cmd.\n"
    exit 1
  fi
  echo ": Present"
done

echo -e "\n [:Installer][:Dependencies] Dependencies verified successfully."

echo -n " [:Installer][:Downloader] Downloading '$INSTALL_PROFILE' install profile..."

mkdir -p "$HOME/tmp"
curl -sSL https://raw.githubusercontent.com/koshtech/volundir/refs/heads/main/config/setup/$INSTALL_PROFILE_provile.env -o "$HOME/tmp/$INSTALL_PROFILE_profile.env"

echo -n " Done."

echo -n " [:Installer][:Environment] Loading '$INSTALL_PROFILE' profile..."

source "$HOME/tmp/${INSTALL_PROFILE}_profile.env"

export BASE_URL\
  INGOTS\
  KOSHTECH_HOME\
  VOLUNDIR_ROOT\
  INGOTS_ROOT

echo -n " Done."
echo -n " [:Installer][:Environment] Creating local structure..."

mkdir -p "$KOSHTECH_HOME"
mkdir -p "$INGOTS_ROOT"

echo -n " Done."

echo " [:Installer][:Downloader] Downloading essential Ingots..."

for repo in $INGOTS; do
  if [ -d "$INGOTS_ROOT/$repo" ]; then
    echo " [:Installer][:Downloader][:$repo] already installed at $INGOTS_ROOT/$repo. Updating..."
    cd "$INGOTS_ROOT/$repo" && git pull
  else
    echo " [:Installer][:Downloader] Downloading [:$repo] to $INGOTS_ROOT/$repo..."
    git clone "$BASE_URL/$repo.git" "$INGOTS_ROOT/$repo"
  fi
done

echo -n " Done."

echo " [:Installer][:Ruby] launching Ruby Setup..."

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
