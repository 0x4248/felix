#!/bin/bash

rows=$(tput lines)
cols=$(tput cols)

chars=('0' '1' '2' '3' '4' '5' '6' '7' '8' '9' \
       'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' \
       'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' \
       'W' 'X' 'Y' 'Z' '!' '@' '#' '$' '%' '&' '*' \
       '+' '-' '=' '?' )
for r in {0..3}; do
    screen=""
    for i in $(seq 1 $rows); do
        line=""
        for j in $(seq 1 $cols); do
            line="${line}${chars[$RANDOM % ${#chars[@]}]}"
        done
        screen="${screen}${line}\n"
    done
    echo -e "$screen"
    sleep 0.05
done
sleep 1
clear
