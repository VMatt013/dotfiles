#!/bin/sh

run() {
	if ! pgrep -f "$1"; then
		"$@" &
	fi
}

#run "mount" /dev/nvme0n1p4 /media/win-c &
#run "mount" /dev/nvme0n1p3 /media/win-d &
run "autorandr" -c
run "picom" &
#run "kdeconnect-indicator"
run "nm-applet"
run "blueman-applet"
# run "1password" --silent
# run "nitrogen" --restore &
# run "xautolock -time 10 -locker "awesome-client 'awesome.quit()'" "
# run "" &
