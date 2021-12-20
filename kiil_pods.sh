#!/bin/bash

. ./settings.sh

declare -a pods=("rp-187eb73-0" "rp-187eb73-1" "rp-187eb73-2" "rp-187eb73-3" "rp-187eb73-4" "rp-187eb73-5")

min_sleep_sec=$(( 30 ))
max_sleep_sec=$(( 60 ))
_sleep_range=$(( $max_sleep_sec - $min_sleep_sec ))

while true
do
    len=${#pods[@]}
    index=$(($RANDOM % $len))
    pod=${pods[$index]}
    echo "$( date -u ): deleting $pod"
    $K delete pods "$pod" -n $NAMESPACE

    while true
    do
        runnig_cout=$($K get pods -n $NAMESPACE | awk  '{print $3}' | grep "Running" -c)
        wait_seconds=$(( $RANDOM % $_sleep_range ))
        wait_seconds=$(( $wait_seconds + $min_sleep_sec ))
        sleep 10
        if [ $runnig_cout = "6" ]; then
            break;
        else
            echo "Will sleep $wait_seconds sec"
            sleep $wait_seconds
        fi
    done
done