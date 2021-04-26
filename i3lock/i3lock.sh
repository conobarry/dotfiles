#!/bin/sh

# Colors are in form #rrggbbaa

insideColor=$transparent        # Default interior color
ringColor=$darkGreen            # Default ring color
insideVerColor=$transparent     # Interior color while password is being verified
ringVerColor=$darkGreen         # Ring color while password is being verified
insideWrongColor=$transparent   # Interior color when password is wrong
ringWrongColor=$red             # Ring color when password is wrong
lineColor=$transparent          # Color for line separating the inside circle and outer ring
separatorColor='#ffffffff'      # Color of the line separating the ring from the keypresss highlights
verifColor='#000000ff'          # Text color while password is being verified
wrongColor='#000000ff'          # Text color when password is wrong
layoutColor=$transparent        # Color of keyboard layout text
timeColor='#000000ff'           # Color of the time string
dateColor='#000000ff'           # Color of the date string
keyHlColor='#000000ff'          # Color of the highlight when a key is pressed
bsHlColor=$red                  # Color of the highlight when backspace is pressed


alpha='dd'
base03='#002b36'
base02='#073642'
base01='#586e75'
base00='#657b83'
base0='#839496'
base1='#93a1a1'
base2='#eee8d5'
base3='#fdf6e3'
yellow='#b58900'
orange='#cb4b16'
red='#dc322f'
magenta='#d33682'
violet='#6c71c4'
blue='#268bd2'
cyan='#2aa198'
green='#859900'

image="/home/conor/usr/pictures/tiles/my-tiles/my-solaris-aghh.png" # Background image
#--tiling --image=$image \

i3lock \
--ignore-empty-password \
--blur=8 \
--screen 1 \
--clock \
--indicator \
--pass-media-keys \
--pass-screen-keys \
--pass-power-keys \
--pass-volume-keys \
--timestr="%H:%M" \
--datestr="%a %-e %b %Y" \
--keylayout 1 \
--locktext="Locking..." \
--wrongtext="Incorrect" \
--veriftext="Verifying" \
--noinputtext="No input" \
--lockfailedtext="Lock failed" \
--radius=100 \
--ring-width=20 \
--timepos="ix:iy-14" \
\
--time-font="Roboto Mono" \
--date-font="Roboto Mono" \
--layout-font="Roboto Mono" \
--verif-font="Roboto Mono" \
--wrong-font="Roboto Mono" \
\
--insidevercolor=$base2$alpha \
--insidewrongcolor=$base2$alpha \
--insidecolor=$base2$alpha \
--ringvercolor=$green$alpha \
--ringwrongcolor=$red$alpha \
--ringvercolor=$green$alpha \
--ringwrongcolor=$red$alpha \
--ringcolor=$blue$alpha \
--line-uses-ring \
--keyhlcolor=$magenta$alpha \
--bshlcolor=$orange$alpha \
--separatorcolor=$base1$alpha \
--verifcolor=$green \
--wrongcolor=$red \
--layoutcolor=$blue \
--datecolor=$blue \
--timecolor=$blue \