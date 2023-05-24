#!/bin/bash

# dapetin nama pod product
POD_NAME=$(kubectl get pods -l app=product -n belajar-istio -o jsonpath={.items..metadata.name} | cut -d ' ' -f1)

echo "tunggu 1-2 menit untuk prosess pull image" 

# debug container dengan tcpdump
kubectl debug -q -i $POD_NAME -n belajar-istio --image=nicolaka/netshoot -- \
    tcpdump -i eth0 -A -s0 'tcp port 8000 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
