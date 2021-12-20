#!/bin/bash

. ./settings.sh

TOPIC_NAME="randomtest"

#for ((i = 0; i < $TOPICS; i++))
#do
#    print 
#    source ./create_topic.sh "${TOPIC_NAME}_${i}"
#done


min_sleep_sec=$(( 60 ))
max_sleep_sec=$(( 60 * 3 ))
_sleep_range=$(( $max_sleep_sec - $min_sleep_sec ))

mkdir ./producer

while true
do
    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -record-bytes 980 -pprof ':9878' &> ./producer/producer_${topic}.txt &

    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -record-bytes 980 -pprof ':9879' &> ./producer/producer_${topic}.txt &

    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -record-bytes 980 -pprof ':9880' &> ./producer/producer_${topic}.txt &

    wait_seconds=$(( $RANDOM % $_sleep_range ))
    wait_seconds=$(( $wait_seconds + $min_sleep_sec ))
    echo "$( date -u ): sleep $wait_seconds"
    sleep $wait_seconds

    pids=`ps aux | grep "franz-go/examples/bench/bench -tls" | awk '{print $2}'`
    sudo kill -9 $pids

    echo "$( date -u ): wait 5 min"

    sleep $((60 * 2))
done
