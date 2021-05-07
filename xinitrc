#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export QT_QPA_PLATFORMTHEME="qt5ct"
#export DESKTOP_SESSION=plasma
#export KDEWM=/usr/bin/awesome

#sxhkd & # hotkeys
#picom -b & # compositor
#autorandr --change # automatically setup monitors

. ~/.config/xbindkeys/reload.sh # reload xbindkeys
xmodmap ~/.Xmodmap

#run redshift -c ~/.config/redshift/redshift.conf
#run picom -b -c # run compositor

python3 ~/.screenlayout/autodetect.py

xbindkeys &
. ~/.config/redshift/redshift.sh enable 0 1
#redshift -c ~/.config/redshift/redshift.conf &

# Music server
mopidy &

# Mount google drive
rclone mount gdrive: ~/usr/cloud/ --vfs-cache-mode full &

# Start window manager
exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr

#exec bspwm
#exec i3
#exec startplasma-x11
