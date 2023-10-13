#!/bin/bash
export wallpaper=$(find ~/pictures/wallpapers -type f \( -iname \*.jpg -o -iname \*.png \) | shuf -n1)
nitrogen --set-zoom-fill $wallpaper --head=0 --save
nitrogen --set-zoom-fill $wallpaper --head=1 --save
wal -i $wallpaper
sleep .1
nitrogen --restore
qtile cmd-obj -o cmd -f reload_config
