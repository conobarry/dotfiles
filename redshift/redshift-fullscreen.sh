#!/bin/bash

MATCH_NAMES=("SMPlayer")

rsPid="$(pgrep -o redshift)"
if [[ "$rsPid" == "" ]]; then
	echo "Please run redshift first"
	exit
fi

monitorFullscreen() {
	full="0"
	while read state ; do
		if [[ "$full" == "0" && \
                      "$state" =~ "_NET_WM_STATE_FULLSCREEN" && \
                      "$state" =~ "_NET_WM_STATE_FOCUSED" ]]; then
			kill -USR1 "$rsPid"
			full="1"
		else
			if [[ "$full" == "1" ]]; then
				kill -USR1 "$rsPid"
				full="0"
			fi

			if [[ ! "$state" =~ "_NET_WM_STATE_FOCUSED" ]]; then
				return
			fi
		fi
	done < <(xprop -notype -spy -id "$window" 32a _NET_WM_STATE | stdbuf -oL uniq)
}

shopt -s nocasematch
while read window ; do
	name="$(xprop -notype -id "$window" 8s ':$0\n' WM_NAME)"
	for match in "${MATCH_NAMES[@]}" ; do
		if [[ "$name" =~ "$match" ]]; then
			monitorFullscreen
			break
		fi
	done
done < <(xprop -notype -root -spy 32x ':$0\n' _NET_ACTIVE_WINDOW | stdbuf -oL uniq | stdbuf -oL awk -F: '{print $2}')            
