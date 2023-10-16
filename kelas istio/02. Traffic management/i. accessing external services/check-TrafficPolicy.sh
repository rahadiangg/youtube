#!/bin/bash

kubectl get istiooperator installed-state -n istio-system -o jsonpath='{.spec.meshConfig.outboundTrafficPolicy.mode}'

# Jika returnnya nilai kosong artinya itu ALLOW_ANY
# karena defaultnya adalah ALLOW_ANY