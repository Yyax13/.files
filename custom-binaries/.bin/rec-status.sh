#!/bin/bash

if [ -f "/tmp/wl-screenrec.pid" ]; then
  echo '{"text":"","class":"active"}'
else
  echo '{"text":"","class":"inactive"}'
fi
