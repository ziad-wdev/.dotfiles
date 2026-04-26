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
