#!/usr/bin/env bash

set -e

if ! which dockutil; then

  # Calculate last release package name
  PKG_NAME=$(curl -s https://api.github.com/repos/kcrawford/dockutil/releases/latest \
    | grep "dockutil-.*\.pkg\"" \
    | head -1 | cut -d : -f 2,3 | tr -d \" | tr -d ,| xargs )

  # Build download URL
  DOWNLOAD_URL="https://github.com/kcrawford/dockutil/releases/latest/download/${PKG_NAME}"

  # Create a temporary file
  TEMP_DIR=$(mktemp -d "dockutil.XXXX")

  # Remove temporary dir on exist
  trap 'rm -rf $TEMP_DIR' EXIT

  # Download release to temporary file
  curl -L --max-redirs 5 -sS "$DOWNLOAD_URL" -o "$TEMP_DIR/dockutil.pkg"

  # Perform Install
  sudo installer -pkg "$TEMP_DIR/dockutil.pkg" -target /

fi

dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add '~/Downloads' --view grid --display stack

killall Dock
