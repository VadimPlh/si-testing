#!/bin/bash

. ./settings.sh

TOPIC_NAME="randomtest"



min_sleep_sec=$(( 60 * 2 ))
max_sleep_sec=$(( 60 * 5 ))
_sleep_range=$(( $max_sleep_sec - $min_sleep_sec ))

mkdir ./consumer

CONS_GROUP=group-2nd-shft

while true
do
    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -consume -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -pprof ':9578' &> /dev/null&

    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -consume -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -pprof ':9579' &> /dev/null &

    topic=$(($RANDOM % $TOPICS))
    $FRANZ_BENCH -consume -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic ${TOPIC_NAME}_$topic \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -pprof ':9580' &> /dev/null &

    wait_seconds=$(( $RANDOM % $_sleep_range ))
    wait_seconds=$(( $wait_seconds + $min_sleep_sec ))
    echo "$( date -u ): sleep $wait_seconds"
    sleep $wait_seconds

    pids=`ps aux | grep "franz-go/examples/bench/bench -consume" | awk '{print $2}'`
    sudo kill -9 $pids

    echo "$( date -u ): wait 5 min"

    sleep $((60 * 2))
done
