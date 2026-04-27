source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

function qed
    comm -23 \
        (comm -23 (pacman -Qeq | sort | psub) (pacman -Qetq | sort | psub) | psub) \
        (pactree -ul 00-meta-cachyos -d 1 | sort | psub)
end

function qet
    pacman -Qet
end

function wal
    if test -f "$argv[1]"
        # 1. Set wallpaper
        awww img "$argv[1]" --transition-type random
        
        # 2. Sync with Matugen
        # Determine mode: default to dark, or check a variable
        set -l mode (test "$THEME_MODE" = "light"; and echo "light"; or echo "dark")
                
        # Run matugen with the mode
        matugen image "$argv[1]" -m $mode
        
        # 3. Update symlink for hyprlock
        ln -sf (realpath "$argv[1]") /tmp/current_wallpaper.png
        
        echo "Wallpaper and theme updated successfully!"
    else
        echo "Usage: change_wallpaper <path_to_image>"
    end
end
