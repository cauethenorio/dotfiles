#!/bin/sh

# hide the icon
defaults write com.oliverpeate.Bluesnooze '{hideIcon=1;}'

# Start at login
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Bluesnooze", path:"/Applications/Bluesnooze.app", hidden:false}'
