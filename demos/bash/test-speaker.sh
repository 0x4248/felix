sound 700
sleep 0.5
sound 800
sleep 0.5
sound 950
sleep 0.2
sound 900
sleep 0.5
sound 600
sleep 1
for i in {0..4}; do
    for j in {0..10}; do
        sound $(($j*100))
        sleep 0.005
    done
done


d=10

for ((t=0; t<400; t+=1)); do
    hz=$(echo "1000+500 *l($t/100)" | bc -l)
    sound ${hz%.*}
done
for j in {1..5}; do
    for i in {0..10}; do
        for ((t=0; t<250; t+=10)); do
            hz=$(echo "1000+500 *l(($t/($j/2))/100)" | bc -l)
            sound ${hz%.*}
        done
    done
done

for i in {0..200}; do
    sound $((($RANDOM%100)*50))
    sleep 0.002
done


for i in {0..500}; do
    sound $(($RANDOM%1000))
    sleep 0.0001
done

for i in {0..200}; do
    sound $((($RANDOM%10)*500))
    sleep 0.002
done

for i in {0..5}; do
    for j in {0..10}; do
        sound 1000
        sleep 0.01
        sound 400
        sleep 0.01
    done
    for j in {0..10}; do
        sound 600
        sleep 0.01
        sound 500
        sleep 0.01
    done
done

sound 800
sleep 0.5
sound 400
sleep 0.5
mute
