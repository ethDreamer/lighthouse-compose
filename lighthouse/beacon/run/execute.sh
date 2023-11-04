#!/bin/bash

if [ "$METRICS_ENABLED" = "true" ]; then
    METRICS_ARG="--metrics --metrics-address=0.0.0.0 --metrics-allow-origin=*"
fi

if [ "$PROXY_ENABLED" = "true" ]; then
    EE_TARGET="http://proxy:8560"
else
    EE_TARGET="http://execution:8560"
fi

if [ "$MEVBOOST_ENABLED" = "true" ]; then
    BUILDER_ARG="--builder=http://mev-boost:8560"
fi

echo "******************** STARTING LIGHTHOUSE BEACON NODE ********************"

exec lighthouse \
    --log-color \
    --debug-level=info \
    --datadir ./datadir \
    --network mainnet \
    beacon \
    --eth1 \
    --http \
    --discovery-port $CONSENSUS_DISC \
    --port $CONSENSUS_DISC \
    --http-address=0.0.0.0 \
    $(printf '%s' "$METRICS_ARG") \
    --execution-jwt=/shared/jwt.secret \
    --execution-endpoint=$EE_TARGET \
    $BUILDER_ARG

