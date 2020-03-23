#!/bin/bash

MENU=$(echo -e 'link\nlocal' | dmenu -p 'link/local:  ')

local_storage () {
	DIR="$HOME/movies/"
	CHOSEN="$(ls $DIR | dmenu -l 5 -p 'select video  ')"
	if [[ "$CHOSEN" = *.mkv ]]; then
		mpv "$DIR$CHOSEN"
	elif [[ -d "$DIR$CHOSEN" ]]; then
		cd "$DIR$CHOSEN"
		mpv *{.mkv,.avi,.mp4}
	else
		exit 0
	fi
}

by_link () {
	choice=$( (echo 1 | grep 0) | dmenu -p 'paste a link to a video  ')
	if [[ -n $choice ]]; then
		mpv --ytdl-format="[height=720]" $choice
	else
		exit 0
	fi
}

case $MENU in
	link)
		by_link
		;;
	local)
		local_storage
		;;
	*)
		exit 0
		;;
esac