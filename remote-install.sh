#!/usr/bin/env bash

set -e

SOURCE="https://github.com/cauethenorio/dotfiles"
TARGET="$HOME/dev/dotfiles"

GREEN="\033[0;32m"
NC="\033[0m" # No color
CYAN="\033[0;36m"


are_command_line_tools_installed() {
  xcode-select -p > /dev/null 2>&1
}

if ! are_command_line_tools_installed; then
  sudo softwareupdate -i -a
  xcode-select --install
fi

while true; do
    if ! are_required_tools_available; then
        echo "Complete the 'Developer Tools' installation to continue. Retrying in 5s..."
        sleep 5
    else
        break
    fi
done

echo "Installing dotfiles..."
git clone "$SOURCE" "$TARGET"

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

