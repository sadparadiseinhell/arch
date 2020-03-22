#!/bin/bash

OPT="$(echo -e "lock\nlogout\nsuspend\nhibernate\nreboot\npoweroff" | dmenu -p "power menu  ")"
execute () {
	case $OPT in
		h*|r*|s*) ACTION="systemctl $OPT" ;;
		p*) ACTION="$(paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga' | systemctl $OPT)" ;;
		lock) ACTION="$HOME/scripts/lock.sh" ;;
		logout) ACTION="/usr/bin/killall xinit" ;;
	esac

	if [[ $CONFIRM = "yes" ]]; then
		$ACTION
	elif [[ $CONFIRM = "no" ]]; then
		echo ':('
	fi
}

confirm () {
	if [[ -z $OPT ]]; then
		exit 0
	else
		CONFIRM=$(echo -e "no\nyes" | dmenu -p "$OPT  ")
	fi
}

confirm && execute

exit 0