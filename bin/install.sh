#!/usr/bin/env bash
# Volundir Installer Script

INSTALL_PROFILE="$1"

echo -e "\n [:Volundir][:PWA] Welcome!

 Thanks for choosing our loved software!

 The Installer Script is now starting...\n"
echo -e " [:Installer][:Dependencies] Verifying system dependencies...\n"

# Checks operating system dependencies
for cmd in git ruby curl tar; do
  echo -n "  checking for ${cmd} ..."
  if ! command -v "$cmd" &> /dev/null; then
    echo -n ": Not found"
    echo -e "\n   Error: The required command '${cmd}' was not found."
    echo -e "   Please install it using your system's package manager (apt, brew, yum).\n"
    echo -e " [:Installer][:Dependencies] Dependency not found ${cmd}.\n"
    exit 1
  fi
  echo ": Present"
done

echo -e "\n [:Installer][:Dependencies] Dependencies verified successfully."

echo -n " [:Installer][:Downloader] Downloading '${INSTALL_PROFILE}' install profile..."

mkdir -p "$HOME/tmp"
# curl -sSL https://raw.githubusercontent.com/koshtech/volundir/refs/heads/main/config/setup/${INSTALL_PROFILE}_provile.env -o "$HOME/tmp/${INSTALL_PROFILE}_profile.env"

echo " Done."

echo -n " [:Installer][:Environment] Loading '${INSTALL_PROFILE}' profile..."

source "$HOME/tmp/${INSTALL_PROFILE}_profile.env"

echo " Done."
echo -n " [:Installer][:Environment] Creating local structure..."

mkdir -p "$KOSHTECH_HOME"
mkdir -p "$KOSHTECH_HOME/bin"
mkdir -p "$INGOTS_ROOT"

echo " Done."

echo -e " [:Installer][:Downloader] Downloading essential Ingots...\n"

for repo in $INGOTS; do
  if [ -d "${INGOTS_ROOT}/${repo}" ]; then
    echo -n " [:Installer][:Downloader][:$repo] already installed at ${INGOTS_ROOT}/${repo}... Updating..."
    cmdout=$(cd "${INGOTS_ROOT}/${repo}" && git pull 2>&1)
    es=$?

    if ((es)); then
      echo >&2 "$cmdout"
    else
      echo " Done"
    fi
  else
    echo -n " [:Installer][:Downloader] Downloading [:$repo] to $INGOTS_ROOT/$repo..."

    cmdout=$(git clone "${BASE_URL}/${repo}.git" "${INGOTS_ROOT}/${repo}" 2>&1)
    es=$?

    if ((es)); then
      echo >&2 "$cmdout"
    else
      echo " Done"
    fi
  fi
done

echo -e " [:Installer] Essential Ingots installed.\n"

echo -n " [:Installer][:Ruby] Creating Ruby Env..."
cd "${KOSHTECH_HOME}"

for bin_link in $BIN_LINKS; do
  ln -sf "${INGOTS_ROOT}/${bin_link}" "${KOSHTECH_HOME}/bin/"
done

for cp_files in $CP_ROOT_FILES; do
  cp  "${INGOTS_ROOT}/${cp_files}" "${KOSHTECH_HOME}/"
done

echo -e " Done.\n"

# Transitions to the Ruby installation script
if [ -f "bin/setup" ]; then
  echo "==> Handing over to Ruby installer script..."
  bundle install
  echo " [:Installer][:Ruby] Launching Ruby Setup..."
  ruby bin/setup
else
  echo "==> Volundir installed successfully!"
  echo "Add 'export PATH=\"\$HOME/.koshtech/bin:\$PATH\"'' to your .bashrc / .zshrc"
fi
