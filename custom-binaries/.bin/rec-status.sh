#!/bin/bash

if [ -f /tmp/wf-recording.pid ]; then
    echo '{"text":"","class":"active"}'
else
    echo '{"text":"","class":"inactive"}'
fi
