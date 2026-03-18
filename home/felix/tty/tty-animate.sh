#!/bin/sh
set -e

MSG="TITAN DATA SYSTEM | FELIX CONSOLE"
MSG2="INIT TERM BY PRESSING ENTER"
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
    
    i=1    # Move spaces
    echo $MSG
    echo $MSG2
    spaces=$((spaces + step))
    cycles=$((cycles + 1))
    [ "$cycles" -ge 40 ] && spaces=0 && cycles=0

    sleep 30
done
