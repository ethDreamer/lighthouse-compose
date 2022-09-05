#!/bin/bash

if [ "$ENCRYPTED_SECRETS_DIRECTORY" = "true" ]; then
    SECRETS_MOUNT_TEST_FILE=./datadir/secrets/.mounted
    while [ ! -f $SECRETS_MOUNT_TEST_FILE ]; do
        echo "validator secrets not mounted.. sleeping for 2 seconds"
        sleep 2
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
    --unencrypted-http-transport \
    --http-address=0.0.0.0 \
    --http-port 5062 \
    --http-allow-origin \* \
    $(printf '%s' "$METRICS_ARG") \
    --init-slashing-protection \
    --beacon-nodes http://beacon:5052 \
    $BUILDER_ARG

#    --http-allow-keystore-export \
#    --http-store-passwords-in-secrets-dir \
