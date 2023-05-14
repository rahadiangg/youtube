#!/bin/bash

while true; do \
  curl --write-out '%{http_code}\n' -s -i --output /dev/null "http://sifood.belajar-istio.local:8080"; \
  curl --write-out '%{http_code}\n' -s -i --output /dev/null "http://sifood.belajar-istio.local:8080/review"; \
  sleep .$RANDOM; done
