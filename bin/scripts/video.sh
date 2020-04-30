#!/bin/sh

source $HOME/scripts/launcher.sh

MENU=$(echo -e 'local\nlink\ntwitch\nsearch (youtube)\ndownload' | $LAUNCHER -p 'link/local: ')

local_storage () {
	DIR="$HOME/movies/"
	CHOICE="$(ls $DIR | $LAUNCHER -l 5 -p 'select video ')"
	if [[ -n $CHOICE ]] && [[ "$CHOICE" = *.mkv ]]; then
		mpv "$DIR$CHOICE"
		exit 0
	elif [[ -n $CHOICE ]] && [[ -d "$DIR$CHOICE" ]]; then
		cd "$DIR$CHOICE"
		mpv *{.mkv,.avi,.mp4}
		if [[ $? != 0 ]]; then
			cd $(ls $DIR$CHOICE)
			mpv *{.mkv,.avi,.mp4}
			exit 0
		fi
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 'video cannot be opened'
	fi
}

by_link () {
	LINK=$( (echo 1 | grep 0) | $LAUNCHER -p 'paste a link to a video ')
	if [[ -n $LINK ]]; then
		mpv --ytdl-format="[height=720]" $LINK
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 'video cannot be opened'
	fi
}

download () {
	LINK=$(echo | grep 0 | $LAUNCHER -p 'paste a link to a video ')
	if [[ -z $LINK ]]; then
		exit 0
	fi

	cd $HOME/movies
	youtube-dl -f bestvideo[height=1080]+bestaudio[ext=m4a] --merge-output-format mkv $LINK

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 'video cannot be downloaded'
		exit 0
	else
		notify-send -t 2000 'video downloaded'
	fi
}

yt_search () {
	INPUT=$(echo | grep 0 | $LAUNCHER -p 'search ')
	if [[ -n $INPUT ]]; then
		mpv --ytdl-format="bestvideo[height<=1080]+bestaudio" ytdl://ytsearch:"$INPUT"
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 'video cannot be opened'
	fi
}

twitch () {
	LINK=$(echo | grep 0 | $LAUNCHER -p 'paste a link ')
	if [[ -n $LINK ]]; then
		mpv --ytdl-format="720p+bestaudio" $LINK
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 'video cannot be opened'
	fi
}

case $MENU in
	link)
		by_link
		;;
	local)
		local_storage
		;;
	download)
		download
		;;
	search*)
		yt_search
		;;
	twitch)
		twitch
		;;
	*)
		exit 0
		;;
esac
