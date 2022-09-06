#!/bin/sh

RELAY="https://0xac6e77dfe25ecd6110b8e780608cce0dab71fdd5ebea22a16c0205200f2f8e2e3ad3b71d3499c54ad14d6c21b41a37ae@boost-relay.flashbots.net"

/app/mev-boost \
    -addr 0.0.0.0:8560 \
    -loglevel info \
    -mainnet \
    -relays $RELAY

