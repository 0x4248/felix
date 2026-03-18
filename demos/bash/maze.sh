I=0
while true; do
    PICK=$((RANDOM%6))
    if [ $PICK == 0 ]; then
        printf "┌"
    elif [ $PICK == 2 ]; then 
        printf "└"
    elif [ $PICK == 3 ]; then
        printf "┐"
    elif [ $PICK == 4 ]; then
        printf "┘"
    elif [ $PICK == 5 ]; then
        printf "|"
    else
        printf "-"
    fi
    echo $(($PICK*100)) > /dev/buzzer
    sleep 0.003
    if [ $I -gt 1000 ]; then
        sleep 2
        I=0
        for J in {0..30}; do
            echo 
            echo $((J*100)) > /dev/buzzer 
            sleep 0.02
        done
    fi    

    I=$(($I+1))
done

