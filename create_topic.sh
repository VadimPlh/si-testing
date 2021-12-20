#!/bin/bash

. ./settings.sh

TOPIC=$1
$RPK topic create $TOPIC \
    --tls-enabled --brokers $BROKERS --sasl-mechanism SCRAM-SHA-256 \
    --tls-truststore $CERT -p $PARTITIONS -r $REPLICATION \
    -c segment.bytes=$(( 2**30 ))\
    -c retention.ms=$(( 60 * 1000 )) \
    -c redpanda.remote.read=true -c redpanda.remote.write=true \
    --user $USER --password $PASSWORD