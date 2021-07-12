#!/usr/bin/env bash

function run {
    if ! pgrep -f $1 ;
    then
        $@&
    fi
}

#run autorandr --change

run ~/.config/xbindkeys/reload.sh # reload xbindkeys
run xmodmap ~/.Xmodmap # reload xmodmap
run picom -b -c # run compositor
run feh --bg-tile ~/pictures/wallpapers/solaris_dolphins.png # set wallpaper

run discord
#run python3 .local/bin/beautifuldiscord --css ~/.config/beautifuldiscord/discord-custom.css

#run xrandr --dpi 100 # set dpi
#run python3 ~/.screenlayout/autodetect.py # autodetect screen layout
