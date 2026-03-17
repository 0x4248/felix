#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/root/felix"

if [ -x "$BASE_DIR/buzzerd/init.sh" ]; then
	bash "$BASE_DIR/buzzerd/init.sh"
else
	echo "Warning: buzzerd/init.sh not found or not executable: $BASE_DIR/buzzerd/init.sh" >&2
fi

sleep 0.5

if [ -x "$BASE_DIR/buzzerd/startup-tone.sh" ]; then
	bash "$BASE_DIR/buzzerd/startup-tone.sh" &
else
	echo "Warning: buzzerd/startup-tone.sh not found or not executable" >&2
fi

bash "$BASE_DIR/tty/startup-anim.sh"

echo "Felix init done"
