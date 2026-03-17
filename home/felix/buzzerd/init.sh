#!/usr/bin/env bash
set -euo pipefail

# Init helper for buzzer: ensures pipe exists, permissions are set and
# starts the Python daemon if it isn't already running.

BASE_DIR="/root/felix/buzzerd"
SERIAL="/dev/ttyACM0"
PIPE="/dev/buzzer"

# Give serial device permissions if present
if [ -e "$SERIAL" ]; then
    chmod a+rw "$SERIAL" || true
    stty -F "$SERIAL" 115200 raw -echo || true
else
    echo "Warning: serial device $SERIAL not present yet" >&2
fi

# Create named pipe if it doesn't exist
if [ ! -p "$PIPE" ]; then
    mkfifo "$PIPE"
    chmod 0666 "$PIPE"
    echo "Created pipe $PIPE"
fi

# Start Python daemon if not already running
if ! pgrep -f "[b]uzzerd.py" >/dev/null; then
    # Do not background here if systemd/front-end will manage the service.
    # Start in background for compatibility with the current setup.
    nohup python3 "$BASE_DIR/buzzerd.py" >/var/log/felix-buzzerd.log 2>&1 &
    echo "Started buzzerd.py (pid $!)"
else
    echo "buzzerd.py already running"
fi

echo "buzzerd init complete"
