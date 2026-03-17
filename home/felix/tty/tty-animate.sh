#!/bin/sh
set -e

MSG="Press Enter to enable this console..."
tput civis
trap 'tput cnorm; clear' EXIT

spaces=0
step=20
cycles=0
sleep_time=0.1   # typing speed per character

while true; do
    tput clear

    # Print spaces first
    printf "%*s" "$spaces" ""
    
    i=1
    while [ $i -le $(echo -n "$MSG" | wc -c) ]; do
        printf "%s" "$(echo "$MSG" | cut -c $i)"
        i=$((i + 1))
        sleep "$sleep_time"
    done
    printf "\n"

    # Move spaces
    spaces=$((spaces + step))
    cycles=$((cycles + 1))
    [ "$cycles" -ge 40 ] && spaces=0 && cycles=0

    sleep 5
done