#!/bin/bash

if [ "$METRICS_ENABLED" = "true" ]; then
    METRICS_ARG="--Metrics.Enabled true --Metrics.ExposePort=6060"
fi

echo "******************** STARTING NETHERMIND ********************"

exec /nethermind/Nethermind.Runner \
    --config=mainnet \
    --datadir="./datadir" \
	--JsonRpc.Enabled=true \
	--JsonRpc.EnabledModules="net,eth,consensus,subscribe,web3,admin,rpc" \
	--JsonRpc.Port=8545 \
	--JsonRpc.Host=0.0.0.0 \
	--Network.DiscoveryPort=${EXECUTION_DISC} \
	--Network.P2PPort=${EXECUTION_DISC} \
    --JsonRpc.JwtSecretFile=/shared/jwt.secret \
    --Sync.SnapSync true \
    --Merge.Enabled true \
    --Merge.TerminalTotalDifficulty 58750000000000000000000 \
    --JsonRpc.AdditionalRpcUrls="http://0.0.0.0:8560|http;ws|engine;eth;net;subscribe;web3;client" \
    $METRICS_ARG

