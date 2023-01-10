#!/usr/bin/env bash

set -e

SOURCE="https://github.com/cauethenorio/dotfiles"
TARGET="$HOME/dev/sdotfiles"

GREEN="\033[0;32m"
NC="\033[0m" # No color

is_executable() {
  type "$1" > /dev/null 2>&1
}

if is_executable "git"; then
  CMD="git clone $SOURCE $TARGET";
else
  echo "No git available. Aborting."
  exit 1
fi

echo "Installing dotfiles..."
mkdir -p "$TARGET"
eval "$CMD"
echo -e "\ndotfiles installed 🎉"

echo -e "\nUse the make command to choose what install:"
cd "$TARGET"
make list
