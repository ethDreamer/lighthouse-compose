#!/bin/bash
docker pull sigp/lighthouse:latest \
    && docker pull nethermind/nethermind:latest \
    && docker pull flashbots/mev-boost:latest \
    && docker stop -t 60 stake-execution-1 \
    && docker compose -f beacon.yml -f validator.yml -f execution.yml -f metrics.yml -f mev-boost.yml down

#docker rmi -f stake-mev-boost 
docker rmi -f stake-execution stake-beacon stake-validator \
    && docker compose -f beacon.yml -f validator.yml -f execution.yml -f metrics.yml -f mev-boost.yml up -d


