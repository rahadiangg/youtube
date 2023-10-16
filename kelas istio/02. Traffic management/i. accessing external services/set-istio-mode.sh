#!/bin/bash


MODE=REGISTRY_ONLY

if [ -n "$1" ]; then
    MODE="$1"
fi

istioctl install --set profile=demo  --set meshConfig.outboundTrafficPolicy.mode="$MODE"