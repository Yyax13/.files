#!/bin/bash

PIDFILE="/tmp/wf-recording.pid"
OUTDIR="$HOME/Videos/Recordings"
mkdir -p "$OUTDIR"

if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE")
    rm "$PIDFILE"
    notify-send "Recording stopped"
else
    FILE="$OUTDIR/rec-$(date +%Y-%m-%d_%H-%M-%S).mp4"
    wf-recorder -f "$FILE" &
    echo $! > "$PIDFILE"
    notify-send "Recording started"
fi
