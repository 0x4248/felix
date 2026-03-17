#!/usr/bin/env bash
set -euo pipefail

PIPE=/dev/buzzer

if [ ! -p "$PIPE" ]; then
	echo "Pipe $PIPE does not exist; skipping startup tone" >&2
	exit 0
fi

for i in {0..5}; do
	for j in {0..3}; do
		printf "%s\n" $((j * 300)) > "$PIPE"
		sleep 0.02
	done
done

printf "0\n" > "$PIPE"
