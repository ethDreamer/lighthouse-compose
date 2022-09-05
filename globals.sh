#!/bin/bash

export EXECUTION_NODE=besu # can be [besu|nethermind]
export CONSENSUS_DISC=9002  # discovery TCP/UDP port open to internet for lighthouse
export EXECUTION_DISC=30305 # discovery TCP/UDP port open to internet for execution node

export ENCRYPTED_SECRETS_DIRECTORY=true

# metrics settings
export PROMETHEUS_PORT=9090 # port to serve prometheus front-end
export GRAFANA_PORT=3000    # port to serve grafana front-end



