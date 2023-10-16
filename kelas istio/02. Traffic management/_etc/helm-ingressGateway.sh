#!/bin/bash


helm repo add istio https://istio-release.storage.googleapis.com/charts                                     
helm repo update

helm upgrade --install istio-ingressgateway-second istio/gateway -f values-ingressGateway.yaml -n istio-system