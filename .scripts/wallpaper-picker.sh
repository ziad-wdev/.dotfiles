#!/bin/bash

# Directory containing your wallpapers
DIR="$HOME/Pictures/Wallpapers"

# Select wallpaper using rofi
FILE=$(ls "$DIR" | rofi -dmenu -p "Select Wallpaper")

# Set the wallpaper
if [ -n "$FILE" ]; then
    fish -c "wal '$DIR/$FILE'"
fi
