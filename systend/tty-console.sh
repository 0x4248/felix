#!/bin/sh
set -e


/root/felix/tty/tty-animate.sh &
anim_pid=$!


read -r _
kill "$anim_pid" 2>/dev/null || true

tput cnorm
clear
exec /bin/su - root