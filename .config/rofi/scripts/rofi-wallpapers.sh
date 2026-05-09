#!/bin/bash

DIR="$HOME/Pictures/wallpapers"
CACHE_DIR="$DIR/.cache/rofi_wallpapers"
mkdir -p "$CACHE_DIR"

set_wallpaper() {
    cp "$1" "/tmp/current_wallpaper" &

    awww img "$1" --transition-type random &
    matugen image "$1" --prefer lightness &
}

# Background Cleanup (Quietly removes thumbnails for deleted wallpapers)
comm -23 <(ls -p "$CACHE_DIR" | grep -v / | sort) <(ls -p "$DIR" | grep -v / | sort) | while read -r old_thumb; do
    [[ -f "$CACHE_DIR/$old_thumb" ]] && rm "$CACHE_DIR/$old_thumb"
done &>/dev/null &

# Mapfile to store all wallpaper paths in an array
mapfile -d '' ALL_FILES < <(find "$DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0 | sort -z)

list_wallpapers() {
    for img in "${ALL_FILES[@]}"; do
        filename=$(basename "$img")
        thumb="$CACHE_DIR/$filename"

        # Generate thumbnail if it doesn't already exist in the cache
        if [ ! -f "$thumb" ]; then
            magick "$img" -thumbnail 320x180^ -gravity center -extent 320x180 -quality 60 -strip "$thumb" &
            icon="$img"
        else
            icon="$thumb"
        fi

        # Format the display name
        display_name=$(echo "$filename" | sed 's/\.[^.]*$//; s/[_-]/ /g' | perl -ne 'print join " ", map {ucfirst} split')

        # Output display name, thumbnail as icon, and the FULL path as hidden info
        echo -en "$display_name\0icon\x1f$icon\x1finfo\x1f$img\n"
    done
}

selection_idx=$(list_wallpapers | rofi -dmenu -format 'i' -config ~/.config/rofi/configs/wallpapers.rasi -p "󰸉  WALLPAPERS")

if [[ -n "$selection_idx" && "$selection_idx" -ge 0 ]]; then
    set_wallpaper "${ALL_FILES[$selection_idx]}"
fi
