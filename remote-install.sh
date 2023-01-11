#!/usr/bin/env bash

set -e

SOURCE="https://github.com/cauethenorio/dotfiles"
TARGET="$HOME/dev/dotfiles"

GREEN="\033[0;32m"
NC="\033[0m" # No color
CYAN="\033[0;36m"

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
echo -e "\n${GREEN}dotfiles installed 🎉${NC}"

echo -e "\n${CYAN}Now you can chdir to the dotfiles dir with:${NC}"
echo "cd ${TARGET}"

echo -e "\n${CYAN}And install everything by running:${NC}"
echo "make install"

echo -e "\n${CYAN}Or use the 'make' command to choose what to install:${NC}"
echo "cd $TARGET"
echo make list

