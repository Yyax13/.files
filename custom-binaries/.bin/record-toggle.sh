#!/bin/bash

PIDFILE="/tmp/wf-recording.pid"
OUTDIR="$HOME/Videos/Recordings"
mkdir -p "$OUTDIR"

if [ -f "$PIDFILE" ]; then
  kill $(cat "$PIDFILE")
  rm "$PIDFILE"
  notify-send "Recording stopped"
else
  defaultMonitor="$(pactl get-default-sink).monitor"
  FILE="$OUTDIR/rec-$(date +%Y-%m-%d_%H-%M-%S).mp4"

  if pactl list short sources | awk '{print $2}' | grep -Fxq "$defaultMonitor"; then
    wf-recorder --audio="$defaultMonitor" -f "$FILE" &
    echo $! >"$PIDFILE"
    notify-send "Recording started"
  else
    wf-recorder -f "$FILE" &
    echo $! >"$PIDFILE"
    notify-send "Recording started"
  fi

fi
