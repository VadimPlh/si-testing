#!/bin/bash

. ./settings.sh

TOPIC="delete_first_segment"
. ./create_topic.sh $TOPIC

$FRANZ_BENCH -tls -sasl-method scram-sha-256 -sasl-user $USER \
    -sasl-pass $PASSWORD -topic $TOPIC \
    -compression snappy -log-level info \
    -brokers $BROKERS -ca-cert $CERT \
    -record-bytes 980 -pprof ':9878'