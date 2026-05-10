#!/bin/bash

clear

BLUE="\e[44m"
WHITE="\e[97m"
DIM="\e[2m"
RESET="\e[0m"

center_bar() {
    local message="$1"
    local cols=$(tput cols)
    local padding=$(( (cols - ${#message}) / 2 ))

    printf "${BLUE}${WHITE}%*s%s%*s${RESET}\n" \
        "$padding" "" "$message" "$padding" ""
}

short_uptime() {
    uptime | sed 's/.*up \([^,]*\), .*load average: \(.*\)/UP \1 | LOAD \2/'
}

center_bar "4248 SYSTEMS UNIX/386 RELEASE 4.2"
echo ""
echo "(C) 4248 Systems, a part of 0x4248"
echo "Under the GNU General Public License v3.0"
echo ""
printf "HOSTNAME      %s\n" "$(uname -n)"
printf "TERMINAL      %s\n" "$(tty)"
printf "USER          %s\n" "$USER"
printf "LOGIN TIME    %s\n" "$(date)"
printf "KERNEL        %s\n" "$(uname -sr)"
printf "IP ADDRESS    %s\n" "$(ip addr show | awk '/inet / && !/127.0.0.1/ {print $2}' | head -n 1)"
short_uptime

echo ""
printf "MEMORY\n"
free -h | awk '
NR==1 {next}
NR==2 {
    printf "  RAM   USED %-8s FREE %-8s TOTAL %-8s\n", $3, $4, $2
}
NR==3 {
    printf "  SWAP  USED %-8s FREE %-8s TOTAL %-8s\n", $3, $4, $2
}'

echo ""
last -a -T -n 2 | head -n 5
free -h | awk 'NR==1{next} NR==2{printf "RAM   USED %-8s FREE %-8s TOTAL %-8s\n", $3, $4, $2} NR==3{printf "SWAP  USED %-8s FREE %-8s TOTAL %-8s\n", $3, $4, $2}'
echo ""
center_bar "*** BEGIN SESSION ***"

echo 500 > /dev/ttyACM0
sleep 0.1
echo 0 > /dev/ttyACM0

echo ""
source ~/.bashrc