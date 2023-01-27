#!/bin/sh

# don't hide the icon
defaults write "com.mowglii.ItsycalApp" "HideIcon" -bool false

# use icon with outline
defaults write "com.mowglii.ItsycalApp" "UseOutlineIcon" -bool true

# show month name in the icon
defaults write "com.mowglii.ItsycalApp" "ShowMonthInIcon" -bool true

# highlight Sunday and Saturday
defaults write "com.mowglii.ItsycalApp" "HighlightedDOWs" -int 65

# Start at login
osascript -e 'tell application "System Events" to make login item at end with properties {name: "Itsycal", path:"/Applications/Itsycal.app", hidden:false}'
