#!/bin/bash

PIDFILE="/tmp/wl-screenrec.pid"
OUTDIR="$HOME/Videos/Recordings"
mkdir -p "$OUTDIR"

if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")

  kill -INT "$PID"
  rm "$PIDFILE"

  notify-send "Recording stopped"
else
  defaultMonitor="$(pactl get-default-sink).monitor"
  FILE="$OUTDIR/rec-$(date +%Y-%m-%d_%H-%M-%S).mp4"

  if pactl list short sources | awk '{print $2}' | grep -Fxq "$defaultMonitor"; then
    echo "$defaultMonitor $FILE $LIBVA_DRIVER_NAME" >>/tmp/rec.log
    env -u LIBVA_DRIVER_NAME wl-screenrec --audio --audio-device "$defaultMonitor" -f "$FILE" &
  else
    env -u LIBVA_DRIVER_NAME wl-screenrec -f "$FILE" &
  fi

  echo $! >"$PIDFILE"
  notify-send "Recording started"
fi
