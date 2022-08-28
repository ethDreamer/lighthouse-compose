#!/bin/bash

if [ "$SINGLE_VALIDATOR_PASS" = "true" ]; then
    VALIDATOR_PASS_FILE=./datadir/secrets/validator_pass
    while [ ! -f $VALIDATOR_PASS_FILE ]; do
        echo "validator password file not found.. sleeping for 5 seconds"
        sleep 5
    done
fi

if [ "$METRICS_ENABLED" = "true" ]; then
    METRICS_ARG="--metrics --metrics-address=0.0.0.0 --metrics-allow-origin=*"
fi

if [ "$MEVBOOST_ENABLED" = "true" ]; then
    BUILDER_ARG="--private-tx-proposals"
fi

echo "******************* STARTING LIGHTHOUSE VALIDATOR NODE *******************"

exec lighthouse \
    --debug-level=info \
    --datadir ./datadir \
    --network mainnet \
    validator_client \
    --http \
    --http-port 5062 \
    --http-address=0.0.0.0 \
    --unencrypted-http-transport \
    --http-allow-origin \* \
    $(printf '%s' "$METRICS_ARG") \
    --init-slashing-protection \
    --beacon-nodes http://beacon:5052 \
    $BUILDER_ARG

