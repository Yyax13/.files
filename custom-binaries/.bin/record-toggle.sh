#!/bin/bash

PIDFILE="/tmp/wl-screenrec.pid"
OUTDIR="$HOME/Videos/Recordings"

mkdir -p "$OUTDIR"

if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")

  if kill -0 "$PID" 2>/dev/null; then
    kill -INT "$PID"
    notify-send "Recording" "Stopping recording..."
  fi

  rm -f "$PIDFILE"
  exit 0
fi

defaultMonitor="$(pactl get-default-sink).monitor"
FILE="$OUTDIR/rec-$(date +%Y-%m-%d_%H-%M-%S).mp4"

ARGS=(
  --filename "$FILE"
  --encode-resolution 1920x1080
  --encode-pixfmt yuv420p
  --max-fps 60
  --no-damage
  --ffmpeg-encoder libx264
  --ffmpeg-encoder-options "preset=medium,crf=18"
  --audio-codec aac
  --audio-bitrate "24 kB"
)

if pactl list short sources | awk '{print $2}' | grep -Fxq "$defaultMonitor"; then
  ARGS+=(--audio --audio-device "$defaultMonitor")
fi

env -u LIBVA_DRIVER_NAME wl-screenrec "${ARGS[@]}" &

echo $! >"$PIDFILE"
notify-send "Recording" "Recording started"
