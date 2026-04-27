source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

function qed
    set meta_deps (
        for pkg in (pacman -Qetq | grep '^00-')
            pactree -u -d 1 $pkg | grep -v '^00-'
        end | sort
    )
    set non_meta_deps (comm -23 (pacman -Qeq | sort | psub) (pacman -Qetq | sort | psub) | sort)

    # Use printf to convert the list variables into a stream for comm
    comm -23 (printf "%s\n" $non_meta_deps | psub) (printf "%s\n" $meta_deps | psub) | sort
end

function qet
    pacman -Qetq | sort
end

function wal
    if test -f "$argv[1]"
        # 1. Set wallpaper
        awww img "$argv[1]" --transition-type random
        
        # 2. Sync with Matugen
        matugen image "$argv[1]" --prefer lightness
        
        # 3. Update symlink for hyprlock
        ln -sf (realpath "$argv[1]") /tmp/current_wallpaper.png
        
        echo "Wallpaper and theme updated successfully!"
    else
        echo "Usage: change_wallpaper <path_to_image>"
    end
end

fish_add_path /home/ziad/.spicetify
