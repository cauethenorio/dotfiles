#!/bin/sh

# paste by default
defaults write "org.p0deje.Maccy" "pasteByDefault" -bool true

# remove formatting on paste
defaults write "org.p0deje.Maccy" "removeFormattingByDefault" -bool true

# Open menu with Shift+Command+V
defaults write "org.p0deje.Maccy" "KeyboardShortcuts_popup" '"{\"carbonModifiers\":768,\"carbonKeyCode\":9}"'

# Increase history size to 999 items
defaults write "org.p0deje.Maccy" "historySize" -int 999

# Do not take focus from current focused app
defaults write "org.p0deje.Maccy" "avoidTakingFocus" -bool true

# Start at login
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Maccy", path:"/Applications/Maccy.app", hidden:false}'
