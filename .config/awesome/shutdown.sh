#!/bin/sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}
run "umount" /media/win-c
run "umount" /media/win-d
#run "/sbin/shutdown" now & 
# run "" &
